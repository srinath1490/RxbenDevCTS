/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
    0.1 -   Allen Becca                 05/30/2012                 Created the file 
   
======================================================================== */
public with sharing class GMF_XML_ConflictCode_controller {
    
    Conflict_Code_List__c record;
    List<Conflict_Codes__c> cRecord = new List<Conflict_Codes__c>();
    Map<String,String> rmap = new Map<String,String>();
    Map<String,String> cmap_2 = new Map<String,String>();
    List<Map<String,String>> cmap = new List<Map<String,String>>();
  
    Id parentId;
  
    public GMF_XML_ConflictCode_controller(ApexPages.StandardController controller) {
        
        parentId=controller.getId();
        
        //Hix field added as per Request 01100, By Rahul Nasa
        record=[SELECT 
                        c.RecordType.Name, c.Name, c.Inactive__c, c.Id, c.Conflict_Code_List_Name__c, 
                        c.Conflict_Code_List_Description__c, c.Effective_Date__c, c.Termination_Date__c,Hix__c
                    FROM Conflict_Code_List__c c
                    WHERE Id=:parentId AND isDeleted = false LIMIT 1];
        cRecord=[SELECT     
                        c.Related_Conflict_Code_List__r.Name,c.Value__c, c.Related_GPI__c, c.Related_Conflict_Code_List__c, c.RecordType.Name, c.Overlap_Percent__c, c.Operator__c, 
                        c.Name, c.Id, c.GPI__c, c.Diagnosis_Code__c, c.Days_to_Review__c, c.Daily_Dose__c, c.DUR_Message__c, 
                        c.Conflict_Codes__c, c.Clinical_Program__c, c.Age__c, c.Effective_Date__c, c.Termination_Date__c 
                    FROM Conflict_Codes__c c
                    WHERE Related_Conflict_Code_List__c=:record.Id AND isDeleted = false];
                    
        //Build MAPs
        rmap.put('ConflictCodeListID',String.valueOf(record.Name));
        rmap.put('ConflictCodeListName',String.valueOf(record.Conflict_Code_List_Name__c));
        rmap.put('ConflictCodeListDescription',String.valueOf(record.Conflict_Code_List_Description__c));
        rmap.put('RecordType',String.valueOf(record.RecordType.Name)); 
        rmap.put('Inactive',String.valueOf(record.Inactive__c));
        
        
        
        rmap.put('EffectiveDate',String.valueOf(record.Effective_Date__c));
        rmap.put('TerminationDate',String.valueOf(record.Termination_Date__c));
        //Hix field added as per Request 01100, By Rahul Nasa
        rmap.put('HIX',String.valueOf(record.Hix__c));
        //Hix field added as per Request 01100, By Rahul Nasa
        for(Conflict_Codes__c c : cRecord){
            cmap_2 = new Map<String,String>();
            cmap_2.put('ConflictCodeID',String.valueOf(c.Name));
            cmap_2.put('ConflictCodes',String.valueOf(c.Conflict_Codes__c));
            cmap_2.put('RecordType',String.valueOf(c.RecordType.Name)); 
            cmap_2.put('GPI',String.valueOf(c.GPI__c));
            cmap_2.put('RelatedConflictCodeListID',String.valueOf(c.Related_Conflict_Code_List__r.Name));
            cmap_2.put('RelatedGPI',String.valueOf(c.Related_GPI__c));
            cmap_2.put('DaysToReview',String.valueOf(c.Days_to_Review__c));
            cmap_2.put('OverlapPercent',String.valueOf(c.Overlap_Percent__c));
            cmap_2.put('Age',String.valueOf(c.Age__c)); 
            cmap_2.put('Operator',String.valueOf(c.Operator__c));   
            cmap_2.put('DURMessage',String.valueOf(c.DUR_Message__c));
            cmap_2.put('EffectiveDate',String.valueOf(c.Effective_Date__c)); 
            cmap_2.put('TerminationDate',String.valueOf(c.Termination_Date__c)); 
            cmap_2.put('DailyDose',String.valueOf(c.Daily_Dose__c));
            cmap.add(cmap_2);
        }
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
        String CurrentVersion='1.0';
        String s=gmfwriter.getparentXml(CurrentVersion,'ConflictCodeList','ConflictCode',rmap,cmap);
        //updating record for custom history tracking. Added 12/27/11- Saraag
        record.LastSent__c=system.now();
         update record;
        //end
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=record.Effective_Date__c;
        c.Subject=String.valueOf(record.Name)+' '+'-'+' '+String.valueOf(record.Conflict_Code_List_Name__c);
        insert c;
        
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=record.Conflict_Code_List_Name__c+'.xml';
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
        Conflict_Code_List__c r = new Conflict_Code_List__c();
        insert r;   
        
        Conflict_Codes__c c = new Conflict_Codes__c();
        c.RecordTypeId = [Select Id From RecordType WHERE SobjectType = 'Conflict_Codes__c' AND isActive = true LIMIT 1].Id;
        c.Related_Conflict_Code_List__c = r.Id;
        c.Age__c = 15;
        c.Operator__c = 'Less Than';
        c.GPI__c = '4568*';
        insert c;
        
        ApexPages.StandardController rsc = new ApexPages.StandardController(r);
        GMF_XML_ConflictCode_controller rc = new GMF_XML_ConflictCode_controller(rsc);
        rc.generateXML();
    }
}