/*Purpose: Apex Test Class for VFP_crdNewSteppedCopay.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/9/2011       Apex Test Class for VFP_crdNewSteppedCopay.
======================================================================== 
*/
@isTest
private class TEST_crdNewSteppedCopay{

     static testMethod void testCrdNewCoPay(){
         CRD__c testCrd=new CRD__c();     
         testCrd.Any_drug_specific_Specialty_copays__c=true;
         insert testCrd;  
         
         Copay_Tier__c mailCopay= new Copay_Tier__c();
         mailCopay.Stepped_Copay__c=true;
         mailCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
         mailCopay.CRD__c = testCrd.id;
         insert mailCopay;
         
         Copay_Tier__c Retail= new Copay_Tier__c();
         Retail.Stepped_Copay__c=true;
         Retail.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
         Retail.CRD__c = testCrd.id;
         insert Retail;
         
         Copay_Tier__c Paper= new Copay_Tier__c();
         Paper.Stepped_Copay__c=true;
         Paper.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper').getRecordTypeId();
         Paper.CRD__c = testCrd.id;
         insert Paper;
         
         Copay_Tier__c Specialty= new Copay_Tier__c();
         Specialty.Stepped_Copay__c=true;
         Specialty.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Specialty').getRecordTypeId();
         Specialty.CRD__c = testCrd.id;
         insert Specialty;
         
         
         Copay_Tier__c oonCopay= new Copay_Tier__c();
         oonCopay.Stepped_Copay__c=true;
         oonCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper Out of Network').getRecordTypeId();
         oonCopay.CRD__c = testCrd.id;
         insert oonCopay;      

        Copay_Tier__c SpecialoonCopay= new Copay_Tier__c();
         SpecialoonCopay.Stepped_Copay__c=true;
         SpecialoonCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Specialty OON').getRecordTypeId();
         SpecialoonCopay.CRD__c = testCrd.id;
         insert SpecialoonCopay; 
         
         
         
         SteppedCopay__c steppedCopay=new SteppedCopay__c(); 
         steppedCopay.Copay_Tier__c=mailCopay.id;
         steppedCopay.Min_Range__c=10;
         steppedCopay.Max_Range__c=10;         
         steppedCopay.Dollar_Amount__c=10;
         insert steppedCopay;
         
         Copay_Tier__c RetailCopay= new Copay_Tier__c();
         RetailCopay.Stepped_Copay__c=true;        
         RetailCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
         RetailCopay.CRD__c = testCrd.id;
         insert RetailCopay;
         SteppedCopay__c steppedCopay1=new SteppedCopay__c(); 
         steppedCopay1.Copay_Tier__c=RetailCopay.id;
         steppedCopay1.Min_Range__c=10;
         steppedCopay1.Max_Range__c=10;         
         steppedCopay1.Dollar_Amount__c=10;
         insert steppedCopay1;         
         
         Copay_Tier__c paperCopay= new Copay_Tier__c();
         paperCopay.Stepped_Copay__c=true;
         paperCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper').getRecordTypeId();
         paperCopay.CRD__c = testCrd.id;
         insert paperCopay;
         
         SteppedCopay__c steppedCopay2=new SteppedCopay__c(); 
         steppedCopay2.Copay_Tier__c=paperCopay.id;
         steppedCopay2.Min_Range__c=10;
         steppedCopay2.Max_Range__c=10;         
         steppedCopay2.Dollar_Amount__c=10;         
         insert steppedCopay2;         
         
         Copay_Tier__c specialityCopay = new Copay_Tier__c();
         specialityCopay.Stepped_Copay__c=true;         
         specialityCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Specialty').getRecordTypeId();
         specialityCopay.CRD__c = testCrd.id;
         insert specialityCopay;
         
         SteppedCopay__c steppedCopay3=new SteppedCopay__c(); 
         steppedCopay3.Copay_Tier__c=specialityCopay.id;
         steppedCopay3.Min_Range__c=10;
         steppedCopay3.Max_Range__c=10;         
         steppedCopay3.Dollar_Amount__c=10;          
         insert steppedCopay3;


         SteppedCopay__c oonSteppedCopay3=new SteppedCopay__c(); 
         oonSteppedCopay3.Copay_Tier__c=oonCopay.id;
         oonSteppedCopay3.Min_Range__c=10;
         oonSteppedCopay3.Max_Range__c=10;         
         oonSteppedCopay3.Dollar_Amount__c=10;          
         insert oonSteppedCopay3;

         SteppedCopay__c specoonSteppedCopay3=new SteppedCopay__c(); 
         specoonSteppedCopay3.Copay_Tier__c=SpecialoonCopay.id;
         specoonSteppedCopay3.Min_Range__c=10;
         specoonSteppedCopay3.Max_Range__c=10;         
         specoonSteppedCopay3.Dollar_Amount__c=10;          
         insert specoonSteppedCopay3;        
         
        PageReference newCrdNewCopay = Page.VF_crdNewSteppedCoPay; 
        newCrdNewCopay.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(newCrdNewCopay); 
        
        ApexPages.StandardController s = new ApexPages.standardController(steppedCopay);        
        VFP_CRDNewSteppedCoPayController controller = new VFP_CRDNewSteppedCoPayController(s);
        controller.specialityoonparentid = SpecialoonCopay.id;
        
        controller.mailParentId =mailCopay.Id;
        controller.getItems();
        controller.steppedPaperCopayWrapper[0].noOfSteps=1;
        controller.steppedSpecialityCopayWrapper[0].noOfSteps=1;
       controller.steppedRetailCopayWrapper[0].noOfSteps=1;
       
       controller.steppedOOnCopayWrapper[0].noOfSteps=1;
       controller.oonParentId=oonCopay.id;
       controller.sortOOnlist();
       controller.steppedRetailCopayWrapper[0].isRetailtoSpeciality=true;
        controller.steppedRetailCopayWrapper[0].isRetailtoPaper=true;
        controller.steppedRetailCopayWrapper[0].steppedCopayItemList.add(steppedCopay1);
       controller.steppedMailCopayWrapper[0].noOfSteps=1;        
       controller.retailTier2Copy=Retail.id;
       controller.isRetailtoPaper=true;
       controller.isSteppedPaper=true;
       controller.isSteppedSpeciality=true;
       controller.isRetailtoSpeciality=true; 
       
       controller.sortRetaillist();      
       
      // controller.copyFromRetail();
       controller.isSteppedPaper=false;
       controller.isSteppedSpeciality=false;           
       controller.isRetailtoSpeciality=true;
       controller.isRetailtoPaper=true;    
       
              
       
       //controller.copyFromRetail();                                             
       controller.sortPaperlist(); 
       controller.previousStep();
       controller.Save();
       controller.crd.Any_drug_specific_Specialty_copays__c=true;
       controller.Save();
       
       controller.retailParentId=RetailCopay.id;
       controller.paperParentId=RetailCopay.id;
        controller.specialityParentId =RetailCopay.id;
       
       controller.steppedRetailCopayWrapper[0].copayTierId= RetailCopay.id;
controller.sortRetaillist();

       //controller.mailParentId=RetailCopay.id;
       //controller.steppedMailCopayWrapper[0].copayTierId= RetailCopay.id;
        controller.sortMaillist();
        controller.steppedSpecialityCopayWrapper[0].copayTierId= RetailCopay.id;
         controller.sortSpecialitylist();
         controller.steppedPaperCopayWrapper[0].copayTierId= RetailCopay.id;
         controller.sortPaperlist();
        ApexPages.StandardController s2 = new ApexPages.standardController(steppedCopay);        
        VFP_CRDNewSteppedCoPayController controller2 = new VFP_CRDNewSteppedCoPayController(s2);
        controller2.getTypeOfStepCopay();        
        controller2.sortMaillist();                                 
        controller2.sortPaperlist();    
        controller2.sortRetaillist();
        controller2.sortSpecialitylist();
        
        controller.steppedspecialityOONCopayWrapper[0].copayTierId= SpecialoonCopay.id;

        controller2.sortspecialityoonlist();
        controller2.Save(); 
    
        
        controller.steppedRetailCopayWrapper = controller.steppedMailCopayWrapper;
        controller.previousStep();
       // controller.copayTierList = null;
        controller.checkSteppedCopayStatus();
        controller.specialityOONParentId = specoonSteppedCopay3.id;
        controller.steppedSpecialityOOnCopayWrapper[0].copayTierId = controller.specialityOONParentId;
        controller.sortSpecialityOOnlist();
        controller.specialityOONParentId= specoonSteppedCopay3.id;
        controller.steppedSpecialityOOnCopayWrapper[0].copayTierId = controller.specialityOONParentId;
        
        controller.sortSpecialityOOnlist();  
        controller.steppedPaperCopayWrapper = controller.steppedSpecialityOOnCopayWrapper;
        controller.save();
        controller.previousStep2();
        controller.save2();
        
        

        
        

     }
      static testMethod void testCrdNewCoPay1(){
         CRD__c testCrd=new CRD__c();     
         testCrd.Any_DAW_specific_Retail_copays__c=true;
         insert testCrd;  
         
         Copay_Tier__c mailCopay= new Copay_Tier__c();
         mailCopay.Stepped_Copay__c=true;
         mailCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();
         mailCopay.CRD__c = testCrd.id;
         insert mailCopay;
         
         Copay_Tier__c Retail= new Copay_Tier__c();
         Retail.Stepped_Copay__c=true;
         Retail.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
         Retail.CRD__c = testCrd.id;
         insert Retail;
         
         Copay_Tier__c Paper= new Copay_Tier__c();
         Paper.Stepped_Copay__c=true;
         Paper.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper').getRecordTypeId();
         Paper.CRD__c = testCrd.id;
         insert Paper;
         
         Copay_Tier__c Specialty= new Copay_Tier__c();
         Specialty.Stepped_Copay__c=true;
         Specialty.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Specialty').getRecordTypeId();
         Specialty.CRD__c = testCrd.id;
         insert Specialty;
         
         
         Copay_Tier__c oonCopay= new Copay_Tier__c();
         oonCopay.Stepped_Copay__c=true;
         oonCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper Out of Network').getRecordTypeId();
         oonCopay.CRD__c = testCrd.id;
         insert oonCopay;      

        Copay_Tier__c SpecialoonCopay= new Copay_Tier__c();
         SpecialoonCopay.Stepped_Copay__c=true;
         SpecialoonCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Specialty OON').getRecordTypeId();
         SpecialoonCopay.CRD__c = testCrd.id;
         insert SpecialoonCopay; 
         
         
         
         SteppedCopay__c steppedCopay=new SteppedCopay__c(); 
         steppedCopay.Copay_Tier__c=mailCopay.id;
         steppedCopay.Min_Range__c=10;
         steppedCopay.Max_Range__c=10;         
         steppedCopay.Dollar_Amount__c=10;
         insert steppedCopay;
         
         Copay_Tier__c RetailCopay= new Copay_Tier__c();
         RetailCopay.Stepped_Copay__c=true;        
         RetailCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId();
         RetailCopay.CRD__c = testCrd.id;
         insert RetailCopay;
         SteppedCopay__c steppedCopay1=new SteppedCopay__c(); 
         steppedCopay1.Copay_Tier__c=RetailCopay.id;
         steppedCopay1.Min_Range__c=10;
         steppedCopay1.Max_Range__c=10;         
         steppedCopay1.Dollar_Amount__c=10;
         insert steppedCopay1;         
         
         Copay_Tier__c paperCopay= new Copay_Tier__c();
         paperCopay.Stepped_Copay__c=true;
         paperCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Paper').getRecordTypeId();
         paperCopay.CRD__c = testCrd.id;
         insert paperCopay;
         
         SteppedCopay__c steppedCopay2=new SteppedCopay__c(); 
         steppedCopay2.Copay_Tier__c=paperCopay.id;
         steppedCopay2.Min_Range__c=10;
         steppedCopay2.Max_Range__c=10;         
         steppedCopay2.Dollar_Amount__c=10;         
         insert steppedCopay2;         
         
         Copay_Tier__c specialityCopay = new Copay_Tier__c();
         specialityCopay.Stepped_Copay__c=true;         
         specialityCopay.recordtypeid=Schema.SObjectType.Copay_Tier__c.getRecordTypeInfosByName().get('Specialty').getRecordTypeId();
         specialityCopay.CRD__c = testCrd.id;
         insert specialityCopay;
         
         SteppedCopay__c steppedCopay3=new SteppedCopay__c(); 
         steppedCopay3.Copay_Tier__c=specialityCopay.id;
         steppedCopay3.Min_Range__c=10;
         steppedCopay3.Max_Range__c=10;         
         steppedCopay3.Dollar_Amount__c=10;          
         insert steppedCopay3;


         SteppedCopay__c oonSteppedCopay3=new SteppedCopay__c(); 
         oonSteppedCopay3.Copay_Tier__c=oonCopay.id;
         oonSteppedCopay3.Min_Range__c=10;
         oonSteppedCopay3.Max_Range__c=10;         
         oonSteppedCopay3.Dollar_Amount__c=10;          
         insert oonSteppedCopay3;

         SteppedCopay__c specoonSteppedCopay3=new SteppedCopay__c(); 
         specoonSteppedCopay3.Copay_Tier__c=SpecialoonCopay.id;
         specoonSteppedCopay3.Min_Range__c=10;
         specoonSteppedCopay3.Max_Range__c=10;         
         specoonSteppedCopay3.Dollar_Amount__c=10;          
         insert specoonSteppedCopay3;        
         
        PageReference newCrdNewCopay = Page.VF_crdNewSteppedCoPay; 
        newCrdNewCopay.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(newCrdNewCopay); 
        
        ApexPages.StandardController s = new ApexPages.standardController(steppedCopay);        
        VFP_CRDNewSteppedCoPayController controller = new VFP_CRDNewSteppedCoPayController(s);
       
        controller.previousStep();
        controller.steppedRetailCopayWrapper = controller.steppedMailCopayWrapper;
        controller.previousStep();
        controller.steppedPaperCopayWrapper = controller.steppedMailCopayWrapper;
        controller.previousStep();
        controller.steppedSpecialityCopayWrapper = controller.steppedMailCopayWrapper;
        
        controller.previousStep();
        controller.Save2();
        controller.Save();
    }       
   
          static testMethod void testCrdNewCoPay2(){
                 CRD__c testCRD = new CRD__c();
                 testCRD.Standard_or_Custom_Plan__c = 'creating a custom plan';
                
                 insert testCRD;
                 
                
          PageReference newCrdNewCopay = Page.VF_crdNewSteppedCoPay; 
        newCrdNewCopay.getParameters().put('crdid',testCrd.id);    
        Test.setCurrentPage(newCrdNewCopay); 
        SteppedCopay__c steppedCopay  = new SteppedCopay__c ();
        ApexPages.StandardController s = new ApexPages.standardController(steppedCopay);        
        VFP_CRDNewSteppedCoPayController controller = new VFP_CRDNewSteppedCoPayController(s);
            controller.checkSteppedCopayStatus();
            controller.save2();
          }

     
}