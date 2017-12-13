@isTest
public class DataStorage_FetchOrgLimits_Test{

    public static testMethod void mocktest(){
        Test.startTest();
        
        string body = '{"DataStorageMB":{"Max":290854,"Remaining":23923},"FileStorageMB":{"Max":2945538,"Remaining":2431075}}';
                        
        singlereqmock ss = new SingleReqMock(200, 'success', body, null);
        
        Test.setMock(HttpCalloutMock.class, ss);
        
        DataStorage_FetchOrgLimits.StorageDetails();
        
        Test.stopTest();
    }
    
}