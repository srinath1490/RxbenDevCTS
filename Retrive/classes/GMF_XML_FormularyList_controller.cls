/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
   1.0 -   Becca Allen                 05/30/2012              Created the file 
   1.1 -    Becca Allen             12/10/2012                  updated with last modified date, last sent date, etc.
   1.2 -    Becca Allen             04/09/2013                  updated per request #929
   1.3 -    Sushant Sethi           07/29/2013                  updated as per Req 01087
   1.4 -    Becca Allen             09/26/2013                  updated with HIX field auto-population on created case
   2.0 -    Nitish                  06/27/2014                  Request No 4923
   3.0 -    Nitish                  09/11/2015                  Request No 06007
======================================================================== */
public class GMF_XML_FormularyList_controller {
    Formulary_List__c FLrecord;
    public boolean batchContext = false;
    List<Formulary_List_Entry__c>  FLERecords=new List<Formulary_List_Entry__c>();
    public XmlStreamWriter w = new XmlStreamWriter();
    Id parentId;
    /* 
     * Constructor of class GMF_XML_FormularyList_controller 
     */ 

    public GMF_XML_FormularyList_controller(ApexPages.StandardController controller) {
      //context record
      parentId=controller.getId();
      batchContext = GMFBuilderUtil.batchContext;
        //Hix field added as per Request 01100, By Rahul Nasa
      //Data gathering
      FLRecord=[SELECT Effective_Date__c,Termination_Date__c,Hix__c,Name,Formulary_List_Name__c,LastModifiedDate, LastSent__c,Formulary_List_Description__c,OptionCode__r.Name,Option_Code_Name__c,Option_Code_Description__c,Status_Code_Description__c,Status_Code__c,Formulary_List_Tier__c, Inactive__c,Sent_To_CVS_Date__c FROM Formulary_List__c WHERE Id=:parentId LIMIT 1]; 
      
      //Getting Formulary List Entry records and using parent-child select query to get values of form junction for each Formulary List Entry record.
      if(FLRecord!=NULL)
      FLERecords=[SELECT Name,Formulary_List__r.Name,Description_of_Formulary_List_Entry__c,LastModifiedDate, LastSent__c, Effective_Date__c ,Termination_Date__c,GPI__c,NDC__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c ,Action__c,Message__c, Member_Message__c,Rx__c,OTC__c,Allow_Transition_Fill__c,
      (SELECT Formulary_List_Entry_ID__c,Form_ID__c,LastModifiedDate, Form_Name__c,Form_Description__c,Record_Type__c FROM Form_Junction__r),
      (SELECT Id,Name,Effective_Date__c,key__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c,OTC__c,Restrict_NDC__c,
       Rx__c,Termination_Date__c,Related_Formulary_List_Entry__c,Related_Formulary_List_Entry_GPI__c,Related_Formulary_List_Entry__r.name From NDC_Lists__r)
          FROM Formulary_List_Entry__c 
       WHERE Formulary_List__r.Id=:FLRecord.Id AND isDeleted = false];
      //End Data gathering
   }   
   /*
    * ########BEGING XML generation###########
    * Method :- generateXML
    * Description :- This Method transfer page to case detail page and generate XML
    */   
    public PageReference generateXML(){ 
      //LEVEL 1: PARENT Writing Formulary List elements
      w.writeStartDocument(null, '1.0');     
          
      w.writeComment('Formulary List Section');
      w.writeStartElement(null,'FormularyList', null);
      writeXMLElement('FormularyList-XMLVersion',String.valueOf('1.2'));           
      writeXMLElement('Inactive',String.valueOf(FLRecord.Inactive__c));
      writeXMLElement('FormularyListID',String.valueOf(FLRecord.Name));
      writeXMLElement('FormularyListName',String.valueOf(FLRecord.Formulary_List_Name__c));
      writeXMLElement('FormularyListDescription',String.valueOf(FLRecord.Formulary_List_Description__c));
      writeXMLElement('OptionCode',String.valueOf(FLRecord.OptionCode__r.Name));
      writeXMLElement('OptionCodeName',String.valueOf(FLRecord.Option_Code_Name__c));
      writeXMLElement('OptionCodeDescription',String.valueOf(FLRecord.Option_Code_Description__c));
      writeXMLElement('StatusCode', String.valueOf(FLRecord.Status_Code__c));
      writeXMLElement('StatusCodeDescription',String.valueOf(FLRecord.Status_Code_description__c));
      writeXMLElement('EffectiveDate',String.valueOf(FLRecord.Effective_Date__c));
      writeXMLElement('TerminationDate',String.valueOf(FLRecord.Termination_Date__c));      
        //Hix field added as per Request 01100, By Rahul Nasa
       writeXMLElement('HIX',String.valueOf(FLRecord.Hix__c));       
        //Hix field added as per Request 01100, By Rahul Nasa
      writeXMLElement('LastModifiedDate',String.valueOf(FLRecord.LastModifiedDate));
      //writeXMLElement('LastSent',String.valueOf(FLRecord.LastSent__c));
      writeXMLElement('SentToCVSDate',String.valueOf(FLRecord.Sent_To_CVS_Date__c));//Richa added for Req 6012
      writeXMLElement('TimeStamp',String.valueOf(system.now()));
      writeXMLElement('FormularyListTier',String.valueOf(FLRecord.Formulary_List_Tier__c));
      
      
      //LEVEL 2: CHILD Writing Formulary List Entry elements
      for(Formulary_List_Entry__c FLE:FLERecords){
         w.writeComment('Formulary List Entry Section');
         w.writeStartElement(null,'FormularyListEntry', null);
         writeXMLElement('FormularyListEntryID',String.valueOf(FLE.Name));
         writeXMLElement('FormularyList',String.valueOf(FLE.Formulary_List__r.Name));
         writeXMLElement('DescriptionofFormularyListEntry',String.valueOf(FLE.Description_of_Formulary_List_Entry__c));
         writeXMLElement('EffectiveDate',String.valueOf(FLE.Effective_Date__c));
         writeXMLElement('TerminationDate',String.valueOf(FLE.Termination_Date__c));
         writeXMLElement('FLELastModified',String.valueOf(FLE.LastModifiedDate));
         writeXMLElement('GPI',String.valueOf(FLE.GPI__c));
         writeXMLElement('NDC',String.valueOf(FLE.NDC__c));
         writeXMLElement('MSCodeM',String.valueOf(FLE.MS_Code_M__c));
         writeXMLElement('MSCodeN',String.valueOf(FLE.MS_Code_N__c));
         writeXMLElement('MSCodeO',String.valueOf(FLE.MS_Code_O__c));
         writeXMLElement('MSCodeY',String.valueOf(FLE.MS_Code_Y__c ));
         writeXMLElement('Action',String.valueOf(FLE.Action__c));
         writeXMLElement('PharmacyMessage',String.valueOf(FLE.Message__c));
         writeXMLElement('MemberMessage',String.valueOf(FLE.Member_Message__c));
         writeXMLElement('AllowTransitionFill',FLE.Allow_Transition_Fill__c);
         writeXMLElement('Rx',String.valueOf(FLE.Rx__c));
         writeXMLElement('OTC',String.valueOf(FLE.OTC__c));
         
          //LEVEL 3: GRAND CHILD each formulary list entry can have multiple Form junction records
            for(Form_Junction__c FJn:FLE.Form_Junction__r){
                w.writeComment('Form Junction section');
                w.writeStartElement(null,'FormJunction', null);
                writeXMLElement('FormListEntryID',String.valueOf(FJn.Formulary_List_Entry_ID__c));
                writeXMLElement('FormID',String.valueOf(FJn.Form_ID__c));
                writeXMLElement('FormName',String.valueOf(FJn.Form_Name__c));
                writeXMLElement('FormDescription',String.valueOf(FJn.Form_Description__c));
                writeXMLElement('RecordType',String.valueOf(FJn.Record_Type__c));
                w.writeEndElement(); //writing the closing XML tag for each Form Junction
            } 
            for(Restricted_NDC_List__c RNDC : FLE.NDC_Lists__r){
                w.writeComment('RestrictedNDCList Section');
                   w.writeStartElement(null,'RestrictedNDCList', null);
                   writeXMLElement('RestrictedNDCListID',String.valueOf(RNDC.Name));
                   writeXMLElement('RelatedFormularyListEntryID',String.valueOf(RNDC.Related_Formulary_List_Entry__r.name));
                   writeXMLElement('RelatedFormularyListEntryGPI',String.valueOf(RNDC.Related_Formulary_List_Entry_GPI__c));
                   writeXMLElement('RestrictNDC',String.valueOf(RNDC.Restrict_NDC__c));
                   writeXMLElement('EffectiveDate',String.valueOf(RNDC.Effective_Date__c));
                   writeXMLElement('TerminationDate',String.valueOf(RNDC.Termination_Date__c));
                   writeXMLElement('MSCodeM',String.valueOf(RNDC.MS_Code_M__c));
                   writeXMLElement('MSCodeN',String.valueOf(RNDC.MS_Code_N__c));
                   writeXMLElement('MSCodeO',String.valueOf(RNDC.MS_Code_O__c));
                   writeXMLElement('MSCodeY',String.valueOf(RNDC.MS_Code_Y__c));
                   writeXMLElement('OTC',String.valueOf(RNDC.OTC__c));
                   writeXMLElement('Rx',String.valueOf(RNDC.Rx__c));
                   w.writeEndElement();
              }   
            
            // end Form Junction record
       w.writeEndElement(); //writing the closing XML tag for each Formulary List Entry record 
      } //End of Formulary List Entry records
      w.writeEndElement(); //End of Formulary List- writing the closing XML tag for each Form Junction
     
        w.writeEndDocument();
        String s = w.getXmlString();
        w.close();
 //###########END XML GENERATION#############  
 
 //Updating record, for Custom History Tracking
      FLrecord.LastSent__c=system.now();
      
      
      //creating case record and attaching the XML
      case c=new case();
      c.Aetna_Case_Type__c='GMF Case';
      c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
      c.Effective_Date__c=FLrecord.Effective_Date__c;
      c.CRD_GMF_Formulary_Drug_List__c = true;
      c.GMF_Form_List_FLI__c = true;
      c.Subject=String.valueOf(FLrecord.Name)+' '+'-'+' '+String.valueOf(FLrecord.Formulary_List_Name__c);
      if (FLrecord.HIX__c == true) {
                c.HIX__c = true;
            } else {
                c.HIX__c = false;
            }
      GMFBuilderUtil.updateExternalCase(c,FLrecord);//Richa added for Req 6012      
      insert c;
      //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
      if(!batchContext){
          FLrecord.Sent_To_CVS_Date__c=system.now();
          FLrecord.PDF_Date__c=system.now();
          FLrecord.External_Case__c = c.id;
      }
      update FLrecord;
      Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
        xmlAttach.body=xmlblob;
        xmlAttach.Name=String.valueOf(FLrecord.Name)+' '+system.now()+'.xml';
        xmlAttach.parentId=c.Id;
        xmlAttach.contentType='XML';
        insert xmlAttach;
        //redirecting the user to the newly created case record's detail
        String urlStr = '/'+String.valueOf(c.Id);
   PageReference MyObjectPR = new 
PageReference(urlStr);
    
return MyObjectPR;
 }   
    
    /*
     * Method :- writeXMLElement
     * Description :- This Method generates the XML Element
     */ 
        
  private void writeXMLElement(String elementName, String elementValue){
        w.writeStartElement(null,elementName,null);
        if(elementValue!=NULL){ //vaue is present
            w.writeCharacters(elementValue);
        }
        else{ // no value
            w.writeCharacters('');
        }
        w.writeEndElement();
    }
    
}