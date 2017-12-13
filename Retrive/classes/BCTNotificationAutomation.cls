/*Process  
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL                                 
   1.0 -    Abhishek       20-02-2014       Class for Notification FCG/PCG Automation Process  
============================================================================================== */
public with sharing class BCTNotificationAutomation {

    //Open Term Date
    public final static string  OPEN_TERM_DATE = '2099-12-31';
   
    List < Partial_Control_Group__c > partControl = new List < Partial_Control_Group__c > ();
    /*
     * Method:- bctNotificationAutomation.
     * Description:- Fetch the AINotification response and insert record into Patial controll Group object.
     */
    public void bctNotificationAutomation(BCTNotificationService.ReturnData aiResponseData) {
        Partial_Control_Group__c insertPCG = new Partial_Control_Group__c();
        List < Account > acc = new List < Account >();
        Account account = new Account();
      string typeofplanPCG = '';
      if(airesponseData.typeofPlan != null)
         typeofplanPCG = airesponseData.typeofPlan.toLowerCase();
        String TradControll;
        if(aiResponseData.traditionalHierarchy != null && aiResponseData.traditionalHierarchy.control != null){
            Integer MaxAccountLen = 7;
            TradControll = appendLeadingZero(MaxAccountLen,String.valueof(aiResponseData.traditionalHierarchy.control));
        }
        if (aiResponseData.PSUID !=null && !String.isBlank(aiResponseData.PSUID)) {
                aiResponseData.PSUID = aiResponseData.PSUID.trim();
                acc = [Select Id, Name, APM_PSUID__c FROM Account WHERE APM_PSUID__c = : aiResponseData.PSUID limit 1];
        }
        if(acc.size() == 0){
            if(!string.isBlank(aiResponseData.accountName))
            {
            account.name = aiResponseData.accountName;
            if(aiResponseData.PSUID != null)
                account.APM_PSUID__c = aiResponseData.PSUID.trim();
                account.Subsegment__c = aiResponseData.subSegment;
                // account.Market_Segment__c = aiResponseData.Marketsegment;
                acc.add(account);
                insert acc;
            }
        }       
        if(typeofplanPCG.contains('trad')) {
            if (aiResponseData.traditionalHierarchy != null) {
                //Insert PCG Automation 
                String pcgKey;
                //will do query on partial Controll Group to get Control+Plan
                if (TradControll != null && aiResponseData.traditionalHierarchy.planSummary != null) { 
                    aiResponseData.traditionalHierarchy.planSummary = aiResponseData.traditionalHierarchy.planSummary.trim();              
                    pcgKey = TradControll + aiResponseData.traditionalHierarchy.planSummary;
                    partControl = [Select Id, PCGKey__c, PSUID__c, PSUnique_ID__c,Account__c FROM Partial_Control_Group__c WHERE PCGKey__c = : pcgKey limit 1];
                    if(! partControl.isEmpty()){
                        insertPCG = partControl[0];
                    }
                    if (!acc.isEmpty() && insertPCG.Account__c == null) {
                        insertPCG.Account__c = acc[0].ID;
                    }
                
                    if (TradControll != null) {
                        insertPCG.CSAP_Control_ID__c = TradControll;
                    }
                    insertPCG.CSAP_Plan_ID__c = aiResponseData.traditionalHierarchy.planSummary.toUpperCase();
                    insertPCG.Product_Indicator__c = 'PPO';
                    if(aiResponseData.erb == '1' || aiResponseData.erb == '01'){
                        insertPCG.Rating_ERB__c = 'R';
                    }else{
                        insertPCG.Rating_ERB__c = 'NR';
                    }
                    insertPCG.Subsegment__c = aiResponseData.subSegment;
                    if (aiResponseData.effectiveDate != null && aiResponseData.effectiveDate != '') insertPCG.Control_Group_Effective_Date__c = date.valueof(aiResponseData.effectiveDate);
                    if ( String.isBlank(aiResponseData.termDate) || aiResponseData.termDate > OPEN_TERM_DATE){
                        insertPCG.Control_Group_Term_Date__c = date.valueOf(OPEN_TERM_DATE);
                    }else{
                        insertPCG.Control_Group_Term_Date__c = date.valueof(aiResponseData.termDate);
                    }
                    insertPCG.PSUID__c = aiResponseData.PSUID;
                    upsert insertPCG;
                    processFCGAutomation(aiResponseData,acc,insertPCG);
                }
            }
        }
    }
    /*
     * Method:- processFCGAutomation.
     * Description:- retreive the notification data and insert into Full controll group object.
     */
    public static void processFCGAutomation(BCTNotificationService.ReturnData aiResponseData,List<Account> acc, Partial_Control_Group__c insertPCG) {
        List < Full_Control_Group__c > fullControl = new List < Full_Control_Group__c > ();
        Full_Control_Group__c insertFCG = new Full_Control_Group__c();
        String TradControll;
        String TradAccount;
        String TradSuffix;
        if(aiResponseData.traditionalHierarchy != null&& aiResponseData.traditionalHierarchy.control != null){
            Integer MaxAccountLen = 7;
            TradControll = appendLeadingZero(MaxAccountLen,String.valueof(aiResponseData.traditionalHierarchy.control));
        }
        if(aiResponseData.traditionalHierarchy != null&& aiResponseData.traditionalHierarchy.account != null){
            Integer MaxAccountLen = 4;
            TradAccount = appendLeadingZero(MaxAccountLen,String.valueof(aiResponseData.traditionalHierarchy.account));
        }
        if(aiResponseData.traditionalHierarchy != null&&aiResponseData.traditionalHierarchy.suffix != null){
            Integer MaxAccountLen = 2;
            TradSuffix = appendLeadingZero(MaxAccountLen,String.valueof(aiResponseData.traditionalHierarchy.suffix));
        }
        if (TradControll != null && TradSuffix != null 
                        && TradAccount != null && aiResponseData.traditionalHierarchy.planSummary != null) {
            String fcgKey = TradControll + TradSuffix + TradAccount + String.valueof(aiResponseData.traditionalHierarchy.planSummary);
            fullControl = [Select Id, FCGKey__c,Account_Name__c FROM Full_Control_Group__c WHERE FCGKey__c = : fcgKey limit 1];
            if (! fullControl.isEmpty()) {
                insertFCG = fullControl[0];
            } 
            if (aiResponseData.PSUID != null && aiResponseData.PSUID != '') {
                if (! acc.isEmpty() && insertFCG.Account_Name__c == null) {
                    insertFCG.Account_Name__c = acc[0].Id;
                }
            }
            String description,keyPlan;
            insertFCG.CSAP_Account_ID__c = TradAccount;
            insertFCG.CSAP_Control_ID__c = TradControll;
            insertFCG.CSAP_Suffix_ID__c =  TradSuffix;
            insertFCG.CSAP_Plan_ID__c = aiResponseData.traditionalHierarchy.planSummary.toUpperCase();
            insertFCG.Carrier_ID__c = aiResponseData.CarrierId;
            /* Added By sushant for Request 4607 -- Start */
            if(airesponseData.fundingType == '01' || airesponseData.fundingType == '1'){ insertFCG.Group_Funding_Type_Code__c = 'FI';}
            else if(airesponseData.fundingType == '3' || airesponseData.fundingType == '03' || airesponseData.fundingType == '5' || airesponseData.fundingType == '05' || 
            airesponseData.fundingType == '6' || airesponseData.fundingType == '06' || airesponseData.fundingType == '7' || airesponseData.fundingType == '07'){ 
             insertFCG.Group_Funding_Type_Code__c = 'SI';
            }
            else if(airesponseData.fundingType == '99'){ insertFCG.Group_Funding_Type_Code__c = String.valueof('UNK');}
            else {insertFCG.Group_Funding_Type_Code__c = 'SF';}
            /* -- End  */
            insertFCG.Product_Indicator__c = 'PPO';
            insertFCG.Subsegment__c = aiResponseData.subSegment;
            if (aiResponseData.effectiveDate != null && aiResponseData.effectiveDate != '') {
                insertFCG.Control_Group_Effective_Date__c = date.valueof(aiResponseData.effectiveDate);
            }
            if (insertPCG.Control_Group_Term_Date__c!=null) {
                insertFCG.Control_Group_Term_Date__c = insertPCG.Control_Group_Term_Date__c;
            }
            insertFCG.PSUID__c = aiResponseData.PSUID;
                description = aiResponseData.traditionalHierarchy.control + aiResponseData.traditionalHierarchy.planSummary.toUpperCase();
                insertFCG.CAG_Group_ID__c = description;
            upsert insertFCG;
            system.debug('fcg--'+insertFCG.Id);
            orgborAutomation(aiResponseData.OrgId, aiResponseData.OrgArrangementId, aiResponseData.OrgType, insertFCG, insertPCG);
                                
        }       
    }
    /*
     * Method:- orgborAutomation.
     * Description:- retreive the notification data and insert record into Full controll group object as well as Orgstructure object.
     */
    public static void orgborAutomation(string orgid, string arrngid, string orgtype, Full_Control_Group__c insertFCG, Partial_Control_Group__c insertPCG) {
        string orgKey;
        string orgStructureKey;
        List < OrgandArrangement__c > listOrgAndArrangementRecord = new List < OrgandArrangement__c >();
        List < OrgStructure__c > listOrgStructure = new List < OrgStructure__c >();
        OrgStructure__c orgStructureRecord = new OrgStructure__c();
        List<CSAP_CGLP_Junction__c> Csapjunction = new List<CSAP_CGLP_Junction__c>();
        CSAP_CGLP_Junction__c csap = new CSAP_CGLP_Junction__c();
        if (orgid != null && arrngid != null) orgkey = orgid + arrngid;
        if (orgkey != null && orgkey != '') listOrgAndArrangementRecord = [Select Name, id, ArrangmentId__c, ArrangmentName__c, JoinKey__c, OrgId__c, OrgType__c from OrgandArrangement__c 
                                                                                                                                                                 where JoinKey__c = : orgKey];
            if (insertFCG.Id != null) {
                listOrgStructure = [Select Id, FullControlGroup__c, OrgandArrangement__c, OrgArrangmentId__c, JoinKey__c, OrgType__c, OrgId__c FROM OrgStructure__c 
                                                                                                WHERE  JoinKey__c =: orgkey AND FullControlGroup__c =: insertFCG.Id limit 1];
                if (listOrgStructure.size() > 0) {
                    listOrgStructure[0].FullControlGroup__c = insertFCG.Id;
                    if (listOrgAndArrangementRecord.size() > 0 && listOrgAndArrangementRecord[0].Id != null) listOrgStructure[0].OrgandArrangement__c = listOrgAndArrangementRecord[0].Id;
                    listOrgStructure[0].OrgArrangmentId__c = arrngid;
                    listOrgStructure[0].JoinKey__c = orgkey;
                    listOrgStructure[0].OrgType__c = orgtype;
                    listOrgStructure[0].OrgId__c = orgid;
                    update listOrgStructure[0];
                } else {
                    orgStructureRecord.FullControlGroup__c = insertFCG.Id;
                    if (listOrgAndArrangementRecord.size() > 0 && listOrgAndArrangementRecord[0].Id != null) orgStructureRecord.OrgandArrangement__c = listOrgAndArrangementRecord[0].Id;
                    orgStructureRecord.OrgArrangmentId__c = arrngid;
                    orgStructureRecord.JoinKey__c = orgkey;
                    orgStructureRecord.OrgType__c = orgtype;
                    orgStructureRecord.OrgId__c = orgid;
                    insert orgStructureRecord;
                }
            }
          Id record = Schema.SObjectType.CSAP_CGLP_Junction__c.getRecordTypeInfosByName().get('Full CG to Partial CG').getRecordTypeId();
          Csapjunction = [SELECT Id, Full_Control_Group__c,Partial_Control_Group__c,RecordTypeId FROM CSAP_CGLP_Junction__c 
                                                                                     WHERE Full_Control_Group__c =: insertFCG.Id  AND Partial_Control_Group__c =: insertPCG.Id Limit 1];
          if(Csapjunction.size() == 0){
                csap.Full_Control_Group__c = insertFCG.Id;
                csap.Partial_Control_Group__c = insertPCG.Id;
                csap.RecordTypeId = record;
                insert csap;
          }
    }
    
    /**
     * Method:- appendLeadingZero.
     * Description:- it's an util method based on the certain condition we append zero.
     */
    private static string  appendLeadingZero(Integer maxlength,String TraditionalAccount){                                                          
        Integer resAccount = TraditionalAccount.length();
        String s = '';
        for(Integer i = 0; i<maxlength-resAccount; i++)
        {
            s+='0';
        }
        TraditionalAccount = s+TraditionalAccount;
        return TraditionalAccount;
    }
}