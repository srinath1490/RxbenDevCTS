/** 
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TEST_TPIDSendToAI {
 
    private final static set<String> allowedFileMIMEs =new set<String>{'text/comma-separated-values',
                                                            'text/csv',  
                                                            'application/csv', 
                                                            'application/excel', 
                                                            'application/vnd.ms-excel', 
                                                            'application/vnd.msexcelapplication/vnd.ms-excel',
                                                            'application/octet-stream'};
   static testMethod void testTpidSendToAi() {
   	
		 //  private Transient Blob                 Attachment;
		  
		  // Public  Transient Integer              fileSize     {get;set;}
		 //  Public  Transient String               fileString    {get;set;}
		 //  Public  Integer                        fileLinesSize {get;set;}   
		//public  Generic_CSVReader  csvReader;
	    Integer MAXFILESIZE=2097152; // 2MB
	    Integer MAXROWS=1000;
		String   fileName  = 'xsl';
		String   fileType = 'application/xsl';
		//Blob fileContent = Blob.valueOf('111111');
     	List<string> tpidList=new List<string>();
        List<string> fileLines = new List<string>{'11111','22222','3333333'};
    	String[] inputvalues = filelines[0].split(',');
        string s=inputvalues[0];
        tpidList.add(s);	
        Test.startTest();   
    	crd__c dumCrd = new crd__c();
        insert dumCrd;	
        
        Joblog__c jlog = new Joblog__c();
        jlog.Error__c = 'rx plan ID';
        insert jlog;
        
        AI_Request__c aiReq = new AI_Request__c();
        aiReq.CRD_ID__c = dumCrd.id;
        aiReq.Request_Type__c = 'Traditional_Packaged';
        aiReq.Plan_ID__c = tpidList[0];
        aiReq.Pricing_Schedule__c = 'Y4';
        aiReq.Risk_Indicator__c = 'R';
        aiReq.Job_Logger__c = jlog.Id;
        insert aiReq;
        
        VFP_TPIDSendToAI testAI = new VFP_TPIDSendToAI();
        testAI.sendTPIDToAi();
        testAI.fileName = 'abc.sv';
        String blobCreator = 'TPID\r\n11111111';
        testAI.fileContent = blob.valueof(blobCreator);
        testAI.sendTPIDToAi();
        testAI.fileName = 'abc.csv';
        testAI.fileContent = blob.valueof(blobCreator);
        testAI.sendTPIDToAi();
        testAI.fileName = 'abc.csv';
        testAI.fileContent = blob.valueof(blobCreator);
        testAI.fileType = 'text/csv';
        testAI.sendTPIDToAi();
        
        for(integer i = 0;i<1100;i++)
        	blobCreator = blobCreator + '\r\n11111111';
        
        testAI.fileName = 'abc.csv';
        testAI.fileContent = blob.valueof(blobCreator);
        testAI.fileType = 'text/csv';
        testAI.sendTPIDToAi();
        testAI.resetDataLoad();

        //ApexPAges.StandardController sc = new ApexPages.StandardController();
        Generic_CSVReader csvReader=new Generic_CSVReader();
        //BAC_MassTPIDSend2AI obj = new BAC_MassTPIDSend2AI (sc);
      //  Id testId7 = obj.BAC_MassTPIDSend2AI(jlog.Id,dumCrd.id,fileContent);
    	//ID batchprocessid = Database.executeBatch(obj);
        Test.stopTest();
    }
}