@isTest
private class Test_SS_provLineAdvViewCNTRL {
 
 testMethod static void checkErrorPostive(){
 	insert prepareData();
 	provLineAdvViewCNTRL controller=getControllerObj();
 	controller.checkError();
 	
 	//assertions
 	system.assert(!controller.isComplex); //not complex prov and pcg's plans are same for one control.
 	system.debug(controller.getErrorData());
 	system.assert(controller.getErrorData()==null);
 }
 
 testMethod static void checkErrorNegative(){
	
 	List<Provisional_Lines__c> pvList=prepareData();
 	pvList[0].PLSM_CD__c='XY'; //changing so it will be detected as a complex case.
 	insert pvList;
 	
 	provLineAdvViewCNTRL obj=getControllerObj();
 	obj.checkError();
 	
 	//assertions
 	system.assert(obj.isComplex); //is complex
 	system.debug(obj.getErrorData());
 	system.assert(obj.getErrorData()!=null);
 	
 	//March27, checking owner,status,perscomplexcasefields.
 	Case caserec=[select PERScomplexcase__c from case where id=:obj.controller.getId()][0];
 	system.assert(caserec.perscomplexcase__c); //is complex
 	
 }
 
 
 static List<Provisional_Lines__c> prepareData(){
    	Account a=new account(name='testcrdaccount');
	     insert a;
	 	CRD__c crdrec=new CRD__c(rxplanid__c='012456789',TP_ID__c='12',Effective_Start_Date__c=Date.valueOf('2013-10-12'),Account__c=a.Id,Plan_Type_Mail__c=true);
	     insert crdrec;
	 	case c=new case(crd_name__c=crdrec.Id,controleffective__c='7456882014-02-01');
	 	 insert c;
	 	 
	 	  
	 	 Map <String,Schema.RecordTypeInfo> recordTypesCSAP = CSAP_CGLP_Junction__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    	 Id RecTypeIdinadj = recordTypesCSAP.get('CRD to Partial CG').getRecordTypeId();

	 	 //inserting PCGs under CRD 	 
	 	 List<Partial_Control_Group__c> pcgList=new List<Partial_Control_Group__c>();
	 	 	pcgList.add(new Partial_Control_Group__c(Account__c=a.Id,CSAP_Control_ID__c='0745688',CSAP_Plan_ID__c='AB'));
	 	 	pcgList.add(new Partial_Control_Group__c(Account__c=a.Id,CSAP_Control_ID__c='0745688',CSAP_Plan_ID__c='BC'));
	 	 	insert pcgList;
	 	 	
	 	 	//inserting CSAP CGLP junction records.
	 	 	insert new CSAP_CGLP_Junction__c(Partial_Control_Group__c=(pcgList[0]).Id,CRD__c=crdrec.Id,recordtypeid=RecTypeIdinadj);
	 	 	insert new CSAP_CGLP_Junction__c(Partial_Control_Group__c=(pcgList[1]).Id,CRD__c=crdrec.Id,recordtypeid=RecTypeIdinadj);
	 	 	
	 	 //inserting prov and line value records
	 	 	List<Provisional_Lines__c> provList=new List<Provisional_Lines__c>();
	 	 	provList.add(new Provisional_Lines__c(Case__c=c.Id,PersreportTimestamp__c=system.now(),PLSM_CD__c='AB',Key__c='123'));
	 	 	provList.add(new Provisional_Lines__c(Case__c=c.Id,PersreportTimestamp__c=system.now(),PLSM_CD__c='BC',Key__c='321'));
	 	 return provList;
	 	 	
 }
 
 static provLineAdvViewCNTRL getControllerObj(){
	ApexPages.StandardController sc = new ApexPages.StandardController([select Id,crd_name__c,controleffective__c from case limit 1][0]);
	return (new provLineAdvViewCNTRL(sc));
	
 }
}