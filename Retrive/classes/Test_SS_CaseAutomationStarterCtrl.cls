@isTest
public class Test_SS_CaseAutomationStarterCtrl{

static testMethod void falloutStd1(){
	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
    
	ssobj.confirmForceRun=true;
	ssobj.confirmFallout=true;
test.startTest();
    ssobj.fallout();
test.stopTest();

}

static testMethod void falloutStd2(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmFallout=true;
	ssobj.LimitByDefault=true;
test.startTest();
    ssobj.fallout();
test.stopTest();

ssobj.LimitByDefault=true;
ssobj.DateLimit=true;
ssobj.confirmForceRun=true;
ssobj.confirmFallout=true;
ssobj.fallout();  

}

static testMethod void falloutLimited(){
    	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
		ssobj.confirmForceRun=true;
	ssobj.confirmFallout=true;
	ssobj.LimitedExecution=true;
	ssobj.LimitByDefault=true;
test.startTest();
    ssobj.fallout();
test.stopTest();

    ssobj.confirmForceRun=true;
	ssobj.confirmFallout=true;
	ssobj.LimitedExecution=true;
	ssobj.DateLimitDefault=true;
	ssobj.fallout();

}

//----- Std success


static testMethod void stdsuccesspkg1(){
	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmSuccesspkg=true;
test.startTest();
    ssobj.StdPkg();
test.stopTest();

}

static testMethod void stdsuccesspkg2(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmSuccesspkg=true;
	ssobj.LimitByDefault=true;
test.startTest();
    ssobj.StdPkg();
test.stopTest();

ssobj.LimitByDefault=true;
ssobj.DateLimit=true;
ssobj.confirmForceRun=true;
ssobj.confirmSuccesspkg=true;
ssobj.StdPkg();  

}

static testMethod void stdsuccesspkg2Limited(){
    	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
		ssobj.confirmForceRun=true;
	ssobj.confirmSuccessPkg=true;
	ssobj.LimitedExecution=true;
	ssobj.LimitByDefault=true;
test.startTest();
    ssobj.StdPkg();
test.stopTest();

    ssobj.confirmForceRun=true;
	ssobj.confirmSuccessPkg=true;
	ssobj.LimitedExecution=true;
	ssobj.DateLimitDefault=true;
	ssobj.StdPkg();

}

//----- Std Nonpkg success


static testMethod void stdsuccessnpkg1(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmSuccessnonPkg=true;
test.startTest();
    ssobj.stdnpkg();
test.stopTest();

}

static testMethod void stdsuccessnpkg2(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmSuccessnonPkg=true;
ssobj.LimitbyDefault=true;
test.startTest();
    ssobj.StdPkg();
test.stopTest();

ssobj.LimitByDefault=true;
ssobj.DateLimit=true;
ssobj.confirmForceRun=true;
ssobj.confirmSuccesspkg=true;
ssobj.stdnpkg();  

}

static testMethod void stdsuccessnpkg2Limited(){
    	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
		ssobj.confirmForceRun=true;
	ssobj.confirmSuccessnonpkg=true;
	ssobj.LimitedExecution=true;
	ssobj.DateLimitDefault=true;
test.startTest();
    ssobj.StdnPkg();
test.stopTest();

    ssobj.confirmForceRun=true;
	ssobj.confirmSuccessnonpkg=true;
	ssobj.LimitedExecution=true;
	ssobj.DateLimitDefault=true;
	ssobj.stdnpkg();

}

//----- Std PERS pkg success


static testMethod void PersPkg1(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmPERSpkg=true;
test.startTest();
    ssobj.PersPkg();
test.stopTest();

}

static testMethod void PersPkg2(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmPERSpkg=true;
	ssobj.LimitedExecution=true;
test.startTest();
    ssobj.PersPkg();
test.stopTest();

ssobj.LimitByDefault=true;
ssobj.DateLimit=true;
ssobj.confirmForceRun=true;
ssobj.confirmPERSpkg=true;
ssobj.stdnpkg();  

}

static testMethod void PersPkgLimited(){
    	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
		ssobj.confirmForceRun=true;
	ssobj.confirmPERSpkg=true;
	ssobj.LimitedExecution=true;
	//ssobj.stdnpkg=true;
test.startTest();
    ssobj.PersPkg();
test.stopTest();

    ssobj.confirmForceRun=true;
	ssobj.confirmPERSpkg=true;
	ssobj.LimitedExecution=true;
	ssobj.DateLimitDefault=true;
	ssobj.PersPkg();

}
//----- Std PERS non-pkg success


static testMethod void PersNPkg1(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmPERSnonpkg=true;
test.startTest();
    ssobj.PersNPkg();
test.stopTest();

}

static testMethod void PersNPkg2(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmPERSnonpkg=true;
	ssobj.LimitedExecution=true;
test.startTest();
    ssobj.PersNPkg();
test.stopTest();

ssobj.LimitByDefault=true;
ssobj.DateLimit=true;
ssobj.confirmForceRun=true;
ssobj.confirmPERSnonpkg=true;
ssobj.PersNPkg();  

}

static testMethod void PersNPkgimited(){
    	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
		ssobj.confirmForceRun=true;
	ssobj.confirmPERSnonpkg=true;
	ssobj.LimitedExecution=true;
	//.stdnpkg=true;
test.startTest();
    ssobj.PersNPkg();
test.stopTest();

    ssobj.confirmForceRun=true;
	ssobj.confirmPERSnonpkg=true;
	ssobj.LimitedExecution=true;
	ssobj.LimitBy=true;
	ssobj.LimitByValue=100;
	ssobj.PersNPkg();
	List<asyncapexJob> s=ssobj.ApexJobList;
}

    
    static testMethod void genericstd1(){
        SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
		ssobj.confirmForceRun=true;
test.startTest();
    ssobj.GenericRun();
test.stopTest();
        
    }
    
    static testMethod void genericStd2(){
		SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	ssobj.confirmForceRun=true;
	ssobj.confirmFallout=true;
	ssobj.LimitByDefault=true;
test.startTest();
    ssobj.GenericRun();
test.stopTest();
ssobj.LimitedExecution=true;
ssobj.LimitByDefault=true;
ssobj.DateLimit=true;
ssobj.confirmForceRun=true;
ssobj.confirmFallout=true;
ssobj.GenericRun(); 

}

static testMethod void genericLimited(){
    	SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
		ssobj.confirmForceRun=true;
	ssobj.confirmFallout=true;
	ssobj.LimitedExecution=true;
	ssobj.LimitByDefault=true;
test.startTest();
    ssobj.GenericRun();
test.stopTest();

    ssobj.confirmForceRun=true;
	ssobj.confirmFallout=true;
	ssobj.LimitedExecution=true;
	ssobj.DateLimitDefault=true;
	ssobj.GenericRun();

}
    
    static testmethod void filters(){
                SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();

    	ssobj.LimitBy=true;
        ssobj.LimitBydefault=true;
        ssobj.DateLimit=true;
        ssobj.DateLimitDefault=true;
        ssobj.getFilters();
        ssobj.showApexJobs();
           ssobj.cancelJob();

    }
    
    static testMethod void forcedrunFalse(){
     	  SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	 	  ssobj.confirmForceRun=false;
   		  ssobj.fallout();
            ssobj.PersNPkg();
            ssobj.PersPkg();
            ssobj.stdnpkg();
            ssobj.StdPkg();
        	ssobj.GenericRun();
        
 
    }
       static testMethod void invalidFilters(){
     	  SS_CaseAutomationStarterCtrl ssobj= new SS_CaseAutomationStarterCtrl();
	 	  ssobj.confirmForceRun=true;
           	ssobj.LimitedExecution=true;
			ssobj.LimitBy=true;
       		ssobj.LimitBydefault=true;
        	ssobj.DateLimit=true;
       		ssobj.DateLimitDefault=true;
   		  ssobj.fallout();
            ssobj.PersNPkg();
            ssobj.PersPkg();
            ssobj.stdnpkg();
            ssobj.StdPkg();
        	ssobj.GenericRun();
           
           //---
          
           	ssobj.LimitBy=true;
       		ssobj.LimitBydefault=false;
        	ssobj.DateLimit=false;
       		ssobj.DateLimitDefault=false;
          	ssobj.LimitByvalue=NULL;
        	ssobj.fallout();
            ssobj.PersNPkg();
            ssobj.PersPkg();
            ssobj.stdnpkg();

        	ssobj.GenericRun();

    }
}