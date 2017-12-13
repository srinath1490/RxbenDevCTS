public class SS_DLC_Clone_Controller{
    public Drug_List_Criteria__c ClonedDLC {get;set;}
    public Boolean commercial{get;set;}  
    public id medicareID{get;set;}
    SS_FullCloner_Worker Cloner;
    Transient Drug_List_Criteria__c ClonedDLCCopy; //making a copy to detect if changes were made.
    ID recId; //needed for cloner.
    public Boolean proceedFlag{public get;private set;} //only proceed when one of the key fields change. This is a validation requirement.
    
    public SS_DLC_Clone_Controller(ApexPages.standardController control){
        this.init();
        medicareId = [SELECT id from RecordType WHERE SobjectType = 'Drug_List_Criteria__c' AND DeveloperName like '%Medicare%' LIMIT 1].id;
        commercialCloning();
    }
    public SS_DLC_Clone_Controller(){
        this.init();
        medicareId = [SELECT id from RecordType WHERE SobjectType = 'Drug_List_Criteria__c' AND DeveloperName like '%Medicare%' LIMIT 1].id;
        commercialCloning();
    }
    
    public void init(){
        proceedFlag=true;
        try{
            recId=(Id)ApexPages.currentPage().getParameters().get('Id');
            if(recId==NULL||String.valueOf(recId)=='')
              proceedFlag=false;
        }catch(System.stringException se){
            //invalid ID provided.Alert user.
            proceedFlag=false;
            system.debug(logginglevel.error,'Error in SS_DLC_Clone_Controller, trying to read ID param from URL. Sys Msg:'+se.getMessage());
            //throw se;
        }
        
        if(proceedFlag){
            Cloner=new SS_FullCloner_Worker(); //to have a custom object child record excluded use SS_Full_Cloner(List of childobj to ignore);
            ClonedDLC=(Drug_List_Criteria__c)cloner.getClone(recId);
            ClonedDLCCopy=ClonedDLC.clone(true,true,true,true);
            system.debug(logginglevel.error,'clonedDLC:'+clonedDLC);
            //return ClonedDLC;
        }
        else{
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,'This page should only be used from Clone button on DLC record. System could not determine source DLC to clone.'));
            // return NULL;
       }
    }
    
    public pageReference saveMe(){
        String cloneRecordId;
        Boolean callsuccess=true;
        if(true){
            try{
                 cloneRecordId=Cloner.save();
            }catch(Exception e){
                if(e.getTypeName().contains('Dml')){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Could not clone record. Please resolve error(s).If no additional errors are displayed, there might be a DLC with similar criteria already in the system.'));
                    system.debug(logginglevel.error,'Error occured.DML|SSCloner:'+e.getMessage());
                    callSuccess=false;
                }
                else{
                    callSuccess=false;
                    throw e;                    
                }
            }
            if(callSuccess)
                return (new pageReference('/'+cloneRecordId));
            else
                return NULL;
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'To clone,please change atleast one key field: Drug Type Code,Drug Code Value,MS Code M,MS Code N,MS Code O,MS Code Y,Rx,OTC,Repack,DESI,Maintenance,Route,NDC.'));
            return NULL;
        }
            
    }
    
    public pageReference cancelandBack(){
       if(recId!=NULL&&String.valueOf(recId)!='')
        return (new pageReference('/'+recId));
       else
        return (new pageReference('/home/home.jsp')); //incase there was no recordId
    }    
    public void commercialCloning(){
        if(ClonedDLC.RecordTypeId !=NULL && ClonedDLC.RecordTypeId == medicareId){
        commercial=true;
        }else
         {
             commercial = false;        
         }             
    }
    private Boolean valid(){ //proactively making sure the DML will not fail due to the custom validation requiring change in key fields for DLC under one DL.
        
        if(proceedFlag){
        /*
         If(ClonedDLC.Drug_Type_Code__c==ClonedDLCCopy.Drug_Type_Code__c&&
            ClonedDLC.Drug_Code_Value__c==ClonedDLCCopy.Drug_Code_Value__c&&
            ClonedDLC.MS_Code_M__c==ClonedDLCCopy.MS_Code_M__c&&
            ClonedDLC.MS_Code_N__c==ClonedDLCCopy.MS_Code_N__c&&
            ClonedDLC.MS_Code_O__c==ClonedDLCCopy.MS_Code_O__c&&
            ClonedDLC.MS_Code_Y__c==ClonedDLCCopy.MS_Code_Y__c&&
            ClonedDLC.Rx__c==ClonedDLCCopy.Rx__c&&
            ClonedDLC.OTC__c==ClonedDLCCopy.OTC__c&&
            ClonedDLC.Repack__c==ClonedDLCCopy.Repack__c&&
            ClonedDLC.DESI__c==ClonedDLCCopy.DESI__c&&
            ClonedDLC.Maintenance__c==ClonedDLCCopy.Maintenance__c&&
            ClonedDLC.Route__c==ClonedDLCCopy.Route__c&&
            ClonedDLC.NDC__c==ClonedDLCCopy.NDC__c&&
            ClonedDLC.Drug_List__c==ClonedDLCCopy.Drug_List__c)
             return false;
          else
             return true; */
             return true;
        }
        else
             return false;
        
    
    }
    
   
    
}