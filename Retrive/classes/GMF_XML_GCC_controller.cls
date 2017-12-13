/*Purpose: initial draft of XML
========
History
-------
VERSION     AUTHOR                      DATE                             DETAIL
1.0 -       Becca Allen                 05/30/2012              Created the file
1.1 -           rakesh                      11-Aug'12               added fields GCC_Type, Carrier_List (Req. 780)
1.2 -       Becca Allen                 12/10/2012              updated with Last Modified Date, Last Sent, etc.
1.3 -       Becca Allen                 04/09/2013              updated per request #929
======================================================================== */
public class GMF_XML_GCC_controller {
    Generic_Code_Conversion__c GCCrecord;
    public boolean batchContext = false;
    List<Generic_Code_Conversion__c> GCCtemp;
    List<Generic_Code_Conversion_Entry__c>  GCCentityRecord=new List<Generic_Code_Conversion_Entry__c>();
    Map<String,String> GCC=new Map<String,String>();
    Map<String,String> GCCelem=new Map<String,String>();
    List<Map<String,String>> GCCelems=new List<Map<String,String>>();
    Id parentId;

    public GMF_XML_GCC_controller(ApexPages.StandardController controller) {
        batchContext = GMFBuilderUtil.batchContext;
        ParentId=controller.getId();
        GCCtemp=[SELECT Effective_Date__c,Termination_Date__c,Name,Generic_Code_Conversion_Name__c,LastModifiedDate,LastSent__c,Generic_Code_Conversion_Description__c,Inactive__c, GCC_Type__c, Carrier_List__c,Sent_To_CVS_Date__c FROM Generic_Code_Conversion__c WHERE Id = :parentId];
        if(GCCtemp.size()>0)
            GCCrecord=GCCtemp[0];
        if(GCCrecord!=NULL){
            GCCentityRecord=[SELECT Notes__c,Name,Description_of_GCC_Entry__c,LastModifiedDate,GPI__c,NDC__c,Effective_Date__c,Termination_Date__c,Generic_Code__c,Brand_Name_Code__c,FDA_Application_Type__c,New_Generic_Code__c FROM Generic_Code_Conversion_Entry__c WHERE Generic_Code_Conversion__c = :GCCrecord.Id AND isDeleted = false];

            GCC.put('GenericCodeConversionID',String.valueOf(GCCrecord.Name));
            GCC.put('GenericCodeConversionName',String.valueOf(GCCrecord.Generic_Code_Conversion_Name__c));
            GCC.put('GenericCodeConversionDescription',String.valueOf(GCCrecord.Generic_Code_Conversion_Description__c));
            GCC.put('Inactive',String.valueOf(GCCrecord.Inactive__c));
            GCC.put('EffectiveDate',String.valueOf(GCCrecord.Effective_Date__c));
            GCC.put('TerminationDate',String.valueOf(GCCrecord.Termination_Date__c));
            GCC.put('GCCType',String.valueOf(GCCrecord.GCC_Type__c));
            GCC.put('CarrierList',String.valueOf(GCCrecord.Carrier_List__c));
            GCC.put('LastModifiedDate',String.valueOf(GCCrecord.LastModifiedDate));
            //GCC.put('LastSent',String.valueOf(GCCrecord.LastSent__c));
            GCC.put('SentToCVSDate',String.valueOf(GCCrecord.Sent_To_CVS_Date__c));
            GCC.put('TimeStamp',String.valueOf(system.now()));

            GCCelem.clear();
            GCCelems.clear();

            //Building Formulary Junction Map
            system.debug(GCCentityRecord.size());
            for(Generic_Code_Conversion_Entry__c GCCE:GCCentityRecord){
                GCCelem=new Map<String,String>();
                system.debug('Size:'+String.valueOf(GCCelem.size()));
                //GCCelem.put('RelatedGenericCodeConversionID',String.valueOf(GCCrecord.Name));
                GCCelem.put('GenericCodeConversionEntryID',String.valueOf(GCCE.Name));
                GCCelem.put('DescriptionofGCCEntry',String.valueOf(GCCE.Description_of_GCC_Entry__c));
                GCCelem.put('GPI',String.valueOf(GCCE.GPI__c));
                GCCelem.put('NDC',String.valueOf(GCCE.NDC__c));
                GCCelem.put('EffectiveDate',String.valueOf(GCCE.Effective_Date__c));
                GCCelem.put('TerminationDate',String.valueOf(GCCE.Termination_Date__c));
                GCCelem.put('GenericCode',String.valueOf(GCCE.Generic_Code__c));
                GCCelem.put('BrandNameCode',String.valueOf(GCCE.Brand_Name_Code__c));
                GCCelem.put('FDAApplicationType',String.valueOf(GCCE.FDA_Application_Type__c));
                GCCelem.put('NewGenericCode',String.valueOf(GCCE.New_Generic_Code__c));
                GCCelem.put('Notes',String.valueOf(GCCE.Notes__c));
                GCCelem.put('GCCEntryLastModified',String.valueOf(GCCE.LastModifiedDate));
                system.debug(GCCelem);
                GCCelems.add(GCCelem);
                system.debug(GCCelems.isEmpty());
            }
        }
    }

    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
        String CurrentVersion='1.3';
        String s=gmfwriter.getparentXml(CurrentVersion,'GCC','GCC_Entry',GCC,GCCelems);
        GCCrecord.LastSent__c=system.now();
        
        case c=new case();
        c.Aetna_Case_Type__c='GMF Case';
        if(GCCrecord.Sent_To_CVS_Date__c != null){
            c.GMF_Medispan__c=true;
            c.CRD_GMF_Formulary_Drug_List__c = true;
        }
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=GCCrecord.Effective_Date__c;
        c.Subject=String.valueOf(GCCrecord.Name)+' '+'-'+' '+String.valueOf(GCCrecord.Generic_Code_Conversion_Name__c);
        GMFBuilderUtil.updateExternalCase(c,GCCrecord);//Richa added for Req 6012
        insert c;
        //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
          if(!batchContext){
              GCCrecord.Sent_To_CVS_Date__c=system.now();
              GCCrecord.PDF_Date__c=system.now();
              GCCrecord.External_Case__c = c.id;
          }
            update GCCrecord;
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
        xmlAttach.body=xmlblob;
        xmlAttach.Name=GCCrecord.Name+' '+system.now()+'.xml';
        xmlAttach.parentId=c.Id;
        xmlAttach.contentType='XML';
        insert xmlAttach;

        String urlStr = '/'+String.valueOf(c.Id);

        PageReference MyObjectPR = new
            PageReference(urlStr);

        return MyObjectPR;
    }
}