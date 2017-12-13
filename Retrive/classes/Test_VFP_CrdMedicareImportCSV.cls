/*Purpose: Apex Class for Test_VFP_CrdMedicareImportCSV
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Nitish                5/19/2015       Apex Class for Test_VFP_CrdMedicareImportCSV
========================================================================
*/
@isTest(SeeAllData=TRUE)
    public class Test_VFP_CrdMedicareImportCSV{
    static testMethod Void unitTestFI(){
    Datetime CurrentDate = system.now();
    List<case> cvscase = new List<case>();
    VFP_CrdMedicareImportCSV file=new VFP_CrdMedicareImportCSV ();
    StaticResource defaultResource = [Select id,name,Body From StaticResource where Name='TestImportCSV'];
    Blob content= defaultResource.Body;
    crd_medicare__c cmd = new crd_medicare__c();
    cmd.status__c = 'New';
    cmd.Formulary_Id__c = '123';
    insert cmd;
    system.debug('!!!!!'+cmd);
    case cases = new case();
    cases.status = 'New';
    cases.CRD_Medicare__c = cmd.id;
    insert cases;
    system.debug('0000'+cases);
    file.csvFileBody = content;
    system.debug('%%%%'+file.csvFileBody);
    file.importCSVFile();
    file.loadExistingBatch();
    }
    static testMethod Void unitTestSI(){
    Datetime CurrentDate = system.now();
    List<case> cvscase = new List<case>();
    VFP_CrdMedicareImportCSV file=new VFP_CrdMedicareImportCSV ();
    StaticResource defaultResource = [Select id,name,Body From StaticResource where Name='TestImportCSVSI'];
    Blob content= defaultResource.Body;
    crd_medicare__c cmd = new crd_medicare__c();
    cmd.status__c = 'New';
    cmd.Formulary_Id__c = '123';
    insert cmd;
    system.debug('!!!!!'+cmd);
    case cases = new case();
    cases.status = 'New';
    cases.CRD_Medicare__c = cmd.id;
    insert cases;
    system.debug('0000'+cases);
    file.csvFileBody = content;
    system.debug('%%%%'+file.csvFileBody);
    file.importCSVFile();
    file.loadExistingBatch();
    }
    
    static testMethod Void unitTestFail(){
    Datetime CurrentDate = system.now();
    List<case> cvscase = new List<case>();
    VFP_CrdMedicareImportCSV file=new VFP_CrdMedicareImportCSV ();
    StaticResource defaultResource = [Select id,name,Body From StaticResource where Name='TestImportCSVFail'];
    Blob content= defaultResource.Body;
    crd_medicare__c cmd = new crd_medicare__c();
    cmd.status__c = 'New';
    cmd.Formulary_Id__c = '123';
    insert cmd;
    system.debug('!!!!!'+cmd);
    case cases = new case();
    cases.status = 'New';
    cases.CRD_Medicare__c = cmd.id;
    insert cases;
    system.debug('0000'+cases);
    file.csvFileBody = content;
    system.debug('%%%%'+file.csvFileBody);
    file.setwrapperList();
    file.getwrapperList();
    VFP_CrdMedicareImportCSV.WrapCase wrc = new VFP_CrdMedicareImportCSV.WrapCase(cases);
    file.importCSVFile();
    file.loadExistingBatch();
    case cases1 = new case();
    cases.CRD_Medicare__c = cmd.id;
    insert cases1;
    file.csvFileBody = content;
    file.importCSVFile();
    }
    }