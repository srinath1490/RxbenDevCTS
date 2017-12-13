global class HVXMLGenerator implements Database.batchable<Drug_List_Criteria__c>, Database.Stateful{
   //Others controller. 
    global String XMLstring;
    public boolean batchContext = false;
    public Id parentId;
    global Drug_List__c DLrecord;
    List<Drug_List_Criteria__c>  DLCRecord;
    static List<Id> stepTherapyId;
    static List<Step_Therapy_PreRequisite_Drug__c> steptherapyList;
    global Map<Id, List<Step_Therapy_PreRequisite_Drug__c>> grandgrandchild;
    global static Attachment a;
    public Id tempAid;
    global case c;
    global Integer currentFileNumber;
    global static final Integer MAXSIZE=3145728;//file size in Bytes. Current Size: 3 MB

    global HVXMLGenerator(Id p){
        XMLstring='';
        batchContext = GMFBuilderUtil.batchContext;
        parentId=p;
        grandgrandchild = new Map<Id, List<Step_Therapy_PreRequisite_Drug__c>>();
        stepTherapyId = new List<Id>();
        currentFileNumber=0;
        XMLStreamWriter w=new XmlStreamWriter();
        DLrecord=[SELECT 
                    Clinical_Edit_Code_Description__c, Clinical_Edit_Code__c, Termination_Date__c, State__c, Standard__c, Special_Use__c, Segment__c, RecordType.Name, Platform__c, 
                    Name, Inactive__c, Id, Funding__c, Effective_Date__c, LastModifiedDate,LastSent__c,Sent_To_CVS_Date__c,Non_GPI_Non_NDC_Check__c, HIX__c, CVS_Caremark_Drug_List_ID__c, Drug_List_Name__c, Description__c, Account__c
                    FROM Drug_List__c 
                    WHERE Id=:parentId LIMIT 1];

        a=new Attachment();
        a.body=Blob.valueof('');
        a.Name=DLrecord.Name+'.txt';
            a.parentId=DLrecord.Id;
            a.contentType='TXT';
        insert a;
        tempAid=a.Id;

                    
//beging retrieving child and grand child
            
             DLCrecord=[SELECT   
                        Unit_Cost__c, Transition_of_Care__c, Term__c, LastModifiedDate, Funding__c, Status__c, Start_Age__c, Start_Age_Type__c, Specialty_Name__c, 
                        Specialty_Description__c, Speciality__r.Name, Speciality__r.LastModifiedDate, Speciality__r.Sent_To_CVS_Date__c, Sequence__c, Rx__c, Rule__c, Route__c, Required__c, 
                        RecordType.Name, Quantity_over_Time_Time_Value__c, Quantity_over_Time_Time_Period__c, Quantity_over_Time_Quantity__c, 
                        Provider__r.Name, Provider__r.LastModifiedDate, Provider__r.Sent_To_CVS_Date__c, Provider_Name__c, Provider_Descriptoin__c, Prescriber__r.Name, Prescriber__r.LastModifiedDate, Prescriber__r.Sent_To_CVS_Date__c, Prescriber_Name__c, 
                        Prescriber_Description__c, Per__c, OTC__c, Number_of_pre_requisites__c, Notes__c, Non_Maintenance__c,Should_count_towards_meeting_ST_Protocol__c,Allow_Transition_Fill__c,TOC_applies__c,Intent__c,Start_Date__c,Maxiumum_Fills_Over_Time_Time_Value__c,Maximum_Fills_Over_Time_Time_Period__c,Member_Message__c, 
                        Non_Compliance__c, Name, Minimum_Quantity__c, Minimum_Days__c, Message__c, Maximum_Quantity__c, Maximum_Fills__c, 
                        Maximum_Dollars__c, Maximum_Days__c, Max_Quantity_per_Fill__c, Max_Days_per_Fill__c, Maintenance__c, MS_Code_Y__c, 
                        MS_Code_O__c, MS_Code_N__c, MS_Code_M__c,Qualifiers__c, Lab_Tests__r.Name, Lab_Tests__r.LastModifiedDate, Lab_Tests__r.Sent_To_CVS_Date__c, Lab_Tests_Name__c, Lab_Test_Description__c, Id, 
                        Grandfathering__c, Gender__c, Force_to_Specialty__c, End_Age__c, End_Age_Type__c, Effective__c, Drug_Type_Code__c, 
                        Drug_List_Criteria_Description__c, Inactive__c, Drug_Code_Value__c, Diagnosis__r.Name, Diagnosis__r.LastModifiedDate, Diagnosis__r.Sent_To_CVS_Date__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                        Days_over_Time_of_Days__c, Days_over_Time_Time_Value__c, Days_over_Time_Time_Period__c, Daily_Dose__c, DESI__c,NDC__c, 
                        Clinical_Edit_Option_Code__c, Bypass_days__c, Repack__c, X100_Copay__c,DAW_Code__c,Excluded_from_Deductible__c,Zero_Copay__c,
                        Message_Action__c,Description_of_NDC_Drug_List_Criteria__c, By_pass_Aetna_Health_Fund__c,Clinical_Edit_Code_Description__c,
                        (SELECT 
                            Termination_Date__c, Step_Therapy_Pre_Requisite_Drug_Parent__r.Name, 
                            Step_Therapy_Pre_Requisite_Drug_Name__c, Specialty_Name__c, Specialty_Description__c, Speciality__r.Name, Speciality__r.LastModifiedDate, Speciality__r.Sent_To_CVS_Date__c,  
                            Sequence__c, Remaining__c, Related_Drug_List_Criteria__c, Provider__r.Name, Provider__r.LastModifiedDate, Provider__r.Sent_To_CVS_Date__c, Provider_Name__c, Provider_Descriptoin__c, 
                            Prescriber__r.Name, Prescriber__r.LastModifiedDate, Prescriber__r.Sent_To_CVS_Date__c, Prescriber_Name__c, Prescriber_Description__c, Object_List__r.Name, Object_List__r.LastModifiedDate, Object_List__r.Sent_To_CVS_Date__c, No_of_Distinct_Drugs__c, Name, 
                            NDC__c, Minimum_Day_Supply__c, Mandatory__c, MS_Code_Y__c, MS_Code_O__c, MS_Code_N__c, MS_Code_M__c, Lookback__c,Override_Primary_Edit__c,Smart_Edit_Type__c,
                            Lookback_Period__c, Lab_Tests__r.Name, Lab_Tests__r.LastModifiedDate, Lab_Tests__r.Sent_To_CVS_Date__c, Lab_Tests_Name__c, Lab_Test_Description__c, Id, GPI__c, Effective_Date__c,
                            Drug_Type_Code__c, Drug_List_Name__c, Drug_Code_Value__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                            Description_of_Pre_Requisite_Drug__c, Days_Remaining__c,Modifier__c,Related_DLC_Drug_Code_Value__c,Priority__c
                        FROM Step_Therapy_Pre_Requisite_Drugs__r WHERE isDeleted = false ),
                        (SELECT 
                            Record_Type__c,Name, Id, Denial_Letter_Name__c, Denial_Letter_ID__r.Name, 
                            Denial_Letter_Description__c 
                        FROM Denial_Letter_Junction__r WHERE isDeleted = false ),
                        (SELECT of_Days_Supply__c,Beginning_Range__c,End_Range__c,Percent_Minimum_Use__c,Quantity__c,Related_Drug_List_Criteria__r.Name,Step_Type__c,Time_Period__c,Time_Value__c
                        
                        FROM Stepped_Quantity_Over_Time__r)
                    FROM Drug_List_Criteria__c 
                    WHERE Inactive__c=false and Drug_List__c=:DLrecord.Id AND isDeleted = false ];
        
        // grandchild's children Ids
        for(Drug_List_Criteria__c dlc : DLCrecord){
            for(Step_Therapy_PreRequisite_Drug__c stpd : dlc.Step_Therapy_Pre_Requisite_Drugs__r){
                stepTherapyId.add(stpd.Id);
            }
        }
        steptherapyList = [Select 
                            s.Termination_Date__c,s.Step_Therapy_Pre_Requisite_Drug_Parent__r.Name, 
                            s.Step_Therapy_Pre_Requisite_Drug_Name__c, s.Specialty_Name__c, s.Specialty_Description__c, s.Speciality__r.Name, s.Speciality__r.LastModifiedDate, s.Speciality__r.Sent_To_CVS_Date__c,
                            s.Sequence__c, s.Remaining__c, s.Related_Drug_List_Criteria__r.Name, s.Provider__r.Name, s.Provider__r.LastModifiedDate, s.Provider__r.Sent_To_CVS_Date__c, s.Provider_Name__c, 
                            s.Provider_Descriptoin__c, s.Prescriber__r.Name, s.Prescriber__r.LastModifiedDate, s.Prescriber__r.Sent_To_CVS_Date__c, s.Prescriber_Name__c, s.Prescriber_Description__c, s.Object_List__r.Name, s.Object_List__r.LastModifiedDate, s.Object_List__r.Sent_To_CVS_Date__c,
                            s.No_of_Distinct_Drugs__c, s.Name, s.NDC__c, s.Minimum_Day_Supply__c, s.Mandatory__c, s.MS_Code_Y__c, s.MS_Code_O__c, 
                            s.MS_Code_N__c, s.MS_Code_M__c,s.Override_Primary_Edit__c ,s.Smart_Edit_Type__c , s.Lookback__c, s.Lookback_Period__c, s.Lab_Tests__r.Name, s.Lab_Tests__r.LastModifiedDate, s.Lab_Tests__r.Sent_To_CVS_Date__c, s.Lab_Tests_Name__c, 
                            s.Lab_Test_Description__c, s.Id, s.GPI__c, s.Effective_Date__c, s.Drug_Type_Code__c, s.Drug_List_Name__c, 
                            s.Drug_Code_Value__c, s.Diagnosis_Name__c, s.Diagnosis_Description__c, s.Description_of_Pre_Requisite_Drug__c, 
                            s.Days_Remaining__c,s.Modifier__c,s.Related_DLC_Drug_Code_Value__c,s.Priority__c
                        From Step_Therapy_PreRequisite_Drug__c s
                        WHERE s.Step_Therapy_Pre_Requisite_Drug_Parent__r.Id IN :stepTherapyId];
        system.debug('grandgrandchild: ' + steptherapyList.size());
        // we now place it in a map so we can access the information easier while generating the xml
        for(Step_Therapy_PreRequisite_Drug__c stp : steptherapyList){
            List<Step_Therapy_PreRequisite_Drug__c> tempList = new List<Step_Therapy_PreRequisite_Drug__c>();
            if(grandgrandchild.containsKey(stp.Step_Therapy_Pre_Requisite_Drug_Parent__c)){
                tempList = grandgrandchild.get(stp.Step_Therapy_Pre_Requisite_Drug_Parent__c);
            }
            tempList.add(stp);
            grandgrandchild.put(stp.Step_Therapy_Pre_Requisite_Drug_Parent__c, tempList);
        }               
        
 //end retrieving child and grand child            
      //intializing XML
        w.writeStartDocument(null, '1.0');
                   
        //writing parent elements
        w.writeComment('DrugList Section');
        w.writeStartElement(null,'DrugList', null);
        writeXMLElement(w,'DrugList-XMLVersion',String.valueOf('1.4'));        
            writeXMLElement(w,'DrugListID',String.valueOf(DLrecord.Name));
            writeXMLElement(w,'DrugListName',String.valueOf(DLrecord.Drug_List_Name__c));
            writeXMLElement(w,'DrugGroupDescription',String.valueOf(DLrecord.Description__c));
            writeXMLElement(w,'RecordType',String.valueOf(DLrecord.RecordType.Name));
            writeXMLElement(w,'TimeStamp',String.valueOf(system.now()));
            writeXMLElement(w,'LastModifiedDate',String.valueOf(DLrecord.LastModifiedDate));
            writeXMLElement(w,'SentToCVSDate',String.valueOf(DLrecord.Sent_To_CVS_Date__c));
            writeXMLElement(w,'SpecialUse',String.valueOf(DLrecord.Special_Use__c));
            writeXMLElement(w,'EffectiveDate',String.valueOf(DLrecord.Effective_Date__c));
            writeXMLElement(w,'TerminationDate',String.valueOf(DLrecord.Termination_Date__c));
            writeXMLElement(w,'HIX',String.valueOf(DLrecord.HIX__c));
            writeXMLElement(w,'Inactive',String.valueOf(DLrecord.Inactive__c));
            writeXMLElement(w,'ClinicalEditCode',String.valueOf(DLrecord.Clinical_Edit_Code__c));
            writeXMLElement(w,'ClinicalEditCodeDescription',String.valueOf(DLrecord.Clinical_Edit_Code_Description__c));
            writeXMLElement(w,'CVSCaremarkDrugListID',String.valueOf(DLrecord.CVS_Caremark_Drug_List_ID__c));
            writeXMLElement(w,'NonGPINonNDCCheck',String.valueOf(DLrecord.Non_GPI_Non_NDC_Check__c));
              
        XMLstring+=w.getXmlString();
    w.close();
    a.body=Blob.valueOf(XMLstring);
    update a;
    XMLstring='';

    system.debug(LoggingLevel.ERROR,'Constructor-String so far:'+XMLString);
    }

    global Iterable<Drug_List_Criteria__c> start(Database.BatchableContext BC){
        return new DLCIterable(DLCrecord);
    }

    global void execute(Database.BatchableContext BC, List<Drug_List_Criteria__c> scope){

        //building XML
                XMLStreamWriter w=new XmlStreamWriter();

        for(Drug_List_Criteria__c dlc:scope){
                    w.writeComment('DrugListCriteria Section');
                    w.writeStartElement(null,'DrugListCriteria', null);
                    writeXMLElement(w,'DrugListCriteriaID',String.valueOf(dlc.Name));
                    //writeXMLElement(w,'DrugList',String.valueOf(DLrecord.Name));
                    writeXMLElement(w,'RecordType',String.valueOf(dlc.RecordType.Name));                
                    writeXMLElement(w,'Inactive',String.valueOf(dlc.Inactive__c));
                    writeXMLElement(w,'AllowTransitionFill',String.valueOf(dlc.Allow_Transition_Fill__c));
                    writeXMLElement(w,'TOCapplies',String.valueOf(dlc.TOC_applies__c));
                    writeXMLElement(w,'ShouldcounttowardsmeetingSTProtocol',String.valueOf(dlc.Should_count_towards_meeting_ST_Protocol__c));
                    writeXMLElement(w,'LastModifiedDate',String.valueOf(dlc.LastModifiedDate)); 
                    writeXMLElement(w,'DescriptionofDrugListCriteria',String.valueOf(dlc.Drug_List_Criteria_Description__c));
                    writeXMLElement(w,'EffectiveDate',String.valueOf(dlc.Effective__c));
                    writeXMLElement(w,'TerminationDate',String.valueOf(dlc.Term__c));
                    writeXMLElement(w,'Funding',String.valueOf(dlc.Funding__c));
                    writeXMLElement(w,'DrugTypeCode',String.valueOf(dlc.Drug_Type_Code__c));
                    writeXMLElement(w,'DrugCodeValue',String.valueOf(dlc.Drug_Code_Value__c));
                    writeXMLElement(w,'NDC',String.valueOf(dlc.NDC__c));
                    writeXMLElement(w,'DescriptionofNDCDrugListCriteria',String.valueOf(dlc.Description_of_NDC_Drug_List_Criteria__c));
                    writeXMLElement(w,'Status',String.valueOf(dlc.Status__c));
                    writeXMLElement(w,'Intent',String.valueOf(dlc.Intent__c));
                    writeXMLElement(w,'MSCode_M',String.valueOf(dlc.MS_Code_M__c));
                    writeXMLElement(w,'MSCode_N',String.valueOf(dlc.MS_Code_N__c));
                    writeXMLElement(w,'MSCode_O',String.valueOf(dlc.MS_Code_O__c));
                    writeXMLElement(w,'MSCode_Y',String.valueOf(dlc.MS_Code_Y__c));
                    writeXMLElement(w,'Qualifiers',String.valueOf(dlc.Qualifiers__c));
                    writeXMLElement(w,'RX',String.valueOf(dlc.Rx__c));
                    writeXMLElement(w,'OTC',String.valueOf(dlc.OTC__c));
                    writeXMLElement(w,'Repack',String.valueOf(dlc.Repack__c));
                    writeXMLElement(w,'DESI',String.valueOf(dlc.DESI__c));
                    writeXMLElement(w,'Maintenance',String.valueOf(dlc.Maintenance__c));
                    writeXMLElement(w,'NonMaintenance',String.valueOf(dlc.Non_Maintenance__c));
                    writeXMLElement(w,'RouteOfAdministration',String.valueOf(dlc.Route__c));
                    writeXMLElement(w,'DAWCode',String.valueOf(dlc.DAW_Code__c));
                    writeXMLElement(w,'ZeroCopay',String.valueOf(dlc.Zero_Copay__c));
                    writeXMLElement(w,'ExcludedFromDeductOrAccum',String.valueOf(dlc.Excluded_from_Deductible__c));
                    writeXMLElement(w,'Prescriber',String.valueOf(dlc.Prescriber__r.Name));
                    writeXMLElement(w,'PrescriberName',String.valueOf(dlc.Prescriber_Name__c));
                    writeXMLElement(w,'PrescriberDescription',String.valueOf(dlc.Prescriber_Description__c));
                    writeXMLElement(w,'PrescriberLastModified',String.valueOf(dlc.Prescriber__r.LastModifiedDate));
                    writeXMLElement(w,'PrescriberSentToCVSDate',String.valueOf(dlc.Prescriber__r.Sent_To_CVS_Date__c));
                    writeXMLElement(w,'Specialty',String.valueOf(dlc.Speciality__r.Name));
                    writeXMLElement(w,'SpecialtyName',String.valueOf(dlc.Specialty_Name__c));
                    writeXMLElement(w,'SpecialtyDescription',String.valueOf(dlc.Specialty_Description__c));
                    writeXMLElement(w,'SpecialtyLastModified',String.valueOf(dlc.Speciality__r.LastModifiedDate));
                    writeXMLElement(w,'SpecialtySentToCVSDate',String.valueOf(dlc.Speciality__r.Sent_To_CVS_Date__c));
                    writeXMLElement(w,'LabTests',String.valueOf(dlc.Lab_Tests__r.Name));
                    writeXMLElement(w,'LabTestsName',String.valueOf(dlc.Lab_Tests_Name__c));
                    writeXMLElement(w,'LabTestDescription',String.valueOf(dlc.Lab_Test_Description__c));
                    writeXMLElement(w,'LabTestsLastModified',String.valueOf(dlc.Lab_Tests__r.LastModifiedDate));
                    writeXMLElement(w,'LabTestsSentToCVSDate',String.valueOf(dlc.Lab_Tests__r.Sent_To_CVS_Date__c));
                    writeXMLElement(w,'Diagnosis',String.valueOf(dlc.Diagnosis__r.Name));
                    writeXMLElement(w,'DiagnosisName',String.valueOf(dlc.Diagnosis_Name__c));
                    writeXMLElement(w,'DiagnosisDescription',String.valueOf(dlc.Diagnosis_Description__c));
                    writeXMLElement(w,'DiagnosisLastModified',String.valueOf(dlc.Diagnosis__r.LastModifiedDate));
                    writeXMLElement(w,'DiagnosisSentToCVSDate',String.valueOf(dlc.Diagnosis__r.Sent_To_CVS_Date__c));
                    writeXMLElement(w,'Provider',String.valueOf(dlc.Provider__r.Name));
                    writeXMLElement(w,'ProviderName',String.valueOf(dlc.Provider_Name__c));
                    writeXMLElement(w,'ProviderDescription',String.valueOf(dlc.Provider_Descriptoin__c));
                    writeXMLElement(w,'ProviderLastModified',String.valueOf(dlc.Provider__r.LastModifiedDate));
                    writeXMLElement(w,'ProviderSentToCVSDate',String.valueOf(dlc.Provider__r.Sent_To_CVS_Date__c));
                    writeXMLElement(w,'StartAge',String.valueOf(dlc.Start_Age__c));
                    writeXMLElement(w,'PeriodtDateStartDate',String.valueOf(dlc.Start_Date__c));
                    writeXMLElement(w,'EndAge',String.valueOf(dlc.End_Age__c));
                    writeXMLElement(w,'EndAgeType',String.valueOf(dlc.End_Age_Type__c));
                    writeXMLElement(w,'Gender',String.valueOf(dlc.Gender__c));
                    writeXMLElement(w,'Grandfathering',String.valueOf(dlc.Grandfathering__c));
                    writeXMLElement(w,'TransitionOfCare',String.valueOf(dlc.Transition_of_Care__c));
                    writeXMLElement(w,'MinimumDays',String.valueOf(dlc.Minimum_Days__c));
                    writeXMLElement(w,'MaximumDays',String.valueOf(dlc.Maximum_Days__c));
                    writeXMLElement(w,'DayQuantityRule',String.valueOf(dlc.Rule__c));
                    writeXMLElement(w,'MinimumQuantity',String.valueOf(dlc.Minimum_Quantity__c));
                    writeXMLElement(w,'MaximumQuantity',String.valueOf(dlc.Maximum_Quantity__c));
                    writeXMLElement(w,'MaximumDollars',String.valueOf(dlc.Maximum_Dollars__c));
                    writeXMLElement(w,'MaximumFills',String.valueOf(dlc.Maximum_Fills__c));
                    writeXMLElement(w,'MaximumFillsOverTimePeriod',String.valueOf(dlc.Maximum_Fills_Over_Time_Time_Period__c));
                    writeXMLElement(w,'MaximumFillsOverTimeValue',String.valueOf(dlc.Maxiumum_Fills_Over_Time_Time_Value__c));
                    writeXMLElement(w,'DailyDose',String.valueOf(dlc.Daily_Dose__c));
                    writeXMLElement(w,'DaysOverTimeNumberOfDays',String.valueOf(dlc.Days_over_Time_of_Days__c));
                    writeXMLElement(w,'DaysOverTimeTimePeriod',String.valueOf(dlc.Days_over_Time_Time_Period__c));
                    writeXMLElement(w,'DaysOverTimeTimeValue',String.valueOf(dlc.Days_over_Time_Time_Value__c));
                    writeXMLElement(w,'QuantityOverTimeQuantity',String.valueOf(dlc.Quantity_over_Time_Quantity__c));
                    writeXMLElement(w,'QuantityOverTimeTimePeriod',String.valueOf(dlc.Quantity_over_Time_Time_Period__c));
                    writeXMLElement(w,'QuantityOverTimeTimeValue',String.valueOf(dlc.Quantity_over_Time_Time_Value__c));
                    writeXMLElement(w,'MaxDaysPerFill',String.valueOf(dlc.Max_Days_per_Fill__c));
                    writeXMLElement(w,'MaxQuantityPerFill',String.valueOf(dlc.Max_Quantity_per_Fill__c));
                    writeXMLElement(w,'ForceToSpecialty',String.valueOf(dlc.Force_to_Specialty__c));
                    writeXMLElement(w,'UnitCost',String.valueOf(dlc.Unit_Cost__c));
                    writeXMLElement(w,'PharmacyMessage',String.valueOf(dlc.Message__c));
                    writeXMLElement(w,'MemberMessage',String.valueOf(dlc.Member_Message__c));
                    writeXMLElement(w,'MessageAction',String.valueOf(dlc.Message_Action__c));
                    writeXMLElement(w,'OneHundredPercentCopay',String.valueOf(dlc.X100_Copay__c));
                    writeXMLElement(w,'ClinicalEditOptionCode',String.valueOf(dlc.Clinical_Edit_Option_Code__c));
                    writeXMLElement(w,'ClinicalEditCodeDescription',String.valueOf(dlc.Clinical_Edit_Code_Description__c));
                    writeXMLElement(w,'NumberofPreRequisiteDrugsRequired',String.valueOf(dlc.Required__c));
                    writeXMLElement(w,'BypassAetnaHealthFund',String.valueOf(dlc.By_pass_Aetna_Health_Fund__c));
                    writeXMLElement(w,'NumberRequired',String.valueOf(dlc.Required__c));
                    writeXMLElement(w,'BypassDays',String.valueOf(dlc.Bypass_days__c));
                    writeXMLElement(w,'Intent',String.valueOf(dlc.Intent__c));
                    writeXMLElement(w,'Notes',String.valueOf(dlc.Notes__c));
                    writeXMLElement(w,'NumberOfPreRequisites',String.valueOf(dlc.Number_of_pre_requisites__c));
                    writeXMLElement(w,'NonCompliance',String.valueOf(dlc.Non_Compliance__c));
           
                     
                    //write grandchild elements
                    for(Step_Therapy_PreRequisite_Drug__c stpd : dlc.Step_Therapy_Pre_Requisite_Drugs__r){
                        w.writeComment('StepTherapyPreRequisiteDrug Section');
                        w.writeStartElement(null,'StepTherapyPreRequisiteDrug', null);
                            writeXMLElement(w,'StepTherapyPre-RequisiteDrugID',String.valueOf(stpd.Name));
                            writeXMLElement(w,'RelatedDrugListCriteria',String.valueOf(dlc.Name));
                            writeXMLElement(w,'RelatedStepTherapyPre-requisiteDrug',String.valueOf(stpd.Step_Therapy_Pre_Requisite_Drug_Parent__r.Name));
                            writeXMLElement(w,'StepTherapyPre-RequisiteDrugName',String.valueOf(stpd.Step_Therapy_Pre_Requisite_Drug_Name__c  ));
                            writeXMLElement(w,'DescriptionofPre-RequisiteDrug',String.valueOf(stpd.Description_of_Pre_Requisite_Drug__c));
                            writeXMLElement(w,'DrugTypeCode',String.valueOf(stpd.Drug_Type_Code__c));
                            writeXMLElement(w,'DrugCodeValue',String.valueOf(stpd.Drug_Code_Value__c));
                            writeXMLElement(w,'EffectiveDate',String.valueOf(stpd.Effective_Date__c));
                            writeXMLElement(w,'TerminationDate',String.valueOf(stpd.Termination_Date__c));
                            writeXMLElement(w,'Mandatory',String.valueOf(stpd.Mandatory__c));
                            writeXMLElement(w,'Modifier',String.valueOf(stpd.Modifier__c));
                            writeXMLElement(w,'RelatedDLCDrugCodeValue',String.valueOf(stpd.Related_DLC_Drug_Code_Value__c));
                            writeXMLElement(w,'Priority',String.valueOf(stpd.Priority__c));
                            writeXMLElement(w,'NumberOfDistinctDrugs',String.valueOf(stpd.No_of_Distinct_Drugs__c));
                            writeXMLElement(w,'Lookback',String.valueOf(stpd.Lookback__c));
                            writeXMLElement(w,'LookbackPeriod',String.valueOf(stpd.Lookback_Period__c));
                            writeXMLElement(w,'MinimumDaySupply',String.valueOf(stpd.Minimum_Day_Supply__c));
                            writeXMLElement(w,'DaysRemaining',String.valueOf(stpd.Days_Remaining__c));
                            writeXMLElement(w,'PercentRemaining',String.valueOf(stpd.Remaining__c));
                            writeXMLElement(w,'MSCode_M',String.valueOf(stpd.MS_Code_M__c));
                            writeXMLElement(w,'MSCode_N',String.valueOf(stpd.MS_Code_N__c));
                            writeXMLElement(w,'MSCode_O',String.valueOf(stpd.MS_Code_O__c));
                            writeXMLElement(w,'MSCode_Y',String.valueOf(stpd.MS_Code_Y__c));
                            writeXMLElement(w,'OverridePrimaryEdit',String.valueOf(stpd.Override_Primary_Edit__c));
                            writeXMLElement(w,'SmartEditType',String.valueOf(stpd.Smart_Edit_Type__c));
                            writeXMLElement(w,'NDC',String.valueOf(stpd.NDC__c));
                            writeXMLElement(w,'Prescriber',String.valueOf(stpd.Prescriber__r.Name));
                            writeXMLElement(w,'PrescriberName',String.valueOf(stpd.Prescriber_Name__c));
                            writeXMLElement(w,'PrescriberDescription',String.valueOf(stpd.Prescriber_Description__c));
                            writeXMLElement(w,'PrescriberLastModified',String.valueOf(stpd.Prescriber__r.LastModifiedDate));
                            writeXMLElement(w,'PrescriberSentToCVSDate',String.valueOf(stpd.Prescriber__r.Sent_To_CVS_Date__c));
                            writeXMLElement(w,'Specialty',String.valueOf(stpd.Speciality__r.Name));
                            writeXMLElement(w,'SpecialtyName',String.valueOf(stpd.Specialty_Name__c));
                            writeXMLElement(w,'SpecialtyDescription',String.valueOf(stpd.Specialty_Description__c));
                            writeXMLElement(w,'SpecialtyLastModified',String.valueOf(stpd.Speciality__r.LastModifiedDate));
                            writeXMLElement(w,'SpecialtySentToCVSDate',String.valueOf(stpd.Speciality__r.Sent_To_CVS_Date__c));
                            writeXMLElement(w,'LabTests',String.valueOf(stpd.Lab_Tests__r.Name));
                            writeXMLElement(w,'LabTestsName',String.valueOf(stpd.Lab_Tests_Name__c));
                            writeXMLElement(w,'LabTestsDescription',String.valueOf(stpd.Lab_Test_Description__c));
                            writeXMLElement(w,'LabTestsLastModified',String.valueOf(stpd.Lab_Tests__r.LastModifiedDate));
                            writeXMLElement(w,'LabTestsSentToCVSDate',String.valueOf(stpd.Lab_Tests__r.Sent_To_CVS_Date__c));
                            writeXMLElement(w,'Diagnosis',String.valueOf(stpd.Object_List__r.Name));
                            writeXMLElement(w,'DiagnosisName',String.valueOf(stpd.Diagnosis_Name__c));
                            writeXMLElement(w,'DiagnosisDescription',String.valueOf(stpd.Diagnosis_Description__c));
                            writeXMLElement(w,'DiagnosisLastModified',String.valueOf(stpd.Object_List__r.LastModifiedDate));
                            writeXMLElement(w,'DiagnosisSentToCVSDate',String.valueOf(stpd.Object_List__r.Sent_To_CVS_Date__c));
                            writeXMLElement(w,'Provider',String.valueOf(stpd.Provider__r.Name));
                            writeXMLElement(w,'ProviderName',String.valueOf(stpd.Provider_Name__c));
                            writeXMLElement(w,'ProviderDescription',String.valueOf(stpd.Provider_Descriptoin__c));
                            writeXMLElement(w,'ProviderLastModified',String.valueOf(stpd.Provider__r.LastModifiedDate));
                            writeXMLElement(w,'ProviderSentToCVSDate',String.valueOf(stpd.Provider__r.Sent_To_CVS_Date__c));
                            
                            if(grandgrandchild.containsKey(stpd.Id)){
                                for(Step_Therapy_PreRequisite_Drug__c s : grandgrandchild.get(stpd.Id)){
                                    w.writeComment('StepTherapyPreRequisiteDrugChild Section');
                                    w.writeStartElement(null,'StepTherapyPreRequisiteDrugChild', null);
                                        writeXMLElement(w,'StepTherapyPre-RequisiteDrugID',String.valueOf(s.Name));
                                        writeXMLElement(w,'RelatedDrugListCriteria',String.valueOf(s.Related_Drug_List_Criteria__r.Name));
                                        writeXMLElement(w,'RelatedStepTherapyPre-requisiteDrug',String.valueOf(s.Step_Therapy_Pre_Requisite_Drug_Parent__r.Name));
                                        writeXMLElement(w,'StepTherapyPre-RequisiteDrugName',String.valueOf(s.Step_Therapy_Pre_Requisite_Drug_Name__c ));
                                        writeXMLElement(w,'DescriptionofPre-RequisiteDrug',String.valueOf(s.Description_of_Pre_Requisite_Drug__c));
                                        writeXMLElement(w,'DrugTypeCode',String.valueOf(s.Drug_Type_Code__c));
                                        writeXMLElement(w,'DrugCodeValue',String.valueOf(s.Drug_Code_Value__c));
                                        writeXMLElement(w,'EffectiveDate',String.valueOf(s.Effective_Date__c));
                                        writeXMLElement(w,'TerminationDate',String.valueOf(s.Termination_Date__c));
                                        writeXMLElement(w,'Mandatory',String.valueOf(s.Mandatory__c));
                                        writeXMLElement(w,'NumberOfDistinctDrugs',String.valueOf(s.No_of_Distinct_Drugs__c));
                                        writeXMLElement(w,'Lookback',String.valueOf(s.Lookback__c));
                                        writeXMLElement(w,'LookbackPeriod',String.valueOf(s.Lookback_Period__c));
                                        writeXMLElement(w,'MinimumDaySupply',String.valueOf(s.Minimum_Day_Supply__c));
                                        writeXMLElement(w,'DaysRemaining',String.valueOf(s.Days_Remaining__c));
                                        writeXMLElement(w,'PercentRemaining',String.valueOf(s.Remaining__c));
                                        writeXMLElement(w,'MSCode_M',String.valueOf(s.MS_Code_M__c));
                                        writeXMLElement(w,'MSCode_N',String.valueOf(s.MS_Code_N__c));
                                        writeXMLElement(w,'MSCode_O',String.valueOf(s.MS_Code_O__c));
                                        writeXMLElement(w,'MSCode_Y',String.valueOf(s.MS_Code_Y__c));
                                        writeXMLElement(w,'OverridePrimaryEdit',String.valueOf(s.Override_Primary_Edit__c));
                                        writeXMLElement(w,'SmartEditType',String.valueOf(s.Smart_Edit_Type__c));
                                        writeXMLElement(w,'NDC',String.valueOf(s.NDC__c));
                                        writeXMLElement(w,'Prescriber',String.valueOf(s.Prescriber__r.Name));
                                        writeXMLElement(w,'PrescriberName',String.valueOf(s.Prescriber_Name__c));
                                        writeXMLElement(w,'PrescriberDescription',String.valueOf(s.Prescriber_Description__c));
                                        writeXMLElement(w,'PrescriberLastModified',String.valueOf(s.Prescriber__r.LastModifiedDate));
                                        writeXMLElement(w,'PrescriberSentToCVSDate',String.valueOf(s.Prescriber__r.Sent_To_CVS_Date__c));
                                        writeXMLElement(w,'Specialty',String.valueOf(s.Speciality__r.Name));
                                        writeXMLElement(w,'SpecialtyName',String.valueOf(s.Specialty_Name__c));
                                        writeXMLElement(w,'SpecialtyDescription',String.valueOf(s.Specialty_Description__c));
                                        writeXMLElement(w,'SpecialtyLastModified',String.valueOf(s.Speciality__r.LastModifiedDate));
                                        writeXMLElement(w,'SpecialtySentToCVSDate',String.valueOf(s.Speciality__r.Sent_To_CVS_Date__c));
                                        writeXMLElement(w,'LabTests',String.valueOf(s.Lab_Tests__r.Name));
                                        writeXMLElement(w,'LabTestsName',String.valueOf(s.Lab_Tests_Name__c));
                                        writeXMLElement(w,'LabTestsDescription',String.valueOf(s.Lab_Test_Description__c));
                                        writeXMLElement(w,'LabTestsLastModified',String.valueOf(s.Lab_Tests__r.LastModifiedDate));
                                        writeXMLElement(w,'LabTestsSentToCVSDate',String.valueOf(s.Lab_Tests__r.Sent_To_CVS_Date__c));
                                        writeXMLElement(w,'Diagnosis',String.valueOf(s.Object_List__r.Name));
                                        writeXMLElement(w,'DiagnosisName',String.valueOf(s.Diagnosis_Name__c));
                                        writeXMLElement(w,'DiagnosisDescription',String.valueOf(s.Diagnosis_Description__c));
                                        writeXMLElement(w,'DiagnosisLastModified',String.valueOf(s.Object_List__r.LastModifiedDate));
                                        writeXMLElement(w,'DiagnosisSentToCVSDate',String.valueOf(s.Object_List__r.Sent_To_CVS_Date__c));
                                        writeXMLElement(w,'Provider',String.valueOf(s.Provider__r.Name));
                                        writeXMLElement(w,'ProviderName',String.valueOf(s.Provider_Name__c));
                                        writeXMLElement(w,'ProviderDescription',String.valueOf(s.Provider_Descriptoin__c));
                                        writeXMLElement(w,'ProviderLastModified',String.valueOf(s.Provider__r.LastModifiedDate));
                                        writeXMLElement(w,'ProviderSent',String.valueOf(s.Provider__r.Sent_To_CVS_Date__c));
                                    w.writeEndElement();
                                }
                            }
                            
                        w.writeEndElement();
                    }
                    
                    //write grandchild elements
                    for(Denial_Letter_Junction__c dlj : dlc.Denial_Letter_Junction__r){
                        w.writeComment('Form Section');
                        w.writeStartElement(null,'FormJunction', null);
                            writeXMLElement(w,'FormJunctionID',String.valueOf(dlj.Name));
                            writeXMLElement(w,'FormID',String.valueOf(dlj.Denial_Letter_ID__r.Name));
                            writeXMLElement(w,'FormName',String.valueOf(dlj.Denial_Letter_Name__c));
                            writeXMLElement(w,'FormDescription',String.valueOf(dlj.Denial_Letter_Description__c));
                            writeXMLElement(w,'RecordType',String.valueOf(dlj.Record_Type__c));
                        w.writeEndElement();
                    }
                    
                   //Writing Stepped Quantity Over Time
                    for(Stepped_Over_Time__c sqrecord:dlc.Stepped_Quantity_Over_Time__r){
                        
                        w.writeComment('Stepped Quantity Over Time');
                        w.writeStartElement(null,'SteppedQuantityOverTime', null);
                            writeXMLElement(w,'NoOfDaysSupply',String.valueOf(sqrecord.of_Days_Supply__c));
                            writeXMLElement(w,'BeginningRange',String.valueOf(sqrecord.Beginning_Range__c));
                            writeXMLElement(w,'EndRange',String.valueOf(sqrecord.End_Range__c));
                            writeXMLElement(w,'PercentMinimumUse',String.valueOf(sqrecord.Percent_Minimum_Use__c));
                            writeXMLElement(w,'Quantity',String.valueOf(sqrecord.Quantity__c));
                            writeXMLElement(w,'RelatedDrugListCriteria',String.valueOf(sqrecord.Related_Drug_List_Criteria__r.Name));
                            writeXMLElement(w,'StepType',String.valueOf(sqrecord.Step_Type__c));
                            writeXMLElement(w,'TimePeriod',String.valueOf(sqrecord.Time_Period__c));
                            writeXMLElement(w,'TimeValue',String.valueOf(sqrecord.Time_Value__c));
                        w.writeEndElement();
                    }
                   
                   //end loop Stepped Quantity Over Time
                w.writeEndElement(); //Ending DLC
        }//end for-loop
        a=[select id,body,BodyLength from Attachment where id=:tempAid];
        //check if the size is less than MAXSIZE MB.
        if(a.BodyLength>=MAXSIZE){ //greater than or equal to MAXSIZE.
            if(c==NULL){
                c=new Case();
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
                if(!batchContext){
                  DLrecord.External_Case__c = c.id;
                }
            }
            XMLstring=w.getXmlString();
            XMLstring=a.body.toString()+XMLstring;

            currentFileNumber++;
            String cN=[select caseNumber from case where id=:c.Id][0].caseNumber;
            
            Blob xmlblob=Blob.valueof(endXML(XMLString,cN));
            Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=DLrecord.Name+'_'+cN+'_'+currentFileNumber+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
            insert xmlAttach;

            //intializing temporary attachment
            a.body=Blob.valueof(startXML());
            update a;

        } 

        else{ //with in size limits.

            XMLstring=w.getXmlString();
            XMLstring=a.body.toString()+XMLstring;
            a.body=Blob.valueOf(XMLstring);
            update a;
        }
     XMLString='';
     w.close();


    }

//----FINISH METHOD----
    global void finish(Database.BatchableContext BC){

        //finishing XML
            a=[select id,body from Attachment where id=:tempAid];

            
            //updating record.
        DLrecord.LastSent__c=system.now();
        
        
        //End
        //inserting case if it wasn't already inserted by execute method.
          if(c==NULL){
                c=new Case();
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
                if(DLrecord.HIX__c == true) {
                c.HIX__c = true;
                } else {
                    c.HIX__c = false;
                }
                GMFBuilderUtil.updateExternalCase(c,DLrecord);//Richa added for Req 6012
                insert c;
                if(!batchContext){
                  DLrecord.External_Case__c = c.id;
                }  
            }
            //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
          if(!batchContext){
              DLrecord.Sent_To_CVS_Date__c=system.now();
              DLrecord.PDF_Date__c=system.now();
          }
          update DLrecord;
       
        String cN=[select caseNumber from case where id=:c.Id][0].caseNumber;
        
        currentFileNumber++;
        XMLstring=a.body.toString()+'<!-- XML Meta info.FB --> <XMLcaseNumber>'+cN+'</XMLcaseNumber>'+'<XMLfileNumber>'+String.valueOf(currentFileNumber)+'</XMLfileNumber>'+'<XMLfinalFile>true</XMLfinalFile><!-- end XML Meta info --></DrugList>'; //finishing up the XML.
        
        Blob xmlblob=Blob.valueof(XMLString);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=DLrecord.Name+'_'+cN+'_'+currentFileNumber+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
        insert xmlAttach;
        
        system.debug(logginglevel.error,'Case Created:+'+c.id);
        
        //sending email
        HVXMLCaller.callMailHandler(c.Id,Userinfo.getUserEmail(),Dlrecord.Name);
    }

    private void writeXMLElement(XMLStreamWriter sw,String elementName, String elementValue){
        sw.writeStartElement(null,elementName,null);
        if(elementValue!=NULL){
            sw.writeCharacters(elementValue);
        }
        else{
            sw.writeCharacters('');
        }
        sw.writeEndElement();
    }

    private string startXML(){

        XMLStreamWriter w=new XMLStreamWriter();

         w.writeStartDocument(null, '1.0');
                   
        //writing parent elements
        w.writeComment('DrugList Section');
        w.writeStartElement(null,'DrugList', null);
        writeXMLElement(w,'DrugList-XMLVersion',String.valueOf('1.4'));        
            writeXMLElement(w,'DrugListID',String.valueOf(DLrecord.Name));
            writeXMLElement(w,'DrugListName',String.valueOf(DLrecord.Drug_List_Name__c));
            writeXMLElement(w,'DrugGroupDescription',String.valueOf(DLrecord.Description__c));
            writeXMLElement(w,'RecordType',String.valueOf(DLrecord.RecordType.Name));
            writeXMLElement(w,'TimeStamp',String.valueOf(system.now()));
            writeXMLElement(w,'LastModifiedDate',String.valueOf(DLrecord.LastModifiedDate));
            writeXMLElement(w,'SentToCVSDate',String.valueOf(DLrecord.Sent_To_CVS_Date__c));
            writeXMLElement(w,'SpecialUse',String.valueOf(DLrecord.Special_Use__c));
            writeXMLElement(w,'EffectiveDate',String.valueOf(DLrecord.Effective_Date__c));
            writeXMLElement(w,'TerminationDate',String.valueOf(DLrecord.Termination_Date__c));
            writeXMLElement(w,'Inactive',String.valueOf(DLrecord.Inactive__c));
            writeXMLElement(w,'ClinicalEditCode',String.valueOf(DLrecord.Clinical_Edit_Code__c));
            writeXMLElement(w,'ClinicalEditCodeDescription',String.valueOf(DLrecord.Clinical_Edit_Code_Description__c));
            writeXMLElement(w,'CVSCaremarkDrugListID',String.valueOf(DLrecord.CVS_Caremark_Drug_List_ID__c));
            writeXMLElement(w,'NonGPINonNDCCheck',String.valueOf(DLrecord.Non_GPI_Non_NDC_Check__c));
              
        String InitialString=w.getXmlString();
        w.close();
        return InitialString;
    }

    private string endXML(String s,String caseNum){
        return s+('<!-- XML Meta info --> <XMLcaseNumber>'+caseNum+'</XMLcaseNumber>'+'<XMLfileNumber>'+String.valueOf(currentFileNumber)+'</XMLfileNumber>'+'<XMLfinalFile>false</XMLfinalFile><!-- end XML Meta info --></DrugList>');
    }
    
}