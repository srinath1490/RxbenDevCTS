public with sharing class Pharmacy_Network_Request_Clone {
	
	Pharmacy_Network_Request__c request;
	Id parentId;
	
	public Pharmacy_Network_Request_Clone(ApexPages.StandardController Controller) {
        
        parentId=controller.getId();
        request=[Select p.Zip_Code__c, p.State__c, p.Clone__c, p.Job_Title__c, p.NCPDP_Number_Locked_for_Original__c, p.Additional_NCPDPs_Locked_for_Origina__c, p.Stage__c, p.OwnerId, p.Name_of_Pharmacy__c, p.NDA_Verified__c, p.NDA_Verified_Date__c, p.NCPDP__c, p.Initial_Contact_Date__c, p.Id, p.ESI_PSAO_Affiliation_Verification__c, p.Contracted_with_ESI__c, p.Contracted_with_CVS__c, p.Contact_Phone_Number__c, p.Contact_Name__c, p.Contact_Email_Address__c, p.Class_of_Trade__c, p.City__c, p.CVSH_PSAO_Affiliation_Verification__c, p.Address_2__c, p.Address_1__c, p.Additional_NCPDP_numbers__c From Pharmacy_Network_Request__c p where id=:parentId];
    }  
    public PageReference CreateClone() {
        
        Pharmacy_Network_Request__c p= new Pharmacy_Network_Request__c();
        p.OwnerId=request.OwnerId;
        p.Initial_Contact_Date__c=request.Initial_Contact_Date__c;
        p.Class_of_Trade__c=request.Class_of_Trade__c;
        p.Stage__c='PSAO Verification';
        p.Contact_Name__c=request.Contact_Name__c;
        p.Job_Title__c=request.Job_Title__c;
        p.Contact_Phone_Number__c=request.Contact_Phone_Number__c;
        p.Contact_Email_Address__c=request.Contact_Email_Address__c;
        p.Name_of_Pharmacy__c=request.Name_of_Pharmacy__c;
        p.Additional_NCPDP_numbers__c=request.Additional_NCPDPs_Locked_for_Origina__c;
        p.NCPDP__c=request.NCPDP_Number_Locked_for_Original__c;
        p.Additional_NCPDPs_Locked_for_Origina__c=request.Additional_NCPDPs_Locked_for_Origina__c;
        p.NCPDP_Number_Locked_for_Original__c=request.NCPDP_Number_Locked_for_Original__c;
        p.Contracted_with_CVS__c=request.Contracted_with_CVS__c;
        p.Contracted_with_ESI__c=request.Contracted_with_ESI__c;
        p.Address_1__c=request.Address_1__c;
        p.Address_2__c=request.Address_2__c;
        p.City__c=request.City__c;
        p.State__c=request.State__c;
        p.Zip_Code__c=request.Zip_Code__c;
        p.CVSH_PSAO_Affiliation_Verification__c=request.CVSH_PSAO_Affiliation_Verification__c;
        p.ESI_PSAO_Affiliation_Verification__c=request.ESI_PSAO_Affiliation_Verification__c;
        p.NDA_Verified__c=request.NDA_Verified__c;
        p.NDA_Verified_Date__c=request.NDA_Verified_Date__c;
        p.Clone__c=true;

        insert p;
        
        if (request.Clone__c == true) {
                request.Cloned__c = false;
            } else {
                request.Cloned__C = true;}
        update request;
        
        PageReference pageref = new PageReference('/' + p.Id +'/e?retURL=' + p.Id);
        pageref.setRedirect(true);
        return pageref;
    }

}