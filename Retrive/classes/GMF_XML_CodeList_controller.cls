/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
    0.1 -   Allen Becca                 05/30/2012                 Created the file 
   
======================================================================== */
public with sharing class GMF_XML_CodeList_controller {
    
    Codes_List__c record;
    List<Codes__c> cRecord = new List<Codes__c>();
    Map<String,String> rmap = new Map<String,String>();
    Map<String,String> cmap_2 = new Map<String,String>();
    List<Map<String,String>> cmap = new List<Map<String,String>>();
  
    Id parentId;
  
    public GMF_XML_CodeList_controller(ApexPages.StandardController controller) {
        
        parentId=controller.getId();
        //Hix field added as per Request 01100, By Rahul Nasa
        record=[SELECT 
                        c.Name, c.Inactive__c, c.Id, c.Code_List_Name__c, c.Code_List_Description__c, 
                        c.RecordType.Name, c.Effective_Date__c, c.Termination_Date__c,Hix__c 
                    FROM Codes_List__c c
                    WHERE Id=:parentId AND isDeleted = false LIMIT 1];
        cRecord=[SELECT     
                        c.Related_Code_List__r.Name,c.Related_Code_List__c,c.Result_of_Service_Codes__c, c.RecordType.Name, c.Professional__c, c.POS_Dose_Optimization__c, c.Name, c.Id 
                    FROM Codes__c c
                    WHERE Related_Code_List__c=:record.Id AND isDeleted = false];
                    
        //Build MAPs
        rmap.put('CodeListID',String.valueOf(record.Name));
        rmap.put('CodeListName',String.valueOf(record.Code_List_Name__c));
        rmap.put('CodeListDescription',String.valueOf(record.Code_List_Description__c));
        rmap.put('Inactive',String.valueOf(record.Inactive__c));
        rmap.put('RecordType',String.valueOf(record.RecordType.Name));
        
        //removed fields
        
        rmap.put('EffectiveDate',String.valueOf(record.Effective_Date__c));
        rmap.put('TerminationDate',String.valueOf(record.Termination_Date__c));
        //Hix field added as per Request 01100, By Rahul Nasa
        rmap.put('HIX',String.valueOf(record.Hix__c));
        //Hix field added as per Request 01100, By Rahul Nasa
        
        for(Codes__c c : cRecord){
            cmap_2 = new Map<String,String>();
            cmap_2.put('CodeID',String.valueOf(c.Name));
            cmap_2.put('RecordType',String.valueOf(c.RecordType.Name));
            cmap_2.put('RelatedCodeListID',String.valueOf(c.Related_Code_List__r.Name));    
            cmap_2.put('ProfessionalServiceCode',String.valueOf(c.Professional__c));   
            cmap_2.put('ResultOfServiceCode',String.valueOf(c.Result_of_Service_Codes__c));
            cmap.add(cmap_2);
        }
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
        String CurrentVersion='1.0';
        String s=gmfwriter.getparentXml(CurrentVersion,'CodeList','Code',rmap,cmap);
        
        //upadting record for custom history tracking. Added 12/27/11- Saraag
        
        record.LastSent__c=system.now();
        update record;
        //end
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=record.Effective_Date__c;
        c.Subject=String.valueOf(record.Name)+' '+'-'+' '+String.valueOf(record.Code_List_Name__c);
        insert c;
        
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=record.Code_List_Name__c+'.xml';
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
        Codes_List__c r = new Codes_List__c();
        r.Effective_Date__c=system.today();
        r.Termination_Date__c=system.today().addDays(3);
        r.Code_List_Description__c='sample Decription';
        r.Code_List_Name__c='sample Name';
        insert r;   
        
        Codes__c c = new Codes__c();
        c.RecordTypeId = [Select Id From RecordType WHERE SobjectType = 'Codes__c' AND isActive = true LIMIT 1].Id;
        c.Related_Code_List__c = r.Id;
        insert c;
        
        ApexPages.StandardController rsc = new ApexPages.StandardController(r);
        GMF_XML_CodeList_controller rc = new GMF_XML_CodeList_controller(rsc);
        rc.generateXML();
    }
}