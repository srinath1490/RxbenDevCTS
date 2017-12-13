/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
   1.0 -    Becca Allen           05/30/2012               Created the file 
   1.1 -    Becca Allen             12/10/2012              updated with Last Modified Date, Last Sent Date, etc.
======================================================================== */
public with sharing class GMF_XML_ClinicalProgramGroup {
    public boolean batchContext = false;
    Clinical_Program_Group__c CPGrecord;
    List<Clinical_Program_Junction__c>  CPJRecord = new List<Clinical_Program_Junction__c>();
    Map<String,String> CPGmap = new Map<String,String>();
    Map<String,String> CPJmap_2 = new Map<String,String>();
    List<Map<String,String>> CPJmap = new List<Map<String,String>>();
  
    Id parentId;
  
    public GMF_XML_ClinicalProgramGroup(ApexPages.StandardController controller) {
        batchContext = GMFBuilderUtil.batchContext;
        parentId=controller.getId();
        //Hix field added as per Request 01100, By Rahul Nasa
        CPGrecord=[SELECT 
                        Effective_Date__c,Termination_Date__c,Hix__c,LastModifiedDate, LastSent__c, RecordType.Name, Name, Inactive__c, Id, Clinical_Program_Group_Name__c, 
                        Clinical_Program_Group_Description__c,Sent_To_CVS_Date__c
                    FROM Clinical_Program_Group__c 
                    WHERE Id=:parentId AND isDeleted = false LIMIT 1];
        CPJRecord=[SELECT   
                        Name, Id, Clinical_Program__r.Name,Clinical_Program__r.LastModifiedDate, Clinical_Program__r.LastSent__c,Clinical_Program__r.Sent_To_CVS_Date__c, Clinical_Program__r.Clinical_Programs_Name__c, Clinical_Program__r.Description__c
                    FROM Clinical_Program_Junction__c 
                    WHERE Clinical_Program_Group__c=:CPGrecord.Id AND isDeleted = false];
                    
        //Build MAPs
        CPGmap.put('ClinicalProgramGroupID',String.valueOf(CPGrecord.Name));
        CPGmap.put('ClinicalProgramGroupName',String.valueOf(CPGrecord.Clinical_Program_Group_Name__c));
        CPGmap.put('ClinicalProgramGroupDescription',String.valueOf(CPGrecord.Clinical_Program_Group_Description__c));
        CPGmap.put('Inactive',String.valueOf(CPGrecord.Inactive__c));
        CPGmap.put('RecordType',String.valueOf(CPGrecord.RecordType.Name));
        CPGmap.put('EffectiveDate',String.valueOf(CPGrecord.Effective_Date__c));
        CPGmap.put('TerminationDate',String.valueOf(CPGrecord.Termination_Date__c));
        //Hix field added as per Request 01100, By Rahul Nasa
        CPGmap.put('HIX',String.valueOf(CPGrecord.Hix__c));
        //Hix field added as per Request 01100, By Rahul Nasa
        CPGmap.put('LastModifiedDate',String.valueOf(CPGrecord.LastModifiedDate));
        //CPGmap.put('LastSent',String.valueOf(CPGrecord.LastSent__c));
        CPGmap.put('SentToCVSDate',String.valueOf(CPGrecord.Sent_To_CVS_Date__c));
        CPGmap.put('TimeStamp',String.valueOf(system.now()));
        
        for(Clinical_Program_Junction__c cpj : CPJRecord){
            CPJmap_2 = new Map<String,String>();
            CPJmap_2.put('ClinicalProgramJunction',String.valueOf(cpj.Name));
            CPJmap_2.put('ClinicalProgram',String.valueOf(cpj.Clinical_Program__r.Name));
            CPJmap_2.put('ClinicalProgramName',String.valueOf(cpj.Clinical_Program__r.Clinical_Programs_Name__c));
            CPJmap_2.put('ClinicalProgramDescription',String.valueOf(cpj.Clinical_Program__r.Description__c));
            CPJmap_2.put('ClinicalProgramLastModified',String.valueOf(cpj.Clinical_Program__r.LastModifiedDate));
            CPJmap_2.put('ClinicalProgramSentToCVSDate',String.valueOf(cpj.Clinical_Program__r.Sent_To_CVS_Date__c));  
            CPJmap.add(CPJmap_2);
        }
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
        String CurrentVersion='1.1';
        String s=gmfwriter.getparentXml(CurrentVersion,'ClinicalProgramGroup','ClinicalProgramGroupJunction',CPGmap,CPJmap);
        //Updating record for custom history tracking.Added 12/28/11- Saraag
         CPGrecord.LastSent__c=system.now();
        
        //End
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=CPGrecord.Effective_Date__c;
        c.CRD_GMF_Clinical_Programs__c = true;
        c.Subject=String.valueOf(CPGrecord.Name)+' '+'-'+' '+String.valueOf(CPGrecord.Clinical_Program_Group_Name__c);
        GMFBuilderUtil.updateExternalCase(c,CPGrecord);//Richa added for Req 6012
        insert c;
        //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
         if(!batchContext){
          CPGrecord.Sent_To_CVS_Date__c=system.now();
          CPGrecord.PDF_Date__c=system.now();
          CPGrecord.External_Case__c = c.id;
         }
         update CPGrecord;
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=CPGrecord.Name+' '+system.now()+'.xml';
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
        
        Account a = new Account();
        a.Name = 'test';
        insert a;
        
        Clinical_Program_Group__c cpg = new Clinical_Program_Group__c();
        RecordType rt = [SELECT id from RecordType WHERE SobjectType = 'Clinical_Program_Group__c' AND developerName like '%RxCheck%' AND isActive = true LIMIT 1];
        cpg.Clinical_Program_Group_Name__c = 'test';
        cpg.Clinical_Program_Group_Description__c = 'description';
        cpg.RecordTypeId = rt.Id;
        cpg.Effective_Date__c=system.today();
        cpg.Termination_Date__c=system.today().addDays(3);
        insert cpg;
        
        rt = [SELECT id from RecordType WHERE SobjectType = 'Clinical_Program__c' AND developerName like '%RxCheck%' AND isActive = true LIMIT 1];
        Clinical_Program__c cp = new Clinical_Program__c();
        cp.Clinical_Programs_Name__c = 'test';
        cp.Description__c = 'test';
        cp.RecordTypeId = rt.Id;
        cp.Account__c = a.Id;
        insert cp;
        
        Clinical_Program_Junction__c cpj = new Clinical_Program_Junction__c();
        cpj.Clinical_Program__c = cp.Id;
        cpj.Clinical_Program_Group__c = cpg.Id;
        insert cpj;
        
        
        ApexPages.StandardController cpgsc = new ApexPages.StandardController(cpg);
        GMF_XML_ClinicalProgramGroup cpgrc = new GMF_XML_ClinicalProgramGroup(cpgsc);
        cpgrc.generateXML();
        
    }
    
}