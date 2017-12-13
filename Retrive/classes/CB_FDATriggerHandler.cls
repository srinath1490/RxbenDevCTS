/*Purpose: Apex Class to update Drug records based on FDA Table records
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0      Ayushi Agrawal  4/25/2016           Apex Trigger to update Drug records based on FDA Table records during FDA records load (Req 06497)
======================================================================== */
public with sharing class CB_FDATriggerHandler{
    
     /* Class Variables */
      public List<FDA__c> fDAtoProcess = new List<FDA__c>();
    
    
    /**
     * Method :- Contructor
     * Description :- Contructor for the class.
    **/
    public CB_FDATriggerHandler(Boolean Insertevent, Boolean UpdateEvent, Map<id,FDA__c> DrugMapOld, List<FDA__c> FDAListNew){
            
            if(UpdateEvent) {
             for(FDA__c FDAobject : FDAListNew) {
               if(DrugMapOld.get(FDAobject.id).NDC__c != FDAobject.NDC__c) {
                   fDAtoProcess.add(FDAobject);
               }
             }
           } else if(Insertevent) {
                fDAtoProcess = FDAListNew;
           } else { //Do Nothing
           }     
        } 
     
     
     /**
     * Method :- afterInsert
     * Description :- This method is executed for the before Insert logic for FDA object.
    **/
    public void afterInsert(){
          try{  
            populateDrugfromFDA();
          } catch (exception e) {
              throw e;
          }  
    }  
        
    
    /**
     * Method :- afterUpdate
     * Description :- This method is executed for the before Update logic for FDA object.
    **/
    public void afterUpdate(){
          try{  
            populateDrugfromFDA();
          } catch (exception e) {
              throw e;
          }  
    } 
    
    
    /**
     * Method :- populateDrugfromFDA
     * Description :- This method finds the matching Drug record for the updated/inserted FDA record and updates the Drug record accordingly.
    **/
    public void populateDrugfromFDA(){
      try{  
        set<String> nDCList = new set<String>();
        list<Drug__c> drugstoupdate = new list<Drug__c>();
        
        //List of NDCs for the FDA records inserted/updated
        for(FDA__c fdarec : fDAtoProcess) {
            nDCList.add(fdarec.NDC__c);
        }
        
        //Map of the drug record corresponding to the NDC values of FDA records being inserted/updated
        map<String,Drug__c> nDCDrugMap = new map<String,Drug__c>();
        for (Drug__c drugrec: [Select id,name,NDC__c,fda__c from Drug__c where NDC__c=:nDCList LIMIT 80000]) {
            nDCDrugMap.put(drugrec.NDC__c, drugrec);
        }
        
        //Logic to update the Drug records based on the FDA load
        for (fda__c fDAobj : fDAtoProcess) {
            if(nDCDrugMap.containsKey(fDAobj.NDC__c)) {  //Key for matching FDA record is the NDC field value
                       nDCDrugMap.get(fDAobj.NDC__c).FDA__c = fDAobj.id;
                       drugstoupdate.add(nDCDrugMap.get(fDAobj.NDC__c));
                    }
                    else {//Do Nothing
                    } 
            }
        
        if(drugstoupdate.size()>0) {
            database.update(drugstoupdate);
        }
      } catch (exception e) {
              throw e;
          }  
    }
      
}