/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
    1.0 -   Allen, Becca          05/30/2012                   Created the file 
    1.1 -   Allen, Becca          12/10/2012                    Updated with Last Modified Date and Last Sent
======================================================================== */
public with sharing class GMF_XML_ObjectList_controller {
    
    Object_List__c OLrecord;
    public boolean batchContext = false;
    List<Object_List_Item__c>  OLIRecord = new List<Object_List_Item__c>();
    Map<String,String> OLmap = new Map<String,String>();
    Map<String,String> OLImap_2 = new Map<String,String>();
    List<Map<String,String>> OLImap = new List<Map<String,String>>();
  
    Id parentId;
  
    public GMF_XML_ObjectList_controller(ApexPages.StandardController controller) {
        batchContext = GMFBuilderUtil.batchContext; 
        parentId=controller.getId();
        OLrecord=[SELECT 
                        Effective_Date__c,Termination_Date__c,State__c, Standard__c, LastModifiedDate, LastSent__c,Segment__c, RecordType.Name, Platform__c, Object_List_Name__c, Object_List_Description__c, 
                        Name, Inactive__c, Id, Funding__c, Account__c,Sent_To_CVS_Date__c
                    FROM Object_List__c 
                    WHERE Id=:parentId LIMIT 1];
        OLIrecord=[SELECT   
                        Value__c, LastModifiedDate, Upper_Range__c, Upper_Age__c, Upper_Age_Type__c, Units__c, Test_Type__c, Test_Performed__c, 
                        Termination_date__c, Status__c, Standard_Text_Selection__c, Sequence__c, RecordType.Name, Qualifiers__c, 
                        Period__c, Operator__c, Object_List__c, Object_List_Name__c, Object_List_ID__c, Object_List_Description__c, 
                        Name, Lower_Range__c, Lower_Age__c, Lower_Age_Type__c, Lookback_Number_of_Periods__c, Lab_Test_Result_Value__c, 
                        Id, Gender__c, Effective_Date__c
                    FROM Object_List_Item__c 
                    WHERE Object_List__c=:OLrecord.Id AND isDeleted = false ];
                    
        //Build MAPs
        OLmap.put('ObjectListID',String.valueOf(OLrecord.Name));
        OLmap.put('ObjectListName',String.valueOf(OLrecord.Object_List_Name__c));
        OLmap.put('ObjectListDescription',String.valueOf(OLrecord.Object_List_Description__c));
        OLmap.put('RecordType',String.valueOf(OLrecord.RecordType.Name));
        OLmap.put('Inactive',String.valueOf(OLrecord.Inactive__c));
        OLmap.put('EffectivaDate',String.valueOf(OLrecord.Effective_Date__c));
        OLmap.put('TerminationDate',String.valueOf(OLrecord.Termination_Date__c));
        OLmap.put('LastModifiedDate',String.valueOf(OLrecord.LastModifiedDate));
        //OLmap.put('LastSent',String.valueOf(OLrecord.LastSent__c));
        OLmap.put('SentToCVSDate',String.valueOf(OLrecord.Sent_To_CVS_Date__c));
        OLmap.put('TimeStamp',String.valueOf(system.now()));
        
        for(Object_List_Item__c oli : OLIrecord){
            OLImap_2 = new Map<String,String>();
            OLImap_2.put('ObjectListItemID',String.valueOf(oli.Name));
            OLImap_2.put('Qualifiers',String.valueOf(oli.Qualifiers__c));
            OLImap_2.put('Value',String.valueOf(oli.Value__c));
            //OLImap_2.put('ObjectList',String.valueOf(oli.Object_List__c));  
            OLImap_2.put('LowerAgeType',String.valueOf(oli.Lower_Age_Type__c));  
            OLImap_2.put('UpperAgeType',String.valueOf(oli.Upper_Age_Type__c));    
            OLImap_2.put('Status',String.valueOf(oli.Status__c));    
            OLImap_2.put('EffectiveDate',String.valueOf(oli.Effective_Date__c));  
            OLImap_2.put('TerminationDate',String.valueOf(oli.Termination_date__c));  
            OLImap_2.put('TestType',String.valueOf(oli.Test_Type__c));
            OLImap_2.put('Gender',String.valueOf(oli.Gender__c));
            OLImap_2.put('LowerAge',String.valueOf(oli.Lower_Age__c));
            OLImap_2.put('UpperAge',String.valueOf(oli.Upper_Age__c));   
            OLImap_2.put('LabTestResultValue',String.valueOf(oli.Lab_Test_Result_Value__c));            
            OLImap_2.put('Units',String.valueOf(oli.Units__c));
            OLImap_2.put('Operator',String.valueOf(oli.Operator__c));
            OLImap_2.put('LowerRange',String.valueOf(oli.Lower_Range__c));
            OLImap_2.put('UpperRange',String.valueOf(oli.Upper_Range__c));
            OLImap_2.put('TestPerformed',String.valueOf(oli.Test_Performed__c));
            OLImap_2.put('StandardTextSelection',String.valueOf(oli.Standard_Text_Selection__c));
            OLImap_2.put('LookbackNumberOfPeriods',String.valueOf(oli.Lookback_Number_of_Periods__c));
            OLImap_2.put('Period',String.valueOf(oli.Period__c));
            OLImap_2.put('OLILastModifiedDate',String.valueOf(oli.LastModifiedDate));
            
            OLImap.add(OLImap_2);
        }
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
        String CurrentVersion='1.1';
        String s=gmfwriter.getparentXml(CurrentVersion,'ObjectList','ObjectListItem',OLmap,OLImap);
        
        //Updating Record for custom History tracking
        OLrecord.LastSent__c=system.now();
        
        
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.GMF_Drug_List__c = true;
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=OLrecord.Effective_Date__c;
        c.Subject=String.valueOf(OLrecord.Name)+' '+'-'+' '+String.valueOf(OLrecord.Object_List_Name__c);
        GMFBuilderUtil.updateExternalCase(c,OLrecord);//Richa added for Req 6012
        insert c;
        //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
        if(!batchContext){
          OLrecord.Sent_To_CVS_Date__c=system.now();
          OLrecord.PDF_Date__c=system.now();
          OLrecord.External_Case__c = c.id;
        }
        update OLrecord;
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=OLrecord.Name+' '+system.now()+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
        insert xmlAttach;
        
        String urlStr = '/'+String.valueOf(c.Id);
        PageReference MyObjectPR = new 
        PageReference(urlStr);
    
        return MyObjectPR;
    }
    
    /** 
    * =====================================================================
    *                          TEST CASE(S)
    * =====================================================================
    **/
    static testMethod void testXMLGeneration(){
        RecordType rt = [SELECT id from RecordType WHERE SobjectType = 'Object_List__c' AND DeveloperName like '%Prescriber%' LIMIT 1];
        Account a = new Account();
        a.Name = 'test Account';
        a.A_c_Email__c='a@a.com';
        insert a;
        
        Object_List__c ol = new Object_List__c();
        ol.Account__c = a.Id;
        ol.Object_List_Name__c = 'test';
        ol.Object_List_Description__c = 'new object list description';
        ol.Effective_Date__c=system.today();
        ol.Termination_Date__c=system.today().addDays(3);
        insert ol;
        
        Object_List_Item__c oli = new Object_List_Item__c();
        oli.Object_List__c = ol.Id;
        oli.Qualifiers__c = 'NPI';
        oli.Effective_Date__c = system.today();
        oli.Value__c = 'test';
        oli.Termination_date__c = system.today() + 5;
        insert oli;     
        
        ApexPages.StandardController olsc = new ApexPages.StandardController(ol);
        GMF_XML_ObjectList_controller olrc = new GMF_XML_ObjectList_controller(olsc);
        olrc.generateXML();
    }
    
}