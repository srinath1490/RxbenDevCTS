/*Purpose: Apex Test Class for VFP_CRDNewCopay.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 9/6/2011       Apex Test Class for VFP_CRDNewCopay.
======================================================================== 
*/
@isTest
private class TEST_CRDNewCopay{
     static testMethod void testCrdNewCoPay(){
           CRD__c testCrd=new CRD__c();        
           testCrd.Plan_Type_Mail__c=true;
           testCrd.Plan_Type_Paper__c=true;
           testCrd.Plan_Type_Retail__c=true;
           testCrd.Plan_Type_Specialty__c=true;
           testCrd.Plan_Type_Specialty_OON__c=true;
           testCrd.Plan_Type_Paper_Out_of_Network__c=true;
           insert testCrd;

           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay ); 
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
          
           controller.picklistselectedvalue=12;
           controller.picklistselectedvalue1=1;
           controller.picklistselectedvalue2=1;
           controller.picklistselectedvalue3=1;
           //controller.picklistselectedvalue4=1;
           //controller.picklistselectedvalue5=1;
           controller.getRetaildata();
           controller.getMaildata();
           controller.getPaperdata();
           controller.getSpecialitydata();
           controller.getPaperOutOfNetworkdata();
           controller.getSpecialityOutOfNetworkdata();
           controller.getItems();           
           controller.sortReaillist(); 
           controller.sortPaperlist();      
           controller.sortSpecialitylist();       
           controller.sortMaillist();
           controller.sortPaperOutOfNetworkList();
           controller.sortSpecialityOutOfNetworkList();
           controller.save();
    
           Copay_Tier__c mailTier = new Copay_Tier__c();
           mailTier.CRD__c=testCrd.id;  
           mailTier.Stepped_Copay__c=true;
           mailTier.recordtypeId = controller.getRecordType('Mail');      
           insert mailTier;        
           SteppedCopay__c steppedCopay1=new SteppedCopay__c();
           steppedCopay1.Copay_Tier__c=mailTier.id;
           insert steppedCopay1;
        
           Copay_Tier__c paperTier = new Copay_Tier__c();
           paperTier.CRD__c=testCrd.id;  
           paperTier.Stepped_Copay__c=true;
           paperTier.recordtypeId = controller.getRecordType('Paper');      
           insert paperTier;        
           SteppedCopay__c steppedCopay2=new SteppedCopay__c();
           steppedCopay2.Copay_Tier__c=paperTier.id;
           insert steppedCopay2;
        
           Copay_Tier__c retailTier = new Copay_Tier__c();
           retailTier.CRD__c=testCrd.id;  
           retailTier.Stepped_Copay__c=true;
           retailTier.recordtypeId = controller.getRecordType('Retail');      
           insert retailTier;        
           SteppedCopay__c steppedCopay3=new SteppedCopay__c();
           steppedCopay3.Copay_Tier__c=retailTier.id;
           insert steppedCopay3;
        
           Copay_Tier__c specialityTier = new Copay_Tier__c();
           specialityTier.CRD__c=testCrd.id;  
           specialityTier.Stepped_Copay__c=true;        
           specialityTier.recordtypeId = controller.getRecordType('Specialty');      
           insert specialityTier;        
           SteppedCopay__c steppedCopay4=new SteppedCopay__c();
           steppedCopay4.Copay_Tier__c=specialityTier.id;
           insert steppedCopay4;
           
           Copay_Tier__c specialityOONTier = new Copay_Tier__c();
           specialityOONTier.CRD__c=testCrd.id;  
           specialityOONTier.Stepped_Copay__c=true;        
           specialityOONTier.recordtypeId = controller.getRecordType('Specialty OON');      
           insert specialityOONTier;        
           SteppedCopay__c steppedCopay5=new SteppedCopay__c();
           steppedCopay5.Copay_Tier__c=specialityOONTier.id;
           insert steppedCopay5;
           
           Copay_Tier__c PaperOONTier = new Copay_Tier__c();
           PaperOONTier.CRD__c=testCrd.id;  
           PaperOONTier.Stepped_Copay__c=true;        
           PaperOONTier.recordtypeId = controller.getRecordType('Paper Out of Network');      
           insert PaperOONTier;        
           SteppedCopay__c steppedCopay6=new SteppedCopay__c();
           steppedCopay6.Copay_Tier__c=PaperOONTier.id;
           insert steppedCopay6;
           
            ApexPages.StandardController s2 = new ApexPages.standardController(testCrd);        
            VFP_crdNewCoPay controller2 = new VFP_crdNewCoPay(s2);           
            controller2.save();
            controller2.showPanel();
            controller2.picklistselectedvalue=12;
            controller2.picklistselectedvalue1=1;
            controller2.picklistselectedvalue2=1;
            controller2.picklistselectedvalue3=1;
                      
            controller2.crd.Plan_Type_Paper__c=false;
            controller2.crd.Plan_Type_Mail__c=false;
            controller2.crd.Plan_Type_Retail__c=false;
            controller2.crd.Plan_Type_Specialty__c=false;
            controller2.crd.Integrate_with_Medical__c='No';
           
            controller2.isRetailtoPaper=true;
            controller2.crd.Plan_Type_Paper__c=true;
            controller2.crd.Plan_Type_Specialty__c=true;
            controller2.isRetailtoSpeciality=true; 
            controller2.copyFromRetail();
            controller2.crd.Plan_Type_Paper__c=false;
            controller2.crd.Plan_Type_Specialty__c=false;
            test.startTest();
            controller2.previousStep();         

            VFP_crdNewCoPay controller3 = new VFP_crdNewCoPay(s2);
            controller3.isSteppedAvailable=false;            
            controller3.crd.Plan_Type_Paper__c=false;
            controller3.showPaperPanel();
            controller3.crd.Plan_Type_Paper__c=true;            
            controller3.showPaperPanel();            
            
            controller3.sortPaperOutOfNetworkList(); 
            
            controller3.crd.Plan_Type_Specialty__c=false;
            controller3.showSpecialityPanel();
            controller3.crd.Plan_Type_Specialty__c=true;
            controller3.showSpecialityPanel();
            
            controller3.crd.Plan_Type_Retail__c=false;
            controller3.showRetailPanel();
            controller3.crd.Plan_Type_Retail__c=true;
            controller3.showRetailPanel();
            
            controller3.crd.Plan_Type_Mail__c=false;
            controller3.showMailPanel();
            controller3.crd.Plan_Type_Mail__c=false;
            controller3.showMailPanel();
            
            controller3.crd.Plan_Type_Paper_Out_of_Network__c=false;
            controller3.showpaperOOnPanel();
            controller3.crd.Plan_Type_Paper_Out_of_Network__c=true;
            controller3.showpaperOOnPanel();
            controller3.showOONLowerPanel();
            
            controller3.crd.Plan_Type_Specialty_OON__c=false;
            controller3.showSpecialityOONPanel();
            controller3.crd.Plan_Type_Specialty_OON__c=true;
            controller3.showSpecialityOONPanel();
            controller3.showSpecialityOONLowerPanel();
            controller3.save(); 
            delete testCrd; 
            controller3.save();
            test.stopTest();   
 
          
     }  
    static testMethod void testCrdNewCoPayUpdateTrigger(){
            list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and Name='Specialty' ]);   
            CRD__c testCrd1=new CRD__c();
            testCrd1.Plan_Type_Specialty__c=true;
            insert testCrd1;
                
            Copay_Tier__c specialityTier1 = new Copay_Tier__c();
            specialityTier1.CRD__c=testCrd1.id;  
            specialityTier1.Stepped_Copay__c=true;        
            specialityTier1.recordtypeId = rt.get(0).id; 
            insert specialityTier1;      
            SteppedCopay__c steppedCopay4=new SteppedCopay__c();
            steppedCopay4.Copay_Tier__c=specialityTier1.id;
            insert steppedCopay4;   
            specialityTier1.Stepped_Copay__c=false;
            specialityTier1.Dollar_Amount__c=10;
            update specialityTier1;  
            
                 
         }  
    static testMethod void testCrdNewCopay1(){
         CRD__c testCrd=new CRD__c();        
           //testCrd.Plan_Type_Mail__c=true;
          // testCrd.Plan_Type_Paper__c=true;
          //testCrd.Plan_Type_Retail__c=true;
          //testCrd.Plan_Type_Specialty__c=true;
           testCrd.Plan_Type_Paper_Out_of_Network__c=true;
           insert testCrd;
           
           Copay_Tier__c mailTier = new Copay_Tier__c();
           mailTier.CRD__c=testCrd.id;  
          // mailTier.Stepped_Copay__c=true;
           RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Mail'];
           mailTier.recordtypeId = mailRt.id;
           insert mailTier;        
           SteppedCopay__c steppedCopay1=new SteppedCopay__c();
           steppedCopay1.Copay_Tier__c=mailTier.id;
           insert steppedCopay1;
        
           Copay_Tier__c paperTier = new Copay_Tier__c();
           paperTier.CRD__c=testCrd.id;  
        //   paperTier.Stepped_Copay__c=true;
           RecordType paperRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Paper'];
           paperTier.recordtypeId = paperRt.id;
           insert paperTier;        
           SteppedCopay__c steppedCopay2=new SteppedCopay__c();
           steppedCopay2.Copay_Tier__c=paperTier.id;
           insert steppedCopay2;
        
           Copay_Tier__c retailTier = new Copay_Tier__c();
           retailTier.CRD__c=testCrd.id;  
        //   retailTier.Stepped_Copay__c=true;
           RecordType retailRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Retail'];
           retailTier.recordtypeId = retailRt.id;
           insert retailTier;        
           SteppedCopay__c steppedCopay3=new SteppedCopay__c();
           steppedCopay3.Copay_Tier__c=retailTier.id;
           insert steppedCopay3;
        
           Copay_Tier__c specialityTier = new Copay_Tier__c();
           specialityTier.CRD__c=testCrd.id;  
          // specialityTier.Stepped_Copay__c=true; 
           RecordType SpecialtyRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Specialty'];       
           specialityTier.recordtypeId = SpecialtyRt.id;
           insert specialityTier;        
           SteppedCopay__c steppedCopay4=new SteppedCopay__c();
           steppedCopay4.Copay_Tier__c=specialityTier.id;
           insert steppedCopay4;
           
           Copay_Tier__c paperOOnTier = new Copay_Tier__c();
           paperOOnTier .CRD__c=testCrd.id;  
          // specialityTier.Stepped_Copay__c=true;    
           RecordType oonRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Paper Out of Network'];           
           paperOOnTier .recordtypeId =oonRt.id;
           insert paperOOnTier ;        
           SteppedCopay__c oonSteppedCopay4=new SteppedCopay__c();
           oonSteppedCopay4.Copay_Tier__c=paperOOnTier .id;
           insert oonSteppedCopay4;   
           
           Copay_Tier__c SpecialtyOOnTier = new Copay_Tier__c();
           SpecialtyOOnTier.CRD__c=testCrd.id;  
          // specialityTier.Stepped_Copay__c=true;    
           RecordType soonRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Specialty OON'];           
           SpecialtyOOnTier.recordtypeId =soonRt.id;
           insert SpecialtyOOnTier;        
           SteppedCopay__c oonSteppedCopay5=new SteppedCopay__c();
           oonSteppedCopay5.Copay_Tier__c=SpecialtyOOnTier.id;
           insert oonSteppedCopay5;      
           
           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay );
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=true;                      
           controller.save();
           controller.previousStep();
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=true;
           controller.save();
           controller.previousStep();           
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Specialty__c=true;           
           controller.save();        
           controller.previousStep(); 
           
                        
    } 
    static testMethod void testCrdNewCopay2(){
           CRD__c testCrd=new CRD__c();        
           testCrd.Plan_Type_Mail__c=true;
           insert testCrd;
           
           Copay_Tier__c mailTier = new Copay_Tier__c();
           mailTier.CRD__c=testCrd.id;  
          // mailTier.Stepped_Copay__c=true;
           RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Mail'];
           mailTier.recordtypeId = mailRt.id;
           insert mailTier;        
           SteppedCopay__c steppedCopay1=new SteppedCopay__c();
           steppedCopay1.Copay_Tier__c=mailTier.id;
           insert steppedCopay1;
        
           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay ); 
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=true;                      
           controller.save();
           controller.previousStep();controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=true;
           controller.save();
           controller.previousStep();           
           
        }
        
        static testMethod void testCrdNewCopay3(){
           CRD__c testCrd=new CRD__c();        
           testCrd.Plan_Type_Paper__c=true;
           insert testCrd;
           
           Copay_Tier__c paperTier = new Copay_Tier__c();
           paperTier.CRD__c=testCrd.id;  
        //   paperTier.Stepped_Copay__c=true;
           RecordType paperRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Paper'];
           paperTier.recordtypeId = paperRt.id;
           insert paperTier;        
           SteppedCopay__c steppedCopay2=new SteppedCopay__c();
           steppedCopay2.Copay_Tier__c=paperTier.id;
           insert steppedCopay2;
        
           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay ); 
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=true;                      
           controller.save();
           controller.previousStep();controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=true;
           controller.save();
           controller.previousStep();           
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Specialty__c=true;           
           controller.save();        
           controller.previousStep(); 
        }
        
        static testMethod void testCrdNewCopay4(){
           CRD__c testCrd=new CRD__c(); 
           testCrd.Plan_Type_Retail__c=true;
           insert testCrd;
           
           Copay_Tier__c retailTier = new Copay_Tier__c();
           retailTier.CRD__c=testCrd.id;  
        //   retailTier.Stepped_Copay__c=true;
           RecordType retailRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Retail'];
           retailTier.recordtypeId = retailRt.id;
           insert retailTier;        
           SteppedCopay__c steppedCopay3=new SteppedCopay__c();
           steppedCopay3.Copay_Tier__c=retailTier.id;
           insert steppedCopay3;
           
           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay ); 
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=true;                      
           controller.save();
           controller.previousStep();controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=true;
           controller.save();
           controller.previousStep();           
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Retail__c=true;           
           controller.save();        
           controller.previousStep(); 
           
        }
        
        static testMethod void testCrdNewCopay5(){
           CRD__c testCrd=new CRD__c(); 
           testCrd.Plan_Type_Specialty__c=true;
           insert testCrd;
           List<Copay_Tier__c> lstOfCT =new List<Copay_Tier__c>();
           string rtName = 'Mail';
           Copay_Tier__c specialityTier = new Copay_Tier__c();
           specialityTier.CRD__c=testCrd.id;  
          // specialityTier.Stepped_Copay__c=true; 
           RecordType SpecialtyRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Specialty'];       
           specialityTier.recordtypeId = SpecialtyRt.id;
           insert specialityTier;
           lstOfCT.add(specialityTier);        
           SteppedCopay__c steppedCopay4=new SteppedCopay__c();
           steppedCopay4.Copay_Tier__c=specialityTier.id;
           insert steppedCopay4;
           
           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay ); 
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=true;                      
           controller.save();
           controller.previousStep();controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=true;
           controller.save();
           controller.previousStep();           
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Retail__c=false;
           controller.crd.Plan_Type_Specialty__c=true;           
           controller.save();
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Retail__c=false;
           controller.crd.Plan_Type_Specialty__c=false;           
           controller.save();
           controller.isRetailtoPaper = TRUE;
           controller.isRetailtoSpeciality = TRUE;
           controller.copyFromRetail();
           controller.checkChangedData();       
           controller.previousStep(); 
           controller.getspecialtyPicklistOptions();
           controller.showOONLowerPanelForNo();
           controller.showSpecialityOONLowerPanelforNo();
           controller.previousStep2();
           controller.Save1();
           controller.saveWrappedList1(lstOfCT,rtName);
           controller.updateWrappedList1(lstOfCT,rtName);
        }
        
        static testMethod void testCrdNewCopay6(){
           CRD__c testCrd=new CRD__c(); 
           testCrd.Plan_Type_Specialty_OON__c=true;
           insert testCrd;
           
           Copay_Tier__c SpecialtyOOnTier = new Copay_Tier__c();
           SpecialtyOOnTier.CRD__c=testCrd.id;  
          // specialityTier.Stepped_Copay__c=true;    
           RecordType soonRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Specialty OON'];           
           SpecialtyOOnTier.recordtypeId =soonRt.id;
           insert SpecialtyOOnTier;        
           SteppedCopay__c oonSteppedCopay5=new SteppedCopay__c();
           oonSteppedCopay5.Copay_Tier__c=SpecialtyOOnTier.id;
           insert oonSteppedCopay5;  
           
           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay ); 
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=true;                      
           controller.save();
           controller.previousStep();controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=true;
           controller.save();
           controller.previousStep();           
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Retail__c=false;
           controller.crd.Plan_Type_Specialty__c=false;
           controller.crd.Plan_Type_Specialty_OON__c=true;           
           controller.save();        
           controller.previousStep(); 
           
        }
        static testMethod void testCrdNewCopay7(){
           
           CRD__c testCrd=new CRD__c(); 
           testCrd.Plan_Type_Specialty__c=true;
           insert testCrd;
           List<Copay_Tier__c> lstOfCT =new List<Copay_Tier__c>();
           string rtName = 'Mail';
           Copay_Tier__c specialityTier = new Copay_Tier__c();
           specialityTier.CRD__c=testCrd.id;  
          // specialityTier.Stepped_Copay__c=true; 
           RecordType SpecialtyRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Specialty'];       
           specialityTier.recordtypeId = SpecialtyRt.id;
           insert specialityTier;
           lstOfCT.add(specialityTier);        
           SteppedCopay__c steppedCopay4=new SteppedCopay__c();
           steppedCopay4.Copay_Tier__c=specialityTier.id;
           insert steppedCopay4;
           
           
           
           
           
           Copay_Tier__c SpecialtyOOnTier = new Copay_Tier__c();
           SpecialtyOOnTier.CRD__c=testCrd.id;  
          // specialityTier.Stepped_Copay__c=true;    
           RecordType soonRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Specialty OON'];           
           SpecialtyOOnTier.recordtypeId =soonRt.id;
           insert SpecialtyOOnTier;        
           SteppedCopay__c oonSteppedCopay5=new SteppedCopay__c();
           oonSteppedCopay5.Copay_Tier__c=SpecialtyOOnTier.id;
           insert oonSteppedCopay5;  
           
           PageReference newCrdNewCopay = Page.VF_CRDNewCoPay; 
           newCrdNewCopay.getParameters().put('id',testCrd.id);    
           Test.setCurrentPage(newCrdNewCopay ); 
           ApexPages.StandardController s = new ApexPages.standardController(testCrd);        
           VFP_crdNewCoPay controller = new VFP_crdNewCoPay(s);
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=true;                      
           controller.save();
           controller.previousStep();controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=true;
           controller.save();
           controller.previousStep();           
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Retail__c=true;           
           controller.save();        
           controller.previousStep(); 
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Retail__c=false;
           controller.crd.Plan_Type_Specialty__c=true;
           controller.crd.Plan_Type_Specialty_OON__c=true;           
           controller.save();        
           controller.previousStep();
           controller.crd.Plan_Type_Mail__c=false;
           controller.crd.Plan_Type_Paper_Out_of_Network__c=false;                
           controller.crd.Plan_Type_Paper__c=false;
           controller.crd.Plan_Type_Retail__c=false;
           controller.crd.Plan_Type_Specialty__c=false;
           controller.crd.Plan_Type_Specialty_OON__c=true;           
           controller.save();        
           controller.previousStep();
           controller.isRetailtoPaper = TRUE;
           controller.isRetailtoSpeciality = TRUE;
           controller.copyFromRetail();
           controller.checkChangedData();       
           controller.previousStep(); 
           controller.getspecialtyPicklistOptions();
           controller.showOONLowerPanelForNo();
           controller.showSpecialityOONLowerPanelforNo();
           controller.previousStep2();
           controller.Save1();
           controller.saveWrappedList1(lstOfCT,rtName);
           controller.updateWrappedList1(lstOfCT,rtName);
        }
}