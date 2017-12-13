public with sharing class CB_crdBuildDatacontroller {
    List<CRDBuildOrder__c> selectedRecords;
    public decimal carrierId {get;set;}//= 7700;
    public string whatisCarrier {get;set;}//= 'Traditional/PPO';
    PageReference cancelUrl;
    public List<CBON> setupData {get;set;}
    List<Pers_Full_Report__c> persList;
    
    public CB_crdBuildDatacontroller(ApexPages.StandardSetController stdCon){
        //selectedRecords = ((List<CRDBuildOrder__c>)stdCon.getSelected();
        selectedRecords = ((List<CRDBuildOrder__c>)stdCon.getRecords()).clone();
       /* if(stdCon.getHasNext()){
            while(stdCon.getHasNext()){
                
                selectedRecords.addall((List<CRDBuildOrder__c>)stdCon.getRecords());
                stdCon.next();
            }
            
        }*/
        
        /// Create for first 200;
        
        cancelUrl = stdCon.cancel();
        carrierId = 7700;
        whatisCarrier = 'Traditional/PPO';
        initData();
    }
    
    private void initData(){
        //GetAllDat from PersFullReport
        setupData = new List<CBON>();
        persList = new List<Pers_Full_Report__c>();
        
        for(CRDBuildOrder__c crdBuild : [Select 
                                            Id
                                            , (Select 
                                                    Id, WS_CNTRL_NO__c, WS_INFRC_EFF_DT__c,WS_NEW_INFRC_EFF_DT__c, WS_PLSM_CD__c, WS_PSUID__c 
                                                From 
                                                    Pers_Full_Report__r) 
                                        From 
                                            CRDBuildOrder__c
                                        Where
                                            Id in :selectedRecords]){
            //Set CarrierId and What is Carrier
            //What_is_the_carrier__c, Carrier_ID__c
            String control,plan,psuid;
            Date effectiveDate;
            for(Pers_Full_Report__c pers : crdBuild.Pers_Full_Report__r){
                pers.Carrier_ID__c = carrierId;
                pers.What_is_the_carrier__c = whatisCarrier;
                control = String.valueOf(integer.valueOf(pers.WS_CNTRL_NO__c));
                plan = pers.WS_PLSM_CD__c;
                psuid = String.valueOf(integer.valueOf(pers.WS_PSUID__c));//pers.WS_PSUID__c;
                effectiveDate = pers.WS_NEW_INFRC_EFF_DT__c;
            }
            persList.addall(crdBuild.Pers_Full_Report__r);
            setupData.add(new CBON(control, plan, psuid, effectiveDate));
            
        }
    }
    
    public pageReference createSetupData(){
        PageReference pg;
        try{
            for(Pers_Full_Report__c pers : persList){
                pers.Carrier_ID__c = carrierId;
                pers.What_is_the_carrier__c = whatisCarrier;
            }
            update persList;
            this.processSetupData();
            delete [Select id from CVSRxPlanId__c];
            pg = cancelUrl;
        }catch(Exception ex){
            ApexPages.addMessages(ex);
        }
        return pg;
    }
    
    private void processSetupData(){
        Map<String,Account> mapPsuidtoAccount = new Map<String,Account>();
        Set<String> setOfPsuids = new Set<String>();
        for(CBON sRecord : setupData){
            setOfPsuids.add(sRecord.psuid);
        }
        
        //Accounts
        for(Account acc : [Select
                                Id, APM_PSUID__c
                          From
                                Account
                          Where
                                APM_PSUID__c IN :setOfPsuids]){
            setOfPsuids.remove(acc.APM_PSUID__c);
            mapPsuidtoAccount.put(acc.APM_PSUID__c , acc);
        }
        if(! setOfPSuids.isEmpty()){
            //Create New Account
            List<Account> accountList = new List<Account>();
            for(String psuid : setOfPsuids){
                Account acc = new Account();
                acc.APM_PSUID__c = psuid;
                acc.Name = 'Account - ' + psuid;
                accountList.add(acc);
                mapPsuidtoAccount.put(acc.APM_PSUID__c , acc);
            }
            insert accountList;
            
        }
        
        //PCG
        Map<String,Partial_Control_Group__c> pcgRecords = new Map<String,Partial_Control_Group__c>();
        for(CBON sRecord : setupData){
            String pcgKey = sRecord.control + sRecord.Plan;
            Account acc = mapPsuidtoAccount.get(sRecord.psuid);
            Partial_Control_Group__c pcg = new Partial_Control_Group__c();
            pcg.CSAP_Control_ID__c = sRecord.control;
            pcg.CSAP_Plan_ID__c = sRecord.plan;
            pcg.Control_Group_Effective_Date__c = sRecord.effectiveDate;
            pcg.Account__c = acc.id;
            pcg.PCG_Unique_Key__c = pcgKey;
            pcgRecords.put(pcgKey, pcg);
        }
        upsert pcgRecords.values() PCG_Unique_Key__c;
    }
    
    public class CBON{
        public string control {get;set;}
        public string plan {get;set;}
        public string psuid {get;set;}
        public date effectiveDate {get;set;}
        
        public CBON(string control, string plan, string psuid, date effectiveDate){
            this.control = control;
            this.plan = plan;
            this.psuid = psuid;
            this.effectiveDate = effectiveDate;        
        }
        
    }
}