public class GMF_XML_DrugList_controller {
  Drug_List__c DLrecord;
  List<Drug_List_Criteria__c>  DLCRecord=new List<Drug_List_Criteria__c>();
  Map<String,String> DLmap=new Map<String,String>();
  Map<String,String> DLCmap=new Map<String,String>();
  Id parentId;
  
    public GMF_XML_DrugList_controller(ApexPages.StandardController controller) {
       parentId=controller.getId();
       DLrecord=[SELECT Name,Drug_List_Name__c,Effective_Date__c,CVS_Caremark_Drug_List_ID__c,LastModifiedDate,LastSent__c,Non_GPI_Non_NDC_Check__c,Description__c,Special_Use__c,RecordTypeId FROM Drug_List__c WHERE Id=:parentId LIMIT 1];
       DLCrecord=[SELECT Name,RecordTypeId,Drug_List__c,Qualifiers__c,Maximum_Fills_Over_Time_Time_Period__c,Maxiumum_Fills_Over_Time_Time_Value__c,Start_Date__c,Drug_List_Criteria_Description__c,Funding__c, Effective__c,Term__c,LastModifiedDate,Required__c,Bypass_days__c,Notes__c,Number_of_pre_requisites__c,Non_Compliance__c,Drug_Type_Code__c,Drug_Code_Value__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c,Rx__c,OTC__c,Repack__c,DESI__c,Maintenance__c,Non_Maintenance__c,Route__c,Status__c,Unit_Cost__c,Gender__c,Prescriber__c,Speciality__c,Lab_Tests__c,Diagnosis__c,Start_Age__c,End_Age__c,Grandfathering__c,Transition_of_Care__c,Message__c,Minimum_Days__c,Maximum_Days__c,Rule__c,Minimum_Quantity__c,Maximum_Quantity__c,Maximum_Dollars__c,Maximum_Fills__c, Message_Action__c,Member_Message__c FROM Drug_List_Criteria__c WHERE Drug_List__c=:DLrecord.Id AND isDeleted = false ];
       //Build MAPs
        Dlmap.put('DrugListID','Name');
        Dlmap.put('DrugListName','Drug_List_Name__c');
        Dlmap.put('DrugListDescription','Description__c');
        Dlmap.put('SpecialUse','Special_Use__c');
        Dlmap.put('RecordType','RecordTypeId');
        Dlmap.put('CVSCaremarkDrugListID','CVS_Caremark_Drug_List_ID__c');
        Dlmap.put('LastModifiedDate','LastModifiedDate');
        Dlmap.put('LastSent','LastSent__c');
        Dlmap.put('NonGPINonNDCCheck','Non_GPI_Non_NDC_Check__c');
       // Dlmap.put('TimeStamp',String.valueOf(System.now()));
        
        DlCmap.put('DrugsListCriteriaID','Name');
        //DlCmap.put('DrugList','Drug_List__c');
        DlCmap.put('RecordType','RecordTypeId');
        DlCmap.put('DescriptionofDrugListCriteria','Drug_List_Criteria_Description__c');
        DlCmap.put('EffectiveDate','Effective__c');
        DlCmap.put('TerminationDate','Term__c');
        DlCmap.put('Funding','Funding__c');
        DlCmap.put('DrugTypeCode','Drug_Type_Code__c');
        DlCmap.put('DrugCodeValue','Drug_Code_Value__c');
        DlCmap.put('M','MS_Code_M__c');
        DlCmap.put('N','MS_Code_N__c');
        DlCmap.put('O','MS_Code_O__c');
        DlCmap.put('Y','MS_Code_Y__c');
        DlCmap.put('Rx','Rx__c');
        DlCmap.put('OTC','OTC__c');
        DlCmap.put('Repack','Repack__c');
        DlCmap.put('DESI','DESI__c');
        DlCmap.put('Maintenance','Maintenance__c');
        DlCmap.put('NonMaintenance','Non_Maintenance__c');
        DlCmap.put('RouteofAdministration','Route__c');
        DlCmap.put('Status','Status__c');
        DlCmap.put('UnitCost','Unit_Cost__c');
        DlCmap.put('Gender','Gender__c');
        DlCmap.put('Prescriber','Prescriber__c');
        DlCmap.put('Speciality','Speciality__c');
        DlCmap.put('LabTests','Lab_Tests__c');
        DlCmap.put('Diagnosis','Diagnosis__c');
        DlCmap.put('StartAge','Start_Age__c');
        DlCmap.put('PeriodtoDateStartDate','Start_Date__c');
        DlCmap.put('EndAge','End_Age__c');
        DlCmap.put('Grandfathering','Grandfathering__c');
        DlCmap.put('TransitionofCare','Transition_of_Care__c');
        DlCmap.put('Qualifiers','Qualifiers__c');
       
        DlCmap.put('PharmacyMessage','Message__c');
        DlCmap.put('MemberMessage','Member_Message__c');
        DlCmap.put('MinimumDays','Minimum_Days__c');
        DlCmap.put('MaximumDays','Maximum_Days__c');
        DlCmap.put('Rule','Rule__c');
        DlCmap.put('MinQuantity','Minimum_Quantity__c');
        DlCmap.put('MaximumQuantity','Maximum_Quantity__c');
        DlCmap.put('MaximumDollars','Maximum_Dollars__c');
        DlCmap.put('MaximumFills','Maximum_Fills__c');
        DlCmap.put('MaximumFillsOverTimeTimePeriod','Maximum_Fills_Over_Time_Time_Period__c');
        DlCmap.put('MaximumFillsOverTimeTimeValue','Maxiumum_Fills_Over_Time_Time_Value__c');
        DlCmap.put('MessageAction','Message_Action__c');
        DlCmap.put('#Required','Required__c');
        DlCmap.put('BypassDays','Bypass_days__c');
        DlCmap.put('Notes','Notes__c');
        DlCmap.put('NumberofPreRequisites','Number_of_pre_requisites__c');
        DlCmap.put('NonCompliance','Non_Compliance__c');
        DlCmap.put('LastModifiedDate','LastModifiedDate');
        

       
    }
    
    public PageReference generateXML(){
      GMFXmlWriter gmfwriter=new GMFXmlWriter();
      String s=gmfwriter.getXml(DLrecord,DLCrecord,'DrugList','DrugListCriteria',DLmap,DLCmap);
      case c=new case();
      c.Aetna_Case_Type__c='GMF Case';
      c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
      c.Effective_Date__c=DLrecord.Effective_Date__c;
      c.Subject=String.valueOf(DLrecord.Name)+' '+'-'+' '+String.valueOf(DLrecord.Drug_List_Name__c);
      c.Existing_CVS_Caremark_Drug_List_ID__c = DLrecord.CVS_Caremark_Drug_List_ID__c;
      insert c;
      Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
        xmlAttach.body=xmlblob;
        xmlAttach.Name=DLrecord.Name+' '+system.now()+'.xml';
        xmlAttach.parentId=c.Id;
        xmlAttach.contentType='XML';
        insert xmlAttach;
        
        String urlStr = '/'+String.valueOf(c.Id);
   PageReference MyObjectPR = new 
PageReference(urlStr);
    
return MyObjectPR;
    }
    
}