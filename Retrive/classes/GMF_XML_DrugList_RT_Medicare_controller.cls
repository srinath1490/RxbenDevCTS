/*Purpose: Apex  Class to generate the XML of DrugList and attach it with case
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Becca                03/03/2014          generate DrugList - Medicare  XML  
   1.1 -    Nitish               06/27/2014          Request No-  4923
   1.2 -    Richa                08/12/2014          Request No-  5339 - added 5 new fields
   1.3 -    Richa                10/03/2015          Req 5600, moved 5 fields from DL to DLC section
   1.4 -    Joognu                18/06/2015         Implemented request 5845
======================================================================== */
public with sharing class GMF_XML_DrugList_RT_Medicare_controller {
Drug_List__c DLrecord;
    List<Drug_List_Criteria__c>  DLCRecord = new List<Drug_List_Criteria__c>();
    Map<String,String> DLmap = new Map<String,String>();
    Map<String,String> DLCmap_2 = new Map<String,String>();
    List<Map<String,String>> DLCmap = new List<Map<String,String>>();
    public XmlStreamWriter w = new XmlStreamWriter();
    Id parentId;
    /*
     * Constructor of class GMF_XML_DrugList_RT_Medicare_controller 
     */ 
    public GMF_XML_DrugList_RT_Medicare_controller (ApexPages.StandardController controller) {
        
        parentId=controller.getId();
          //Hix field added as per Request 01100
        DLrecord=[SELECT 
                        Clinical_Edit_Code_Description__c, Clinical_Edit_Code__c, Termination_Date__c,Hix__c, LastModifiedDate,LastSent__c,Non_GPI_Non_NDC_Check__c,State__c, Standard__c, Special_Use__c, Segment__c, RecordType.Name, Platform__c, 
                        Name, Inactive__c, Id, Funding__c, Effective_Date__c, CVS_Caremark_Drug_List_ID__c, Drug_List_Name__c, Description__c, Account__c, Additional_Criteria__c, Part_B_Indicator__c, Non_Part_D_Indicator__c, Cost_Associated__c
                    FROM Drug_List__c 
                    WHERE Id=:parentId LIMIT 1];
        DLCrecord=[SELECT   
                        Name,Maximum_Fills_Over_Time_Time_Period__c,Maxiumum_Fills_Over_Time_Time_Value__c,Start_Date__c,Description_of_NDC_Drug_List_Criteria__c,NDC__c,Funding__c, LastModifiedDate,Unit_Cost__c, Transition_of_Care__c, Term__c, Status__c, Start_Age__c, Start_Age_Type__c, Specialty_Name__c, 
                        Specialty_Description__c, Speciality__r.Name, Speciality__r.LastModifiedDate, Speciality__r.LastSent__c, Sequence__c, Rx__c, Rule__c, Route__c, Required__c, 
                        RecordType.Name, Quantity_over_Time_Time_Value__c, Quantity_over_Time_Time_Period__c, Quantity_over_Time_Quantity__c, 
                        Provider__r.Name, Provider__r.LastModifiedDate, Provider__r.LastSent__c, Provider_Name__c, Provider_Descriptoin__c, Prescriber__r.Name, Prescriber__r.LastModifiedDate, Prescriber__r.LastSent__c,Prescriber_Name__c, 
                        Prescriber_Description__c, Per__c, OTC__c, Number_of_pre_requisites__c, Notes__c, Non_Maintenance__c, 
                        Non_Compliance__c, Minimum_Quantity__c,Minimum_Days__c, Message__c,Member_Message__c, Message_Form__r.Name, Message_Text__c,Maximum_Quantity__c, Maximum_Fills__c, 
                        Maximum_Dollars__c, Maximum_Days__c, Max_Quantity_per_Fill__c, Max_Days_per_Fill__c, Maintenance__c, MS_Code_Y__c, 
                        MS_Code_O__c, MS_Code_N__c, MS_Code_M__c, Lab_Tests__r.Name, Lab_Tests__r.LastModifiedDate, Lab_Tests__r.LastSent__c, Lab_Tests_Name__c, Lab_Test_Description__c, Id, 
                        Grandfathering__c, Gender__c, Force_to_Specialty__c, End_Age__c, End_Age_Type__c, Effective__c, Drug_Type_Code__c, 
                        Drug_List_Criteria_Description__c, Drug_Code_Value__c, Diagnosis__r.Name, Diagnosis__r.LastModifiedDate, Diagnosis__r.LastSent__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                        Days_over_Time_of_Days__c, Days_over_Time_Time_Value__c, Days_over_Time_Time_Period__c, Daily_Dose__c, DESI__c, 
                        Clinical_Edit_Option_Code__c, Inactive__c , Bypass_days__c, Repack__c, X100_Copay__c,DAW_Code__c,Excluded_from_Deductible__c,Edit_Code__c,Alt_Drug_Message_1__c,Alt_Drug_Message_2__c,Alt_Drug_Message_3__c,Alt_Drug_Message_4__c,
                        Clinical_Edit_Code_Description__c, Zero_Copay__c,Message_Action__c,By_pass_Aetna_Health_Fund__c,Allow_Transition_Fill__c,TOC_applies__c,Should_count_towards_meeting_ST_Protocol__c,
                        (SELECT Denial_Letter_ID__r.Name,Drug_List_Criteria_ID__r.Name,Name,Drug_List_Criteria_ID__c,Denial_Letter_ID__c,Denial_Letter_Name__c,Denial_Letter_Description__c,Record_Type__c
                           FROM Denial_Letter_Junction__r)
                    FROM Drug_List_Criteria__c 
                    WHERE Inactive__c=false and Drug_List__c=:DLrecord.Id AND isDeleted = false ];
         }
    
    /*
     * Method :- generateXML
     * Description :- This method transfer control to case detail page and generate XML
     */   
    public PageReference generateXML(){
    
//### XML String Generation ###
        w.writeStartDocument(null, '1.0');
                  
        //LEVEL 1: writing parent elements- Drug List
        w.writeComment('DrugList Section');
        w.writeStartElement(null,'DrugList', null);
        writeXMLElement('DrugList-XMLVersion',String.valueOf('1.0'));      
        writeXMLElement('DrugListID',String.valueOf(DLrecord.Name));
        writeXMLElement('DrugListName',String.valueOf(DLrecord.Drug_List_Name__c));
        writeXMLElement('DrugGroupDescription',String.valueOf(DLrecord.Description__c));
        writeXMLElement('RecordType',String.valueOf(DLrecord.RecordType.Name));
        writeXMLElement('SpecialUse',String.valueOf(DLrecord.Special_Use__c));
        writeXMLElement('EffectiveDate',String.valueOf(DLrecord.Effective_Date__c));
        writeXMLElement('TerminationDate',String.valueOf(DLrecord.Termination_Date__c));
        writeXMLElement('HIX',String.valueOf(DLrecord.Hix__c));
        writeXMLElement('AdditionalCriteria',String.valueOf(DLrecord.Additional_Criteria__c));
        writeXMLElement('PartBIndicator',String.valueOf(DLrecord.Part_B_Indicator__c));
        writeXMLElement('NonPartDIndicator',String.valueOf(DLrecord.Non_Part_D_Indicator__c));
        writeXMLElement('Inactive',String.valueOf(DLrecord.Inactive__c)); 
        writeXMLElement('ClinicalEditCode',String.valueOf(DLrecord.Clinical_Edit_Code__c));
        writeXMLElement('ClinicalEditCodeDescription',String.valueOf(DLrecord.Clinical_Edit_Code_Description__c));
        writeXMLElement('CVSCaremarkDrugListID',String.valueOf(DLrecord.CVS_Caremark_Drug_List_ID__c));
        /*writeXMLElement('EditCode',String.valueOf(DLrecord.Edit_Code__c));
        writeXMLElement('AltDrugMessage1',String.valueOf(DLrecord.Alt_Drug_Message_1__c));
        writeXMLElement('AltDrugMessage2',String.valueOf(DLrecord.Alt_Drug_Message_2__c));
        writeXMLElement('AltDrugMessage3',String.valueOf(DLrecord.Alt_Drug_Message_3__c));
        writeXMLElement('AltDrugMessage4',String.valueOf(DLrecord.Alt_Drug_Message_4__c));Richa commented for Req 5600*/
        writeXMLElement('LastModifiedDate',String.valueOf(DLrecord.LastModifiedDate));
        writeXMLElement('LastSent',String.valueOf(DLrecord.LastSent__c));
        writeXMLElement('TimeStamp',String.valueOf(system.now()));
        // END LEVEL 1
        //LEVEL 2: Writing child elements- Drug List Criteria
        for(Drug_List_Criteria__c dlc : DLCrecord){
            
            w.writeComment('Drug ListCriteria Section');
            w.writeStartElement(null,'DrugListCriteria', null);  
            writeXMLElement('DrugListCriteriaID',String.valueOf(dlc.Name));        
            writeXMLElement('LastModifiedDate',String.valueOf(dlc.LastModifiedDate));
            writeXMLElement('TerminationDate',String.valueOf(dlc.Term__c));
            writeXMLElement('RecordType',String.valueOf(dlc.RecordType.Name));               
            writeXMLElement('Inactive',String.valueOf(dlc.Inactive__c));
            writeXMLElement('ShouldcounttowardsmeetingSTProtocol',String.valueOf(dlc.Should_count_towards_meeting_ST_Protocol__c));           
            writeXMLElement('DescriptionofDrugListCriteria',String.valueOf(dlc.Drug_List_Criteria_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(dlc.Effective__c));
            writeXMLElement('TerminationDate',String.valueOf(dlc.Term__c));
            writeXMLElement('NumberRequired',String.valueOf(dlc.Required__c));
            writeXMLElement('BypassDays',String.valueOf(dlc.Bypass_days__c));
            writeXMLElement('Notes',String.valueOf(dlc.Notes__c));
            writeXMLElement('NumberOfPreRequisites',String.valueOf(dlc.Number_of_pre_requisites__c));
            writeXMLElement('NonCompliance',String.valueOf(dlc.Non_Compliance__c));
            writeXMLElement('Funding',String.valueOf(dlc.Funding__c));
            writeXMLElement('DrugTypeCode',String.valueOf(dlc.Drug_Type_Code__c));
            writeXMLElement('DrugCodeValue',String.valueOf(dlc.Drug_Code_Value__c));
            writeXMLElement('NDC',String.valueOf(dlc.NDC__c));
            writeXMLElement('DescriptionofNDCDrugListCriteria',String.valueOf(dlc.Description_of_NDC_Drug_List_Criteria__c));
            writeXMLElement('Status',String.valueOf(dlc.Status__c));
            writeXMLElement('MSCode_M',String.valueOf(dlc.MS_Code_M__c));
            writeXMLElement('MSCode_N',String.valueOf(dlc.MS_Code_N__c));
            writeXMLElement('MSCode_O',String.valueOf(dlc.MS_Code_O__c));
            writeXMLElement('MSCode_Y',String.valueOf(dlc.MS_Code_Y__c));
            writeXMLElement('EditCode',String.valueOf(dlc.Edit_Code__c));
            writeXMLElement('AltDrugMessage1',String.valueOf(dlc.Alt_Drug_Message_1__c));
            writeXMLElement('AltDrugMessage2',String.valueOf(dlc.Alt_Drug_Message_2__c));
            writeXMLElement('AltDrugMessage3',String.valueOf(dlc.Alt_Drug_Message_3__c));
            writeXMLElement('AltDrugMessage4',String.valueOf(dlc.Alt_Drug_Message_4__c));
            writeXMLElement('RX',String.valueOf(dlc.Rx__c));
            writeXMLElement('OTC',String.valueOf(dlc.OTC__c));
            writeXMLElement('Repack',String.valueOf(dlc.Repack__c));
            writeXMLElement('DESI',String.valueOf(dlc.DESI__c));
            writeXMLElement('Maintenance',String.valueOf(dlc.Maintenance__c));
            writeXMLElement('NonMaintenance',String.valueOf(dlc.Non_Maintenance__c));
            writeXMLElement('RouteOfAdministration',String.valueOf(dlc.Route__c));
            writeXMLElement('DAWCode',String.valueOf(dlc.DAW_Code__c));
            writeXMLElement('ForceToSpecialty',String.valueOf(dlc.Force_to_Specialty__c));
            writeXMLElement('ClinicalEditOptionCode',String.valueOf(dlc.Clinical_Edit_Option_Code__c));
            writeXMLElement('ClinicalEditCodeDescription',String.valueOf(dlc.Clinical_Edit_Code_Description__c));
            writeXMLElement('PharmacyMessage',String.valueOf(dlc.Message__c));
            writeXMLElement('MemberMessage',String.valueOf(dlc.Member_Message__c));
            writeXMLElement('MessageForm',String.valueOf(dlc.Message_Form__r.Name));
            writeXMLElement('MessageText',String.valueOf(dlc.Message_Text__c));
            writeXMLElement('MessageAction',String.valueOf(dlc.Message_Action__c));
            //writeXMLElement('MaximumFillsOverTimePeriod',String.valueOf(dlc.Maximum_Fills_Over_Time_Time_Period__c));
            //writeXMLElement('MaxiumumFillsOverTimeValue',String.valueOf(dlc.Maxiumum_Fills_Over_Time_Time_Value__c));
            //writeXMLElement('StartDate',String.valueOf(dlc.Start_Date__c));
         
            
            //LEVEL 3: GRANDCHILD- FORM JUNCTION
               for(Denial_Letter_Junction__c formJunction:dlc.Denial_Letter_Junction__r){
                 w.writeComment('Form Junction Section');
                 w.writeStartElement(null,'FormJunction', null);
                 writeXMLElement('FormJunctionID',String.valueOf(formJunction.Name));
                 writeXMLElement('RelatedDrugListCriteriaID',String.valueOf(formJunction.Drug_List_Criteria_ID__r.Name));
                 writeXMLElement('RelatedFormID',String.valueOf(formJunction.Denial_Letter_ID__r.Name));
                 writeXMLElement('FormDescription',String.valueOf(formJunction.Denial_Letter_Description__c));
                 writeXMLElement('RecordType',String.valueOf(formJunction.Record_Type__c));
                 w.writeEndElement();
                }//END LEVEL 3
            w.writeEndElement();
        }// END LEVEL 2 
        w.writeEndElement();
        //close document
        w.writeEndDocument();
        String s = w.getXmlString();
        w.close();
//### END XML String Generation ###
	GMFBuilderUtil.byPassGMFValidation=true; 
    DLrecord.LastSent__c=system.now();
    update DLrecord;
  //end
//Creating case, attachment
             
        Case c=new Case();
        c.Aetna_Case_Type__c='Medicare GMF';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and sobjectType = 'Case' and DeveloperName = 'External_Medicare_GMF'].id;
        c.Effective_Date__c=DLrecord.Effective_Date__c;
        c.GMF_Drug_List__c = true;
        if(DLrecord.Special_Use__c=='Specialty List'){
            c.GMF_Specialty_Drug_Lists__c=true;
        } else {
            c.GMF_Specialty_Drug_Lists__c=false;
        }
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
    } // End generateXML
    
    /*
     * Method :- writeXMLElement
     * Description :- This method generates XML Element
     */   
     private void writeXMLElement(String elementName, String elementValue){
        w.writeStartElement(null,elementName,null);
        if(elementValue!=NULL){
            w.writeCharacters(elementValue);
        }
        else{
            w.writeCharacters('');
        }
        w.writeEndElement();
    } // End writeXMLElement
    
    
} // End Class