public with sharing  class BAC_CB_ExceptionHandler {
   /** 
     * Method :- MyException
     * Description :- Erorr Handling
     */      
    public class MyException extends Exception {
    		
    }
    
    public void createException(Exception ex, CRD__c crdId){
    	String caseDescription='';
    	String caseReason='';
    	String caseType='';
    	String caseOrigin='';
    	string caseSubject='';
    	Error_log__c err = new Error_log__c();
    	List<Error_log__c> errList = new List<Error_log__c>();
    	err.subject__c = 'Ai Failed';
    	if(crdId.Id!=null)
    	{
    		err.CRD__c = crdId.Id;
    	}
    	err.Error_Description__c = 'Message: ' + ex.getMessage() + '\nStack Trace: ' + ex.getStackTraceString();
    	errList.add(err);
    	insert errList;
    	system.debug('errorlog'+errList);
    	case c = new case();
    	c.Description=caseDescription;//'Following fields were included in the notification from Aetna Integrator:\n\n'+caseDescription;
        c.Origin=caseOrigin;//'Other';
        c.Case_Type__c=caseType;//'Benefit Control Implementation Support';
        c.Reason=caseReason;//'AI notification';
        c.Subject=caseSubject;//'Notification from Aetna Integrator';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'Internal_CRD_GMF_Process' and sobjecttype = 'Case'].id;
        if(crdId.Id!=null)
    	{
       	 c.CRD_ID__c = crdId.Id;
    	}
        insert c;
        system.debug('case c'+c);
    }
    
}