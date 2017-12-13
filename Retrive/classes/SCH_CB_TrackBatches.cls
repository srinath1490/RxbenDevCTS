global class SCH_CB_TrackBatches implements Schedulable {
    /* 
     * Method :- execute
     * Description :- This Method is a batch schedulde method
     */   
    global void execute(SchedulableContext sc){
        
        this.TrackBatches();
    }
    
    global static void CheckExec(String mode){
        
        id classid;
        system.debug('mode++++++++++++++++++++++'+ mode);
        List<apexclass> clas = [select id from ApexClass where name=:mode];
            for(apexclass a:clas){
                classid=a.id;
            }
        
        set<string> setStatus = new set<string>{'Processing','Preparing','Failed','Completed'};
        list<AsyncApexJob> aj = [select id, Status from AsyncApexJob where Apexclassid=:classid and createddate=TODAY and Jobtype = 'BatchApex'];
        
        if(aj.size()<1){
            CB_CRDBMonitor CB = new CB_CRDBMonitor();
            CB.sendEmailmethod(mode,'NA');
        }
    }
    
    public void TrackBatches(){
        String Batch1 = 'BAC_CB_PersFullReportTriggerHandler';
        String Batch2 = 'Batch_CRDBuildStep1';
        String Batch3 = 'BAC_CB_CAGRestructure';
        String Batch4 = 'BAC_FIFOTagging';
        String Batch5 = 'SCH_OrgborIntegration';
        String Batch6 = 'BAC_PcgFcgAutomationHandlerFallout';
        String Batch7 = 'BAC_UpdateCIF';
        String Batch8 = 'BAT_TradFallNotifProcessor';
        String Batch9 = 'BAC_CB_archivePFRs';
        String Batch10 = 'BAC_GMFBuilderUpdateCVS';
        String Batch11 = 'BAC_GMFBuilder';
        String Batch12 = 'BAC_DrugDescriptionMapping';
        String Batch13 = 'BAC_StepTherapyDescriptionMapping';
        String Batch14 = 'BAC_CB_SeedPersStep';
        
        system.debug('timestamp++++++++++++++++++++++'+ system.now().format().replace(system.now().date().format(), '').trim());
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '12:40 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch1);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '12:41 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch2);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '12:42 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch3);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '12:43 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch4);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '5:15 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch5);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '5:16 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch6);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '5:17 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch7);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '5:18 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch8);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '5:19 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch9);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '5:20 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch10);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '5:21 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch11);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '12:44 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch12);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '12:45 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch13);
        }
        
        if (( system.now().format().replace(system.now().date().format(), '').trim() ) == '12:46 AM'){
            SCH_CB_TrackBatches.CheckExec(Batch14);
        }
    }
}