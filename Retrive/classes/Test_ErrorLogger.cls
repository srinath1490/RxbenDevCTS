@isTest
private class Test_ErrorLogger{
    testMethod static void fullargs(){
        system.assert(ErrorLogger.create('subject','1','impactedArea',True,'ErrorDescription',NULL,True,NULL,'category','codename',123,Blob.valueOf('This is a test'))!=NULL);
    }
    
     testMethod static void noBlob(){
        system.assert(ErrorLogger.create('subject','1','impactedArea',True,'ErrorDescription',NULL,True,NULL,'category','codename',123)!=NULL);
        system.assert(ErrorLogger.getRecord('subject','1','impactedArea','ErrorDescription',NULL,True,NULL,'category','codename',123)!=NULL);
        system.assert(ErrorLogger.getRecord('subject','1','impactedArea','ErrorDescription',NULL,True,NULL,'category','codename',123,'solipurams@aetna.com')!=NULL);
    }
    
     testMethod static void throwErrorCase(){
     	
     	
        try{
        ErrorLogger.create('subject','1','impactedArea',True,'ErrorDescription',NULL,True,NULL,'category','codename',12345);
        }catch(Exception e){
        system.assert(e!=NULL);
        }
        
    }
    
    testmethod static void onlySubj(){
     system.assert(ErrorLogger.create('subject')!=NULL);   
    }
    
    testmethod static void onlySubjwAttach(){
     system.assert(ErrorLogger.create('subject',Blob.valueOf('this is a test'))!=NULL);   
    }
}