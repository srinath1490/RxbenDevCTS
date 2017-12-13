global class BAC_CB_Patch implements Database.Batchable <sObject>{   
    private String query ;
    

    global BAC_CB_Patch() {
          query = 'Select id,FalloutCase__c,Case__c ,Case__r.casenumber,name,Processed__c ,PERS_timestamp__c,validatedRealTime__c,Success_Case__c,CRD__r.Name, CRD__r.CRD_Automated__c,CRD__r.Account_Name__c,CRD__r.Account__c,CRD__r.PERS_timestamp__c,valid__c,builtRealTime__c ,Control_Plan_Effective__c, completeChkRealTime__c ,complete__c,AIRealtime__c ,CRD__r.ControlPlanEffective__c, CRD__r.Control__c, CAGRealtime__c,Aicallout__c,XML__c,XMLRealtime__c,PDF__c,PDFRealtime__c , Success_Case__r.Fallout_Reason__c, FalloutCase__r.Fallout_Reason__c, Build__c, PERS__c, CAG__c,Sent_AI_request__c,ControlPlanEffective__c,CRD__r.Plan__c,CRD__r.Effective_Date__c,CRD__r.RxPlanID__c,CRD__r.Y_Schd__c,CVS__c,FalloutCase__r.CaseNumber,Success_Case__r.casenumber from CRDBuildOrder__c where Build__c = true and valid__c= false';
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }
    

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        

        for(sobject s : scope){
            CRDBuildOrder__c crdBuilder = (CRDBuildOrder__c)s;
            CB_ValidationsHandler validationHandler = new CB_ValidationsHandler();
            validationHandler.executeValidation(new List<CRDBuildOrder__c>{crdBuilder});
            if(validationHandler.lstBuilderFallout.isEmpty()){
                crdBuilder.Processed__c = true;
                crdBuilder.validatedRealTime__c=true;           
                update crdBuilder;
                CB_Completion objCompletion = new CB_Completion();    
                objCompletion.execute(new List<CRDBuildOrder__c>{crdBuilder});
                if(objCompletion.failures.IsEmpty()){
                    crdBuilder.Processed__c = true;
                    crdBuilder.completeChkRealTime__c = true;            
                    update crdBuilder;
                }
            }
        }
    }
    
    /**
* Method :- finish(Database.BatchableContext BC)
* Description :- Finish Method for the batch Process
**/
    global void finish(Database.BatchableContext BC) {
   
    }
}