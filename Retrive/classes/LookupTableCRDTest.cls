/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class LookupTableCRDTest {

    static testMethod void LookupTableCRDUnitTest1() {
      Test.startTest();

          Account acc = new Account(Name='Account1');
          insert acc;
        Crd__c  objCrd, objCrd1;
        objCrd = new Crd__c(account__c =acc.id,Plan_Type_Paper__c=true,RxPlanID__c='013',Platform_Information__c='H',TP_ID__c='0999',Rx_PP_ID__c='0987',Y_Schd__c = 'Y4',Effective_Start_Date__c= system.today());
        insert objCrd;
        Partial_Control_Group__c pcg=new Partial_Control_Group__c();
        insert pcg;
            CSAP_CGLP_Junction__c   objCSAP;
            objCSAP = new CSAP_CGLP_Junction__c   (CRD__c = objCrd.id,Partial_Control_Group__c=pcg.id);
        insert  objCSAP;
    TradPkgControlPlanLookup2s__c objtradpckControlPlanLup2 = new TradPkgControlPlanLookup2s__c(RxplanId__c='014',Key__c='786');
    
    insert objtradpckControlPlanLup2 ;
    objCrd.RxPlanID__c='014';
        update objCrd;


        
        objCrd1= new Crd__c(account__c=acc.id,Plan_Type_Paper__c=true,RxPlanID__c='015',Platform_Information__c='H',TP_ID__c='7654',Rx_PP_ID__c=null,Y_Schd__c = 'Y4',Effective_Start_Date__c= system.today());
        insert objCrd1;
        objCrd1.Y_Schd__c = 'Y3';
   		 objCrd1.TP_ID__c='0999';
        objCrd1.RxPlanID__c='016';
        insert (new TradPkgControlPlanLookup2s__c(RxplanId__c='016',Key__c='777'));
    
        update  objCrd1;

        
test.stopTest();
     }
           

          static testMethod void LookupTableCRDUnitTest2() {
          Test.startTest();
     
          Account acc = new Account(Name='Account2');
                  insert acc;
                Crd__c  objCrd, objCrd1;
                objCrd = new Crd__c(account__c =acc.id,Plan_Type_Paper__c=true,RxPlanID__c='013',Platform_Information__c='H',TP_ID__c=null,Rx_PP_ID__c=null,Y_Schd__c = 'Y4',Effective_Start_Date__c= system.today());
                insert objCrd;
				CSAP_CGLP_Junction__c   objCSAP;
                objCSAP = new CSAP_CGLP_Junction__c   (CRD__c = objCrd.id);
                insert  objCSAP;

                objCrd.Rx_PP_ID__c='01234';
				objCrd.RxPlanID__c='015';
                update objCrd;
                

                test.stopTest();
         }
                                     
                }