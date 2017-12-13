/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
    1.0 -   Becca Allen                 05/30/2012                 Created the file 
    1.1 -   Sourabh Jain                09/17/2012                 Added the field Record Type
    1.2 -   Becca Allen                 12/10/2012                 Updated with Last Modified Date, Last Sent Date, etc.
======================================================================== */
public with sharing class GMF_XML_Max_Pay_controller {

    Max_Pay__c MPrecord;
    List<Max_Pay_Limitation__c> MPLRecord = new List<Max_Pay_Limitation__c>();
    List<Exception__c> MPERecord = new List<Exception__c>();
    public XmlStreamWriter w = new XmlStreamWriter();  
    Id parentId;
  
    public GMF_XML_Max_Pay_controller (ApexPages.StandardController controller) {
        
        parentId=controller.getId();
        //Hix field added as per Request 01100, By Rahul Nasa
        MPrecord=[SELECT 
                        Name, Message__c, MP_Name__c, Id, LastModifiedDate, LastSent__c, End_Date__c, Begin_Date__c,Record_Type__c,Hix__c
                    FROM Max_Pay__c 
                    WHERE Id=:parentId LIMIT 1];
        MPLRecord=[SELECT   
                        Name, Max_Pay_Limit__c, Id, Has_Exception__c, LastModifiedDate, End_Days_Supply__c, Begin_Days_Supply__c
                    FROM Max_Pay_Limitation__c 
                    WHERE Max_Pay__c=:MPrecord.Id AND isDeleted = false ];
        MPERecord=[SELECT   
                         Termination_Date__c, Name, Message__c, Max_Pay_Limit__c, Id, LastModifiedDate, GPI__c, End_Days_Supply__c, Effective_Date__c, 
                         Begin_Days_Supply__c
                    FROM Exception__c 
                    WHERE Max_Pay_c__c=:MPrecord.Id AND isDeleted = false ];
    }
    
    public PageReference generateXML(){
        
        w.writeStartDocument(null, '1.0');
                       
        //writing parent elements
        w.writeComment('MaxPay Section');
        w.writeStartElement(null,'MaxPay', null);
        writeXMLElement('MaxPay-XMLVersion',String.valueOf('1.2'));        
            writeXMLElement('MaxPayID',String.valueOf(MPrecord.Name));
            writeXMLElement('MaxPayName',String.valueOf(MPrecord.MP_Name__c));
            writeXMLElement('RecordType',String.valueOf(MPrecord.Record_Type__c));
            writeXMLElement('BeginDate',String.valueOf(MPrecord.Begin_Date__c));
            writeXMLElement('EndDate',String.valueOf(MPrecord.End_Date__c));
            //Hix field added as per Request 01100, By Rahul Nasa
             writeXMLElement('HIX',String.valueOf(MPrecord.Hix__c));
             //Hix field added as per Request 01100, By Rahul Nasa
            writeXMLElement('Message',String.valueOf(MPrecord.Message__c));
            writeXMLElement('LastModifiedDate',String.valueOf(MPrecord.LastModifiedDate));
            writeXMLElement('LastSent',String.valueOf(MPrecord.LastSent__c));
            writeXMLElement('TimeStamp',String.valueOf(system.now()));
              
            //write child element Max_Pay_Limitation__c with no exception
            for(Max_Pay_Limitation__c mpl : MPLRecord){
                w.writeComment('MaxPayLimitation Section');
                w.writeStartElement(null,'MaxPayLimitation', null);
                    writeXMLElement('HasException',String.valueOf(mpl.Has_Exception__c));
                    //writeXMLElement('Exception',String.valueOf(mpl.Exception__r.Name));
                    writeXMLElement('RelatedMaxPayID',String.valueOf(MPrecord.Name));
                    writeXMLElement('MaxPayLimitationID',String.valueOf(mpl.Name));
                    writeXMLElement('BeginDaysSupply',String.valueOf(mpl.Begin_Days_Supply__c));              
                    writeXMLElement('EndDaysSupply',String.valueOf(mpl.End_Days_Supply__c));
                    writeXMLElement('MaxPayLimit',String.valueOf(mpl.Max_Pay_Limit__c));
                    writeXMLElement('MPLLastModified',String.valueOf(mpl.LastModifiedDate));
                w.writeEndElement();
            }
                         
            //write child element Max_Pay_Limitation__c with Exception
            for(Exception__c mpe : MPERecord){
                w.writeComment('Exception Section');
                w.writeStartElement(null,'Exception', null);
                    writeXMLElement('RelatedMaxPayID',String.valueOf(MPrecord.Name));
                    writeXMLElement('ExceptionID',String.valueOf(mpe.Name));
                    writeXMLElement('EffectiveDate',String.valueOf(mpe.Effective_Date__c));
                    writeXMLElement('TerminationDate',String.valueOf(mpe.Termination_Date__c));               
                    writeXMLElement('GPI',String.valueOf(mpe.GPI__c));
                    writeXMLElement('MaxPayLimit',String.valueOf(mpe.Max_Pay_Limit__c));
                    writeXMLElement('Message',String.valueOf(mpe.Message__c));
                    writeXMLElement('BeginDaysSupply',String.valueOf(mpe.Begin_Days_Supply__c));
                    writeXMLElement('EndDaysSupply',String.valueOf(mpe.End_Days_Supply__c));
                    writeXMLElement('ExceptionLastModified',String.valueOf(mpe.LastModifiedDate));                                                    
                w.writeEndElement();
            }//end of child elements
        
        //end writing parent elements
        w.writeEndElement();

        //close document
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();
        
        //Updating record for custom history tracking. Added 12/28/2011- Saraag
        MPrecord.LastSent__c=system.now();
        update MPrecord;
        
        //End
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=MPrecord.Begin_Date__c;
        c.Subject=String.valueOf(MPrecord.Name)+' '+'-'+' '+String.valueOf(MPrecord.MP_Name__c);
        insert c;
        
        Blob xmlblob=Blob.valueof(xmlOutput);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=MPrecord.Name+' '+system.now()+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
        insert xmlAttach;
        
        String urlStr = '/'+String.valueOf(c.Id);
        PageReference MyObjectPR = new 
        PageReference(urlStr);
    
        return MyObjectPR;
    }
    
    private void writeXMLElement(String elementName, String elementValue){
        w.writeStartElement(null,elementName,null);
        if(elementValue!=NULL){
            w.writeCharacters(elementValue);
        }
        else{
            w.writeCharacters('');
        }
        w.writeEndElement();
    }
    
    /** 
    * =====================================================================
    *                          TEST CASE(S)
    * =====================================================================
    **/
    static testMethod void testXMLGeneration(){
        
        Max_Pay__c mp = new Max_Pay__c();
        mp.Begin_Date__c=system.today();
        mp.End_Date__c=system.today().addDays(3);
        insert mp;
        mp.End_date__c=system.today().addDays(5);
        mp.message__c='test';
        update mp;
        
        Exception__c e = new Exception__c();
        e.Max_Pay_c__c = mp.Id;
        e.Effective_Date__c=system.today();
        e.Termination_Date__c=system.today().addDays(3);
        insert e; 
        
        List<Max_Pay_Limitation__c> mplList = new List<Max_Pay_Limitation__c>();
        
        Max_Pay_Limitation__c mpl = new Max_Pay_Limitation__c();
        mpl.Max_Pay__c = mp.Id;
        mplList.add(mpl);       
            
        Max_Pay_Limitation__c mpl2 = new Max_Pay_Limitation__c();
        mpl2.Max_Pay__c = mp.Id;
        mplList.add(mpl2);  
        
        Max_Pay_Limitation__c mpl3 = new Max_Pay_Limitation__c();
        mpl3.Max_Pay__c = mp.Id;
        mplList.add(mpl3);
        
        insert mplList;
        
        ApexPages.StandardController mpsc = new ApexPages.StandardController(mp);
        GMF_XML_Max_Pay_controller mpc = new GMF_XML_Max_Pay_controller(mpsc);
        mpc.generateXML();
        
    }

}