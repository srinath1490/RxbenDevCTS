/*Purpose: Apex  Class to generate the XML of DrugList and other related list and attach it with case
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Saraag                Not known          generate DrugList and other related list  XML
   1.1 -    Rishabh                8/8/12            added line 180 for request# 828
   1.2 -    Becca                   8/24/12         added CVS Caremark Drug List ID to case
   1.3 -    Becca                  10/30/12          added line 125 for DLC Funding
   1.4 -    Becca                  11/12/12          added line 191 for DLC # of pre-requisites
   1.5 -    Becca                  12/06/12         updates for Last Modified Date, Last Sent Dates, etc.
   1.6 -    Becca                   04/09/2013      updared per request #929
   1.7 -    Becca                   09/26/2013      updated to add HIX field auto-population on created case04
   1.8 -    Becca                   4/22/14         added new fields for Step Therapy drug lists 
   2.0 -    Nitish                  6/27/14          Request no 4923
   2.1 -    Joognu                  6/18/15          Request no 5845
======================================================================== */
public with sharing class GMF_XML_DrugList_RT_Others_controller {   
    Drug_List__c DLrecord;
    public boolean batchContext = false;
    List<Drug_List_Criteria__c>  DLCRecord = new List<Drug_List_Criteria__c>();
    List<Step_Therapy_PreRequisite_Drug__c> steptherapyList = new List<Step_Therapy_PreRequisite_Drug__c>();
    List<Id> stepTherapyId = new List<Id>();
    Map<Id, List<Step_Therapy_PreRequisite_Drug__c>> grandgrandchild = new Map<Id, List<Step_Therapy_PreRequisite_Drug__c>>();
    Map<id,List<Restricted_NDC_List__c>> StepNDCMap = new Map<id,List<Restricted_NDC_List__c>>();
    List<Restricted_NDC_List__c> ResNDC = new List<Restricted_NDC_List__c>();
    public XmlStreamWriter w = new XmlStreamWriter();
  
    Id parentId;
    /*
     * Constructor of Class GMF_XML_DrugList_RT_Others_controller 
     */  
    public GMF_XML_DrugList_RT_Others_controller (ApexPages.StandardController controller) {
        batchContext = GMFBuilderUtil.batchContext; 
        parentId=controller.getId();
        //Hix field added as per Request 01100
        DLrecord=[SELECT 
                        Clinical_Edit_Code_Description__c, Clinical_Edit_Code__c, Termination_Date__c,Hix__c, Sent_To_CVS_Date__c,State__c, Standard__c, Special_Use__c, Segment__c, RecordType.Name, Platform__c, 
                        Name, Inactive__c, Id, Funding__c, Effective_Date__c, LastModifiedDate,LastSent__c,Non_GPI_Non_NDC_Check__c,CVS_Caremark_Drug_List_ID__c, Drug_List_Name__c, Description__c, Account__c
                    FROM Drug_List__c 
                    WHERE Id=:parentId LIMIT 1];
        DLCrecord=[SELECT   
                        Unit_Cost__c, Transition_of_Care__c, Term__c, LastModifiedDate, Funding__c, Status__c, Start_Age__c, Start_Age_Type__c, Specialty_Name__c, Maximum_Fills_Over_Time_Time_Period__c,Maxiumum_Fills_Over_Time_Time_Value__c,Start_Date__c,
                        Specialty_Description__c, Speciality__r.Name, Speciality__r.LastModifiedDate, Speciality__r.Sent_To_CVS_Date__c, Sequence__c, Rx__c, Rule__c, Route__c, Required__c, 
                        RecordType.Name, Quantity_over_Time_Time_Value__c, Quantity_over_Time_Time_Period__c, Quantity_over_Time_Quantity__c, 
                        Provider__r.Name, Provider__r.LastModifiedDate, Provider__r.Sent_To_CVS_Date__c, Provider_Name__c, Provider_Descriptoin__c, Prescriber__r.Name, Prescriber__r.LastModifiedDate, Prescriber__r.Sent_To_CVS_Date__c, Prescriber_Name__c, 
                        Prescriber_Description__c, Per__c, OTC__c, Number_of_pre_requisites__c, Notes__c, Non_Maintenance__c, 
                        Non_Compliance__c, Name, Minimum_Quantity__c, Minimum_Days__c, Message__c,Member_Message__c, Maximum_Quantity__c, Maximum_Fills__c, 
                        Maximum_Dollars__c, Maximum_Days__c, Max_Quantity_per_Fill__c, Max_Days_per_Fill__c, Maintenance__c, MS_Code_Y__c,Qualifiers__c, 
                        MS_Code_O__c, MS_Code_N__c, MS_Code_M__c, Lab_Tests__r.Name, Lab_Tests__r.LastModifiedDate, Lab_Tests__r.Sent_To_CVS_Date__c, Lab_Tests_Name__c, Lab_Test_Description__c, Id, 
                        Grandfathering__c, Gender__c, Force_to_Specialty__c, End_Age__c, End_Age_Type__c, Effective__c, Drug_Type_Code__c, 
                        Drug_List_Criteria_Description__c, Inactive__c, Drug_Code_Value__c, Diagnosis__r.Name, Diagnosis__r.LastModifiedDate, Diagnosis__r.Sent_To_CVS_Date__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                        Days_over_Time_of_Days__c, Days_over_Time_Time_Value__c, Days_over_Time_Time_Period__c, Daily_Dose__c, DESI__c,NDC__c, 
                        Clinical_Edit_Option_Code__c, Bypass_days__c, Repack__c, X100_Copay__c,DAW_Code__c,Excluded_from_Deductible__c,Zero_Copay__c,
                        Message_Action__c,Description_of_NDC_Drug_List_Criteria__c, By_pass_Aetna_Health_Fund__c,Clinical_Edit_Code_Description__c,Allow_Transition_Fill__c,TOC_applies__c,Should_count_towards_meeting_ST_Protocol__c,Intent__c,
                        (SELECT 
                            Termination_Date__c, Step_Therapy_Pre_Requisite_Drug_Parent__r.Name, 
                            Step_Therapy_Pre_Requisite_Drug_Name__c, Specialty_Name__c, Specialty_Description__c, Speciality__r.Name, Speciality__r.LastModifiedDate, Speciality__r.Sent_To_CVS_Date__c,  
                            Sequence__c, Remaining__c, Related_Drug_List_Criteria__c, Provider__r.Name, Provider__r.LastModifiedDate, Provider__r.Sent_To_CVS_Date__c, Provider_Name__c, Provider_Descriptoin__c, 
                            Prescriber__r.Name, Prescriber__r.LastModifiedDate, Prescriber__r.Sent_To_CVS_Date__c, Prescriber_Name__c, Prescriber_Description__c, Object_List__r.Name, Object_List__r.LastModifiedDate, Object_List__r.Sent_To_CVS_Date__c, No_of_Distinct_Drugs__c, Name, 
                            NDC__c, Minimum_Day_Supply__c, Mandatory__c, MS_Code_Y__c, MS_Code_O__c, MS_Code_N__c, MS_Code_M__c, Lookback__c, Override_Primary_Edit__c,Smart_Edit_Type__c,
                            Lookback_Period__c, Lab_Tests__r.Name, Lab_Tests__r.LastModifiedDate, Lab_Tests__r.Sent_To_CVS_Date__c, Lab_Tests_Name__c, Lab_Test_Description__c, Id, GPI__c, Effective_Date__c,
                            Drug_Type_Code__c, Drug_List_Name__c, Drug_Code_Value__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                            Description_of_Pre_Requisite_Drug__c, Days_Remaining__c,Modifier__c,Related_DLC_Drug_Code_Value__c,Priority__c
                        
                        FROM Step_Therapy_Pre_Requisite_Drugs__r WHERE isDeleted = false ),
                        (SELECT 
                            Record_Type__c,Name, Id, Denial_Letter_Name__c, Denial_Letter_ID__r.Name, 
                            Denial_Letter_Description__c 
                        FROM Denial_Letter_Junction__r WHERE isDeleted = false ),
                        (SELECT of_Days_Supply__c,Beginning_Range__c,End_Range__c,Percent_Minimum_Use__c,Quantity__c,Related_Drug_List_Criteria__r.Name,Step_Type__c,Time_Period__c,Time_Value__c
                        FROM Stepped_Quantity_Over_Time__r),
                        (SELECT Id,Name,Effective_Date__c,key__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c,OTC__c,Related_DLC_Drug_Code_Value__c,Related_Drug_List_Criteria__c,Related_Step_Therapy_Pre_Requisite_Drug__c,
                        Related_ST_pre_requisite_Drug_Code_Value__c,Related_Step_Therapy_Pre_Requisite_Drug__r.Name,Restrict_NDC__c,Rx__c,Related_Drug_List_Criteria__r.Name,Termination_Date__c From NDC_Lists__r)
                    FROM Drug_List_Criteria__c 
                    WHERE Inactive__c=false and Drug_List__c=:DLrecord.Id AND isDeleted = false ];
        
        // because salesforce only allows a max of 1 level deep relationship we need to gather all the Ids so we can find all of the 
        // grandchild's children
        for(Drug_List_Criteria__c dlc : DLCrecord){
            for(Step_Therapy_PreRequisite_Drug__c stpd : dlc.Step_Therapy_Pre_Requisite_Drugs__r){
                stepTherapyId.add(stpd.Id);
            }
        }
        //system.debug(stepTherapyId);
        ResNDC = [SELECT Id,Name,Effective_Date__c,key__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c,OTC__c,Related_DLC_Drug_Code_Value__c,
                            Related_Drug_List_Criteria__c,Related_Step_Therapy_Pre_Requisite_Drug__c,Related_ST_pre_requisite_Drug_Code_Value__c,Restrict_NDC__c,
                            Rx__c,Termination_Date__c,Related_Step_Therapy_Pre_Requisite_Drug__r.Name From Restricted_NDC_List__c where Related_Step_Therapy_Pre_Requisite_Drug__c IN:stepTherapyId];
        for(Restricted_NDC_List__c ND : ResNDC)
        {
            if(StepNDCMap.containskey(ND.Related_Step_Therapy_Pre_Requisite_Drug__c)){
                StepNDCMap.get(ND.Related_Step_Therapy_Pre_Requisite_Drug__c).add(ND);
                }
            else{
                StepNDCMap.put(ND.Related_Step_Therapy_Pre_Requisite_Drug__c,new List<Restricted_NDC_List__c>{ND} );
                }
        }   
        //system.debug('##$$%%'+StepNDCMap);              
        steptherapyList = [Select 
                            s.Termination_Date__c,s.Step_Therapy_Pre_Requisite_Drug_Parent__r.Name, 
                            s.Step_Therapy_Pre_Requisite_Drug_Name__c, s.Specialty_Name__c, s.Specialty_Description__c, s.Speciality__r.Name, s.Speciality__r.LastModifiedDate, s.Speciality__r.LastSent__c, s.Speciality__r.Sent_To_CVS_Date__c,
                            s.Sequence__c, s.Remaining__c, s.Related_Drug_List_Criteria__r.Name, s.Provider__r.Name, s.Provider__r.LastModifiedDate, s.Provider__r.LastSent__c, s.Provider_Name__c,  s.Provider__r.Sent_To_CVS_Date__c,
                            s.Provider_Descriptoin__c, s.Prescriber__r.Name, s.Prescriber__r.LastModifiedDate, s.Prescriber__r.LastSEnt__c,s.Prescriber__r.Sent_To_CVS_Date__c, s.Prescriber_Name__c, s.Prescriber_Description__c, s.Object_List__r.Name, s.Object_List__r.LastModifiedDate, s.Object_List__r.LastSent__c,
                            s.No_of_Distinct_Drugs__c, s.Name, s.NDC__c, s.Minimum_Day_Supply__c, s.Mandatory__c, s.MS_Code_Y__c, s.MS_Code_O__c,  s.Object_List__r.Sent_To_CVS_Date__c,
                            s.MS_Code_N__c, s.MS_Code_M__c,s.Smart_Edit_Type__c ,s.Override_Primary_Edit__c , s.Lookback__c, s.Lookback_Period__c, s.Lab_Tests__r.Name, s.Lab_Tests__r.LastModifiedDate, s.Lab_Tests__r.LastSent__c, s.Lab_Tests_Name__c,s.Lab_Tests__r.Sent_To_CVS_Date__c, 
                            s.Lab_Test_Description__c, s.Id, s.GPI__c, s.Effective_Date__c, s.Drug_Type_Code__c, s.Drug_List_Name__c, 
                            s.Drug_Code_Value__c, s.Diagnosis_Name__c, s.Diagnosis_Description__c, s.Description_of_Pre_Requisite_Drug__c, 
                            s.Days_Remaining__c,s.Modifier__c,s.Related_DLC_Drug_Code_Value__c,s.Priority__c
                            
                        From Step_Therapy_PreRequisite_Drug__c s
                        WHERE s.Step_Therapy_Pre_Requisite_Drug_Parent__r.Id IN :stepTherapyId];
        //system.debug('grandgrandchild: ' + steptherapyList.size());
        // we now place it in a map so we can access the information easier while generating the xml
        for(Step_Therapy_PreRequisite_Drug__c stp : steptherapyList){
            List<Step_Therapy_PreRequisite_Drug__c> tempList = new List<Step_Therapy_PreRequisite_Drug__c>();
            if(grandgrandchild.containsKey(stp.Step_Therapy_Pre_Requisite_Drug_Parent__c)){
                tempList = grandgrandchild.get(stp.Step_Therapy_Pre_Requisite_Drug_Parent__c);
            }
            tempList.add(stp);
            grandgrandchild.put(stp.Step_Therapy_Pre_Requisite_Drug_Parent__c, tempList);
        }               
        
    }
    /* 
     * Method :- generateXML
     * Description :- This Method transfer page to case detail page and generate XML
     */   
    public PageReference generateXML(){
        
        w.writeStartDocument(null, '1.0');
                   
        //writing parent elements
        w.writeComment('DrugList Section');
        w.writeStartElement(null,'DrugList', null);
        writeXMLElement('DrugList-XMLVersion',String.valueOf('1.8'));        
            writeXMLElement('DrugListID',String.valueOf(DLrecord.Name));
            writeXMLElement('DrugListName',String.valueOf(DLrecord.Drug_List_Name__c));
            writeXMLElement('DrugGroupDescription',String.valueOf(DLrecord.Description__c));
            writeXMLElement('RecordType',String.valueOf(DLrecord.RecordType.Name));
            writeXMLElement('TimeStamp',String.valueOf(system.now()));
            writeXMLElement('LastModifiedDate',String.valueOf(DLrecord.LastModifiedDate));
            writeXMLElement('SentToCVSDate',String.valueOf(DLrecord.Sent_To_CVS_Date__c));
            writeXMLElement('SpecialUse',String.valueOf(DLrecord.Special_Use__c));
            writeXMLElement('EffectiveDate',String.valueOf(DLrecord.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(DLrecord.Termination_Date__c));
            //Hix field added as per Request 01100
            writeXMLElement('HIX',String.valueOf(DLrecord.HIX__c));
            //Hix field added as per Request 01100
            writeXMLElement('Inactive',String.valueOf(DLrecord.Inactive__c));
            writeXMLElement('ClinicalEditCode',String.valueOf(DLrecord.Clinical_Edit_Code__c));
            writeXMLElement('ClinicalEditCodeDescription',String.valueOf(DLrecord.Clinical_Edit_Code_Description__c));
            writeXMLElement('CVSCaremarkDrugListID',String.valueOf(DLrecord.CVS_Caremark_Drug_List_ID__c));
            writeXMLElement('NonGPINonNDCCheck',String.valueOf(DLrecord.Non_GPI_Non_NDC_Check__c));
              
            //write child elements
            for(Drug_List_Criteria__c dlc : DLCRecord){

                w.writeComment('DrugListCriteria Section');
                w.writeStartElement(null,'DrugListCriteria', null);
                    writeXMLElement('DrugListCriteriaID',String.valueOf(dlc.Name));
                    //writeXMLElement('DrugList',String.valueOf(DLrecord.Name));
                    writeXMLElement('RecordType',String.valueOf(dlc.RecordType.Name));                
                    writeXMLElement('Inactive',String.valueOf(dlc.Inactive__c));
                    writeXMLElement('AllowTransitionFill',String.valueOf(dlc.Allow_Transition_Fill__c));
                    writeXMLElement('TOCapplies',String.valueOf(dlc.TOC_applies__c));
                    writeXMLElement('ShouldcounttowardsmeetingSTProtocol',String.valueOf(dlc.Should_count_towards_meeting_ST_Protocol__c));                   
                    writeXMLElement('LastModifiedDate',String.valueOf(dlc.LastModifiedDate)); 
                    writeXMLElement('DescriptionofDrugListCriteria',String.valueOf(dlc.Drug_List_Criteria_Description__c));
                    writeXMLElement('EffectiveDate',String.valueOf(dlc.Effective__c));
                    writeXMLElement('TerminationDate',String.valueOf(dlc.Term__c));
                    writeXMLElement('Funding',String.valueOf(dlc.Funding__c));
                    writeXMLElement('DrugTypeCode',String.valueOf(dlc.Drug_Type_Code__c));
                    writeXMLElement('DrugCodeValue',String.valueOf(dlc.Drug_Code_Value__c));
                    writeXMLElement('NDC',String.valueOf(dlc.NDC__c));
                    writeXMLElement('DescriptionofNDCDrugListCriteria',String.valueOf(dlc.Description_of_NDC_Drug_List_Criteria__c));
                    writeXMLElement('Status',String.valueOf(dlc.Status__c));
                    //writeXMLElement('Intent',String.valueOf(dlc.Intent__c));
                    writeXMLElement('MSCode_M',String.valueOf(dlc.MS_Code_M__c));
                    writeXMLElement('MSCode_N',String.valueOf(dlc.MS_Code_N__c));
                    writeXMLElement('MSCode_O',String.valueOf(dlc.MS_Code_O__c));
                    writeXMLElement('MSCode_Y',String.valueOf(dlc.MS_Code_Y__c));
                    writeXMLElement('Qualifiers',String.valueOf(dlc.Qualifiers__c));
                    writeXMLElement('RX',String.valueOf(dlc.Rx__c));
                    writeXMLElement('OTC',String.valueOf(dlc.OTC__c));
                    writeXMLElement('Repack',String.valueOf(dlc.Repack__c));
                    writeXMLElement('DESI',String.valueOf(dlc.DESI__c));
                    writeXMLElement('Maintenance',String.valueOf(dlc.Maintenance__c));
                    writeXMLElement('NonMaintenance',String.valueOf(dlc.Non_Maintenance__c));
                    writeXMLElement('RouteOfAdministration',String.valueOf(dlc.Route__c));
                    writeXMLElement('DAWCode',String.valueOf(dlc.DAW_Code__c));
                    writeXMLElement('ZeroCopay',String.valueOf(dlc.Zero_Copay__c));
                    writeXMLElement('ExcludedFromDeductOrAccum',String.valueOf(dlc.Excluded_from_Deductible__c));
                    writeXMLElement('Prescriber',String.valueOf(dlc.Prescriber__r.Name));
                    writeXMLElement('PrescriberName',String.valueOf(dlc.Prescriber_Name__c));
                    writeXMLElement('PrescriberDescription',String.valueOf(dlc.Prescriber_Description__c));
                    writeXMLElement('PrescriberLastModified',String.valueOf(dlc.Prescriber__r.LastModifiedDate));
                    writeXMLElement('PrescriberSentToCVSDate',String.valueOf(dlc.Prescriber__r.Sent_To_CVS_Date__c));
                    writeXMLElement('Specialty',String.valueOf(dlc.Speciality__r.Name));
                    writeXMLElement('SpecialtyName',String.valueOf(dlc.Specialty_Name__c));
                    writeXMLElement('SpecialtyDescription',String.valueOf(dlc.Specialty_Description__c));
                    writeXMLElement('SpecialtyLastModified',String.valueOf(dlc.Speciality__r.LastModifiedDate));
                    writeXMLElement('SpecialtySentToCVSDate',String.valueOf(dlc.Speciality__r.Sent_To_CVS_Date__c));
                    writeXMLElement('LabTests',String.valueOf(dlc.Lab_Tests__r.Name));
                    writeXMLElement('LabTestsName',String.valueOf(dlc.Lab_Tests_Name__c));
                    writeXMLElement('LabTestDescription',String.valueOf(dlc.Lab_Test_Description__c));
                    writeXMLElement('LabTestsLastModified',String.valueOf(dlc.Lab_Tests__r.LastModifiedDate));
                    writeXMLElement('LabTestsSentToCVSDate',String.valueOf(dlc.Lab_Tests__r.Sent_To_CVS_Date__c));
                    writeXMLElement('Diagnosis',String.valueOf(dlc.Diagnosis__r.Name));
                    writeXMLElement('DiagnosisName',String.valueOf(dlc.Diagnosis_Name__c));
                    writeXMLElement('DiagnosisDescription',String.valueOf(dlc.Diagnosis_Description__c));
                    writeXMLElement('DiagnosisLastModified',String.valueOf(dlc.Diagnosis__r.LastModifiedDate));
                    writeXMLElement('DiagnosisSentToCVSDate',String.valueOf(dlc.Diagnosis__r.Sent_To_CVS_Date__c));
                    writeXMLElement('Provider',String.valueOf(dlc.Provider__r.Name));
                    writeXMLElement('ProviderName',String.valueOf(dlc.Provider_Name__c));
                    writeXMLElement('ProviderDescription',String.valueOf(dlc.Provider_Descriptoin__c));
                    writeXMLElement('ProviderLastModified',String.valueOf(dlc.Provider__r.LastModifiedDate));
                    writeXMLElement('ProviderSentToCVSDate',String.valueOf(dlc.Provider__r.Sent_To_CVS_Date__c));
                    writeXMLElement('StartAge',String.valueOf(dlc.Start_Age__c));
                    writeXMLElement('PeriodtDateStartDate',String.valueOf(dlc.Start_Date__c));
                    writeXMLElement('EndAge',String.valueOf(dlc.End_Age__c));
                    writeXMLElement('EndAgeType',String.valueOf(dlc.End_Age_Type__c));
                    writeXMLElement('Gender',String.valueOf(dlc.Gender__c));
                    writeXMLElement('Grandfathering',String.valueOf(dlc.Grandfathering__c));
                    writeXMLElement('TransitionOfCare',String.valueOf(dlc.Transition_of_Care__c));
                    writeXMLElement('MinimumDays',String.valueOf(dlc.Minimum_Days__c));
                    writeXMLElement('MaximumDays',String.valueOf(dlc.Maximum_Days__c));
                    writeXMLElement('DayQuantityRule',String.valueOf(dlc.Rule__c));
                    writeXMLElement('MinimumQuantity',String.valueOf(dlc.Minimum_Quantity__c));
                    writeXMLElement('MaximumQuantity',String.valueOf(dlc.Maximum_Quantity__c));
                    writeXMLElement('MaximumDollars',String.valueOf(dlc.Maximum_Dollars__c));
                    writeXMLElement('MaximumFills',String.valueOf(dlc.Maximum_Fills__c));
                    writeXMLElement('MaximumFillsOverTimePeriod',String.valueOf(dlc.Maximum_Fills_Over_Time_Time_Period__c));
                    writeXMLElement('MaximumFillsOverTimeValue',String.valueOf(dlc.Maxiumum_Fills_Over_Time_Time_Value__c));
                    writeXMLElement('DailyDose',String.valueOf(dlc.Daily_Dose__c));
                    writeXMLElement('DaysOverTimeNumberOfDays',String.valueOf(dlc.Days_over_Time_of_Days__c));
                    writeXMLElement('DaysOverTimeTimePeriod',String.valueOf(dlc.Days_over_Time_Time_Period__c));
                    writeXMLElement('DaysOverTimeTimeValue',String.valueOf(dlc.Days_over_Time_Time_Value__c));
                    writeXMLElement('QuantityOverTimeQuantity',String.valueOf(dlc.Quantity_over_Time_Quantity__c));
                    writeXMLElement('QuantityOverTimeTimePeriod',String.valueOf(dlc.Quantity_over_Time_Time_Period__c));
                    writeXMLElement('QuantityOverTimeTimeValue',String.valueOf(dlc.Quantity_over_Time_Time_Value__c));
                    writeXMLElement('MaxDaysPerFill',String.valueOf(dlc.Max_Days_per_Fill__c));
                    writeXMLElement('MaxQuantityPerFill',String.valueOf(dlc.Max_Quantity_per_Fill__c));
                    writeXMLElement('ForceToSpecialty',String.valueOf(dlc.Force_to_Specialty__c));
                    writeXMLElement('UnitCost',String.valueOf(dlc.Unit_Cost__c));
                    writeXMLElement('PharmacyMessage',String.valueOf(dlc.Message__c));
                    writeXMLElement('MemberMessage',String.valueOf(dlc.Member_Message__c));
                    writeXMLElement('MessageAction',String.valueOf(dlc.Message_Action__c));
                    writeXMLElement('OneHundredPercentCopay',String.valueOf(dlc.X100_Copay__c));
                    writeXMLElement('ClinicalEditOptionCode',String.valueOf(dlc.Clinical_Edit_Option_Code__c));
                    writeXMLElement('ClinicalEditCodeDescription',String.valueOf(dlc.Clinical_Edit_Code_Description__c));
                    writeXMLElement('NumberofPreRequisiteDrugsRequired',String.valueOf(dlc.Required__c));
                    writeXMLElement('BypassAetnaHealthFund',String.valueOf(dlc.By_pass_Aetna_Health_Fund__c));
                    writeXMLElement('NumberRequired',String.valueOf(dlc.Required__c));
                    writeXMLElement('BypassDays',String.valueOf(dlc.Bypass_days__c));
                    writeXMLElement('Intent',String.valueOf(dlc.Intent__c));
                    writeXMLElement('Notes',String.valueOf(dlc.Notes__c));
                    writeXMLElement('NumberOfPreRequisites',String.valueOf(dlc.Number_of_pre_requisites__c));
                    writeXMLElement('NonCompliance',String.valueOf(dlc.Non_Compliance__c));
                    // DLC Child Restricted NDC
                            //system.debug('!@#$%'+dlc.NDC_Lists__r);
                      for(Restricted_NDC_List__c RNDC : dlc.NDC_Lists__r){
                           w.writeComment('RestrictedNDCList Section');
                           w.writeStartElement(null,'RestrictedNDCList', null);
                           writeXMLElement('RestrictedNDCListID',String.valueOf(RNDC.Name));
                           writeXMLElement('RelatedDrugListCriteriaID',String.valueOf(RNDC.Related_Drug_List_Criteria__r.Name));
                           writeXMLElement('RelatedDLCDrugCodeValue',String.valueOf(RNDC.Related_DLC_Drug_Code_Value__c));
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
                    
                    
                    
                    
                    
                    
                    //Added by JR
                    
                    
           
                     
                    //write grandchild elements
                    for(Step_Therapy_PreRequisite_Drug__c stpd : dlc.Step_Therapy_Pre_Requisite_Drugs__r){
                        w.writeComment('StepTherapyPreRequisiteDrug Section');
                        w.writeStartElement(null,'StepTherapyPreRequisiteDrug', null);
                            writeXMLElement('StepTherapyPre-RequisiteDrugID',String.valueOf(stpd.Name));
                            writeXMLElement('RelatedDrugListCriteria',String.valueOf(dlc.Name));
                            writeXMLElement('RelatedStepTherapyPre-requisiteDrug',String.valueOf(stpd.Step_Therapy_Pre_Requisite_Drug_Parent__r.Name));
                            writeXMLElement('StepTherapyPre-RequisiteDrugName',String.valueOf(stpd.Step_Therapy_Pre_Requisite_Drug_Name__c  ));
                            writeXMLElement('DescriptionofPre-RequisiteDrug',String.valueOf(stpd.Description_of_Pre_Requisite_Drug__c));
                            writeXMLElement('DrugTypeCode',String.valueOf(stpd.Drug_Type_Code__c));
                            writeXMLElement('DrugCodeValue',String.valueOf(stpd.Drug_Code_Value__c));
                            writeXMLElement('EffectiveDate',String.valueOf(stpd.Effective_Date__c));
                            writeXMLElement('TerminationDate',String.valueOf(stpd.Termination_Date__c));
                            writeXMLElement('Mandatory',String.valueOf(stpd.Mandatory__c));
                            writeXMLElement('Modifier',String.valueOf(stpd.Modifier__c));
                            writeXMLElement('RelatedDLCDrugCodeValue',String.valueOf(stpd.Related_DLC_Drug_Code_Value__c));
                            writeXMLElement('Priority',String.valueOf(stpd.Priority__c));
                            writeXMLElement('NumberOfDistinctDrugs',String.valueOf(stpd.No_of_Distinct_Drugs__c));
                            writeXMLElement('Lookback',String.valueOf(stpd.Lookback__c));
                            writeXMLElement('LookbackPeriod',String.valueOf(stpd.Lookback_Period__c));
                            writeXMLElement('MinimumDaySupply',String.valueOf(stpd.Minimum_Day_Supply__c));
                            writeXMLElement('DaysRemaining',String.valueOf(stpd.Days_Remaining__c));
                            writeXMLElement('PercentRemaining',String.valueOf(stpd.Remaining__c));
                            writeXMLElement('MSCode_M',String.valueOf(stpd.MS_Code_M__c));
                            writeXMLElement('MSCode_N',String.valueOf(stpd.MS_Code_N__c));
                            writeXMLElement('MSCode_O',String.valueOf(stpd.MS_Code_O__c));
                            writeXMLElement('MSCode_Y',String.valueOf(stpd.MS_Code_Y__c));
                            writeXMLElement('OverridePrimaryEdit',String.valueOf(stpd.Override_Primary_Edit__c));
                            writeXMLElement('SmartEditType',String.valueOf(stpd.Smart_Edit_Type__c));
                            writeXMLElement('NDC',String.valueOf(stpd.NDC__c));
                            writeXMLElement('Prescriber',String.valueOf(stpd.Prescriber__r.Name));
                            writeXMLElement('PrescriberName',String.valueOf(stpd.Prescriber_Name__c));
                            writeXMLElement('PrescriberDescription',String.valueOf(stpd.Prescriber_Description__c));
                            writeXMLElement('PrescriberLastModified',String.valueOf(stpd.Prescriber__r.LastModifiedDate));
                            writeXMLElement('PrescriberSentToCVSDate',String.valueOf(stpd.Prescriber__r.Sent_To_CVS_Date__c));
                            writeXMLElement('Specialty',String.valueOf(stpd.Speciality__r.Name));
                            writeXMLElement('SpecialtyName',String.valueOf(stpd.Specialty_Name__c));
                            writeXMLElement('SpecialtyDescription',String.valueOf(stpd.Specialty_Description__c));
                            writeXMLElement('SpecialtyLastModified',String.valueOf(stpd.Speciality__r.LastModifiedDate));
                            writeXMLElement('SpecialtySentToCVSDate',String.valueOf(stpd.Speciality__r.Sent_To_CVS_Date__c));
                            writeXMLElement('LabTests',String.valueOf(stpd.Lab_Tests__r.Name));
                            writeXMLElement('LabTestsName',String.valueOf(stpd.Lab_Tests_Name__c));
                            writeXMLElement('LabTestsDescription',String.valueOf(stpd.Lab_Test_Description__c));
                            writeXMLElement('LabTestsLastModified',String.valueOf(stpd.Lab_Tests__r.LastModifiedDate));
                            writeXMLElement('LabTestsSentToCVSDate',String.valueOf(stpd.Lab_Tests__r.Sent_To_CVS_Date__c));
                            writeXMLElement('Diagnosis',String.valueOf(stpd.Object_List__r.Name));
                            writeXMLElement('DiagnosisName',String.valueOf(stpd.Diagnosis_Name__c));
                            writeXMLElement('DiagnosisDescription',String.valueOf(stpd.Diagnosis_Description__c));
                            writeXMLElement('DiagnosisLastModified',String.valueOf(stpd.Object_List__r.LastModifiedDate));
                            writeXMLElement('DiagnosisSentToCVSDate',String.valueOf(stpd.Object_List__r.Sent_To_CVS_Date__c));
                            writeXMLElement('Provider',String.valueOf(stpd.Provider__r.Name));
                            writeXMLElement('ProviderName',String.valueOf(stpd.Provider_Name__c));
                            writeXMLElement('ProviderDescription',String.valueOf(stpd.Provider_Descriptoin__c));
                            writeXMLElement('ProviderLastModified',String.valueOf(stpd.Provider__r.LastModifiedDate));
                            writeXMLElement('ProviderSentToCVSDate',String.valueOf(stpd.Provider__r.Sent_To_CVS_Date__c));
                             // Step Theraphy Pre-requisite Related Restricted NDC 
                                   if(StepNDCMap.Containskey(stpd.id)){
                                    for(Restricted_NDC_List__c RNDC2 : StepNDCMap.get(stpd.id)){
                                        w.writeComment('RestrictedNDCList Section');
                                        w.writeStartElement(null,'RestrictedNDCList', null);
                                        writeXMLElement('RestrictedNDCListID',String.valueOf(RNDC2.Name));
                                        writeXMLElement('RelatedStepTherapyPreRequisiteDrugID',String.valueOf(RNDC2.Related_Step_Therapy_Pre_Requisite_Drug__r.Name));
                                        writeXMLElement('RelatedSTPreRequisiteDrugCodeValue',String.valueOf(RNDC2.Related_ST_pre_requisite_Drug_Code_Value__c));
                                        //writeXMLElement('RelatedDrugListCriteriaID',String.valueOf(RNDC2.Related_Drug_List_Criteria__r.Name));
                                        //writeXMLElement('RelatedDLCDrugCodeValue',String.valueOf(RNDC2.Related_DLC_Drug_Code_Value__c));
                                        writeXMLElement('RestrictNDC',String.valueOf(RNDC2.Restrict_NDC__c));
                                        writeXMLElement('EffectiveDate',String.valueOf(RNDC2.Effective_Date__c));
                                        writeXMLElement('TerminationDate',String.valueOf(RNDC2.Termination_Date__c));
                                        writeXMLElement('MSCodeM',String.valueOf(RNDC2.MS_Code_M__c));
                                        writeXMLElement('MSCodeN',String.valueOf(RNDC2.MS_Code_N__c));
                                        writeXMLElement('MSCodeO',String.valueOf(RNDC2.MS_Code_O__c));
                                        writeXMLElement('MSCodeY',String.valueOf(RNDC2.MS_Code_Y__c));
                                        writeXMLElement('OTC',String.valueOf(RNDC2.OTC__c));
                                        writeXMLElement('Rx',String.valueOf(RNDC2.Rx__c));
                                        w.writeEndElement();
                                        }
                                   }
                            if(grandgrandchild.containsKey(stpd.Id)){
                                for(Step_Therapy_PreRequisite_Drug__c s : grandgrandchild.get(stpd.Id)){
                                    w.writeComment('StepTherapyPreRequisiteDrugChild Section');
                                    w.writeStartElement(null,'StepTherapyPreRequisiteDrugChild', null);
                                        writeXMLElement('StepTherapyPre-RequisiteDrugID',String.valueOf(s.Name));
                                        writeXMLElement('RelatedDrugListCriteria',String.valueOf(s.Related_Drug_List_Criteria__r.Name));
                                        writeXMLElement('RelatedStepTherapyPre-requisiteDrug',String.valueOf(s.Step_Therapy_Pre_Requisite_Drug_Parent__r.Name));
                                        writeXMLElement('StepTherapyPre-RequisiteDrugName',String.valueOf(s.Step_Therapy_Pre_Requisite_Drug_Name__c ));
                                        writeXMLElement('DescriptionofPre-RequisiteDrug',String.valueOf(s.Description_of_Pre_Requisite_Drug__c));
                                        writeXMLElement('DrugTypeCode',String.valueOf(s.Drug_Type_Code__c));
                                        writeXMLElement('DrugCodeValue',String.valueOf(s.Drug_Code_Value__c));
                                        writeXMLElement('EffectiveDate',String.valueOf(s.Effective_Date__c));
                                        writeXMLElement('TerminationDate',String.valueOf(s.Termination_Date__c));
                                        writeXMLElement('Mandatory',String.valueOf(s.Mandatory__c));
                                        writeXMLElement('NumberOfDistinctDrugs',String.valueOf(s.No_of_Distinct_Drugs__c));
                                        writeXMLElement('Lookback',String.valueOf(s.Lookback__c));
                                        writeXMLElement('LookbackPeriod',String.valueOf(s.Lookback_Period__c));
                                        writeXMLElement('MinimumDaySupply',String.valueOf(s.Minimum_Day_Supply__c));
                                        writeXMLElement('DaysRemaining',String.valueOf(s.Days_Remaining__c));
                                        writeXMLElement('PercentRemaining',String.valueOf(s.Remaining__c));
                                        writeXMLElement('MSCode_M',String.valueOf(s.MS_Code_M__c));
                                        writeXMLElement('MSCode_N',String.valueOf(s.MS_Code_N__c));
                                        writeXMLElement('MSCode_O',String.valueOf(s.MS_Code_O__c));
                                        writeXMLElement('MSCode_Y',String.valueOf(s.MS_Code_Y__c));
                                        writeXMLElement('OverridePrimaryEdit',String.valueOf(s.Override_Primary_Edit__c));
                                        writeXMLElement('SmartEditType',String.valueOf(s.Smart_Edit_Type__c));
                                        writeXMLElement('NDC',String.valueOf(s.NDC__c));
                                        writeXMLElement('Prescriber',String.valueOf(s.Prescriber__r.Name));
                                        writeXMLElement('PrescriberName',String.valueOf(s.Prescriber_Name__c));
                                        writeXMLElement('PrescriberDescription',String.valueOf(s.Prescriber_Description__c));
                                        writeXMLElement('PrescriberLastModified',String.valueOf(s.Prescriber__r.LastModifiedDate));
                                        writeXMLElement('PrescriberSentToCVSDate',String.valueOf(s.Prescriber__r.Sent_To_CVS_Date__c));
                                        writeXMLElement('Specialty',String.valueOf(s.Speciality__r.Name));
                                        writeXMLElement('SpecialtyName',String.valueOf(s.Specialty_Name__c));
                                        writeXMLElement('SpecialtyDescription',String.valueOf(s.Specialty_Description__c));
                                        writeXMLElement('SpecialtyLastModified',String.valueOf(s.Speciality__r.LastModifiedDate));
                                        writeXMLElement('SpecialtySentToCVSDate',String.valueOf(s.Speciality__r.Sent_To_CVS_Date__c));
                                        writeXMLElement('LabTests',String.valueOf(s.Lab_Tests__r.Name));
                                        writeXMLElement('LabTestsName',String.valueOf(s.Lab_Tests_Name__c));
                                        writeXMLElement('LabTestsDescription',String.valueOf(s.Lab_Test_Description__c));
                                        writeXMLElement('LabTestsLastModified',String.valueOf(s.Lab_Tests__r.LastModifiedDate));
                                        writeXMLElement('LabTestsSentToCVSDate',String.valueOf(s.Lab_Tests__r.Sent_To_CVS_Date__c));
                                        writeXMLElement('Diagnosis',String.valueOf(s.Object_List__r.Name));
                                        writeXMLElement('DiagnosisName',String.valueOf(s.Diagnosis_Name__c));
                                        writeXMLElement('DiagnosisDescription',String.valueOf(s.Diagnosis_Description__c));
                                        writeXMLElement('DiagnosisLastModified',String.valueOf(s.Object_List__r.LastModifiedDate));
                                        writeXMLElement('DiagnosisSentToCVSDate',String.valueOf(s.Object_List__r.Sent_To_CVS_Date__c));
                                        writeXMLElement('Provider',String.valueOf(s.Provider__r.Name));
                                        writeXMLElement('ProviderName',String.valueOf(s.Provider_Name__c));
                                        writeXMLElement('ProviderDescription',String.valueOf(s.Provider_Descriptoin__c));
                                        writeXMLElement('ProviderLastModified',String.valueOf(s.Provider__r.LastModifiedDate));
                                        writeXMLElement('ProviderSentToCVSDate',String.valueOf(s.Provider__r.Sent_To_CVS_Date__c));
                                    w.writeEndElement();
                                }
                            }
                            
                        w.writeEndElement();
                    }
                   
                    //write grandchild elements
                    for(Denial_Letter_Junction__c dlj : dlc.Denial_Letter_Junction__r){
                        w.writeComment('Form Section1');
                        w.writeStartElement(null,'FormJunction', null);
                            writeXMLElement('FormJunctionID',String.valueOf(dlj.Name));
                            writeXMLElement('FormID',String.valueOf(dlj.Denial_Letter_ID__r.Name));
                            writeXMLElement('FormName',String.valueOf(dlj.Denial_Letter_Name__c));
                            writeXMLElement('FormDescription',String.valueOf(dlj.Denial_Letter_Description__c));
                            writeXMLElement('RecordType',String.valueOf(dlj.Record_Type__c));
                        w.writeEndElement();
                    }
                    
                   //Writing Stepped Quantity Over Time
                    for(Stepped_Over_Time__c sqrecord:dlc.Stepped_Quantity_Over_Time__r){
                        
                        w.writeComment('Stepped Quantity Over Time');
                        w.writeStartElement(null,'SteppedQuantityOverTime', null);
                            writeXMLElement('NoOfDaysSupply',String.valueOf(sqrecord.of_Days_Supply__c));
                            writeXMLElement('BeginningRange',String.valueOf(sqrecord.Beginning_Range__c));
                            writeXMLElement('EndRange',String.valueOf(sqrecord.End_Range__c));
                            writeXMLElement('PercentMinimumUse',String.valueOf(sqrecord.Percent_Minimum_Use__c));
                            writeXMLElement('Quantity',String.valueOf(sqrecord.Quantity__c));
                            writeXMLElement('RelatedDrugListCriteria',String.valueOf(sqrecord.Related_Drug_List_Criteria__r.Name));
                            writeXMLElement('StepType',String.valueOf(sqrecord.Step_Type__c));
                            writeXMLElement('TimePeriod',String.valueOf(sqrecord.Time_Period__c));
                            writeXMLElement('TimeValue',String.valueOf(sqrecord.Time_Value__c));
                        w.writeEndElement();
                    }
                   
                   //end Stepped Quantity Over Time
                w.writeEndElement();
            }//end of child elements
        
        //end writing parent elements
        w.writeEndElement();

        //close document
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();
         
         GMFBuilderUtil.byPassGMFValidation=true;
        //Updating record for custom history tracking.Added 12/29/2011-Saraag
          DLrecord.LastSent__c=system.now();
          
        
        //End
        
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=DLrecord.Effective_Date__c;
        c.GMF_Drug_List__c = true;
        if(DLrecord.RecordType.Name=='Step Therapy'){
            c.GMF_Step_Therapy__c=true;
        } 
        if(DLrecord.RecordType.Name=='Quantity Limit'){
            c.GMF_Quantity_Limits__c=true;
        } 
        if(DLrecord.RecordType.Name=='Prior Authorization'){
            c.GMF_Prior_Authorization__c=true;
        } 
        c.Subject=String.valueOf(DLrecord.Name)+' '+'-'+' '+String.valueOf(DLrecord.Drug_List_Name__c);
        c.Existing_CVS_Caremark_Drug_List_ID__c = DLrecord.CVS_Caremark_Drug_List_ID__c;
        if (DLrecord.HIX__c == true) {
                c.HIX__c = true;
            } else {
                c.HIX__c = false;
            }
        GMFBuilderUtil.updateExternalCase(c,DLrecord);//Richa added for Req 6012    
        insert c;
        //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
          if(!batchContext){
              DLrecord.Sent_To_CVS_Date__c=system.now();
              DLrecord.PDF_Date__c=system.now();
              DLrecord.External_Case__c = c.id;
          }
          update DLrecord;
          
        Blob xmlblob=Blob.valueof(xmlOutput);
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
    /* 
     * Method :- writeXMLElement
     * Description :- This Method generate XML Element
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
    }
    
    

}