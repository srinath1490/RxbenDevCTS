/**
 Test class PERS_BeforeInsertTRG. 
 */
@isTest
private class Test_TRG_PERS_BeforeInsertTRG {

    static testMethod void myUnitTest() {
    	PERS_report__c pr=new PERS_report__c(NEW_ID_Type__c='TPID',ControlPlanEffective__c='875737 A2014-01-01');
    	insert pr;
    	system.assert([select Package__c from PERS_report__c where id=:pr.Id][0].Package__c=='true');
    	pr=new PERS_report__c(NEW_ID_Type__c='RXID',ControlPlanEffective__c='875737 A2014-01-01');
    	insert pr;
    	system.assert([select Package__c from PERS_report__c where id=:pr.Id][0].Package__c=='false');
    	pr=new PERS_report__c(NEW_ID_Type__c='CNFGID',ControlPlanEffective__c='875737 A2014-01-01');
    	insert pr;
    	system.assert([select Package__c from PERS_report__c where id=:pr.Id][0].Package__c=='true');
    	pr=new PERS_report__c(PREV_ID_TYPE__c='TPID',ControlPlanEffective__c='875737 A2014-01-01');
    	insert pr;
    	system.assert([select Package__c from PERS_report__c where id=:pr.Id][0].Package__c=='true');
    	pr=new PERS_report__c(ControlPlanEffective__c='875737 A2014-01-01');
    	insert pr;
    	system.assert([select Package__c from PERS_report__c where id=:pr.Id][0].Package__c=='false');
    	pr=new PERS_report__c(NEW_ID_Type__c='test',ControlPlanEffective__c='875737 A2014-01-01');
    	try{
    		insert pr;
    	}catch(exception e){
    		system.assert(e!=NULL);
    	}
    	
    	//Populating controleffective and controlplan fields...
    	pr=new PERS_report__c(ControlPlanEffective__c='875737 A2014-01-01',CONTROL_NO__c=875737,NEW_INFRC_EFF_DATE__c=system.today());
    	insert pr;
    	system.assert([select ControlEffective__c,controlplan__c from PERS_report__c where id=:pr.Id][0].ControlEffective__c=='8757372014-01-01');
    	system.assert([select ControlEffective__c,controlplan__c from PERS_report__c where id=:pr.Id][0].controlplan__c=='875737 A');
    	// with PREV_INFRC_EFF_DATE populated.
    	pr=new PERS_report__c(ControlPlanEffective__c='875737 A2014-01-01',CONTROL_NO__c=875737,PREV_INFRC_EFF_DATE__c=system.today());
    	insert pr;
    	system.assert([select ControlEffective__c,controlplan__c from PERS_report__c where id=:pr.Id][0].ControlEffective__c=='8757372014-01-01');
    	system.assert([select ControlEffective__c,controlplan__c from PERS_report__c where id=:pr.Id][0].controlplan__c=='875737 A');
    	
    	
    }
    
     static testMethod void ignoredRecords() {
    	PERS_report__c pr=new PERS_report__c(NEW_ID_Type__c='TPID',ControlPlanEffective__c='875737 A2014-01-01');
    	insert pr;
    	system.assert([select Processed__c from PERS_report__c where id=:pr.Id][0].Processed__c==true);
    	system.assert([select Ignored__c from PERS_report__c where id=:pr.Id][0].Ignored__c==true);
    	
    	   	
    }
    
    static testMethod void invalidCPE() {
    	PERS_report__c pr=new PERS_report__c(NEW_ID_Type__c='TPID',ControlPlanEffective__c='');
    	try{
    	insert pr;
    	}catch(exception e){
    		system.assert(e!=null);
    	}
    	
    	
    	   	
    }
}