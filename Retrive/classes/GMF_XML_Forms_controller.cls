/*Purpose: Apex  Class to generate the XML of Forms and attach it with case
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Saraag                Not known          generate Forms XML
   1.1 -	Becca				  12/10/2012		 update with Last Modified Date, Last Sent Date, etc.
======================================================================== */
public with sharing class GMF_XML_Forms_controller {

    Forms__c Frecord;
    Map<String,String> Fmap = new Map<String,String>();
    List<Map<String,String>> dummyChild = new List<Map<String,String>>();
  
    Id parentId;
  
    public GMF_XML_Forms_controller (ApexPages.StandardController controller) {
        
        parentId=controller.getId();
        Frecord=[SELECT 
                        CVS_Caremark_Stellant_ID__c, RecordType.Name, Name,Effective_Date__c,LastModifiedDate,LastSent__c,Termination_Date__c, Location_of_Form__c, Inactive__c, Id, Form_Text__c, Form_Name__c, Form_Description__c,
                        (Select Name FROM Attachments WHERE isDeleted = false )
                    FROM Forms__c 
                    WHERE Id=:parentId LIMIT 1];
        List<String> attachmentNames = new List<String>(); 
        for(Attachment a: Frecord.Attachments){
            attachmentNames.add(a.Name);
        }
        if(null != Frecord.Location_of_Form__c && (!Frecord.Location_of_Form__c.contains('http://') && !Frecord.Location_of_Form__c.contains('https://'))){
            Frecord.Location_of_Form__c = 'http://' + Frecord.Location_of_Form__c;
        }
        //Build MAPs
        Fmap.put('FormID',String.valueOf(Frecord.Name));
        Fmap.put('FormName',String.valueOf(Frecord.Form_Name__c));
        Fmap.put('CVSCaremarkStellantID',String.valueOf(Frecord.CVS_Caremark_Stellant_ID__c));
        Fmap.put('FormDescription',String.valueOf(Frecord.Form_Description__c));
        Fmap.put('RecordType',String.valueOf(Frecord.RecordType.Name));
        Fmap.put('LocationOfForm',String.valueOf(Frecord.Location_of_Form__c));
        Fmap.put('Attachment',String.valueOf(String.valueOf(attachmentNames)));
        Fmap.put('FormText',String.valueOf(Frecord.Form_Text__c));
        Fmap.put('Inactive',String.valueOf(Frecord.Inactive__c));
        Fmap.put('EffectiveDate',String.valueOf(Frecord.Effective_Date__c));
        Fmap.put('TerminationDate',String.valueOf(Frecord.Termination_Date__c));
        Fmap.put('LastModifiedDate',String.valueOf(Frecord.LastModifiedDate));
        Fmap.put('LastSent',String.valueOf(Frecord.LastSent__c));
        Fmap.put('TimeStamp',String.valueOf(system.now()));
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
         String CurrentVersion='1.1';
        String s=gmfwriter.getparentXml(CurrentVersion,'Forms','',Fmap,dummyChild);
        //updating record for custom history tracking. Added 12/28/11- Saraag
        Frecord.LastSent__c=system.now();
        update Frecord;
        
        //end
        
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=Frecord.Effective_Date__c;
        c.Subject=String.valueOf(Frecord.Name)+' '+'-'+' '+String.valueOf(Frecord.Form_Name__c);
        insert c;
        
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=Frecord.Name+' '+system.now()+'.xml';
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
        RecordType rt = [SELECT id from RecordType WHERE SobjectType = 'Forms__c' AND DeveloperName like '%Denial%' LIMIT 1];
        Forms__c f = new Forms__c();
        f.Form_Name__c = 'test';
        f.RecordTypeId=rt.Id;
        f.Form_Description__c = 'new description';
        f.Form_Text__c = 'text';
        f.Location_of_Form__c = 'http://google.com';
        f.Mark_for_Deletion__c=false;
        f.Effective_Date__c=system.today();
        f.Termination_Date__c=system.today().addDays(3);
        f.CVS_Caremark_Stellant_ID__c='12345';
        insert f;
        
        ApexPages.StandardController fsc = new ApexPages.StandardController(f);
        GMF_XML_Forms_controller fc = new GMF_XML_Forms_controller(fsc);
        fc.generateXML();
    }

}