/**
Test class for Prov Line domain class.
 */
@isTest
private class Test_ProvLineDomain {

    static testMethod void noUpdatehandleProvLineDMLTest() {
   
        PERS_report__c pr= Test_DataGen_CaseAutomation.PERSreportGen()[0];
        pr.BNFT_STATUS_CD__c='ab';
        insert pr;
        case c= Test_DataGen_CaseAutomation.CaseGenerator()[0];
        insert c;
        PERS_report__c prcopy=(PERS_report__c)Database.query(getQueryString())[0];
        Provisional_Lines__c pl=provLineDomain.getRecord(prcopy,c.Id);
        insert pl;
        Provisional_Lines__c plnew=provLineDomain.getRecord(pr,c.Id);
        plnew.PersreportTimestamp__c=datetime.newInstance(1960, 2, 17);
        ProvLineDomain.handleProvLineDML(new Map<string,Provisional_Lines__c>{plnew.key__c=>plnew});//older record.
        system.debug(logginglevel.error,'query Timestamp:'+[select LastModifiedDate from Provisional_lines__c where key__c=:plnew.key__c][0].LastModifiedDate);
        system.debug(logginglevel.error,'pl Timestamp:'+[select LastModifiedDate from Provisional_Lines__c where id=:pl.Id][0].LastModifiedDate);
        system.assert([select LastModifiedDate from Provisional_lines__c where key__c=:plnew.key__c][0].LastModifiedDate==[select LastModifiedDate from Provisional_Lines__c where id=:pl.Id][0].LastModifiedDate);//wasn't modified
        
    }
    
     static testMethod void getRecordwithPlan() {
   
        PERS_report__c pr= Test_DataGen_CaseAutomation.PERSreportGen()[0];
        pr.BNFT_STATUS_CD__c='ab';
        insert pr;
        case c= Test_DataGen_CaseAutomation.CaseGenerator()[0];
        insert c;
        PERS_report__c prcopy=(PERS_report__c)Database.query(getQueryString())[0];
        Provisional_Lines__c pl=provLineDomain.getRecord(prcopy,c.Id,'AB');
        
    }
    
    static testMethod void UpdatehandleProvLineDMLTest() {
   
        PERS_report__c pr= Test_DataGen_CaseAutomation.PERSreportGen()[0];
        pr.BNFT_STATUS_CD__c='ab';
        insert pr;
        case c= Test_DataGen_CaseAutomation.CaseGenerator()[0];
        insert c;
        PERS_report__c prcopy=(PERS_report__c)Database.query(getQueryString())[0];
        Provisional_Lines__c pl=provLineDomain.getRecord(prcopy,c.Id);
        pl.PersreportTimestamp__c=datetime.newInstance(1960, 2, 17);
        insert pl;
        Provisional_Lines__c plnew=provLineDomain.getRecord(pr,c.Id);
        ProvLineDomain.handleProvLineDML(new Map<string,Provisional_Lines__c>{plnew.key__c=>plnew});//older record.
        system.debug(logginglevel.error,'query Timestamp:'+[select LastModifiedDate from Provisional_lines__c where key__c=:plnew.key__c][0].LastModifiedDate);
        system.debug(logginglevel.error,'pl Timestamp:'+[select LastModifiedDate from Provisional_Lines__c where id=:pl.Id][0].LastModifiedDate);
        system.assert([select LastModifiedDate from Provisional_lines__c where key__c=:plnew.key__c][0].LastModifiedDate>datetime.newInstance(1960, 2, 17));//wasn modified
        
    }
    
    static testMethod void checkingUniqueness(){
    	//the key is caseid+provnum for package and nonpkg no crd cases
    	PERS_report__c pr= Test_DataGen_CaseAutomation.PERSreportGen()[0];
        pr.BNFT_STATUS_CD__c='ab';
        insert pr;
        case c= Test_DataGen_CaseAutomation.CaseGenerator()[0];
        insert c;
        PERS_report__c prcopy=(PERS_report__c)Database.query(getQueryString())[0];
        Provisional_Lines__c pl=provLineDomain.getRecord(prcopy,c.Id);
        system.assert(pl.key__c==string.valueof(c.Id)+string.valueOf(prcopy.NEW_PROV_NUM__c)); //caseid+newprovnum
    	//the key is caseid+provnum+plan for nonpackage without crd scenarios
    	 Provisional_Lines__c plnonpkgwCRD=provLineDomain.getRecord(prcopy,c.Id,'ab');
        system.assert(plnonpkgwCRD.key__c==string.valueof(c.Id)+string.valueOf(prcopy.NEW_PROV_NUM__c)+'ab'); //caseid+newprovnum
    	
    }
    
     static testMethod void Exception_handleProvLineDMLTest() {
        List<PERS_report__c> prList= Test_DataGen_CaseAutomation.PERSreportGen();
        PERS_report__c pr=prList[0];
        PERS_report__c pr1=prList[1];
        pr.BNFT_STATUS_CD__c='ab';
        pr.BNFT_STATUS_CD__c='ab';
        insert pr;
        insert pr1;
        case c= Test_DataGen_CaseAutomation.CaseGenerator()[0];
        insert c;
        
        PERS_report__c prcopy=(PERS_report__c)Database.query(getQueryString())[0];
        PERS_report__c prcopy2=(PERS_report__c)Database.query(getQueryString())[1];
        
        prcopy.BNFT_STATUS_CD__c='abcd';//field size exception.
        prcopy2.BNFT_STATUS_CD__c='abcd';//field size exception.
        
        Provisional_Lines__c pl=provLineDomain.getRecord(prcopy,c.Id);
        Provisional_Lines__c pl2=provLineDomain.getRecord(prcopy2,c.Id);
        
        ProvLineDomain.handleProvLineDML(new Map<string,Provisional_Lines__c>{pl.key__c=>pl,pl2.key__c=>pl2});//older record.
        system.assert([select Id from Error_Log__c].size()>0);
        
        system.assert(ProvLineDomain.getRecord(prcopy,null)==null);
    }
    
    private static string getQueryString(){
    	Schema.DescribeSObjectResult  DescribeRec=PERS_report__c.sObjectType.getDescribe();
	    Map<String, Schema.SObjectField> FieldsMap=DescribeRec.fields.getMap();
	    String qry='';
	    for(String s:FieldsMap.keyset()){
	       qry+=s+',';
	    }
	    qry=qry.left(qry.length()-1); 
	            
	    String s='SELECT '+qry+' FROM PERS_report__c order by Name';
	    return s;
    } 
}