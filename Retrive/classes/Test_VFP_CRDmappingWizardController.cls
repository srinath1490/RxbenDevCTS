/*Purpose: Apex Test Class for VFP_CRDmappingWizardController
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Sushant                09/06/2017      Apex Test Class for VFP_CRDmappingWizardController
======================================================================== 
*/

@isTest(seealldata=false)

private class Test_VFP_CRDmappingWizardController{

    static testMethod void unitTestMethod(){
        set<string> globalRecordsSet = new set<string>{'crd__c','drug_coverage__c','accumulations__c','network_junction__c','DC_Drug_List_Group__c'};
        map<string,string> recordMap = new map<string,string>();
        recordMap.put('drug_coverage__c','drug coverage');
        // Mapping Column Record
        Mapping__c mc = new Mapping__c();
        mc.create__c = false;
        mc.Object__c = 'drug_coverage__c';
        mc.Object_Label__c='Drug Coverage';        
        insert mc;
        
        //Mapping Column Record
        Mapping__c mc1 = new Mapping__c();
        mc1.create__c = FALSE;
        mc1.Object__c = 'DC_Drug_List_Group__c';
        mc1.Object_Label__c = 'DC Drug List Group';
        insert mc1;
        
        Mapping__c mc2 = new Mapping__c();
        mc2.create__c = True;
        mc2.Object__c = 'CRD__c';
        mc2.Object_Label__c = 'CRD';
        insert mc2;
        
        //Provision Record
        Provision__c pr = new Provision__c();
        pr.name = 'Provision 9999';
        pr.Provision_Text__c = 'Test Class Provision';
        pr.ProvisionNumber__c = 9999;
        pr.active__c = TRUE;
        insert pr;
        
        //Mapping Template Record       
        Mapping_Template__c mt1 = new Mapping_Template__c();
        mt1.MappingColumnID__c = mc.id;
        mt1.Provisionid__c=pr.id;
        insert mt1;
        
        //Mapping Template Record       
        Mapping_Template__c mtnew = new Mapping_Template__c();
        mtnew.MappingColumnID__c = mc2.id;
        mtnew.Provisionid__c=pr.id;
        insert mtnew;
        
        //Mapping Template Record 
        Mapping_Template__c mt = new Mapping_Template__c();
        mt.MappingColumnID__c = mc1.id;
         mt.Provisionid__c =pr.id;
        insert mt;
        
        //Access the White List under Custom Setting ProvisionList
        list<string> customSettingList = new list<string>(); 
        List<string> provisionOptions = new list<string>();       
                   for(Provisions__c item : Provisions__c.getall().values())
                    {
                    system.debug('####@@@@'+Provisions__c.getall().values());
                        customSettingList.add(Item.name); 
                    }
        
        //Line Value Record
        LineValue__c lv = new LineValue__c();
        lv.active__c = TRUE;
        lv.Line_value__c = 9999;
        lv.name = 'P9999L9999';
        lv.Line_value_text__c = 'Test Class Line Value';
        lv.Provision_ID__c = pr.id;
        insert lv;
        Provisions__c provisionListCustomSetting = new Provisions__c();
        provisionListCustomSetting.Provision_Name__c = 'Provision 9999';
        provisionListCustomSetting.name = '9999';
        insert provisionListCustomSetting;
        //Mapping value record
        Mapping_Values__c mv = new Mapping_Values__c();
                
                mv.FieldValue__c = 'TestJR';
                mv.Line_ValueID__c = lv.id;
                mv.MappingColumnID__c =mc1.id;
                mv.Start_Date__c = system.today();
                mv.End_Date__c = system.today().addDays(2);
                insert mv;
       Mapping_Values__c mv2 = new Mapping_Values__c();
                
                mv2.FieldValue__c = 'TestJR';
                mv2.Line_ValueID__c = lv.id;
                mv2.MappingColumnID__c =mc2.id;
                mv2.Start_Date__c = system.today();
                mv2.End_Date__c = system.today().addDays(2);
                insert mv2;
        
        
        Test.setCurrentPageReference(new PageReference('Page.VF_CRDmappingWizard')); 
        VFP_CRDmappingWizardController controller =new VFP_CRDmappingWizardController(); 
        controller.selectedProvision = '9999';  
        controller.selectedLineValue = '9999';
        controller.getlstProvisions();
        controller.getlstLineValues();
        controller.loadLinevalues();
        controller.setlstProvisions();
        controller.setlstLineValues();
        controller.loadMappingFiles();
        controller.newLinevalue();
        controller.editFieldValue();
        controller.saveFieldValue();
        controller.cancelFieldValue();
    }             

}