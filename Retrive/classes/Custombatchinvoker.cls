/* Class : Custombatchinvoker
   Purpose : To execute the required CRD Builder batch separately */
public without sharing class Custombatchinvoker {
    private final static set<string> SETSTATUS = new set<string>{'Queued','Processing','preparing'};    
    private final static String BATCH_CRDBUILD_STEP = 'Batch_CRDBuildStep';
    private final static String BATCH_VALIDATE_STEP= 'Batch_ValidateStep';
    private final static String BATCH_COMPLETE_STEP = 'Batch_CompleteStep';
    private final static String BATCH_AI_LOGS= 'Batch_AIlogs';
    private final static String BATCH_SEEDS= 'Batch_Seeds';
    private final static String BATCH_CAG = 'Batch_CAG';
    private final static String BATCH_XML = 'Batch_XML';
     private final static String BATCH_FIFO = 'Batch_FIFO';
    private final static String BATCH_CRDBUILD_STEP1= 'Batch_CRDBuildStep1';
    private final static String BAC_CB_VALIDATIONS= 'BAC_CB_Validations';
    private final static String BAC_CB_COMPLETION = 'BAC_CB_Completion';
    private final static String BAC_CB_MASS_SEND2AIREQUEST= 'BAC_CB_MassSend2AIRequest';
    private final static String BAC_CB_MASS_SEND2AI= 'BAC_CB_MassSend2AI';
    private final static String BAC_CB_SEEDPERS_STEP= 'BAC_CB_SeedPersStep';
    private final static String BAC_CB_CAG_RESTRUCTURE= 'BAC_CB_CAGRestructure';
    private final static String BAC_CB_CRDXML_STEP= 'BAC_CB_CRDXMLStep';
    private final static String BAC_FIFOTAGGING = 'BAC_FIFOTagging';
    
    public List<SelectOption> selectOptions {get;set;}
    public String setClassName {get;set;}
    public set<id> idlst {Get;set;}
    public String batchRunReason {get;set;}
    public boolean isRunning {get;set;}
    public list<AsyncApexJob> listAsyncApexJob {get;set;} 
    public String helpText {get;set;}
    private map<String,List<String>> mapBatches
                    = new Map<String,List<String>>{
                         BATCH_CRDBUILD_STEP => new list<string>{BATCH_CRDBUILD_STEP1}
                         , BATCH_VALIDATE_STEP => new List<String>{BAC_CB_VALIDATIONS}
                         , BATCH_COMPLETE_STEP => new List<String>{BAC_CB_COMPLETION}
                         , BATCH_AI_LOGS => new List<String>{BAC_CB_MASS_SEND2AIREQUEST,BAC_CB_MASS_SEND2AI}
                         , BATCH_SEEDS => new List<String>{BAC_CB_SEEDPERS_STEP}
                         , BATCH_CAG => new List<String>{BAC_CB_CAG_RESTRUCTURE}
                         , BATCH_XML => new List<String>{BAC_CB_CRDXML_STEP}
                         ,BATCH_FIFO => new List<String>{BAC_FIFOTAGGING}
                     };
    /* Constructor for the class */
    public Custombatchinvoker(ApexPages.StandardSetController stdCon) {
        isRunning = false;
        selectOptions = new list<SelectOption>();
        SelectOption option=null;
        for(String s : mapBatches.keyset()){
        	option = new SelectOption(s,s);
            selectOptions.add(option);
            selectOptions.sort();
        }
        setClassName = selectOptions[0].getValue();  
        
        integer iCount = 0;
        integer pagenumber = 1;
        idlst = new set<id>();
        do{
            stdCon.setpageNumber(pagenumber ) ;
            iCount = iCount + stdCon.getRecords().size();
            for(SObject temprecord : stdCon.getRecords()){
            	if(temprecord!=NULL){
            		idlst.add(temprecord.id);
              	}
            }
            pagenumber ++;
        }while(stdCon.getHasNext() );
        
    }
    public pageReference executebatch(){
        if(batchRunReason == Null || batchRunReason == ''){//Richa added on 29th dec
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
            											'Please provide a valid reason for running the Batch Process.');
            ApexPages.addMessage(myMsg);
        }else{
            CB_BatchOrchestration testinstance = new CB_BatchOrchestration();
            testinstance.cbonid = idlst;
            testinstance.query = testinstance.querymaker(setClassName);
            if(setClassName.equalsIgnoreCase(BATCH_CRDBUILD_STEP)){
                        testinstance.callBatch_CRDBuildStep();
            }else if(setClassName.equalsIgnoreCase(BATCH_VALIDATE_STEP)){
                        testinstance.callBatch_customValidation();
            }else if(setClassName.equalsIgnoreCase(BATCH_COMPLETE_STEP)){
                        testinstance.callBatch_CompletionStep();
            }else if(setClassName.equalsIgnoreCase(BATCH_AI_LOGS)){
                        testinstance.callBatch_sendtoAI();      
            }else if(setClassName.equalsIgnoreCase(BATCH_CAG)){
                        testinstance.callBatch_CAGRestructure();
            }else if(setClassName.equalsIgnoreCase(BATCH_SEEDS)){
                        testinstance.callBatch_SeedPERSstep();
            }else if(setClassName.equalsIgnoreCase(BATCH_XML)){
                        testinstance.callBatch_CRDXMLStep();
            }else if(setClassName.equalsIgnoreCase(BATCH_FIFO)){       
                        testinstance.callBatch_CRDFIFOStep();       
            }

            Joblog__c jLog = new Joblog__c();//Richa added on 29th dec
            jLog.Task__c = setClassName;
            jLog.Start_time__c = System.now();
            jLog.Notes__c = batchRunReason;
            jLog.Success__c = true; 
            jLog.RequestedBy__c = Userinfo.getuserid();
            insert jLog; 
        }
        return null;
    }
    
        /* Method to display the significance of the Batch that is to be run*/
        public void loadExistingBatch(){
        try {
         isRunning = false;   
         listAsyncApexJob = [SELECT 
                                ApexClass.name,CompletedDate,CreatedDate,JobItemsProcessed,ExtendedStatus,Id, NumberOfErrors
                                ,ParentJobId,Status, TotalJobItems 
                            FROM AsyncApexJob where ApexClass.Name in :mapBatches.get(setClassName) 
                            Order By CreatedDate DESC NULLS First 
                            LIMIT 10] ;
        if(setClassName== BATCH_CRDBUILD_STEP){
             helpText  = System.label.CL0000066;
        }else if(setClassName== BATCH_VALIDATE_STEP){
             helpText  = System.label.CL0000060;
        }else if(setClassName== BATCH_COMPLETE_STEP){
             helpText  = System.label.CL0000061;
        }else if(setClassName== BATCH_AI_LOGS){
             helpText  = System.label.CL0000062;
        }else if(setClassName== BATCH_SEEDS){
             helpText  = System.label.CL0000063;
        }else if(setClassName== BATCH_CAG){
             helpText  = System.label.CL0000064;
        }else if(setClassName== BATCH_XML){
             helpText  = System.label.CL0000065;
        }else {/* else if(setClassName== BATCH_FIFO){
             helpText  = System.label.CL0000070;
             
        }*/ 
        }
        for(AsyncApexJob async : [Select Id from AsyncApexJob where ApexClass.Name in :mapBatches.get(setClassName) 
    														  and Status in:SETSTATUS limit 1]){
           isRunning = true;
        }
         
    } catch (exception e) {
        throw e;
    }
    }
}