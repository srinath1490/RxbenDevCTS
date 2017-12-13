global with sharing class SS_FullCloner_Worker {
   //=============================
   // Meta Information
   //=============================  
   // Namespace or Enhancement:SS_FullCloner. Generic class that can be used to clone record and all child records.
   // Description: Class is called by controller or another facade class. Clone parent record and all related child records.
   // Called by:Another class
  
   /*==================================================================================
   Version                                  Author     Date                     Reason
   1.0                                      Saraag     June6,13                 Created 
   2.0                                      Saraag     July11,13    Added exception list
   3.0                                      Nitish     Request No 06007 - Modified cloning of 'Restricted NDC' object
   ====================================================================================*/
   //============================
   // Constructor
   //============================
   
   //copies all customobjects except custom history and standard objects as mentioned by standardObjecttoClone.
    public SS_FullCloner_Worker(){childObjNOTtoClone=new Set<String>{''};}
    
    //Call this constructor if you want to exclude certain objects. Could be standard or custom.
    public SS_FullCloner_Worker(List<String> exceptionList){
        if(exceptionList!=NULL){
            childObjNOTtoClone=new Set<String>();
            childObjNOTtoClone.addAll(exceptionList);
        }
        else
         childObjNOTtoClone=new Set<String>{''};
    }
   
   //============================
   // Member variabels   
   //============================
   List<sObject> childRecords=new List<sObject>();
   sObject parentRecord;  
   Boolean success=true;
   ID parentId; 
   public String childobjName;
   public String parentLookupField;
   public List<Sobject> restrictNDCList;
   Set<String> standardObjecttoClone=new Set<String>{'Account','Contact','Case','Users','Product'};
   String ObjAPIname;
   sObject parentClonedRecord;
   List<sObject> childRecordsInsertList;
    //Map<String,String> childParentMap;
   Map<String,List<SObject>> childParentMap;
   Set<String> childObjNOTtoClone;
   //=============================
   // Member Methods  
   //=============================
   
   // Method Name: FullClone
   // Arguments: parent record ID
   // Return: Cloned record ID
   // Description: This method is called by the custom button on record detail page. Clones record and all child records
   //              and then returns the cloned record.
   
       public sObject getClone(Id parId){
        
        if(parId!=NULL){   
            parentId=parId;
            
            childRecordsInsertList=new List<sObject>();
            initalizeAllRecords();
            /*for(sObject childRec:childRecords){
                sObject childRecTemp=childRec.clone(false,true,false,false);
                childRecTemp.put(childParentMap.get(childRecTemp.getDescribe().
                  childRecordsInsertList.add();
            }*/
            
            parentClonedRecord=parentRecord.clone(false,true,false,false);
               return parentClonedRecord;
        }
        else
           return NULL;
     }
     public Id save(){
         Id returnId;
         success=true;
        //DML operations
        Try{
            List<Sobject> stepTherapyTempList = new List<Sobject>();
            Insert parentClonedRecord;
            Schema.sObjectType RestrictedNDC = Schema.Restricted_NDC_List__c.getSObjectType();
            Schema.sObjectType steptherapyPrerequisite = Schema.Step_Therapy_PreRequisite_Drug__c.getSObjectType();
            map<Id,Sobject> oldIdNewSobjectMap = new map<Id,Sobject>();
            for(string s:childParentMap.keySet()){
                for(sObject childRec:childParentMap.get(s)){
                    sObject childRecTemp=childRec.clone(false,true,false,false);
                    //Added by JR
                    if(childRecTemp.getSobjecttype() == RestrictedNDC){
                        childRecTemp.put('Key__c',Null);                 
                                                             
                    }//JR ends
                    childRecTemp.put(s.subStringBefore(','),parentClonedRecord.Id);
                    childRecordsInsertList.add(childRecTemp);
                    //RN - Starts
                    if(childRecTemp.getSobjecttype() == steptherapyPrerequisite){
                        stepTherapyTempList.add(childRecTemp);  
                        oldIdNewSobjectMap.put(childRec.Id,childRecTemp);
                    }
                    //RN - Ends
                }
              }
                   
            if(childRecordsInsertList!=NULL&childRecordsInsertList.size()>0)
                Insert childRecordsInsertList;
         //RN - Starts
            Set<ID> steptherapyPrqIds = new Set<ID>(); 
            if(stepTherapyTempList.size()>0) {
                
                for(Id s : oldIdNewSobjectMap.keyset()){
                    steptherapyPrqIds.add(s);
                }
                
                Schema.Describesobjectresult childObjDesResult = steptherapyPrerequisite.getDescribe();
                //Schema.Describesobjectresult objDesResult=parentId.getSObjectType().getDescribe();
                List<Schema.Childrelationship>  childRelations = childObjDesResult.getChildRelationships();
                String qry='';
                Boolean ndcChildFound = false;
                
                for(Schema.Childrelationship cr:childRelations){
                    Schema.DescribeSObjectResult childObjDesc=cr.getChildSObject().getDescribe();
                     childobjName=childObjDesc.getName();
                    
                    if(childobjName == 'Restricted_NDC_List__c'){
                         parentLookupField=cr.getField().getDescribe().getName(); 
                        //get all field names
                        system.debug('54321'+parentLookupField);
                        for(String srt:childObjDesc.fields.getMap().keySet()){
                            qry+=srt+',';
                        }
                        ndcChildFound = true;
                        break;
                    }
                }
                if(ndcChildFound){
                 
                            //system.debug(logginglevel.error,'ChildRecordQuery,Qry:'+qry);
                            if(qry.length()>0)
                                qry=qry.left(qry.length()-1); //removing the extra comma
                                system.debug(logginglevel.error,'Child Query:'+qry);
                              String stepIdstring = '(';
                             for(Id setId :steptherapyPrqIds){
                              stepIdstring =  stepIdstring +'\''+setId+'\''+',';
                              }
                            stepIdstring =stepIdstring.left(stepIdstring.length()-1); //removing the extra comma
                            stepIdstring = stepIdstring +')';
                            system.debug('123456'+'select '+qry+' FROM '+childobjName+' WHERE '+parentLookupField+' IN '+stepIdstring);
                            if(qry.length()>1){ 
                                
                             restrictNDCList = Database.query('select '+qry+' FROM '+childobjName+' WHERE '+parentLookupField + ' IN '+stepIdstring);    
                                             
                        }
                        List<Sobject> childRestrictedNDCRecordsInsertList = new List<Sobject>();
                        for(sObject childNDCRec:restrictNDCList){
                            sObject childNDCRecTemp=childNDCRec.clone(false,true,false,false);
                            
           
                            Sobject childTempRec = oldIdNewSobjectMap.get((Id)childNDCRec.get('Related_Step_Therapy_Pre_Requisite_Drug__c'));
                            
                            childNDCRecTemp.put('Related_Step_Therapy_Pre_Requisite_Drug__c',childTempRec.Id);
                            childNDCRecTemp.put('Key__c',Null);                 
                            childRestrictedNDCRecordsInsertList.add(childNDCRecTemp);              
                        }
                        
                    if(childRestrictedNDCRecordsInsertList!=NULL&childRestrictedNDCRecordsInsertList.size()>0)
                        Insert childRestrictedNDCRecordsInsertList;
                    }
             }       //RN - Ends
        }Catch(Exception e){
            system.debug(logginglevel.error,'SS_FullCloner.Fatal Exception-On Insert'+e.getMessage());
            success=false;
            Throw e;
        }Finally{
            if(success)
              returnID=parentClonedRecord.Id;
            else
              returnID=NULL;
        }
        system.debug(logginglevel.FINE,'Cloned to:'+returnId);
        system.debug(logginglevel.FINEST,'Addend Child records:'+childRecordsInsertList);
     return returnId;       
   }// End FullClone()
   
   private void initalizeAllRecords(){
        String qry='';
       integer i=0;
        childParentMap=new Map<String,List<sObject>>();
        Schema.Describesobjectresult objDesResult=parentId.getSObjectType().getDescribe();
        ObjAPIname=objDesResult.getName();
        //get all field names
        Map<String, Schema.SObjectField> parentFieldsMap=objDesResult.fields.getMap();
        for(String s:parentFieldsMap.keyset()){
            qry+=s+',';
        }
        qry=qry.left(qry.length()-1); //removing the extra comma
       
        List<sObject> TempParentList=Database.Query('SELECT '+qry+' FROM '+ObjAPIname+' WHERE Id=\''+String.valueOf(parentId)+'\'');        
        qry='';
        If(TempParentList!=NULL&&TempParentList.size()==1)
            parentRecord=TempParentList[0];
       
        List<Schema.Childrelationship>  childRelations=objDesResult.getChildRelationships();
       
        for(Schema.Childrelationship cr:childRelations){
            i++;
            Schema.DescribeSObjectResult childObjDesc=cr.getChildSObject().getDescribe();
            String childobjName=childObjDesc.getName();
            String parentLookupField=cr.getField().getDescribe().getName();
            if(!childobjName.contains('History')&&!childObjNOTtoClone.containsAll(new List<String>{childObjName})&&childObjDesc.queryable&&(childobjName.endsWith('__c')||standardObjecttoClone.containsAll(new List<String>{childobjName}))){
                system.debug(logginglevel.ERROR,'Now adding:'+childobjName);
                 //get all field names
                qry='';
                for(String srt:childObjDesc.fields.getMap().keySet()){
                    qry+=srt+',';
                }
                //system.debug(logginglevel.error,'ChildRecordQuery,Qry:'+qry);
              if(qry.length()>0)
                qry=qry.left(qry.length()-1); //removing the extra comma
               system.debug(logginglevel.error,'Child Query:'+qry);
                if(qry.length()>1){ //,+i handles child records with same parent field API .
                 //childRecords.addAll(Database.query('select '+qry+' FROM '+childobjName+' WHERE '+parentLookupField+'= \''+String.valueOf(ParentId)+'\''));  
                 childParentMap.put(parentLookupField+','+i,Database.query('select '+qry+' FROM '+childobjName+' WHERE '+parentLookupField+'= \''+String.valueOf(ParentId)+'\''));
                }
        }
      }
       system.debug(logginglevel.FINER,'Found children:'+childRecords);
   }
   
}//End class SS_FullCloner_Worker