/**
 Test case for CreateCase utility class.
 */
@isTest
private class CreateCaseTest {

    static testMethod void createcaseUnitTest1() {
       
       test.startTest();
           Account acc = new Account(Name='Account1');
           insert acc;
           Crd__c objCrd;
           date d = system.today();
            
           CreateCase objCreateCase = new CreateCase();
           List<string> lstRxPlanIds = new List<string>();
           Map<ID,NotificationStandard__c> MapCRDidNotificationStandard = new Map<ID,NotificationStandard__c>();
           list<Map<ID,NotificationStandard__c>> MapCRDidNotificationStandards = new list<Map<ID,NotificationStandard__c>>();
           
          Group g = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Managers'];
          RecordType rectype = [Select SobjectType, Name, Id, DeveloperName From RecordType  where  Name = 'Event Notifications' AND SobjectType = 'case'];
          
          Group g2 = [Select Type, Name, Id From Group  where Type = 'Queue' and Name = 'Case - BCT Supervisor Unassigned Cases'];      
          RecordType rectype2 = [Select SobjectType, Name, Id, DeveloperName From RecordType  where Name = 'Internal GMF Case' AND SobjectType = 'case'];
         
           
           for(integer i=0;i<5;i++){
               objCrd = new Crd__c(account__c =acc.id,Plan_Type_Paper__c=true,RxPlanID__c='013'+i,Platform_Information__c='H',TP_ID__c=null,Rx_PP_ID__c=null,Y_Schd__c = 'Y4',Effective_Start_Date__c= system.today());
               insert objCrd;
               lstRxPlanIds.add(objCrd.RxPlanID__c);
               NotificationStandard__c notstan= new NotificationStandard__c();
               MapCRDidNotificationStandard.clear();
               notstan.RxPlanID__c = objCrd.RxPlanID__c;
               MapCRDidNotificationStandard.put(objCrd.id,notstan);
               MapCRDidNotificationStandards.add(MapCRDidNotificationStandard);
           }
           
           NotificationFallout__c objFallout = new NotificationFallout__c(benefitsString__c='testbenefit',benefitsStringExtension__c='testextension',ControlPlan__c='testControl',ControlPlanEffective__c='TestCPeffective',
												CRD__c=objCrd.id,effectiveDate__c=d,ERB__c='erb',Fallout__c=true,FundingType__c='funding',PlanId__c = 'planid',pricingSchedule__c='pricingschedule',riskIndicator__c='RI',rxPlanBlock__c='rxplanblock',
												Rxplanid__c='056',Subsegment__c='subsegment',TermDate__c='termdate',tieredRxPlanBlock__c='testPlanBlock',traditionalHierarchy__c='tradHierarchy',CarrierId__c='testCarrier',Package__c=true,PSUID__c='psuid',Traditional__c=true,TypeOfPlan__c='test');
           
           NotificationStandard__c objSuccess = new NotificationStandard__c(benefitsString__c='testbenefit',benefitsStringExtension__c='testextension',ControlPlan__c='testControl',ControlPlanEffective__c='TestCPeffective',
												CRD__c=objCrd.id,effectiveDate__c=d,ERB__c='erb',Fallout__c=true,FundingType__c='funding',PlanId__c = 'planid',pricingSchedule__c='pricingschedule',riskIndicator__c='RI',rxPlanBlock__c='rxplanblock',
												Rxplanid__c='056',Subsegment__c='subsegment',TermDate__c='termdate',tieredRxPlanBlock__c='testPlanBlock',traditionalHierarchy__c='tradHierarchy',CarrierId__c='testCarrier',Package__c=true,PSUID__c='psuid',Traditional__c=true,TypeOfPlan__c='test');
           
           
            objCreateCase.InsertPackageplan(lstRxPlanIds[0]);
            objCreateCase.InsertPackageplans(lstRxPlanIds);
            objCreateCase.pullPackageplan(lstRxPlanIds[0]);
            objCreateCase.pullPackageplans(lstRxPlanIds);
            objCreateCase.pullFallout(objFallout);
            objCreateCase.pullnonpackageCPE(objSuccess);
            objCreateCase.pullPERSNPkgCRDnoCase(d,'1234567',objCrd.Id,system.now(),acc.Id);
            objCreateCase.pullPERSNPkgNoCRD(d,'901100CC2013-01-01',system.now());
            
            //MapCRDidNotificationStandard.put();
            objCreateCase.InsertNonPackageplan(MapCRDidNotificationStandard);
            
            objCreateCase.pullNonPackageplans(MapCRDidNotificationStandard);
            objCreateCase.pullNonPackageplans(MapCRDidNotificationStandards);
       test.stopTest();
    }
    
    static testMethod void formatTest(){
    	CreateCase obj=new createCase();
    	system.assert(obj.cpformat('0087 A').length()==9);
    }
}