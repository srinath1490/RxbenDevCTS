/*Purpose: Apex Class for maintaining the App Menu for CRD Wizard.                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ABHAY                08/05/2011       Apex Class for maintaining the App Menu for CRD Wizard. 
   1.1 -    Joognu Rao           02/07/2014        Implemented request no 4931       
======================================================================== */

public with sharing class VFP_AppMenuController {
   
    public String isIntegratedWithMedical{get;set;}
    public string currentPageName{get;set;}
    public string FundingType{get;set;}
    public string crdId{get;set;}
    public string messagetype{get;set;}
    public CRD__c crdRecord;
    public List<CRDBuildOrder__c> lstCRDbuildOrder{get;set;}    
    public CRD__c currentcrd{get;set;}
    public string message{
    	get{
    			currentcrd = [select 
	    						Id, Insured_Type__c, National__c, CRD_Automated__c 
	    					 from 
	    						CRD__c 
	    					 where 
	    						Id =:crdId];
    	    	if(currentcrd.CRD_Automated__c){
		        CRDBuildOrder__c builderObj;
		        for(CRDBuildOrder__c  crdBuiulder : [select 
		                                                   CRD__c,FalloutCase__c,FalloutCase__r.CaseNumber 
		                                            from 
		                                                CRDBuildOrder__c 
		                                            where 
		                                                CRD__c=:crdId limit 1]){
		            builderObj = crdBuiulder;
		        }
		        if(builderObj != null){
			       if(builderObj.FalloutCase__c==null){
			           messagetype = 'success';
			           message ='CRD is automated and CRD is in CRD Builder queue';
			       }else{
			          messagetype = 'fallout';
			          message ='CRD is automated  and CRD is in CRD Builder queue and has fallout case-'+builderObj.FalloutCase__r.CaseNumber;
			      }
		       }
	    	}
	    	return message;
    	}
    	set;}    

    public VFP_AppMenuController(){
        
    }   
   
}