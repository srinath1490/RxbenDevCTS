global class BAC_processCRDs implements Database.Batchable <sObject>{
    public String query;
 
    global BAC_processCRDs(){
        query = 'Select id, createddate, Delete_BenefitString1__c, Delete_BenefitString2__c,Delete_Processed__c,Delete_checkEqual__c,RxPlanData__c  from CRD__c where Delete_Processed__c != true AND (Standard_or_Custom_Plan__c = \'Creating a custom plan\' OR Standard_or_Custom_Plan__c = \'Cloning a custom plan from existing CRD\')';
        
    }

    global Database.QueryLocator start (Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute (Database.BatchableContext BC, list<CRD__c> scope){
        list<CRD__c> updateCRD = new list <CRD__c>();

        for(CRD__c crd : scope){
            VFP_SendToAIButtonController sendToAI = new VFP_SendToAIButtonController();
            List < string > RxPlanData = new list< string >() ;
            RxPlanData = sendToAI.SendToAI(crd.id);
            crd.Delete_BenefitString1__c = RxPlanData[0];
            if (RxPlanData.size() > 1) {
                crd.Delete_BenefitString2__c = RxPlanData[1].trim();
            }
            if(crd.RxPlanData__c != null && crd.Delete_BenefitString1__c != null){
                if(crd.Delete_BenefitString1__c.compareTo(crd.RxPlanData__c) == 0){
                    crd.Delete_checkEqual__c = true;
                } else {
                    crd.Delete_checkEqual__c = false;
                }
            }    
            crd.Delete_Processed__c = true;
            updateCRD.add(crd);
        }
        Database.update(updateCRD);
    }
    
    global void finish (Database.BatchableContext BC){
    
    }
}