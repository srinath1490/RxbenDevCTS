/**
test class for CaseAuto_BatchLinker. Part of CaseAutomation.
 */
@isTest
private class Test_CaseAuto_BatchLinker {

    static testMethod void step1() {
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();       
        linker.callNext('BAT_TradFallNotifProcessor');
        test.stoptest();
    }
    static testMethod void step2() {
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();       
        linker.callNext('BAT_TradStdPkgProcessor');
        test.stoptest();
    }
    static testMethod void step3() {
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();       
        linker.callNext('BAT_TradStdNPkgProcessor');
        test.stoptest();
    }
    static testMethod void step4() {
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();
        linker.callNext('BAT_PERSPkgProcessor');
        test.stoptest();
    }
    static testMethod void fall(){
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();
    	linker.callTradFallout();
        test.stoptest();
    }
    static testMethod void cTradStdPkg(){
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();
    	linker.callTradStdPkg();
        test.stoptest();
    }
    static testMethod void TradStdNonPkg(){
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();
    	linker.callTradStdNonPkg();
        test.stoptest();
    }
    static testMethod void TradPERSPkg(){
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();
    	linker.callTradPERSPkg();
        test.stoptest();
    }
    static testMethod void TradPERSNonPkg(){
    	test.startTest();
        CaseAuto_BatchLinker linker=new CaseAuto_BatchLinker();
    	linker.callTradPERSNonPkg();
        test.stoptest();
    }
}