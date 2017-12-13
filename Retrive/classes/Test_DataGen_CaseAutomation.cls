/**
Datagenerator test class for BCTcaseautomation classes.
 */
@isTest
public class Test_DataGen_CaseAutomation {
	
    public static List<NotificationStandard__c> StdPkgDataGen() {
    	List<NotificationStandard__c> nstdList=new List<NotificationStandard__c>();
    	nstdList.add(new NotificationStandard__c(Package__c=true,Processed__c=false,Traditional__c=true,rxplanid__c='312456789',controlplaneffective__c='1234567AA2013/11/02')); //no crd, yes case
    	nstdList.add(new NotificationStandard__c(Package__c=true,Processed__c=false,Traditional__c=true,rxplanid__c='512456789',controlplaneffective__c='2234567AA2013/11/02')); //no crd, yes case
    	
    	nstdList.add(new NotificationStandard__c(Package__c=true,Processed__c=false,Traditional__c=true,rxplanid__c='412456789',controlplaneffective__c='6234567AA2013/11/02')); //no crd,no case-same rxplan
    	nstdList.add(new NotificationStandard__c(Package__c=true,Processed__c=false,Traditional__c=true,rxplanid__c='412456789',controlplaneffective__c='7234567AA2013/11/02',ERB__c='R')); //no crd,no case-same rxplan
    	nstdList.add(new NotificationStandard__c(Package__c=true,Processed__c=false,Traditional__c=true,rxplanid__c='412456789',controlplaneffective__c='7234567AA2013/11/02',ERB__c='S')); //no crd,no case-sample rxplan, same
    	nstdList.add(new NotificationStandard__c(Package__c=true,Processed__c=false,Traditional__c=true,rxplanid__c='012456789',controlplaneffective__c='3434567AA2013/11/02')); //existing CRD  	
    	nstdList.add(new NotificationStandard__c(Package__c=true,Processed__c=true,Traditional__c=true));
    	return nstdList;
    }
    
    public static List<NotificationStandard__c> StdNPkgDataGen() {
    	List<NotificationStandard__c> nstdList=new List<NotificationStandard__c>();
    	nstdList.add(new NotificationStandard__c(Package__c=false,Processed__c=false,Traditional__c=true,rxplanid__c='312456789',controlplaneffective__c='1234567AA2013-11-02')); //no crd, yes case
    	nstdList.add(new NotificationStandard__c(Package__c=false,Processed__c=false,Traditional__c=true,rxplanid__c='512456789',controlplaneffective__c='1234567AA2013-11-02')); //no crd, yes case
    	
    	nstdList.add(new NotificationStandard__c(Package__c=false,Processed__c=false,Traditional__c=true,rxplanid__c='012456789',controlplaneffective__c='1234567AA2013-11-02')); //no crd,no case-same rxplan
    	nstdList.add(new NotificationStandard__c(Package__c=false,Processed__c=false,Traditional__c=true,rxplanid__c='412456789',controlplaneffective__c='7234567AA2013-11-02',ERB__c='R')); //no crd,no case-same rxplan
    	nstdList.add(new NotificationStandard__c(Package__c=false,Processed__c=false,Traditional__c=true,rxplanid__c='412456789',controlplaneffective__c='7234567AA2013-11-02',ERB__c='S')); //no crd,no case-sample rxplan, same
    	nstdList.add(new NotificationStandard__c(Package__c=false,Processed__c=false,Traditional__c=true,rxplanid__c='012456789',controlplaneffective__c='3434567AA2013-11-02')); //existing CRD  	
    	nstdList.add(new NotificationStandard__c(Package__c=false,Processed__c=true,Traditional__c=true));
    	return nstdList;
    }
    
    public static List<NotificationFallout__c> FalloutDataGen() {
    	List<NotificationFallout__c> nfList=new List<NotificationFallout__c>();
    	nfList.add(new NotificationFallout__c(processed__c=false,controlplaneffective__c='7234567AA2013-11-02',ErrorType__c='120',ErrorDescription__c='ErrDesc1'));
    	nfList.add(new NotificationFallout__c(processed__c=false,controlplaneffective__c='7234567AA2013-11-02',ErrorType__c='120',ErrorDescription__c='ErrDesc1'));
    	nfList.add(new NotificationFallout__c(processed__c=false,controlplaneffective__c='7234567AA2013-11-02',ErrorType__c='121',ErrorDescription__c='Pricing'));
    	
    	nfList.add(new NotificationFallout__c(processed__c=false,controlplaneffective__c='1234567AA2013-11-02',ErrorType__c='120',ErrorDescription__c='Pricing'));
    	nfList.add(new NotificationFallout__c(processed__c=false,controlplaneffective__c='1234567AA2013-11-02',ErrorType__c='132',ErrorDescription__c='Errodes132'));
    	
    	//added for CRDB release- Like package plan process
    	nfList.add(new NotificationFallout__c(processed__c=false,controlplaneffective__c='1234567AA2013-11-02',ErrorType__c='120',Control__c='1234567',Plan_Summary__c='AA',pricingSchedule__c='Y4',Rxplanid__c='112456789',effectiveDate__c=Date.valueOf('2013-11-02'),ErrorDescription__c='RxPlanID does not exist on AI Non-Pkg table'));
    	nfList.add(new NotificationFallout__c(processed__c=false,controlplaneffective__c='1234567AA2013-11-02',ErrorType__c='120',Control__c='1234567',Plan_Summary__c='AA',pricingSchedule__c='Y4',Rxplanid__c='999956789',effectiveDate__c=Date.valueOf('2013-11-02'),ErrorDescription__c='RxPlanID does not exist on AI Non-Pkg table'));
    	
    	return nfList;
    }
    
    public static List<PERS_report__c> PERSreportGen(){
    	List<PERS_report__c> persList=new List<PERS_report__c>();
    	 persList.add(new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567AA2013-11-02',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123,CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	 persList.add(new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567AA2013-11-02',NEW_PROV_NUM__c=2,NEW_LINE_VAL_NO__c=134,BNFT_STATUS_CD__c='AA',CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	 persList.add(new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='1234567AA2013-11-02',NEW_PROV_NUM__c=2,NEW_LINE_VAL_NO__c=134,BNFT_STATUS_CD__c='BB',CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	 
    	 persList.add(new PERS_report__c(Processed__c=false,NEW_TPID_VAL__c='TPID1',ControlPlanEffective__c='6434567AA2013-11-02',NEW_PROV_NUM__c=1,NEW_LINE_VAL_NO__c=123,CONTROL_NO__c=1234567,NEW_INFRC_EFF_DATE__c=Date.valueOf('2013-11-02')));
    	 
    	return persList;
    }
    
    public static List<CaseControlPlan__c> caseCtlrPlanGen(){
    	Id caseId=[select Id from case where rxplanid1__c='312456789' AND caseAutomationReason__c='AIPkgNewRxplanid'][0].Id;
    	List<CaseControlPlan__c> ccpList=new List<CaseControlPlan__c>();
    	ccpList.add(new CaseControlPlan__c(ControlPlanEffective__c='1234567AA2013-11-02',case__c=caseId,NotificationTimeStamp__c=system.now(),key__c='somekey1',controlplan__c='1234567_AA'));	//inserting controlplan for 1234567AA2013-11-02 inserted above.
    	return ccpList;
    }
    public static List<CRD__c> CRDGenerator(){
    	Account a=new account(name='testcrdaccount');
    	insert a;
    	List<CRD__c> crdList=new List<CRD__c>();
    	crdList.add(new CRD__c(rxplanid__c='012456789',TP_ID__c='12',Effective_Start_Date__c=Date.valueOf('2013-10-12'),Account__c=a.Id,Plan_Type_Mail__c=true));//Traditional Standard Package
    	crdList.add(new CRD__c(rxplanid__c='112456789',TP_ID__c='13',Effective_Start_Date__c=Date.valueOf('2013-9-12'),Account__c=a.Id,Plan_Type_Mail__c=true,predefined__c=true));
    	crdList.add(new CRD__c(rxplanid__c='212456789',TP_ID__c='14'));
    	
    	return crdList;
    }
    
    public static List<NotificationError__c> NotifErrorGenerator(){
    	List<NotificationError__c> nfelist=new List<NotificationError__c>();
        Id eventNotifRecordId=(Id)[select Id from recordtype where DeveloperName='Event_Notifications' LIMIT 1][0].Id;
    	case c2=new case(ControlPlanEffective__c='1234567AA2013-11-02',caseautomationreason__c='AITradFallout',RecordTypeid=eventNotifRecordId,open__c=true);
        insert c2;
    	 datetime myDate = datetime.newInstance(1960, 2, 17);
        nfelist.add(new NotificationError__c(case__c=c2.Id,errortype__c='130',errordescription__c='Errodesc3',key__c='samplekey',NotificationTimeStamp__c=myDate));
        nfelist.add(new NotificationError__c(case__c=c2.Id,errortype__c='132',errordescription__c='Errodes132',key__c='132Errodes132'+String.valueOf(c2.Id),NotificationTimeStamp__c=myDate));
    	return nfelist;
    	
    }
    public static List<case> CaseGenerator(){
    	createcase casecreator=new createcase();
    	case c=casecreator.pullPackageplan('312456789');
    	c.Open__c=true;
    	case c1=casecreator.pullPackageplan('512456789');
    	c1.open__c=true;
    	//return(new List<case>{ casecreator.pullPackageplan('312456789')}); //312456789 is new,but there is a case.
    	return(new List<case>{c,c1});
    	
    }
    
    public static List<case> FallCaseGenerator(){
    	createcase casecreator=new createcase();
    	/*case c=casecreator.pullPackageplan('312456789');
    	c.Open__c=true;
    	c.CaseAutomationReason__c='AITradFallout';
    	c.ControlPlanEffective__c='1234567AA2013-11-02';
    	*/
    	case c1=casecreator.pullPackageplan('512456789');
    	c1.open__c=true;
    	c1.CaseAutomationReason__c='AITradFallout';
    	c1.ControlPlanEffective__c='1444567AA2013-11-02';
    	//return(new List<case>{ casecreator.pullPackageplan('312456789')}); //312456789 is new,but there is a case.
    	return(new List<case>{c1});
    	
    }
    
    public static List<TraditionalNonPkgLookup__c> TradNonPkgLookupGenerator(){
    	List<TraditionalNonPkgLookup__c> Npkglookup=new List<TraditionalNonPkgLookup__c>();
    	Id crdId=[select Id from CRD__c where rxplanid__c='012456789'][0].Id;
    	Id crdId2=[select Id from CRD__c where rxplanid__c='112456789'][0].Id;
    	
    	 Npkglookup.add(new TraditionalNonPkgLookup__c(CRD__c=crdId,ControlPlanEffective__c='1234567AA2013-11-02',key__c='1'+string.valueOf(system.now())));
    	 Npkglookup.add(new TraditionalNonPkgLookup__c(CRD__c=crdId2,ControlPlanEffective__c='1234567AA2013-11-02',key__c='2'));
    	 
    	return NpkgLookup;
    }
 
}