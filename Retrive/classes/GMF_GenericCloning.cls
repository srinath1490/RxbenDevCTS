public class GMF_GenericCloning{
    public Formulary_List_Entry__c ClonedDLC {get;set;}
    public Step_Therapy_PreRequisite_Drug__c ClonedST {get;set;}
    SS_FullCloner_Worker Cloner;
    Transient Sobject ClonedDLCCopy; //making a copy to detect if changes were made.
    ID recId; //needed for cloner.
    public Boolean proceedFlag{public get;private set;} //only proceed when one of the key fields change. This is a validation requirement.
    private static final string STPREREQDRUG = 'Step_Therapy_PreRequisite_Drug__c';
    private static final string FLE = 'Formulary_List_Entry__c';
    private static final string ERRORMSG1 = 'This page should only be used from Clone button.System could not determine parent record to clone.';
    private static final string ERRORMSG2 = 'Could not clone record. Please resolve error(s).If no additional errors are displayed, there might be a parent record with similar criteria already in the system.';
    private static final string FRWDSLASH = '/';
    private static final string DML = 'Dml';
    private static final string HOMEPAGE = '/home/home.jsp';
    private static final string NULLLABEL = '';
    private static final string IDLABEL = 'Id';
    
    public GMF_GenericCloning(ApexPages.standardController control){
        proceedFlag=true;
        try{
            recId=(Id)ApexPages.currentPage().getParameters().get(IDLABEL);
            if(recId == null || String.valueOf(recId) == NULLLABEL)
              proceedFlag=false;
        }catch(System.stringException se){
            proceedFlag=false;
        }

        if(proceedFlag){
            Cloner=new SS_FullCloner_Worker(); //to have a custom object child record excluded use SS_Full_Cloner(List of childobj to ignore);
            String sObjName = recId.getSObjectType().getDescribe().getName();
            if(FLE.equalsIgnoreCase(sObjName)){
                ClonedDLC=(Formulary_List_Entry__c)cloner.getClone(recId);
                ClonedDLCCopy=ClonedDLC.clone(false,true,false,false);
            }
            else if(STPREREQDRUG .equalsIgnoreCase(sObjName)){
                ClonedST=(Step_Therapy_PreRequisite_Drug__c)cloner.getClone(recId);
                ClonedDLCCopy=ClonedST.clone(false,true,false,false);
            }
        } else {
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,ERRORMSG1));
           }
    }
    
    public pageReference saveMe(){
        String cloneRecordId;
        Boolean callsuccess=true;
            try{
                 cloneRecordId=Cloner.save();
            }catch(Exception e){
                if(e.getTypeName().contains(DML)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,ERRORMSG2));
                    callSuccess=false;
                }
                else{
                    callSuccess=false;
                    throw e;                    
                }
            }
            if(callSuccess)
                return (new pageReference(FRWDSLASH + cloneRecordId));
            else
                return NULL;            
    }
    
    public pageReference cancelandBack(){
       if(recId != null && String.valueOf(recId) != NULLLABEL){
           return (new pageReference(FRWDSLASH + recId));
       } else {
            return (new pageReference(HOMEPAGE)); //incase there was no recordId
        }
    }    
}