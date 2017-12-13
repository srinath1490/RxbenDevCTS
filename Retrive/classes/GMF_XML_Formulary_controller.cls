public class GMF_XML_Formulary_controller {
  Formulary__c Fmrecord;
  public boolean batchContext = false;
  List<Formulary__c> Fmtemp;
  List<Formulary_Junction__c>  FmJRecords=new List<Formulary_Junction__c>();
  Map<String,String> FmMap=new Map<String,String>();
  Map<String,String> FmJMap_2=new Map<String,String>();
  List<Map<String,String>> FmJMap=new List<Map<String,String>>();
  Id parentId;
 
    public GMF_XML_Formulary_controller(ApexPages.StandardController controller) {
      parentId=controller.getId();
      batchContext = GMFBuilderUtil.batchContext;
      //Hix field added as per Request 01100, By Rahul Nasa
      Fmtemp=[SELECT Effective_Date__c,Termination_Date__c,Hix__c,Id,Inactive__c,LastModifiedDate,LastSent__c/*, Option_Code_Number_of_Tiers__c */,Option_Code_Open_Closed__c,CVS_Caremark_Formulary_ID__c,Name,Formulary_Name__c,Formulary_Description__c,Notes__c, Option_Code_Name__c, Option_Code_Description__c, Option_Code__r.Name,Sent_To_CVS_Date__c FROM Formulary__c WHERE Id=:parentId LIMIT 1];
      if(Fmtemp.size()>0)
       Fmrecord=Fmtemp[0];
      if(FmRecord!=NULL){
      FmJRecords=[SELECT Formulary__r.Id,/*Formulary_Name__c,*/LastModifiedDate,Formulary_List__r.Name,Formulary_List__r.LastModifiedDate,Formulary_List__r.LastSent__c,Formulary_List__r.Sent_To_CVS_Date__c,Formulary_List_Name__c,Formulary_List__r.OptionCode__r.Option_Code_Name__c,Formulary_List_Description__c,Formulary_List_Tier__c,Priority__c,Effective_Date__c,Termination_Date__c,Option_Code__c FROM Formulary_Junction__c WHERE Formulary__r.Id=:FmRecord.Id AND isDeleted = false ];

      //Building Formulary Map
      FmMap.put('FormularyId',String.valueOf(Fmrecord.Name));
      FmMap.put('InActive',String.valueOf(Fmrecord.Inactive__c));
    //  FmMap.put('OptionCodeNumberofTiers',String.valueOf(Fmrecord.Option_Code_Number_of_Tiers__c));
      FmMap.put('OptionCodeOpenClosed',String.valueOf(Fmrecord.Option_Code_Open_Closed__c));
      FmMap.put('CVSCaremarkFormularyID',String.valueOf(Fmrecord.CVS_Caremark_Formulary_ID__c));
      FmMap.put('FormularyName',String.valueOf(FMrecord.Formulary_Name__c));
      FmMap.put('FormularyDescription',String.valueOf(FmRecord.Formulary_Description__c));
      FmMap.put('OptionCode',String.valueOf(FmRecord.Option_Code__r.Name)); 
      FmMap.put('OptionCodeName',String.valueOf(FmRecord.Option_Code_Name__c)); 
      FmMap.put('OptionCodeDescription',String.valueOf(FmRecord.Option_Code_Description__c)); 
      FmMap.put('Notes',String.valueOf(FmRecord.Notes__c));
      FmMap.put('EffectiveDate',String.valueOf(FmRecord.Effective_Date__c));
      FmMap.put('TerminationDate',String.valueOf(FmRecord.Termination_Date__c));
      //Hix field added as per Request 01100, By Rahul Nasa
      FmMap.put('HIX',String.valueOf(FmRecord.Hix__c));
      //Hix field added as per Request 01100, By Rahul Nasa
      FmMap.put('LastModifiedDate',String.valueOf(FmRecord.LastModifiedDate));
      //FmMap.put('LastSent',String.valueOf(FmRecord.LastSent__c));Commented and added SentToCVSDate as per Req 6012
      FmMap.put('SentToCVSDate',String.valueOf(FmRecord.Sent_To_CVS_Date__c));
      FmMap.put('TimeStamp',String.valueOf(system.now()));

      //Building Formulary Junction Map
      for(Formulary_Junction__c FmJ:FmJRecords){
          FmJMap_2=new Map<String,String>();
          FmJMap_2.put('FLJunctionLastModified',String.valueOf(FmJ.LastModifiedDate));
          FmJMap_2.put('FormularyList',String.valueOf(FmJ.Formulary_List__r.Name));
          FmJMap_2.put('FormularyListName',String.valueOf(FmJ.Formulary_List_Name__c));
          FmJMap_2.put('FormularyDescription',String.valueOf(FmJ.Formulary_List_Description__c));
          FmJMap_2.put('Priority',String.valueOf(FmJ.Priority__c));
          FmJMap_2.put('FormularyListTier',String.valueOf(FmJ.Formulary_List_Tier__c));
          FmJMap_2.put('EffectiveDate',String.valueOf(FmJ.Effective_Date__c));
          FmJMap_2.put('TerminationDate',String.valueOf(FmJ.Termination_Date__c));
          FmJMap_2.put('FormularyListLastModified',String.valueOf(FmJ.Formulary_List__r.LastModifiedDate));
          FmJMap_2.put('FormularyListSentToCVSDate',String.valueOf(FmJ.Formulary_List__r.Sent_To_CVS_Date__c));
          FmJMap_2.put('OptionCode',String.valueOf(FmJ.Formulary_List__r.OptionCode__r.Option_Code_Name__c));         
          FMJMap.add(FmJMap_2);
       
      }
    }
      
    }
    
    public PageReference generateXML(){
  
      GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
      String CurrentVersion='1.0';
      String s=gmfwriter.getparentXml(CurrentVersion,'Formulary','FormularyJunction',FmMap,FmJMap);
      
      //Updating record for custom History tracking
      Fmrecord.LastSent__c=system.now();
     
      //end
      
      case c=new case();
      c.Aetna_Case_Type__c='GMF Case';
      c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
      c.Effective_Date__c=Fmrecord.Effective_Date__c;
      c.CRD_GMF_Formulary_Drug_List__c = true;
      c.GMF_Form_Group_FRM__c = true;
      c.Subject=String.valueOf(Fmrecord.Name)+' '+'-'+' '+String.valueOf(Fmrecord.Formulary_Name__c);
      if (Fmrecord.HIX__c == true) {
                c.HIX__c = true;
            } else {
                c.HIX__c = false;
            }
      GMFBuilderUtil.updateExternalCase(c,Fmrecord);//Richa added for Req 6012
      insert c;
       //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
      if(!batchContext){
          Fmrecord.Sent_To_CVS_Date__c=system.now();//Richa added field in above query for Req 6012
          Fmrecord.PDF_Date__c=system.now();
          Fmrecord.External_Case__c = c.id;
      }
      update Fmrecord;
      Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
        xmlAttach.body=xmlblob;
        xmlAttach.Name=String.valueOf(Fmrecord.Name)+' '+system.now()+'.xml';
        xmlAttach.parentId=c.Id;
        xmlAttach.contentType='XML';
        insert xmlAttach;
        
        String urlStr = '/'+String.valueOf(c.Id);
   PageReference MyObjectPR = new 
PageReference(urlStr);
    
return MyObjectPR;
    }

}