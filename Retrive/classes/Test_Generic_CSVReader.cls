/*
 Test class for Generic CSV reader
*/
@isTest
private class Test_Generic_CSVReader {

    static testMethod void readCVSList() {
        Generic_CSVReader csvHandle=new Generic_CSVReader();
        system.assert(csvHandle.readCVSList(Blob.valueOf('This is a sample'))[0].contains('This is a sample'));
        
    }
}