/*Purpose: Apex Class to update Drug records based on FDA Table records
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Ayushi Agrawal  4/25/2016           Apex Trigger to update Drug records based on FDA Table records during Drug/FDA records load (Req 06497)
======================================================================== */
public with sharing class CB_DrugTriggerHandler extends TriggerHandler{

    /* Class Variables */
    public List<Drug__c> drugToProcess = new List<Drug__c>();
    
    
    /**
     * Method :- Contructor
     * Description :- Contructor for the class.
    **/
    public CB_DrugTriggerHandler(Boolean Insertevent, Boolean UpdateEvent, Map<id,Drug__c> DrugMapOld, List<Drug__c> DrugListNew){
            
            if(UpdateEvent) {
             for(Drug__c drugobject : DrugListNew) {
               if(DrugMapOld.get(drugobject.id).NDC__c != drugobject.NDC__c) {
                   drugToProcess.add(drugobject);
               }
           }
           } else if(Insertevent) {
                drugToProcess = DrugListNew;
           } else { //Do Nothing
           }       
        } 
     
     
     /**
     * Method :- beforeInsert
     * Description :- This method is executed for the before Insert logic for Drug object.
    **/
    public void beforeInsert(){
          try{  
            populateFDAdata();
          } catch (exception e) {
              throw e;
          }  
        }  
        
    
    /**
     * Method :- beforeUpdate
     * Description :- This method is executed for the before Update logic for Drug object.
    **/
    public void beforeUpdate(){
          try{  
            populateFDAdata();
          } catch (exception e) {
              throw e;
          }  
        } 
    
    
    /**
     * Method :- populateFDAdata
     * Description :- This method finds the matching FDA record for the updated/inserted Drug record and updates the Drug record accordingly.
    **/
    public void populateFDAdata() {
      try{  
        set<String> nDCList = new set<String>();
        
        //The list of NDCs is created from the list of Drugs that are part of the Trigger
        for(drug__c d : drugToProcess) {
            nDCList.add(d.NDC__c);
        }
               
        //Map of the FDA record corresponding to each NDC
        map<String,id> nDCFDAmap = new map<String,id>(); 
        for (FDA__c fdarec: [Select id,name,NDC__c from FDA__c where NDC__c=:nDCList LIMIT 80000]) {
            nDCFDAmap.put(fdarec.NDC__c, fdarec.id);
        }
        
        //Setting the value of the FDA field on the Drug records based on matching FDA records
        for (drug__c drugobj : drugToProcess) {
                if(nDCFDAmap.containsKey(drugobj.NDC__c)) {  //Key for matching FDA record is the NDC field value
                   drugobj.FDA__c = nDCFDAmap.get(drugobj.NDC__c);
                }
                else {
                    drugobj.FDA__c = NULL;
                }
            }
      } catch (exception e) {
              throw e;
          }  
    }    
}