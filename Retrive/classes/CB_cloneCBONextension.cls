public class CB_cloneCBONextension{
    public CRDBuildOrder__c crdBuilder{get;set;}
    public string psuid {get;set;}
    public CB_cloneCBONextension(ApexPages.StandardController controller){
        crdBuilder = (CRDBuildOrder__c)controller.getRecord();
    }
    
    public Pagereference cloneCBON(){
        List<Pers_Full_Report__c> persToInsert = new List<Pers_Full_Report__c>();
        Pagereference pg;
        Savepoint sp = Database.setSavepoint();
        try{
            for(Pers_Full_Report__c p : [Select 
                                                Carrier_ID__c,Case__c,Controleffective__c,ControlPlanEffective__c,ControlPlan__c,CRD_Build_Order__c,CRD__c
                                                ,High_Value_Client__c,Id,Ignored__c,Package__c,PERStimestamp__c,Processed__c,ROWNUM__c,SequenceNo__c
                                                ,What_is_the_carrier__c,WS_ACQ_BUSS_CD__c,WS_BNFT_NM__c,WS_BNFT_RMRK__c,WS_BNFT_STATUS_CD__c,WS_CFO_CD__c
                                                ,WS_CNTRCT_ST__c,WS_CNTRL_NM__c,WS_CNTRL_NO__c,WS_COB_CD__c,WS_COB_RMRK__c,WS_CONFIG_VAL__c,WS_CTRL_STATUS_CD__c
                                                ,WS_CUST_CLASS_CD__c,WS_CUST_NO__c,WS_CUST_RENWL_DT__c,WS_CUST_STATUS_CD__c,WS_CUST_SUBSEG__c,WS_FUNDARG_IND__c
                                                ,WS_ID_TYPE__c,WS_INFRC_EFF_DT__c,WS_LV_NO__c,WS_LV_TXT__c,WS_MLR_CONTRACT_SITUS_ST__c,WS_NEW_INFRC_EFF_DT__c
                                                ,WS_ORG_ARRNGMNT_ID__c,WS_ORG_ID__c,WS_ORG_TYPE__c,WS_PLAN_PDC__c,WS_PLAN_RMRK__c,WS_PLSM_BNFT_EFFDT__c,WS_PLSM_CD__c
                                                ,WS_PLSM_PRBNFT_ORG_EFF_DT__c,WS_PLSM_STATUS_CD__c,WS_PROV_LNG_NM__c,WS_PROV_NUM__c,WS_PSUID__c,WS_RISK_IND__c
                                                ,WS_RXPLAN_VAL__c,WS_SEQ_NO__c,WS_SITUS_ST__c,WS_TPID_VAL__c,WS_TRIGGER_DATE__c,WS_TRX_TYP_CD__c
                                            From
                                                Pers_Full_Report__c
                                            Where
                                                CRD_Build_Order__c =:crdBuilder.id]){
                Pers_Full_Report__c pers = p.clone(false,false,false,false);                                    
                pers.crd__c = null;
                pers.CRD_Build_Order__c = null;
                pers.processed__c = false;
                pers.Case__c = null;
                pers.WS_CNTRL_NO__c = crdBuilder.Control__c;
                pers.WS_PLSM_CD__c = crdBuilder.Plan__c;
                pers.WS_NEW_INFRC_EFF_DT__c = crdBuilder.Effective_date__c;
                pers.PERStimestamp__c = crdBuilder.PERS_timestamp__c;
                if(! String.isBlank(psuid )){
                   // pers.WS_PSUID__c =  psuid;
                
                }
                pers.WS_COB_RMRK__c = '05';
                persToInsert.add(pers);
            }
            CB_PersFullReportTriggerHandler.CLONEMODE = True;
            insert persToInsert;
            for(Pers_Full_Report__c p : [Select 
                                                id, CRD_Build_Order__c
                                            From
                                                Pers_Full_Report__c
                                            Where
                                                id in:persToInsert limit 1]){
                pg = new Pagereference('/' + p.CRD_Build_Order__c);
            }
        }catch(Exception ex){
            Apexpages.addMessages(ex);
            Database.rollback(sp);
        }   
        
        return pg;
    }

}