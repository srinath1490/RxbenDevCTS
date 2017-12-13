/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
   1.0 -   Becca Allen          05/30/2012                 Created the file 
   1.1 -    Becca Allen         12/10/2012                  updated with last modified date, last sent date, etc.
   1.2 -    Becca Allen         09/26/2013                  updated with HIX field auto-population on created case
======================================================================== */
public with sharing class GMF_XML_OptionCode {
    public boolean batchContext = false;
    Option_Code__c record;
    Map<String,String> rmap = new Map<String,String>();
    List<Map<String,String>> dummyChild = new List<Map<String,String>>();
    Id parentId;
  
    public GMF_XML_OptionCode (ApexPages.StandardController controller) {
        batchContext = GMFBuilderUtil.batchContext; 
        //Hix field added as per Request 01100, By Rahul Nasa
        parentId=controller.getId();
        record=[SELECT 
                        o.Effective_Date__c,o.LastModifiedDate,o.LastSent__c,o.Termination_Date__c,Hix__c,o.Primary_Secondary_Indicator__c, o.Option_Code_Name__c, o.Option_Code_Description__c, 
                        o.Name, o.Inactive__c,/*o.Number_of_Tiers__c,*/o.Open_Closed__c, o.Id,Sent_To_CVS_Date__c
                From Option_Code__c o 
                WHERE Id = :parentId];

        //Build MAPs
        rmap.put('OptionCodeID',String.valueOf(record.Name));
        rmap.put('OptionCodeName',String.valueOf(record.Option_Code_Name__c));
        rmap.put('OptionCodeDescription',String.valueOf(record.Option_Code_Description__c));
        rmap.put('PrimarySecondaryIndicator',String.valueOf(record.Primary_Secondary_Indicator__c));
     //   rmap.put('NumberOfTiers',String.valueOf(record.Number_of_Tiers__c));
        rmap.put('OpenClosed',String.valueOf(record.Open_Closed__c));
        rmap.put('Inactive',String.valueOf(record.Inactive__c));
        rmap.put('EffectiveDate',String.valueOf(record.Effective_Date__c));
        rmap.put('TerminationDate',String.valueOf(record.Termination_Date__c));        
        //Hix field added as per Request 01100, By Rahul Nasa
        rmap.put('HIX',String.valueOf(record.Hix__c));        
        //Hix field added as per Request 01100, By Rahul Nasa
        rmap.put('LastModifiedDate',String.valueOf(record.LastModifiedDate));
        //rmap.put('LastSent',String.valueOf(record.LastSent__c));
        rmap.put('SentToCVSDate',String.valueOf(record.Sent_To_CVS_Date__c));
        rmap.put('TimeStamp',String.valueOf(system.now()));
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
        String CurrentVersion='1.1';
        String s=gmfwriter.getparentXml(CurrentVersion,'OptionCode','',rmap,dummyChild);
        //updating record for custom history tracking. Added 12/28/2011- Saraag
         record.LastSent__c=system.now();
        
        //end
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        if(record.Sent_To_CVS_Date__c == null){
            c.CRD_GMF_Formulary_Drug_List__c = true;
        }
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=record.Effective_Date__c;
        c.Subject=String.valueOf(record.Name)+' '+'-'+' '+String.valueOf(record.Option_Code_Description__c);
        if (record.HIX__c == true) {
                c.HIX__c = true;
            } else {
                c.HIX__c = false;
            }
        GMFBuilderUtil.updateExternalCase(c,record);//Richa added for Req 6012    
        insert c;
         //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
          if(!batchContext){
              record.Sent_To_CVS_Date__c=system.now();
              record.PDF_Date__c=system.now(); 
              record.External_Case__c = c.id;   
          }
         update record;
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=record.Name+' '+system.now()+'.xml';
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
        Option_Code__c r = new Option_Code__c();
        r.Option_Code_Name__c = 'test';
        r.Option_Code_Description__c = 'new description';
        r.Primary_Secondary_Indicator__c = 'Primary';
        r.Effective_Date__c=system.today();
        r.Termination_Date__c=system.today().addDays(3);
        insert r;
        
        ApexPages.StandardController rsc = new ApexPages.StandardController(r);
        GMF_XML_OptionCode rc = new GMF_XML_OptionCode(rsc);
        rc.generateXML();
    }

}