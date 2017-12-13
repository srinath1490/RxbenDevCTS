@isTest(SeeAllData=true)
private class Test_JobLogger{
    static testmethod void noArgs(){
		system.assert(JobLogger.create()!=NULL);
    }
    
    static testmethod void withattach(){
     	System.assert(JobLogger.create(Blob.valueOf('This is a test attachment'))!=NULL);
    }
    
    static testmethod void withFullArgs(){
     	System.assert(JobLogger.create(NULL,System.now(),'Error','Notes',NULL,System.now(),True,'task',Blob.valueOf('attach'))!=NULL);
    }
    
    static testmethod void batchmethods(){
     	System.assert(JobLogger.startBatch('Error','Notes',NULL,System.now(),true,'task')!=NULL);
     	System.assert(JobLogger.endBatch(System.now(),NULL,'Notes',NULL,True,'task')!=NULL);
     	System.assert(JobLogger.endBatch(System.now(),NULL,'Notes',NULL,True,'task',NULL)!=NULL);
     	
     	AsyncApexJob a=[select Id,Status,NumberofErrors from AsyncApexJob where NumberofErrors=0 LIMIT 1];
     	if(a!=null)
     		System.assert(JobLogger.endBatch(System.now(),NULL,'Notes',NULL,True,'task',a)!=NULL);
     	
     	AsyncApexJob b=[select Id,Status,NumberofErrors from AsyncApexJob where status='Failed' OR Status='Aborted' LIMIT 1 ];
     	if(b!=null)
     		System.assert(JobLogger.endBatch(System.now(),NULL,'Notes',NULL,True,'task',b)!=NULL);
     	
    }
    
    static testmethod void exceptioncase(){
     	
     	try{
     		JobLogger.startBatch('12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890_324words','Notes',NULL,System.now(),true,'task');
     	}catch(Exception e){
     		System.assert(e!=NULL);
     	}	
     	
    }
    
    static testmethod void batchIds(){
    	case c=new case();
    	insert c;
		system.assert(JobLogger.create(c.Id,'Notes')!=NULL);
    }
}