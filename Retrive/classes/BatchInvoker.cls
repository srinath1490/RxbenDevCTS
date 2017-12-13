/*Purpose: Apex Batch Class to invoke batch process and track status of batches
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
1.0      
2.0      Amit Jain        23 Dec, 2014   Modified for request 5376
2.1      Richa            24 Feb, 2015   Added a batch Archive PFRs for Req 05555
======================================================================== */
public class BatchInvoker {

    private map<String,List<String>> mapBatches
                    = new Map<String,List<String>>{
                         'BATCH CRD Builder' => new list<string>{'Batch_CRDBuildStep1', 'BAC_CB_Validations', 'BAC_CB_Completion', 'BAC_CB_MassSend2AIRequest', 'BAC_CB_MassSend2AI'}
                         , 'BATCH PERS SEED' => new List<String>{'BAC_CB_SeedPersStep', 'BAC_CB_CAGRestructure', 'BAC_CB_CRDXMLStep','BAC_FIFOTagging'}
                         , 'BATCH CAG Restructure' => new List<String>{'BAC_CB_CAGRestructure','BAC_CB_SeedPersStep','BAC_CB_CRDXMLStep'}
                         , 'BATCH PCG/FCG ACCOUNT AUTOMATION' => new List<String>{'BAC_PcgFcgAutomationHandlerFallout'}
                         , 'BATCH CIF Creation' => new List<String>{'BAC_UpdateCIF'}
                         , 'BATCH Process CBONs by Date' => new List<String>{'BAC_CB_processOldCBONs','Batch_CRDBuildStep1', 'BAC_CB_Validations', 'BAC_CB_Completion', 'BAC_CB_MassSend2AIRequest', 'BAC_CB_MassSend2AI','BAC_CB_SeedPersStep','BAC_CB_CAGRestructure','BAC_CB_CRDXMLStep'}
                         , 'BATCH PERS Handler' => new List<String>{'BAC_CB_PersFullReportTriggerHandler'}
                         ,'BATCH Archive PFRs' => new list<string>{'BAC_CB_archivePFRs'}//Richa added this batch as part of Req 05555
                     };
             
    private final static set<string> setStatus = new set<string>{'Queued','Processing','preparing'};
    public List<SelectOption> selectOptions {get;set;}
    public String setClassName {get;set;}
    public String batchRunReason {get;set;}
    public boolean batchReasonSet {get;set;}
    public boolean isRunning {get;set;}
    public list<AsyncApexJob> listAsyncApexJob {get;set;} 
    public String helpText {get;set;}
    public BatchInvoker (){
        isRunning = false;
        batchReasonSet =False;
        selectOptions = new List<SelectOption>();
        for(String s : mapBatches.keyset()){
            selectOptions.add(new SelectOption(s,s));
            selectOptions.sort();
        }
        setClassName = selectOptions[0].getValue();        
    }
    
    public pageReference executeBatch(){
        if(batchRunReason == Null || batchRunReason == ''){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide a valid reason for running the Batch Process.');
            ApexPages.addMessage(myMsg);
        }else{
            if(setClassName == 'BATCH XML'){
            Database.executebatch(new BAC_CB_CRDXMLStep (), 1);
            }else if(setClassName == 'BATCH CASE STATUS HISTORY'){
                Database.executebatch(new BAC_CaseStatusHistory(), 200);
            }else if(setClassName == 'BATCH MASS SEND TO AI'){
                    BAC_CB_MassSend2AI.execute();
            }else if(setClassName == 'BATCH CRD CVS'){
                Database.executebatch(new BAC_CB_ShareCases(), 200);
            }else if(setClassName == 'BATCH CRD COMPLETION'){
                Database.executebatch(new BAC_CB_Completion(), 200);
            }else if(setClassName == 'BATCH PCG/FCG ACCOUNT AUTOMATION'){
                Database.executebatch(new BAC_PcgFcgAutomationHandlerFallout(), 10);
            }else if( setClassName == 'BATCH PERS SEED'){
                Database.executeBatch(new BAC_CB_SeedPersStep(),200);
            }else if( setClassName == 'BATCH CAG Restructure'){
                Database.executeBatch(new BAC_CB_CAGRestructure());
            }else if( setClassName == 'BATCH CRD Builder'){
                Database.executeBatch(new Batch_CRDBuildStep1(),1);
            }else if(setClassName == 'BATCH CRD Validation'){
                    Database.executeBatch(new BAC_CB_Validations(),200);
            }else if(setClassName == 'BATCH CIF Creation'){
                    Database.executeBatch(new BAC_UpdateCIF(),200);
            }else if(setClassName == 'BATCH Process CBONs by Date'){
                    Database.executeBatch(new BAC_CB_processOldCBONs(),200);
            }else if(setClassName == 'BATCH PERS Handler'){
                    Database.executeBatch(new BAC_CB_PersFullReportTriggerHandler(),1);
            }else if(setClassName == 'BATCH Archive PFRs'){
                    Database.executeBatch(new BAC_CB_archivePFRs(),200);
            }
            this.loadExistingBatch(); 
            Joblog__c jLog = new Joblog__c();
               jLog.Task__c = setClassName;
               jLog.Start_time__c = System.now();
               jLog.Notes__c = batchRunReason;
               jLog.Success__c = true; 
               jLog.RequestedBy__c = Userinfo.getuserid();
               insert jLog; 
        }     
        return null;
        
    }
    
    public void loadExistingBatch(){
         isRunning = false;   
         listAsyncApexJob = [SELECT 
                                ApexClass.name,CompletedDate,CreatedDate,JobItemsProcessed
                                ,ExtendedStatus,Id, NumberOfErrors
                                ,ParentJobId,Status, TotalJobItems 
                            FROM 
                                AsyncApexJob 
                            where 
                                ApexClass.Name in :mapBatches.get(setClassName) 
                            Order By 
                                CreatedDate DESC NULLS First 
                            LIMIT 10] ;
        if(setClassName== 'BATCH CRD Builder'){
             helpText  = System.label.CL0000054;
        }else if(setClassName== 'BATCH PERS SEED'){
             helpText  = System.label.CL0000055;
        }else if(setClassName== 'BATCH CAG Restructure'){
             helpText  = System.label.CL0000055;
        }else if(setClassName== 'BATCH PCG/FCG ACCOUNT AUTOMATION'){
             helpText  = System.label.CL0000056;
        }else if(setClassName== 'BATCH CIF Creation'){
             helpText  = System.label.CL0000058;
        }else if(setClassName== 'BATCH Process CBONs by Date'){
             helpText  = System.label.CL0000057;
        }else if(setClassName== 'BATCH PERS Handler'){
             helpText  = System.label.CL0000067;
        }
        for(AsyncApexJob async : [Select Id from AsyncApexJob where ApexClass.Name in :mapBatches.get(setClassName)  and Status in:setStatus limit 1]){
           isRunning = true;
        }
         
    }
}