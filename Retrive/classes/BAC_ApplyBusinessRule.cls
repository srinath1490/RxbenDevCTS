/*Purpose: Apex Batch Class to make Callout for AI Request created by batch process
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            6/14/2013       Apex Batch Class to apply Business Rules
======================================================================== */
global class BAC_ApplyBusinessRule implements Database.Batchable < sObject > {
    global String query;
    private Savepoint sp;
    private final String flowName;
    global BAC_ApplyBusinessRule(String Passedquery,String flowName) {
        query =Passedquery; //'select CRD__c,For_In_State__c,For_NPP__c,For_Out_State__c,EffectiveDate_Greater_Than_CRD__c,Cloned_CRD_ID__c from Batch_Logger__c where Processed__c = true';
        this.flowName=flowName;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List < sObject > scope) {
        Set<Id> batchCRDIds = new Set<Id>();
        List<Drug_Coverage__c> listDrugCoverageRecords = new List<Drug_Coverage__c>();
        try {
            sp = Database.setSavepoint();
            
           for (SOBJECT s: Scope) {
                Batch_Logger__c CurrentBatchInstance = (Batch_Logger__c) s;        
                
                if(CurrentBatchInstance.EffectiveDate_Greater_Than_CRD__c=='True' && CurrentBatchInstance.For_NPP__c==True){    
                 batchCRDIds.add(CurrentBatchInstance.Cloned_CRD_ID__c);
                }
                else if(CurrentBatchInstance.EffectiveDate_Greater_Than_CRD__c=='False' && CurrentBatchInstance.For_NPP__c==True){
                    batchCRDIds.add(CurrentBatchInstance.CRD__c);   
                }
                else if(CurrentBatchInstance.For_In_State__c== True && CurrentBatchInstance.Cloned_CRD_ID__c != null){
                    batchCRDIds.add(CurrentBatchInstance.Cloned_CRD_ID__c);
                }
                else if(CurrentBatchInstance.For_In_State__c== True && CurrentBatchInstance.CRD__c != null){        
                    batchCRDIds.add(CurrentBatchInstance.CRD__c);
                }
                else if(CurrentBatchInstance.For_Out_State__c== True && CurrentBatchInstance.Cloned_CRD_ID__c != null){
                    batchCRDIds.add(CurrentBatchInstance.Cloned_CRD_ID__c);
                }
                else if(CurrentBatchInstance.For_Out_State__c== True && CurrentBatchInstance.CRD__c != null){
                    batchCRDIds.add(CurrentBatchInstance.CRD__c);
                }
                
           } 
         if(batchCRDIds.size() > 0 && batchCRDIds.size() != null) {     
             listDrugCoverageRecords = [Select Id,CRD_ID__c,RecordType.name,Do_you_have_Specialty__c,Force_to_Specialty__c,of_fills_before_force_to_specialty__c,Aetna_Specialty_Care_Rx__c,(Select Inclusion_Exclusion_Drug_Class__c,Inclusion_Exclusion__c from DC_Drug_List__r) from Drug_Coverage__c where CRD_ID__c =: batchCRDIds and Exception_Drug_Group__c = ''];
         }    
         if(listDrugCoverageRecords.size()>0 && listDrugCoverageRecords.size() != null){
           for( Drug_Coverage__c DCR : listDrugCoverageRecords){
             if(DCR.recordType.name=='Retail'){
                for(DC_Drug_List_Group__c dcl: DCR.DC_Drug_List__r){
                   if(dcl.drug_list_name__c == 'Fertility- inj (Covered)' && (dcl.Inclusion_Exclusion__c == 'Prior Authorization required' || dcl.Inclusion_Exclusion__c == 'Include')){
                        DCR.Do_you_have_Specialty__c = 'Yes';
                        DCR.Force_to_Specialty__c = 'Yes';
                        DCR.of_fills_before_force_to_specialty__c = 3;
                        DCR.Aetna_Specialty_Care_Rx__c= 'Applies-Expanded List w/ Fertility';
                    }
                    else if(dcl.drug_list_name__c == 'Fertility- inj (Covered)' && (dcl.Inclusion_Exclusion__c != 'Prior Authorization required' || dcl.Inclusion_Exclusion__c != 'Include')){
                        DCR.Do_you_have_Specialty__c = 'Yes';
                        DCR.Force_to_Specialty__c = 'Yes';
                        DCR.of_fills_before_force_to_specialty__c = 3;
                        DCR.Aetna_Specialty_Care_Rx__c= 'Applies-Expanded List';                   
                    }
                }   
             }  
           }
         }   
         
         List<Database.Saveresult> srList = Database.update(listDrugCoverageRecords, false);
         //GC_Utils_Method.logSaveresult(lstLog2Update, srList);
         GC_Utils_Method.saveBusinessRuleResults(listDrugCoverageRecords,srList);  
         } catch (exception e) {
         /*
        if(listDrugCoverageRecords.size() > 0 && listDrugCoverageRecords.size() != null) {     
             GC_Utils_Method.saveBusinessRuleResults(listDrugCoverageRecords,true); 
        }         
        
        if(listDrugCoverageRecords.size() > 0 && listDrugCoverageRecords.size() != null) {     
             GC_Utils_Method.saveBusinessRuleResults(listDrugCoverageRecords,false);
        }         
            */
            Database.rollback(sp);
        }
    }

    global void finish(Database.BatchableContext BC) {
        //Database.executeBatch(new BAC_MassSend2AI('select id,name from opportunity'), 1); 
        System.debug(LoggingLevel.WARN, 'Batch Cloning Process  Finished');
        //Schedule the next job, and give it the system time so name is unique
        
        String query = 'select id,Successfully_Sent_To_AI__c,Has_AI_Error__c,Crd__c,For_NPP__c,For_In_State__c,PERS_Effective_Date_of_New_Benefits__c,For_Out_State__c,Cloned_CRD_ID__c,Dummy_crd__c,TPID_From_PERS__c,Updated_By_Business_Rule__c,name from Batch_Logger__c where Processed__c= true and Has_Error__c= false and Ready_For_AI__c=True and '+flowName;
        //System.schedule('SCH_MassSend2AI' + sysTime.getTime(), chron_exp, new SCH_MassSend2AI(query));
        //Execute MassSendtoAI batch only for NPP and In State
        if(flowName!='For_Out_State__c=true'){
           // Database.executeBatch(new BAC_CB_MassSend2AI(query), 1);
        }
    }
}