public with sharing class CB_CRDbuildStep1{
    public id currentrecordid{get;set;}
    public String abc{get;set;}    
    public list<Pers_Full_Report__c> provline{get;set;}    
    public map<string,map<decimal,set<decimal>>> cpeProvlines {get;set;}
    public list<decimal> lstdec{get;set;}
    public list<sobject> allrecords {get;set;}    
    public string crdBuilderId {get;set;}
    public CB_CRDbuildStep1(ApexPages.StandardController controller) {
        crdBuilderId = (string)controller.getrecord().id;
        /*abc = [select id ,ControlPlanEffective__c,PERStimestamp__c,CRD_Build_Order__c from Pers_Full_Report__c where id =:currentrecordid].ControlPlanEffective__c;
         
        for(Pers_Full_Report__c pfr : [select id ,ControlPlanEffective__c,PERStimestamp__c,CRD_Build_Order__c from Pers_Full_Report__c where id =: currentrecordid]){
            crdBuilderId = pfr.CRD_Build_Order__c;
        } */
        //Added  WS_CNTRL_NM__c by Nitish  for request No 05091
        provline = [select id ,name,Case__c,WS_COB_CD__c,WS_CNTRL_NM__c,OBOR_ORG_TYPE__c,ORG_NAME__c,ARRNG_NAME__c,CRD_Build_Order__c,CRD_Build_Order__r.name, CRD__c,WS_RISK_IND__c,WS_PSUID__c,ControlPlanEffective__c,Carrier_ID__c,WS_CNTRCT_ST__c,What_is_the_carrier__c,WS_CFO_CD__c,WS_COB_RMRK__c,High_Value_Client__c,WS_CUST_SUBSEG__c,WS_ACQ_BUSS_CD__c,processed__c ,PERStimestamp__c,WS_LV_NO__c,WS_PROV_NUM__c,WS_CNTRL_NO__c,WS_PLSM_CD__c,WS_INFRC_EFF_DT__c,WS_NEW_INFRC_EFF_DT__c,WS_MLR_CONTRACT_SITUS_ST__c  from Pers_Full_Report__c where CRD_Build_Order__c =:crdBuilderId  and WS_LV_NO__c != null and WS_PROV_NUM__c !=null];
         //createrecord(); 
        //for(Pers_Full_Report__c presrep : provline)
        //    presrep.Processed__c = true;
    }
    public void createrecord(){
        cpeProvlines = new map<string,map<decimal,set<decimal>>>();
        lstdec = new list<decimal>();
        list<string> lstlinename = new list<string>();
        
        map<decimal,set<decimal>> provlines = new map<decimal,set<decimal>>();
        for(Pers_Full_Report__c tempreportrec : provline){
            lstlinename.add('P' + tempreportrec.WS_PROV_NUM__c +'L' + tempreportrec.WS_LV_NO__c);
            lstdec.add(tempreportrec.WS_PROV_NUM__c);
            set<decimal> line = new set<decimal>();
            if(provlines.containskey(tempreportrec.WS_PROV_NUM__c)){
                line = provlines.get(tempreportrec.WS_PROV_NUM__c);
                line.add(tempreportrec.WS_LV_NO__c);
            }
            else{
                line.add(tempreportrec.WS_LV_NO__c);
            } 
            provlines.put(tempreportrec.WS_PROV_NUM__c,line);
            cpeProvlines.put(tempreportrec.ControlPlanEffective__c + ',' + tempreportrec .PERStimestamp__c,provlines);
        }
        system.debug(cpeProvlines);
        CB_BuildStep testinstance = new CB_BuildStep();
        testinstance.setupdatePERSListpage( provline);
        //testinstance.updatePERSList =  provline;
       list<CB_BuildStep.mappingValueWrapper> allcreatedrecords = testinstance.CRDBuilderfromMapping(lstlinename,cpeProvlines);
       allrecords =getallsobjects(allcreatedrecords);
    }   
    public list<sobject> getallsobjects(list<CB_BuildStep.mappingValueWrapper> allcreatedrecords){
        list<sobject> sobjects = new list<sobject>();
        list<CB_BuildStep.mappingValueWrapper> childrecords = new list<CB_BuildStep.mappingValueWrapper>();
        for(CB_BuildStep.mappingValueWrapper temprec : allcreatedrecords){
            sobjects.add(temprec.currentrecord);
            childrecords.addall(temprec.childobjects);
        }
        if(childrecords != null && childrecords.size() > 0)
            sobjects.addall(getallsobjects(childrecords));
        return sobjects;
    }
}