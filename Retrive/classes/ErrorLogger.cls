public without sharing class ErrorLogger{
    private static Error_log__c errorlog;
	private static Blob argB;
    public static Id create(string subject,String severity,String impactedArea,Boolean EmailDev,String ErrorDescription,Id crdId,Boolean notifyDev,Id userId,String Categ,String CodeNam,Integer linenumber){
        errorlog=new Error_log__c(Subject__c=subject,CRD__c=crdid,Email_Developer__c=notifyDev,Error_Description__c=ErrorDescription,Impacted_Area__c=ImpactedArea,Category__c=Categ,Code_Name__c=codeNam,ErrorLineNumber__c=linenumber);
        Id recid=insertlog();
        return recid;
    }
    
    public static Id create(string subject,String severity,String impactedArea,Boolean EmailDev,String ErrorDescription,Id crdId,Boolean notifyDev,Id userId,String Categ,String CodeNam,Integer linenumber,Blob fileValue){
        errorlog=new Error_log__c(Subject__c=subject,CRD__c=crdid,Email_Developer__c=notifyDev,Error_Description__c=ErrorDescription,Impacted_Area__c=ImpactedArea,Category__c=Categ,Code_Name__c=codeNam,ErrorLineNumber__c=linenumber);
        argB=fileValue;
        Id recid=insertlog();
        return recid;
    }
    
    public static Error_log__c getRecord(string subject,String severity,String impactedArea,String ErrorDescription,Id crdId,Boolean notifyDev,Id userId,String Categ,String CodeNam,Integer linenumber){
       return(new Error_log__c(Subject__c=subject,CRD__c=crdid,Email_Developer__c=notifyDev,Error_Description__c=ErrorDescription,Impacted_Area__c=ImpactedArea,Category__c=Categ,Code_Name__c=codeNam,ErrorLineNumber__c=linenumber));
        
    }
    
     public static Error_log__c getRecord(string subject,String severity,String impactedArea,String ErrorDescription,Id crdId,Boolean notifyDev,Id userId,String Categ,String CodeNam,Integer linenumber,string authoremailadd){
       return(new Error_log__c(Subject__c=subject,CRD__c=crdid,Email_Developer__c=notifyDev,Error_Description__c=ErrorDescription,Impacted_Area__c=ImpactedArea,Category__c=Categ,Code_Name__c=codeNam,ErrorLineNumber__c=linenumber,DevEmail__c=authoremailadd));
        
    }
    

    public static Id create(string subject){
        errorlog=new Error_log__c(subject__c=subject);
        Id recid=insertlog();
        return recid;
    }
     public static Id create(string subject,Blob b){
        errorlog=new Error_log__c(subject__c=subject);
         argB=b;
        Id recid=insertlog();
        return recid;
    }
    
    private static id insertlog(){
        try{
     		insert errorlog;   
            if(argB!=NULL){
             Attachment att=new Attachment();
             att.Body=argB;
             att.Name='Errorlog_' + System.now().format('yyyy_MM_dd_hh_mm_ss') + '.csv';
             att.parentId=errorLog.id;
             insert att;
             
           }//End if
        }Catch(Exception e){
        	system.debug(logginglevel.error,'Error while creating errorlog.System message:'+e.getMessage());
            throw e;
        }
        return errorlog.id;
    }
}