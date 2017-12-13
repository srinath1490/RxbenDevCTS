@isTest 
private class Test_PERS_Audit_Cloning_Button {
    static testMethod void createClonePositive() {

        //test date setup
        PERS_Audit__c testSourceRec=testdatesetup(); //get test record
        insert testSourceRec; //insert test record
        ApexPages.StandardController sc = new ApexPages.StandardController(testSourceRec); //create a standardController since the code needs one to create object.

        //constructing 
        PERS_Audit_Cloning_Button pacObj=new PERS_Audit_Cloning_Button(sc);

        //invoking methods
        PageReference pr=pacObj.CreateClone();
        //Id clonedRecordid=pr.getParameter('Id');
        
       //System.assertNotEquals(clonedRecordid,NULL);
    }

    //Utility method used to create test pers audit record.
    private static PERS_Audit__c testdatesetup(){
        PERS_Audit__c p = new PERS_Audit__c();
        p.Plan_Letter__c = 'FA';
        p.PSU_Completed_Date__c = Date.newInstance(2017, 7, 6);
        p.PSU_Comments__c = 'FA';
        p.PERSAUDIT_Plan_Sponsor_Unique_ID__c = '89560114';
        p.PERSAUDIT_Control_Group_Number__c = '865638';
        p.New_Existing_Customer__c = 'Revision';
        p.Funding__c = 'Self Insured';
        p.Effective_Date__c = Date.newInstance(2017, 1, 6);
        p.Audit_Plan_Sponsor_Name_New_Customer__c = 'Test';
        p.Opportunity_Reason__c = 'Test';
        p.CTT_Number__c = 'PSS-0000708375';
        return p; //return the record without inserting.
    }
}