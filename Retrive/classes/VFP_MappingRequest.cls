/*Purpose: Trigger handler to Autopopulate Field (Various levels of approver associated with this Mapping Request)                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Joognu Rao            2/19/2015       Autopopulate Field (Various levels of approver associated with this Mapping Request)
   
======================================================================== */

public with sharing class VFP_MappingRequest{
    
    public  static boolean TRIGGER_CONTEXT = false; 
    
    
    /**
    * Method :- onBeforeInsert
    * Description :- Method to set stage and coder for the mapping request created. 
    **/
    
    public static void onBeforeInsert(List<Mapping_Request__c> newRec){
            for(Mapping_Request__c record : newRec){
                //record.Coder__c = record.ownerid;
                record.Stage__c = 'Level 1';
                
            }
    }
    
    /**
    * Method :- onBeforeOwnerUpdate
    * Description :- Method to restrict approver from approving the record twice. 
    **/
    public static void onBeforeOwnerUpdate(List<Mapping_Request__c> newRec, List<Mapping_Request__c> oldRec){
        
        Map<Id, Mapping_Request__c> mapVerifyOldRequests = new Map<Id, Mapping_Request__c>();
        
        for(Mapping_Request__c mr : oldRec){
                mapVerifyOldRequests.put(mr.id,mr);     
         }  

       for(Mapping_Request__c Newmr : newRec){
       
           system.debug('***'+Newmr.ownerid+'***'+'-----'+mapVerifyOldRequests.get(Newmr.id).ownerid);
            if((Newmr.ownerid != mapVerifyOldRequests.get(Newmr.id).ownerid) && ((string.valueOf(mapVerifyOldRequests.get(Newmr.id).ownerid)).startswith('00G')) && ((string.valueof(Newmr.ownerid)).startswith('005'))){
                
                if(((Newmr.Stage__c=='Level 1') && (Newmr.Coder__c!= null ) && (Newmr.ownerid==Newmr.Coder__c))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('1st approver matching'+Newmr.X1st_level_Approver__c+'-----'+Newmr.ownerid);
                }
                
                if(((Newmr.Stage__c=='Level 2') && (Newmr.X1st_level_Approver__c!= null ) && (Newmr.ownerid==Newmr.Coder__c || Newmr.ownerid==Newmr.X1st_level_Approver__c))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('1st approver matching'+Newmr.X1st_level_Approver__c+'-----'+Newmr.ownerid);
                }
                
                if(((Newmr.Stage__c=='Level 3') && (Newmr.X1st_level_Approver__c!= null && Newmr.X2nd_level_Approver__c!= null) && (Newmr.ownerid==Newmr.Coder__c || Newmr.ownerid==Newmr.X1st_level_Approver__c || Newmr.ownerid==Newmr.X2nd_level_Approver__c ))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('1st approver matching'+Newmr.X1st_level_Approver__c+'-----'+Newmr.ownerid);
                }
                
                if(((Newmr.Stage__c=='Level 4') && (Newmr.X1st_level_Approver__c!= null && Newmr.X2nd_level_Approver__c!= null && Newmr.X3rd_level_Approver__c!= null) && (Newmr.ownerid==Newmr.Coder__c || Newmr.ownerid==Newmr.X1st_level_Approver__c || Newmr.ownerid==Newmr.X2nd_level_Approver__c || Newmr.ownerid==Newmr.X3rd_level_Approver__c))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('1st approver matching'+Newmr.X1st_level_Approver__c+'-----'+Newmr.ownerid);
                }
                
                if(((Newmr.Stage__c=='Level 5') && (Newmr.X1st_level_Approver__c!= null && Newmr.X2nd_level_Approver__c!= null && Newmr.X3rd_level_Approver__c!= null && Newmr.Final_Level_Approver__c!= null) && (Newmr.ownerid==Newmr.Coder__c || Newmr.ownerid==Newmr.X1st_level_Approver__c || Newmr.ownerid==Newmr.X2nd_level_Approver__c || Newmr.ownerid==Newmr.X3rd_level_Approver__c || Newmr.ownerid==Newmr.Final_Level_Approver__c))){
                
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('1st approver matching'+Newmr.X1st_level_Approver__c+'-----'+Newmr.ownerid);
                }
                
                /*
                if(((Newmr.X1st_level_Approver__c!= null) && (Newmr.ownerid==Newmr.X1st_level_Approver__c ))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('1st approver matching'+Newmr.X1st_level_Approver__c+'-----'+Newmr.ownerid);
                }
                if(((Newmr.X2nd_level_Approver__c!= null) && (Newmr.ownerid==Newmr.X2nd_level_Approver__c ))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('2nd approver matching');
                }
                if(((Newmr.X3rd_level_Approver__c!= null) && (Newmr.ownerid==Newmr.X3rd_level_Approver__c ))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('3rd approver matching');
                }
                if(((Newmr.Final_Level_Approver__c!= null) && (Newmr.ownerid==Newmr.Final_Level_Approver__c ))){
                    Newmr.addError(label.ApproverRestriction);
                    system.debug('4th approver matching');
                } */              
            } 
             if((Newmr.ownerid != mapVerifyOldRequests.get(Newmr.id).ownerid) && ((string.valueOf(mapVerifyOldRequests.get(Newmr.id).ownerid)).startswith('005')) && ((mapVerifyOldRequests.get(Newmr.id).ownerid) != userinfo.getUserId())){
            
                Newmr.addError(label.OwnerRestriction);
            
            }  
            if((Newmr.ownerid != mapVerifyOldRequests.get(Newmr.id).ownerid) && ((string.valueOf(mapVerifyOldRequests.get(Newmr.id).ownerid)).startswith('00G')) && ((string.valueof(Newmr.ownerid)).startswith('00G'))){
            
                Newmr.addError(label.QueueToQueueRestriction);
            
            }
         }  
            
    }
    
    
    /**
    * Method :- onafterUpdate
    * Description :- Method to set stage and different level of approvers and capture this information in fields
                     for the mapping request created. 
    **/
    public static void onafterUpdate(List<Mapping_Request__c> newRec, List<Mapping_Request__c> oldRec){
            Mapping_Request__c mappingReq;
            List<Mapping_Request__c>lstMR = new List<Mapping_Request__c>();
            Map<Id,LineValue__c> mapMRtoLV = new Map<Id,LineValue__c>();
            List<LineValue__c>lstLV = new List<LineValue__c>();
            Map<string,LineValue__c> mapExistingLV = new Map<string,LineValue__c>();
            
            for(LineValue__c lv : [select id,name,Active__c,Ready_To_Archive__c,Line_value__c,Mapping_Request__c from LineValue__c where Mapping_Request__c IN:newRec]){
                mapMRtoLV.put(lv.Mapping_Request__c,lv);
            }
            
            for(LineValue__c lv :[select id,name,Active__c,Ready_To_Archive__c,Line_value__c,Mapping_Request__c from LineValue__c where Active__c = true /*AND Mapping_Request__c = null*/]){
            
                mapExistingLV.put(lv.name,lv);  
            }
            //throw new cb_buildstep.MerchandiseException('Level 1 ***');
            if(!TRIGGER_CONTEXT){
            
            system.debug('*******'+newRec[0].LastModifiedById+'-------'+newRec[0].ownerid+'&&&&&&&&'+newRec[0].Status__c);
                for(Mapping_Request__c record : newRec){
                            //throw new cb_buildstep.MerchandiseException('***owner****'+mappingReq.Status__c+'---record.Coder__c----');
                            mappingReq = new Mapping_Request__c(id =record.id);
                            if(record.Stage__c == 'Level 1'){
                                  System.debug('Level 1 ***');
//                                 throw new cb_buildstep.MerchandiseException('Level 1 ***');
                                 if(record.Status__c=='Submitted for first level approval' && record.Coder__c==null){ 
                                    system.debug('1st time coder');
                                     mappingReq.Coder__c = record.LastModifiedById;  
                                      System.debug('***Level 1 coder = '+record.LastModifiedById); 
                                 }
                            
                                if(record.Status__c=='Submitted for second level approval' ){
                                    
                                    mappingReq.X1st_level_Approver__c = record.LastModifiedById;
                                    mappingReq.Stage__c = 'Level 2';
                                     system.debug('*******'+record.Stage__c);   
                                }
                                
                                else if(record.Status__c=='Rejected by 1st level approver' ){
                                    
                                   // throw new cb_buildstep.MerchandiseException('***owner****'+mappingReq.ownerid+'---record.Coder__c----');
                                    mappingReq.X1st_level_Approver__c = record.LastModifiedById;
                                    mappingReq.ownerid = record.Coder__c;
                                    
                                }
                            }
                            if(record.Stage__c == 'Level 2'){
                               //throw new cb_buildstep.MerchandiseException('***owner****'+mappingReq.Status__c+'---record.Coder__c----');
                                if(record.Status__c=='Submitted for Third level approval' ){
                                        
                                        mappingReq.X2nd_level_Approver__c = record.LastModifiedById;
                                        mappingReq.Stage__c = 'Level 3';
                                }    
                                else if(record.Status__c=='Rejected by 2nd level approver'){
                                    
                                    mappingReq.X2nd_level_Approver__c = record.LastModifiedById;
                                    mappingReq.ownerid = record.X1st_level_Approver__c;
                                    mappingReq.Stage__c = 'Level 1';
                                }
                            }
                            else if(record.Stage__c == 'Level 3' ){
                                if(record.Status__c=='Pending line value assignment'){
                                        
                                        mappingReq.X3rd_level_Approver__c = record.LastModifiedById;
                                        mappingReq.Stage__c = 'Level 4';
                                }    
                                else if(record.Status__c=='Rejected by 3rd level approver'){
                                    
                                    mappingReq.X3rd_level_Approver__c = record.LastModifiedById;
                                    mappingReq.ownerid = record.X2nd_level_Approver__c;
                                    mappingReq.Stage__c = 'Level 2';
                                }
                            }
                            else if(record.Stage__c == 'Level 4' ){
                                if(record.Status__c=='Line value assigned' ){
                                        
                                        mappingReq.Final_Level_Approver__c = record.LastModifiedById;
                                        mappingReq.Stage__c = 'Level 5';
                                        mappingReq.Approved__c = true;
                                        mappingReq.ownerid = record.LastModifiedById;
                                        if(Label.ApprovalProcessEditLineValue=='true' && record.Line_Value_State__c=='New Line Value added'){
                                            mapMRtoLV.get(record.id).Active__c = true;
                                            lstLV.add(mapMRtoLV.get(record.id));
                                        }else if(Label.ApprovalProcessEditLineValue=='true' && record.Line_Value_State__c=='Modified Existing Line Value'){
                                            mapExistingLV.get(mapMRtoLV.get(record.id).name).Ready_To_Archive__c= true;
                                            mapExistingLV.get(mapMRtoLV.get(record.id).name).Active__c= false;
                                            mapMRtoLV.get(record.id).Active__c = true;
                                            lstLV.add(mapMRtoLV.get(record.id));
                                            lstLV.add(mapExistingLV.get(mapMRtoLV.get(record.id).name));
                                        }
                                }    
                                else if(record.Status__c=='Rejected by final level approver'){
                                    
                                    mappingReq.Final_Level_Approver__c = record.LastModifiedById;
                                    mappingReq.ownerid = record.X3rd_level_Approver__c;
                                    mappingReq.Stage__c = 'Level 3';
                                }
                            }
                        system.debug('endddd*******'+record.Stage__c);                  
                        system.debug('&&&'+mappingReq);
                        lstMR.add(mappingReq);
                        TRIGGER_CONTEXT = true;             
                }           
                system.debug('&&&List '+lstMR);         
                update lstMR; 
                update lstLV;
            }
    }
}