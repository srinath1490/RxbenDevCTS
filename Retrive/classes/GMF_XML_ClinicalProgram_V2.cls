/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
    1.0 -   Becca Allen           05/30/2012                 Created the file
    1.1 -   Rishabh Bansal        8/8/12                     Line #82, added for request 800
    1.2 -   Becca Allen           08/24/12                   Added CVS Drug List ID to Case
    1.3 -   Rishabh Bansal        9/14/12                    Request #511
    1.4 -   Becca Allen           12/10/2012                 updated with last modified date, last sent date, etc.
    1.5 -   Abhishek goel         01/28/2015                 #5471 Removed field CVS_Caremark_Stellant_ID__c
======================================================================== */
public with sharing class GMF_XML_ClinicalProgram_V2 {
    public boolean batchContext = false;
    Clinical_Program__c CPrecord;
    List<Clinical_Program_Criteria__c>  CPCRecord = new List<Clinical_Program_Criteria__c>();
    //List<Conflict_Codes__c>  CCRecord = new List<Conflict_Codes__c>();
    public XmlStreamWriter w = new XmlStreamWriter();
  
    Id parentId;
    List<Conflict_Codes__c> conflictCodesListList = new List<Conflict_Codes__c>();
    List<Codes__c> codesList = new List<Codes__c>();
   /*
    * Constructor of class GMF_XML_ClinicalProgram_V2 
    */   
    public GMF_XML_ClinicalProgram_V2 (ApexPages.StandardController controller) {
        batchContext = GMFBuilderUtil.batchContext;
        parentId=controller.getId();
        //Hix field added as per Request 01100, By Rahul Nasa
        CPrecord=[SELECT 
                        c.POS_Dose_Quantity_Limit__r.Name,c.LastModifiedDate,LastSent__c,c.Therapeutic_Overlap_Allowed__c, c.Therapeutic_Overlap_Allowed_Days__c, c.State__c, 
                        c.Standard__c, c.Slow_Consumption_Assumption__c, c.CVS_Caremark_DUR_ID__c, c.Severity_None_Same_Pharmacy__c, 
                        c.Severity_None_Priority__c, c.Severity_None_Other_Pharmacy__c, c.Severity_Moderate_Same_Pharmacy__c, 
                        c.Severity_Moderate_Priority__c, c.Severity_Moderate_Other_Pharmacy__c, c.Severity_Minor_Same_Pharmacy__c, 
                        c.Severity_Minor_Priority__c, c.Severity_Minor_Other_Pharmacy__c, c.Severity_Major_Same_Pharmacy__c, 
                        c.Severity_Major_Priority__c, c.Severity_Major_Other_Pharmacy__c, c.Segment__c, c.RxCheck_Termination_Date__c, 
                        c.RxCheck_Effective_Date__c, c.RecordType.Name, c.RecordType.DeveloperName, c.Platform__c, 
                        c.Pediatric_dosage_not_available__c, c.PSP_Expiration_Date__c, c.PSP_Effective_Date__c, 
                        c.POS_Dose_Quantity_Limit__c, c.POS_Dose_Override_Drug_List__r.Name, c.POS_Dose_Override_Drug_Group__r.Name, 
                        c.Override_Options__c, c.Name, c.Minimum_Days_for_Inclusion__c, c.Sent_To_CVS_Date__c,
                        c.Maximum_days_below_fill_for_life_of_Rx__c, c.Maximum_Conflicts_per_Prescription__c, 
                        c.Max_Dose_per_Day__c, c.Letter_Id__c, c.Inferred_Disease_Priority__c, c.Inferred_Disease_Response__c, 
                        c.Inferred_Disease_Contradiction_Level__c, c.Indication_Level__c, c.Include_Maintenance_Drugs__c, c.Inactive__c, c.Id, 
                        c.History_Window__c, c.History_Check_Days__c, c.Historical_Days_Extension__c, 
                        c.Geriatrics_dosage_info_not_available__c, c.Gender_Priority__c, c.Gender_Response__c, c.Gender_Contraindication__c, 
                        c.Funding__c, c.Expiration_Date__c,
                        c.Effective_Date__c, c.Duration_of_therapy__c, c.Duplicate_Rx_Therapy_Same_Pharmacy__c, c.Duplicate_Therapy_Priority__c, 
                        c.Duplicate_Rx_Therapy_Other_Pharmacy__c, c.Duplicate_Exact_GPI_Same_Pharmacy__c, c.Duplicate_Exact_GPI_Priority__c, 
                        c.Duplicate_Exact_GPI_Other_Pharmacy__c, c.Drug_Regimen_Priority__c, c.Drug_Regimen_Response__c,  c.Drug_Age_Priority__c, 
                        c.Drug_Age_Response__c,
                        c.Drug_Age_Contraindication_Level__c, c.Dosing_Priority__c, c.Dosing_Response__c, c.Dosage_info_not_available__c, 
                        c.Dosage_Thresholds__c, c.Description__c, c.Days_below_per_fill__c, c.Extend_Historical_Days_Supply__c, c.Onset__c,
                        c.Controlled_Substance_Priority__c, c.Controlled_Substance_Response__c, c.Clinical_Programs_Name__c, 
                        c.Claim_Threshold__c, c.Available_to_be_Picked__c,
                        c.Conflict_Code_Drug_to_Drug_Interaction__c, c.Documentation_Level__c,
                        c.Available_Date__c, c.Adjust_Historical_Days_Supply__c, c.Account__c, c.CVS_Caremark_Drug_List_ID__c,
                        c.Member_ID_Level__c,c.SBM_Sex_Code__c,c.SBM_Date_of_Birth__c,c.SBM_Person_Code__c,c.Duplicate_Therapy_Response__c,
                        c.Duplicate_Therapy_Same_Pharmacy_Response__c,c.Significance_Level__c,c.Adjust_Historical_Rx_Days_Supply__c,c.Duplications_to_Report__c,c.Severity_Major_Status__c,
                        c.Severity_Minor_Status__c,c.Severity_Moderate_Status__c,c.Severity_None_Status__c,c.Severity_Major_Onset__c,c.Severity_Minor_Onset__c,c.Severity_Moderate_Onset__c,
                        c.Severity_None_Onset__c,c.Severity_Major_Documentation_Level__c,c.Severity_Minor_Documentation_Level__c,c.Severity_Moderate_Documentation_Level__c,
                        c.Severity_None_Documentation_Level__c,c.Inferred_Disease_Contraindication_Priori__c,c.Therapeutic_Overlap_Allowed_DT__c,c.of_Days_Therapeutic_Overlap_Allowed__c,
                        c.Duplicate_Rx_Therapy_Priority__c,c.Hix__c,c.of_months_for_Copay_Waiver__c,/*c.SAC_Letter_Templates__c*/c.SAC_Campaign_ID__c,/*c.CVS_Caremark_Stellant_ID__c,*/c.Letter_Description__c,c.SAC_Letter_Templates__c,c.SAC_Letter_Templates__r.name,
                        
                        Conflict_Code_Drug_Age__r.Name, Conflict_Code_Drug_Age__r.LastModifiedDate, Conflict_Code_Drug_Age__r.LastSent__c, Conflict_Code_Drug_Age__r.Conflict_Code_List_Name__c,
                        Conflict_Code_Drug_Age__r.Conflict_Code_List_Description__c, Conflict_Code_Drug_Age__r.RecordType.Name,
                        Conflict_Code_Drug_Age__r.Termination_Date__c, Conflict_Code_Drug_Age__r.Effective_Date__c,
                        Conflict_Code_Drug_Disease__r.Name, Conflict_Code_Drug_Disease__r.LastModifiedDate, Conflict_Code_Drug_Disease__r.LastSent__c, Conflict_Code_Drug_Disease__r.Conflict_Code_List_Name__c,
                        Conflict_Code_Drug_Disease__r.Conflict_Code_List_Description__c, Conflict_Code_Drug_Disease__r.RecordType.Name,
                        Conflict_Code_Drug_Disease__r.Termination_Date__c, Conflict_Code_Drug_Disease__r.Effective_Date__c,
                        Conflict_Code_Drug_to_Drug_Interaction__r.Name, Conflict_Code_Drug_to_Drug_Interaction__r.Conflict_Code_List_Name__c,
                        Conflict_Code_Drug_to_Drug_Interaction__r.Conflict_Code_List_Description__c, Conflict_Code_Drug_to_Drug_Interaction__r.LastModifiedDate, Conflict_Code_Drug_to_Drug_Interaction__r.LastSent__c,
                        Conflict_Code_Drug_to_Drug_Interaction__r.RecordType.Name, Conflict_Code_Drug_to_Drug_Interaction__r.Termination_Date__c,
                        Conflict_Code_Drug_to_Drug_Interaction__r.Effective_Date__c, Conflict_Code_Duplicate_Therapy__r.Name,
                        Conflict_Code_Duplicate_Therapy__r.Conflict_Code_List_Name__c, Conflict_Code_Duplicate_Therapy__r.Conflict_Code_List_Description__c,
                        Conflict_Code_Duplicate_Therapy__r.RecordType.Name, Conflict_Code_Duplicate_Therapy__r.LastSent__c, Conflict_Code_Duplicate_Therapy__r.LastModifiedDate, Conflict_Code_Duplicate_Therapy__r.Termination_Date__c,
                        Conflict_Code_Duplicate_Therapy__r.Effective_Date__c, Conflict_Code_High_Dose__r.Name,
                        Conflict_Code_High_Dose__r.Conflict_Code_List_Name__c, Conflict_Code_High_Dose__r.Conflict_Code_List_Description__c,
                        Conflict_Code_High_Dose__r.RecordType.Name, Conflict_Code_High_Dose__r.Termination_Date__c,
                        Conflict_Code_High_Dose__r.Effective_Date__c, Conflict_Code_High_Dose__r.LastModifiedDate, Conflict_Code_High_Dose__r.LastSent__c,

                        Codes_Drug_Age__r.Name, Codes_Drug_Age__r.LastModifiedDate, Codes_Drug_Age__r.LastSent__c, Codes_Drug_Age__r.Code_List_Name__c, Codes_Drug_Age__r.Code_List_Description__c, Codes_Drug_Age__r.Effective_Date__c, Codes_Drug_Age__r.Termination_Date__c,
                        Codes_Drug_Disease__r.Name, Codes_Drug_Disease__r.Code_List_Name__c, Codes_Drug_Disease__r.LastModifiedDate, Codes_Drug_Disease__r.LastSent__c, Codes_Drug_Disease__r.Code_List_Description__c, Codes_Drug_Disease__r.Effective_Date__c, Codes_Drug_Disease__r.Termination_Date__c,
                        Codes_Drug_to_Drug_Interaction__r.Name, Codes_Drug_to_Drug_Interaction__r.LastModifiedDate, Codes_Drug_to_Drug_Interaction__r.LastSent__c, Codes_Drug_to_Drug_Interaction__r.Code_List_Name__c, Codes_Drug_to_Drug_Interaction__r.Code_List_Description__c, Codes_Drug_to_Drug_Interaction__r.Effective_Date__c, Codes_Drug_to_Drug_Interaction__r.Termination_Date__c,
                        Codes_Duplicate_Therapy__r.Name, Codes_Duplicate_Therapy__r.LastModifiedDate, Codes_Duplicate_Therapy__r.LastSent__c, Codes_Duplicate_Therapy__r.Code_List_Name__c, Codes_Duplicate_Therapy__r.Code_List_Description__c, Codes_Duplicate_Therapy__r.Effective_Date__c, Codes_Duplicate_Therapy__r.Termination_Date__c,
                        Codes_High_Dose__r.Name, Codes_High_Dose__r.Code_List_Name__c, Codes_High_Dose__r.LastModifiedDate, Codes_High_Dose__r.LastSent__c, Codes_High_Dose__r.Code_List_Description__c, Codes_High_Dose__r.Effective_Date__c, Codes_High_Dose__r.Termination_Date__c

                        From Clinical_Program__c c
                        WHERE Id=:parentId AND isDeleted = false LIMIT 1];
                    
        CPCRecord=[Select 
                        c.Termination_Date__c, c.Rx__c, c.Route_of_Administration__c, c.Repack__c, c.RecordType.Name, c.OTC__c, c.Non_Maintenance__c, c.Name, 
                        c.Maintenance__c, c.MS_Code_Y__c, c.MS_Code_O__c, c.MS_Code_N__c, c.MS_Code_M__c, c.Id, c.Effective_Date__c, c.Drug_Type_Code__c, 
                        c.Drug_Code_Value__c, c.DESI__c, c.Alternative_Drug_List__r.Name, c.Alternative_Drug_List__r.LastModifiedDate, c.Alternative_Drug_List__r.LastSent__c,c.Alternative_Drug_List__r.Sent_To_CVS_Date__c  
                    From Clinical_Program_Criteria__c c
                    WHERE c.Clinical_Program__c=:CPrecord.Id AND isDeleted = false];
                    
        Set<Id> conflictCodeListIdSet = new Set<Id>();
        conflictCodeListIdSet.add(CPrecord.Conflict_Code_Drug_Age__c);
        conflictCodeListIdSet.add(CPrecord.Conflict_Code_Drug_Disease__c);
        conflictCodeListIdSet.add(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__c);
        conflictCodeListIdSet.add(CPrecord.Conflict_Code_Duplicate_Therapy__c);
        conflictCodeListIdSet.add(CPrecord.Conflict_Code_High_Dose__c);

        conflictCodesListList = [SELECT Name, RecordType.Name, Conflict_Codes__c, Effective_Date__c, Termination_Date__c,
                                  GPI__c, Related_GPI__c, Age__c, Clinical_Program__c, Codes__c, CreatedById, CreatedDate,
                                  DUR_Message__c, Daily_Dose__c, Days_to_Review__c, IsDeleted, Diagnosis_Code__c,
                                  LastModifiedById, LastModifiedDate, LastSent__c, Operator__c, Overlap_Percent__c, OwnerId,
                                  ConnectionReceivedId, Id, Related_Conflict_Code_List__c, ConnectionSentId, Value__c
                                  FROM Conflict_Codes__c
                                  WHERE Related_Conflict_Code_List__c IN :conflictCodeListIdSet];

        Set<Id> codesIdSet = new Set<Id>();
        codesIdSet.add(CPrecord.Codes_Drug_Age__c);
        codesIdSet.add(CPrecord.Codes_Drug_Disease__c);
        codesIdSet.add(CPrecord.Codes_Drug_to_Drug_Interaction__c);
        codesIdSet.add(CPrecord.Codes_Duplicate_Therapy__c);
        codesIdSet.add(CPrecord.Codes_High_Dose__c);

        codesList = [SELECT Name, Related_Code_List__c, RecordType.Name, Professional__c, Result_of_Service_Codes__c
                     FROM Codes__c
                     WHERE Related_Code_List__c IN :codesIdSet];

        /*
        CCRecord=[SELECT    
                        c.Value__c, c.Related_GPI__c, c.RecordType.Name, c.Operator__c, c.Name, c.Id, c.GPI__c, c.Diagnosis_Code__c, c.Days_to_Review__c, 
                        c.Daily_Dose__c, c.DUR_Message__c, c.Conflict_Codes__c, c.Codes__r.Name, c.Age__c, 
                        (Select 
                            Id, Name, RecordType.Name, Professional__c, Result_of_Service_Codes__c, POS_Dose_Optimization__c, Related_Conflict_Code__r.Name 
                        From Related_Conflict_Code__r) 
                From Conflict_Codes__c c 
                WHERE c.Clinical_Program__c=:CPrecord.Id LIMIT 1000];
        */
        
    }
    /*
     * Method :- generateXML
     * Description :- This Method transfer current page to specified case detail page
     */   
    public PageReference generateXML(){
        
        w.writeStartDocument(null, '1.0');
                   
        //writing parent elements
        w.writeComment('ClinicalProgram RT Save-A-Copay Section');
        w.writeStartElement(null,'ClinicalProgram', null);
        writeXMLElement('ClinicalProgram-XMLVersion',String.valueOf('1.4'));        
        writeXMLElement('ClinicalProgramID',String.valueOf(CPrecord.Name));
        writeXMLElement('CVSCaremarkDrugListID',String.valueOf(CPrecord.CVS_Caremark_Drug_List_ID__c));
        writeXMLElement('ClinicalProgramName',String.valueOf(CPrecord.Clinical_Programs_Name__c));
        writeXMLElement('ClinicalProgramDescription',String.valueOf(CPrecord.Description__c));
        writeXMLElement('RecordType',String.valueOf(CPrecord.RecordType.Name));
        writeXMLElement('LastModifiedDate',String.valueOf(CPrecord.LastModifiedDate));
        //writeXMLElement('LastSent',String.valueOf(CPrecord.LastSent__c));
        writeXMLElement('SentToCVSDate',String.valueOf(CPrecord.Sent_To_CVS_Date__c));
        writeXMLElement('TimeStamp',String.valueOf(system.now()));
        //Hix field added as per Request 01100, By Rahul Nasa
        writeXMLElement('HIX',String.valueOf(CPrecord.Hix__c));
        //Hix field added as per Request 01100, By Rahul Nasa
       // writeXMLElement('SACLetterTemplates',String.valueOf(CPrecord.SAC_Letter_Templates__c));
        writeXMLElement('SACLetterTemplates',String.valueOf(CPrecord.SAC_Letter_Templates__r.name));
        writeXMLElement('LetterDescription',String.valueOf(CPrecord.Letter_Description__c));
        //writeXMLElement('CVSCaremarkStellantID',String.valueOf(CPrecord.CVS_Caremark_Stellant_ID__c));
        writeXMLElement('NoOfMonthsforCopayWaiver',String.valueOf(CPrecord.of_months_for_Copay_Waiver__c));
        writeXMLElement('SACCampaignID',String.valueOf(CPrecord.SAC_Campaign_ID__c));
                       
        if('Concurrent_DUR' == CPrecord.RecordType.DeveloperName){
            w.writeStartElement(null,'ConcurrentDUR', null);
            writeXMLElement('ConcurrentDURID',String.valueOf(CPrecord.Name));
            writeXMLElement('ClinicalProgramName',String.valueOf(CPrecord.Clinical_Programs_Name__c));
            writeXMLElement('ClinicalProgramDescription',String.valueOf(CPrecord.Description__c));
            writeXMLElement('CVSCaremarkDURID',String.valueOf(CPrecord.CVS_Caremark_DUR_ID__c));
            writeXMLElement('MaximumConflictsPerPrescription',String.valueOf(CPrecord.Maximum_Conflicts_per_Prescription__c));
            writeXMLElement('HistoryWindow',String.valueOf(CPrecord.History_Window__c));
            writeXMLElement('MemberIDLevel',String.valueOf(CPrecord.Member_ID_Level__c));
            writeXMLElement('SBMDateOfBirth',String.valueOf(CPrecord.SBM_Date_of_Birth__c));
            writeXMLElement('SBMSexCode',String.valueOf(CPrecord.SBM_Sex_Code__c));
            writeXMLElement('SBMPersonCode',String.valueOf(CPrecord.SBM_Person_Code__c));
    
            w.writeComment('Duplicate Therapy Screening');
            writeXMLElement('DuplicateTherapyPriority',String.valueOf(CPrecord.Duplicate_Therapy_Priority__c));
            writeXMLElement('DuplicateTherapyResponse',String.valueOf(CPrecord.Duplicate_Therapy_Response__c));
            writeXMLElement('DuplicateSamePharmResponse',String.valueOf(CPrecord.Duplicate_Therapy_Same_Pharmacy_Response__c));
            writeXMLElement('TherapeuticOverlapAllowPer',String.valueOf(CPrecord.of_Days_Therapeutic_Overlap_Allowed__c));
            writeXMLElement('TherapeuticOverlapAllowDay',String.valueOf(CPrecord.Therapeutic_Overlap_Allowed_DT__c));
            writeXMLElement('AdjustHistoryRxDaysSupply',String.valueOf(CPrecord.Adjust_Historical_Days_Supply__c));
            writeXMLElement('SignificanceLevel',String.valueOf(CPrecord.Significance_Level__c));
            writeXMLElement('DuplicationsToReport',String.valueOf(CPrecord.Duplications_to_Report__c));
    
            // Conflict Code List (Conflict Code Duplicate Therapy)
            writeXMLElement('CodeListDuplicateTherapyID',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.Name));
            w.writeStartElement(null,'ConflictCodeList', null);
            writeXMLElement('ConflictCodeListID',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.Name));
            writeXMLElement('RecordType',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.RecordType.Name));
            writeXMLElement('ConflictCodeListName',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.Conflict_Code_List_Name__c));
            writeXMLElement('ConflictCodeListDescription',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.Conflict_Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.Termination_Date__c));
            writeXMLElement('CCLDuplicateTherapyLM',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.LastModifiedDate));
            writeXMLElement('CCLDuplicateTherapyLastSent',String.valueOf(CPrecord.Conflict_Code_Duplicate_Therapy__r.LastSent__c));
    
            // Conflict Code
            for (Conflict_Codes__c cc : conflictCodesListList) {
                if (cc.Related_Conflict_Code_List__c == CPrecord.Conflict_Code_Duplicate_Therapy__c) {
                    w.writeStartElement(null,'ConflictCode', null);
                    writeXMLElement('ConflictCodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ConflictCodes',String.valueOf(cc.Conflict_Codes__c));
                    writeXMLElement('EffectiveDate',String.valueOf(cc.Effective_Date__c));
                    writeXMLElement('TerminationDate',String.valueOf(cc.Termination_Date__c));
                    writeXMLElement('GPI',String.valueOf(cc.GPI__c));
                    writeXMLElement('RelatedGPI',String.valueOf(cc.Related_GPI__c));
                    writeXMLElement('Age',String.valueOf(cc.Age__c));
                    writeXMLElement('DailyDose',String.valueOf(cc.Daily_Dose__c));
                    writeXMLElement('DaysToReview',String.valueOf(cc.Days_to_Review__c));
                    writeXMLElement('DiagnosisCode',String.valueOf(cc.Diagnosis_Code__c));
                    writeXMLElement('OverlapPercent',String.valueOf(cc.Overlap_Percent__c));
                    writeXMLElement('DURMessage',String.valueOf(cc.DUR_Message__c));
                    writeXMLElement('Operator',String.valueOf(cc.Operator__c));
                    writeXMLElement('Value',String.valueOf(cc.Value__c));
                    w.writeEndElement(); // w.writeStartElement(null,'ConflictCode', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'ConflictCodeList', null);
    
            w.writeStartElement(null,'CodeList', null);
            writeXMLElement('CodeListDuplicateTherapyID',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.Name));
    
            writeXMLElement('CodeListID',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.Name));
            writeXMLElement('CodeListName',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.Code_List_Name__c));
            writeXMLElement('CodeListDescription',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.Termination_Date__c));
            writeXMLElement('CLDuplicateTherapyLM',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.LastModifiedDate));
            writeXMLElement('CLDuplicateTherapyLastSent',String.valueOf(CPrecord.Codes_Duplicate_Therapy__r.LastSent__c));
    
            for (Codes__c cc : codesList) {
                if (cc.Related_Code_List__c == CPrecord.Codes_Duplicate_Therapy__c) {
                    w.writeStartElement(null,'Code', null);
                    writeXMLElement('CodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ProfessionalServiceCode',String.valueOf(cc.Professional__c));
                    writeXMLElement('ResultOfServiceCodes',String.valueOf(cc.Result_of_Service_Codes__c));
                    w.writeEndElement(); // w.writeStartElement(null,'Code', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'CodeList', null);
    
            writeXMLElement('DrugRegimentPriority',String.valueOf(CPrecord.Drug_Regimen_Priority__c));
            writeXMLElement('DrugRegimenResponse',String.valueOf(CPrecord.Drug_Regimen_Response__c));
            writeXMLElement('MinimumDaysForInclusion',String.valueOf(CPrecord.Minimum_Days_for_Inclusion__c));
            writeXMLElement('PercentDaysBelowPerFill',String.valueOf(CPrecord.Days_below_per_fill__c));
            writeXMLElement('MaxDaysBelowFillForLifeOfRx',String.valueOf(CPrecord.Maximum_days_below_fill_for_life_of_Rx__c));
            writeXMLElement('IncludeMaintenanceDrugs',String.valueOf(CPrecord.Include_Maintenance_Drugs__c));
    
            w.writeComment('Drug to Drug Interaction');
            writeXMLElement('SeverityMajorStatus', String.valueOf(CPrecord.Severity_Major_Status__c));
            writeXMLElement('SeverityMajorPriority', String.valueOf(CPrecord.Severity_Major_Priority__c));
            writeXMLElement('SeverityMajorOtherPharmacy', String.valueOf(CPrecord.Severity_Major_Other_Pharmacy__c));
            writeXMLElement('SeverityMajorSamePharmacy', String.valueOf(CPrecord.Severity_Major_Same_Pharmacy__c));
            writeXMLElement('SeverityMajorOnset', String.valueOf(CPrecord.Severity_Major_Onset__c));
            writeXMLElement('SeverityMajorDocLevel', String.valueOf(CPrecord.Severity_Major_Documentation_Level__c));
            writeXMLElement('SeverityModerateStatus', String.valueOf(CPrecord.Severity_Moderate_Status__c));
            writeXMLElement('SeverityModeratePriority', String.valueOf(CPrecord.Severity_Moderate_Priority__c));
            writeXMLElement('SeverityModerateOtherPharmacy', String.valueOf(CPrecord.Severity_Moderate_Other_Pharmacy__c));
            writeXMLElement('SeverityModerateSamePharmacy', String.valueOf(CPrecord.Severity_Moderate_Same_Pharmacy__c));
            writeXMLElement('SeverityModerateDocLevel', String.valueOf(CPrecord.Severity_Moderate_Documentation_Level__c));
            writeXMLElement('SeverityMinorStatus', String.valueOf(CPrecord.Severity_Minor_Status__c));
            writeXMLElement('SeverityMinorPriority', String.valueOf(CPrecord.Severity_Minor_Priority__c));
            writeXMLElement('SeverityMinorOtherPharmacy', String.valueOf(CPrecord.Severity_Minor_Other_Pharmacy__c));
            writeXMLElement('SeverityMinorSamePharmacy', String.valueOf(CPrecord.Severity_Minor_Same_Pharmacy__c));
            writeXMLElement('SeverityMinorDocLevel', String.valueOf(CPrecord.Severity_Minor_Documentation_Level__c));
            writeXMLElement('SeverityNoneStatus', String.valueOf(CPrecord.Severity_None_Status__c));
            writeXMLElement('SeverityNonePriority', String.valueOf(CPrecord.Severity_None_Priority__c));
            writeXMLElement('SeverityNoneOtherPharmacy', String.valueOf(CPrecord.Severity_None_Other_Pharmacy__c));
            writeXMLElement('SeverityNoneSamePharmacy', String.valueOf(CPrecord.Severity_None_Same_Pharmacy__c));
            writeXMLElement('SeverityNoneDocLevel', String.valueOf(CPrecord.Severity_None_Documentation_Level__c));
            writeXMLElement('ExtendedHistoryDaySupply', String.valueOf(CPrecord.Extend_Historical_Days_Supply__c));
            writeXMLElement('SlowConsumptionAssumption', String.valueOf(CPrecord.Slow_Consumption_Assumption__c));
    
            // Conflict Code List (Conflict Code Drug To Drug)
            writeXMLElement('ConflictCodeDrugToDrugID',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.Name));
            w.writeStartElement(null,'ConflictCodeList', null);
            writeXMLElement('ConflictCodeListID',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.Name));
            writeXMLElement('RecordType',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.RecordType.Name));
            writeXMLElement('ConflictCodeListName',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.Conflict_Code_List_Name__c));
            writeXMLElement('ConflictCodeListDescription',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.Conflict_Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.Termination_Date__c));
            writeXMLElement('CCLDrugtoDrugInteractionLM',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.LastModifiedDate));
            writeXMLElement('CCLDrugtoDrugInteractionLastSent',String.valueOf(CPrecord.Conflict_Code_Drug_to_Drug_Interaction__r.LastSent__c));
    
            // Conflict Code
            for (Conflict_Codes__c cc : conflictCodesListList) {
                if (cc.Related_Conflict_Code_List__c == CPrecord.Conflict_Code_Drug_to_Drug_Interaction__c) {
                    w.writeStartElement(null,'ConflictCode', null);
                    writeXMLElement('ConflictCodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ConflictCodes',String.valueOf(cc.Conflict_Codes__c));
                    writeXMLElement('EffectiveDate',String.valueOf(cc.Effective_Date__c));
                    writeXMLElement('TerminationDate',String.valueOf(cc.Termination_Date__c));
                    writeXMLElement('GPI',String.valueOf(cc.GPI__c));
                    writeXMLElement('RelatedGPI',String.valueOf(cc.Related_GPI__c));
                    writeXMLElement('Age',String.valueOf(cc.Age__c));
                    writeXMLElement('DailyDose',String.valueOf(cc.Daily_Dose__c));
                    writeXMLElement('DaysToReview',String.valueOf(cc.Days_to_Review__c));
                    writeXMLElement('DiagnosisCode',String.valueOf(cc.Diagnosis_Code__c));
                    writeXMLElement('OverlapPercent',String.valueOf(cc.Overlap_Percent__c));
                    writeXMLElement('DURMessage',String.valueOf(cc.DUR_Message__c));
                    writeXMLElement('Operator',String.valueOf(cc.Operator__c));
                    writeXMLElement('Value',String.valueOf(cc.Value__c));
                    w.writeEndElement(); // w.writeStartElement(null,'ConflictCode', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'ConflictCodeList', null);
    
            w.writeStartElement(null,'CodeList', null);
            writeXMLElement('CodeListDrugToDrugID',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.Name));
    
            // ConflictCodeList (Line 1195)
            writeXMLElement('CodeListID',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.Name));
            writeXMLElement('CodeListName',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.Code_List_Name__c));
            writeXMLElement('CodeListDescription',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.Termination_Date__c));
            writeXMLElement('CLDrugtoDrugInteractionLM',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.LastModifiedDate));
            writeXMLElement('CLDrugtoDrugInteractionLastSent',String.valueOf(CPrecord.Codes_Drug_to_Drug_Interaction__r.LastSent__c));
    
            for (Codes__c cc : codesList) {
                if (cc.Related_Code_List__c == CPrecord.Codes_Drug_to_Drug_Interaction__c) {
                    w.writeStartElement(null,'Code', null);
                    writeXMLElement('CodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ProfessionalServiceCode',String.valueOf(cc.Professional__c));
                    writeXMLElement('ResultOfServiceCodes',String.valueOf(cc.Result_of_Service_Codes__c));
                    w.writeEndElement(); // w.writeStartElement(null,'Code', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'CodeList', null);
    
            writeXMLElement('InferredDiseasePriority', String.valueOf(CPrecord.Inferred_Disease_Priority__c));
            writeXMLElement('InferredDiseaseResponse', String.valueOf(CPrecord.Inferred_Disease_Response__c));
            writeXMLElement('IndicationLevel', String.valueOf(CPrecord.Indication_Level__c));
            writeXMLElement('HistoricalDayExtension', String.valueOf(CPrecord.Historical_Days_Extension__c));
            writeXMLElement('InferDisContraindicationLevel', String.valueOf(CPrecord.Inferred_Disease_Contradiction_Level__c));
    
            // Conflict Code List (Conflict Code Drug Disease)
            writeXMLElement('ConflictCodeDrugToDrugID',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.Name));
            w.writeStartElement(null,'ConflictCodeList', null);
            writeXMLElement('ConflictCodeListID',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.Name));
            writeXMLElement('RecordType',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.RecordType.Name));
            writeXMLElement('ConflictCodeListName',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.Conflict_Code_List_Name__c));
            writeXMLElement('ConflictCodeListDescription',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.Conflict_Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.Termination_Date__c));
            writeXMLElement('CCLDrugDiseaseLastModified',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.LastModifiedDate));
            writeXMLElement('CCLDrugDiseaseLastSent',String.valueOf(CPrecord.Conflict_Code_Drug_Disease__r.LastSent__c));
    
            // Conflict Code
            for (Conflict_Codes__c cc : conflictCodesListList) {
                if (cc.Related_Conflict_Code_List__c == CPrecord.Conflict_Code_Drug_Disease__c) {
                    w.writeStartElement(null,'ConflictCode', null);
                    writeXMLElement('ConflictCodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ConflictCodes',String.valueOf(cc.Conflict_Codes__c));
                    writeXMLElement('EffectiveDate',String.valueOf(cc.Effective_Date__c));
                    writeXMLElement('TerminationDate',String.valueOf(cc.Termination_Date__c));
                    writeXMLElement('GPI',String.valueOf(cc.GPI__c));
                    writeXMLElement('RelatedGPI',String.valueOf(cc.Related_GPI__c));
                    writeXMLElement('Age',String.valueOf(cc.Age__c));
                    writeXMLElement('DailyDose',String.valueOf(cc.Daily_Dose__c));
                    writeXMLElement('DaysToReview',String.valueOf(cc.Days_to_Review__c));
                    writeXMLElement('DiagnosisCode',String.valueOf(cc.Diagnosis_Code__c));
                    writeXMLElement('OverlapPercent',String.valueOf(cc.Overlap_Percent__c));
                    writeXMLElement('DURMessage',String.valueOf(cc.DUR_Message__c));
                    writeXMLElement('Operator',String.valueOf(cc.Operator__c));
                    writeXMLElement('Value',String.valueOf(cc.Value__c));
                    w.writeEndElement(); // w.writeStartElement(null,'ConflictCode', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'ConflictCodeList', null);
    
            w.writeStartElement(null,'CodeList', null);
            writeXMLElement('CodeListDrugDiseaseID',String.valueOf(CPrecord.Codes_Drug_Disease__r.Name));
    
            // ConflictCodeList (Line 1242)
            writeXMLElement('CodeListID',String.valueOf(CPrecord.Codes_Drug_Disease__r.Name));
            writeXMLElement('CodeListName',String.valueOf(CPrecord.Codes_Drug_Disease__r.Code_List_Name__c));
            writeXMLElement('CodeListDescription',String.valueOf(CPrecord.Codes_Drug_Disease__r.Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Codes_Drug_Disease__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Codes_Drug_Disease__r.Termination_Date__c));
            writeXMLElement('CLDrugDiseaseLastModified',String.valueOf(CPrecord.Codes_Drug_Disease__r.LastModifiedDate));
            writeXMLElement('CLDrugDiseaseLastSent',String.valueOf(CPrecord.Codes_Drug_Disease__r.LastSent__c));
    
            for (Codes__c cc : codesList) {
                if (cc.Related_Code_List__c == CPrecord.Codes_Drug_Disease__c) {
                    w.writeStartElement(null,'Code', null);
                    writeXMLElement('CodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ProfessionalServiceCode',String.valueOf(cc.Professional__c));
                    writeXMLElement('ResultOfServiceCodes',String.valueOf(cc.Result_of_Service_Codes__c));
                    w.writeEndElement(); // w.writeStartElement(null,'Code', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'CodeList', null);
    
            writeXMLElement('DosingPriority', String.valueOf(CPrecord.Dosing_Priority__c));
            writeXMLElement('DosingResponse', String.valueOf(CPrecord.Dosing_Response__c));
            writeXMLElement('DosageInforNotAvailable', String.valueOf(CPrecord.Dosage_info_not_available__c));
            writeXMLElement('PedDosageInfoNotAvaliable', String.valueOf(CPrecord.Pediatric_dosage_not_available__c));
            writeXMLElement('GerDosageInfoNotAvailable', String.valueOf(CPrecord.Geriatrics_dosage_info_not_available__c));
            writeXMLElement('DosageThersholds', String.valueOf(CPrecord.Dosage_Thresholds__c));
            writeXMLElement('DurationOfTherapy', String.valueOf(CPrecord.Duration_of_therapy__c));
    
            // Conflict Code List (Conflict Code High Dosage)
            writeXMLElement('ConflictCodeDrugToDrugID',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.Name));
            w.writeStartElement(null,'ConflictCodeList', null);
            writeXMLElement('ConflictCodeListID',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.Name));
            writeXMLElement('RecordType',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.RecordType.Name));
            writeXMLElement('ConflictCodeListName',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.Conflict_Code_List_Name__c));
            writeXMLElement('ConflictCodeListDescription',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.Conflict_Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.Termination_Date__c));
            writeXMLElement('CCLHighDoseLastModified',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.LastModifiedDate));
            writeXMLElement('CCLHighDoseLastSent',String.valueOf(CPrecord.Conflict_Code_High_Dose__r.LastSent__c));
    
            // Conflict Code
            for (Conflict_Codes__c cc : conflictCodesListList) {
                if (cc.Related_Conflict_Code_List__c == CPrecord.Conflict_Code_High_Dose__c) {
                    w.writeStartElement(null,'ConflictCode', null);
                    writeXMLElement('ConflictCodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ConflictCodes',String.valueOf(cc.Conflict_Codes__c));
                    writeXMLElement('EffectiveDate',String.valueOf(cc.Effective_Date__c));
                    writeXMLElement('TerminationDate',String.valueOf(cc.Termination_Date__c));
                    writeXMLElement('GPI',String.valueOf(cc.GPI__c));
                    writeXMLElement('RelatedGPI',String.valueOf(cc.Related_GPI__c));
                    writeXMLElement('Age',String.valueOf(cc.Age__c));
                    writeXMLElement('DailyDose',String.valueOf(cc.Daily_Dose__c));
                    writeXMLElement('DaysToReview',String.valueOf(cc.Days_to_Review__c));
                    writeXMLElement('DiagnosisCode',String.valueOf(cc.Diagnosis_Code__c));
                    writeXMLElement('OverlapPercent',String.valueOf(cc.Overlap_Percent__c));
                    writeXMLElement('DURMessage',String.valueOf(cc.DUR_Message__c));
                    writeXMLElement('Operator',String.valueOf(cc.Operator__c));
                    writeXMLElement('Value',String.valueOf(cc.Value__c));
                    w.writeEndElement(); // w.writeStartElement(null,'ConflictCode', null);
                }
            }
            w.writeEndElement(); // w.writeStartElement(null,'ConflictCodeList', null);
    
            w.writeStartElement(null,'CodeList', null);
            writeXMLElement('CodeListHighDoseID',String.valueOf(CPrecord.Codes_High_Dose__r.Name));
    
            // ConflictCodeList (Line 1291)
            writeXMLElement('CodeListID',String.valueOf(CPrecord.Codes_High_Dose__r.Name));
            writeXMLElement('CodeListName',String.valueOf(CPrecord.Codes_High_Dose__r.Code_List_Name__c));
            writeXMLElement('CodeListDescription',String.valueOf(CPrecord.Codes_High_Dose__r.Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Codes_High_Dose__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Codes_High_Dose__r.Termination_Date__c));
            writeXMLElement('CLHighDoseLastModified',String.valueOf(CPrecord.Codes_High_Dose__r.LastModifiedDate));
            writeXMLElement('CLHighDoseLastSent',String.valueOf(CPrecord.Codes_High_Dose__r.LastSent__c));
    
            for (Codes__c cc : codesList) {
                if (cc.Related_Code_List__c == CPrecord.Codes_High_Dose__c) {
                    w.writeStartElement(null,'Code', null);
                    writeXMLElement('CodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ProfessionalServiceCode',String.valueOf(cc.Professional__c));
                    writeXMLElement('ResultOfServiceCodes',String.valueOf(cc.Result_of_Service_Codes__c));
                    w.writeEndElement(); // w.writeStartElement(null,'Code', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'CodeList', null);
    
            writeXMLElement('DrugAgePriority', String.valueOf(CPrecord.Drug_Age_Priority__c));
            writeXMLElement('DrugAgeResponse', String.valueOf(CPrecord.Drug_Age_Response__c));
            writeXMLElement('DrugAgeContraindicationLevel', String.valueOf(CPrecord.Drug_Age_Contraindication_Level__c));
    
            // Conflict Code List (Conflict Code Drug Age)
            writeXMLElement('ConflictCodeDrugToDrugID',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.Name));
            w.writeStartElement(null,'ConflictCodeList', null);
            writeXMLElement('ConflictCodeListID',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.Name));
            writeXMLElement('RecordType',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.RecordType.Name));
            writeXMLElement('ConflictCodeListName',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.Conflict_Code_List_Name__c));
            writeXMLElement('ConflictCodeListDescription',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.Conflict_Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.Termination_Date__c));
            writeXMLElement('CCLDrugAgeLastModified',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.LastModifiedDate));
            writeXMLElement('CCLDrugAgeLastSent',String.valueOf(CPrecord.Conflict_Code_Drug_Age__r.LastSent__c));
    
            // Conflict Code
            for (Conflict_Codes__c cc : conflictCodesListList) {
                if (cc.Related_Conflict_Code_List__c == CPrecord.Conflict_Code_Drug_Age__c) {
                    w.writeStartElement(null,'ConflictCode', null);
                    writeXMLElement('ConflictCodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ConflictCodes',String.valueOf(cc.Conflict_Codes__c));
                    writeXMLElement('EffectiveDate',String.valueOf(cc.Effective_Date__c));
                    writeXMLElement('TerminationDate',String.valueOf(cc.Termination_Date__c));
                    writeXMLElement('GPI',String.valueOf(cc.GPI__c));
                    writeXMLElement('RelatedGPI',String.valueOf(cc.Related_GPI__c));
                    writeXMLElement('Age',String.valueOf(cc.Age__c));
                    writeXMLElement('DailyDose',String.valueOf(cc.Daily_Dose__c));
                    writeXMLElement('DaysToReview',String.valueOf(cc.Days_to_Review__c));
                    writeXMLElement('DiagnosisCode',String.valueOf(cc.Diagnosis_Code__c));
                    writeXMLElement('OverlapPercent',String.valueOf(cc.Overlap_Percent__c));
                    writeXMLElement('DURMessage',String.valueOf(cc.DUR_Message__c));
                    writeXMLElement('Operator',String.valueOf(cc.Operator__c));
                    writeXMLElement('Value',String.valueOf(cc.Value__c));
                    w.writeEndElement(); // w.writeStartElement(null,'ConflictCode', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'ConflictCodeList', null);
    
            w.writeStartElement(null,'CodeList', null);
            writeXMLElement('CodeListDrugAgeID',String.valueOf(CPrecord.Codes_Drug_Age__r.Name));
    
            // ConflictCodeList (Line 1336)
            writeXMLElement('CodeListID',String.valueOf(CPrecord.Codes_Drug_Age__r.Name));
            writeXMLElement('CodeListName',String.valueOf(CPrecord.Codes_Drug_Age__r.Code_List_Name__c));
            writeXMLElement('CodeListDescription',String.valueOf(CPrecord.Codes_Drug_Age__r.Code_List_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Codes_Drug_Age__r.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(CPrecord.Codes_Drug_Age__r.Termination_Date__c));
            writeXMLElement('CLDrugAgeLastModified',String.valueOf(CPrecord.Codes_Drug_Age__r.LastModifiedDate));
            writeXMLElement('CLDrugAgeLastSent',String.valueOf(CPrecord.Codes_Drug_Age__r.LastSent__c));
    
            for (Codes__c cc : codesList) {
                if (cc.Related_Code_List__c == CPrecord.Codes_Drug_Age__c) {
                    w.writeStartElement(null,'Code', null);
                    writeXMLElement('CodeID',String.valueOf(cc.Name));
                    writeXMLElement('RecordType',String.valueOf(cc.RecordType.Name));
                    writeXMLElement('ProfessionalServiceCode',String.valueOf(cc.Professional__c));
                    writeXMLElement('ResultOfServiceCodes',String.valueOf(cc.Result_of_Service_Codes__c));
                    w.writeEndElement(); // w.writeStartElement(null,'Code', null);
                }
            }
    
            w.writeEndElement(); // w.writeStartElement(null,'CodeList', null);
    
            writeXMLElement('GenderPriority', String.valueOf(CPrecord.Gender_Priority__c));
            writeXMLElement('GenderResponse', String.valueOf(CPrecord.Gender_Response__c));
            writeXMLElement('GenderContraindicationLevel', String.valueOf(CPrecord.Gender_Contraindication__c));
    
            w.writeComment('Duplicate Rx Screenining');
            writeXMLElement('DuplicateRxTherapyPriority', String.valueOf(CPrecord.Duplicate_Rx_Therapy_Priority__c));
            writeXMLElement('DuplicateRxTherapyOtherPharm', String.valueOf(CPrecord.Duplicate_Rx_Therapy_Other_Pharmacy__c));
            writeXMLElement('DuplicateRxTherapySamePharm', String.valueOf(CPrecord.Duplicate_Rx_Therapy_Same_Pharmacy__c));
            writeXMLElement('DuplicateExactGPIPriority', String.valueOf(CPrecord.Duplicate_Exact_GPI_Priority__c));
            writeXMLElement('DuplicateExactGPIOtherPharm', String.valueOf(CPrecord.Duplicate_Exact_GPI_Other_Pharmacy__c));
            writeXMLElement('DuplicateEcactGPISamePharm', String.valueOf(CPrecord.Duplicate_Exact_GPI_Same_Pharmacy__c));
            writeXMLElement('TherapeuticOverlapAllowedPer', String.valueOf(CPrecord.Therapeutic_Overlap_Allowed__c));
            writeXMLElement('TherapeuticOverlapDayAllowed', String.valueOf(CPrecord.Therapeutic_Overlap_Allowed_Days__c));
            writeXMLElement('AdjustHistorialDaySupply', String.valueOf(CPrecord.Adjust_Historical_Days_Supply__c));
    
            w.writeComment('Duplicate Rx Screenining');
            writeXMLElement('ControlledSubstancePriority', String.valueOf(CPrecord.Controlled_Substance_Priority__c));
            writeXMLElement('ControlledSubstanceResponse', String.valueOf(CPrecord.Controlled_Substance_Response__c));
            writeXMLElement('HistoryCheckDays', String.valueOf(CPrecord.History_Check_Days__c));
            writeXMLElement('ClaimThershold', String.valueOf(CPrecord.Claim_Threshold__c));
    
            w.writeEndElement(); // w.writeStartElement(null,'ConcurrentDUR', null);
        }
        
            // SaveACopay Required Fields
            if('Save_A_Copay' == CPrecord.RecordType.DeveloperName || 'RxCheck' == CPrecord.RecordType.DeveloperName || 
                'Prescription_Savings_Program' == CPrecord.RecordType.DeveloperName){
                    w.writeComment('Start of Extra ClinicalProgram RT ' + CPrecord.RecordType.Name + ' Section');
                        writeXMLElement('AvailableToBePicked',String.valueOf(CPrecord.Available_to_be_Picked__c));
                        writeXMLElement('AvailableDate',String.valueOf(CPrecord.Available_Date__c));
                        if('RxCheck' == CPrecord.RecordType.DeveloperName){
                            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.RxCheck_Effective_Date__c));
                            writeXMLElement('TerminationDate',String.valueOf(CPrecord.RxCheck_Termination_Date__c));
                        }
                        if('Save_A_Copay' == CPrecord.RecordType.DeveloperName){
                            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.Effective_Date__c));
                            writeXMLElement('ExpirationDate',String.valueOf(CPrecord.Expiration_Date__c));
                        }
                        if('Prescription_Savings_Program' == CPrecord.RecordType.DeveloperName){
                            writeXMLElement('EffectiveDate',String.valueOf(CPrecord.PSP_Effective_Date__c));
                            writeXMLElement('ExpirationDate',String.valueOf(CPrecord.PSP_Expiration_Date__c));
                        }
                        writeXMLElement('LetterID',String.valueOf(CPrecord.Letter_Id__c));
                    w.writeComment('End of Extra ClinicalProgram RT ' + CPrecord.RecordType.Name + ' Section');
            }else if('POS_Dose_Optimization' == CPrecord.RecordType.DeveloperName){
                    w.writeComment('Start of Extra ClinicalProgram RT ' + CPrecord.RecordType.Name + ' Section');
                        writeXMLElement('POSDoseOverrideDrugList',String.valueOf(CPrecord.POS_Dose_Override_Drug_List__r.Name));
                        writeXMLElement('POSDoseOverrideDrugGroup',String.valueOf(CPrecord.POS_Dose_Override_Drug_Group__r.Name));
                        writeXMLElement('POSDoseQuantityLimit',String.valueOf(CPrecord.POS_Dose_Quantity_Limit__r.Name));
                        writeXMLElement('MaxDosePerDay',String.valueOf(CPrecord.Max_Dose_per_Day__c));                  
                        writeXMLElement('OverrideOptions',String.valueOf(CPrecord.Override_Options__c));
                    w.writeComment('End of Extra ClinicalProgram RT ' + CPrecord.RecordType.Name + ' Section');
            }
            
            // Clinical Program Criteria
            if('RxCheck' != CPrecord.RecordType.DeveloperName && 'Concurrent_DUR' != CPrecord.RecordType.DeveloperName &&
                'POS_Dose_Optimization' != CPrecord.RecordType.DeveloperName){
                    for(Clinical_Program_Criteria__c record : CPCRecord){
                        w.writeComment('ClinicalProgramCriteria Section');
                        w.writeStartElement(null,'ClinicalProgramCriteria', null);
                            //writeXMLElement('RelatedClinicalProgramID',String.valueOf(CPrecord.Name));
                            writeXMLElement('ClinicalProgramCriteriaID',String.valueOf(record.Name));
                            writeXMLElement('RecordType',String.valueOf(record.RecordType.Name));
                            writeXMLElement('EffectiveDate',String.valueOf(record.Effective_Date__c));
                            writeXMLElement('TerminationDate',String.valueOf(record.Termination_Date__c));
                            writeXMLElement('DrugTypeCode',String.valueOf(record.Drug_Type_Code__c));
                            writeXMLElement('DrugCodeValue',String.valueOf(record.Drug_Code_Value__c));
                            writeXMLElement('AlternativeDrugList',String.valueOf(record.Alternative_Drug_List__r.Name));
                            writeXMLElement('AlternativeDrugListLastModified',String.valueOf(record.Alternative_Drug_List__r.LastModifiedDate));
                            writeXMLElement('AlternativeDrugListSentToCVSDate',String.valueOf(record.Alternative_Drug_List__r.Sent_To_CVS_Date__c));
                            
                            writeXMLElement('MSCode_M',String.valueOf(record.MS_Code_M__c));
                            writeXMLElement('MSCode_N',String.valueOf(record.MS_Code_N__c));
                            writeXMLElement('MSCode_O',String.valueOf(record.MS_Code_O__c));
                            writeXMLElement('MSCode_Y',String.valueOf(record.MS_Code_Y__c));
                            
                            writeXMLElement('RX',String.valueOf(record.Rx__c));
                            writeXMLElement('OTC',String.valueOf(record.OTC__c));
                            writeXMLElement('Repack',String.valueOf(record.Repack__c));
                            writeXMLElement('DESI',String.valueOf(record.DESI__c));
                            writeXMLElement('Maintenance',String.valueOf(record.Maintenance__c));
                            writeXMLElement('NonMaintenance',String.valueOf(record.Non_Maintenance__c));
                            writeXMLElement('RouteOfAdministration',String.valueOf(record.Route_of_Administration__c));
                        w.writeEndElement();
                    }
            }
            /*
            //Conflict Codes w/ Codes
            if('Concurrent_DUR' == CPrecord.RecordType.DeveloperName || 'POS_Dose_Optimization' == CPrecord.RecordType.DeveloperName){
                 
                //write child element Conflict Code
                for(Conflict_Codes__c rChild : CCRecord){
    
                    w.writeComment('ConflictCodes Section');
                    w.writeStartElement(null,'ConflictCodes', null);
                        writeXMLElement('ConflictCodesName',String.valueOf(rChild.Name));
                        writeXMLElement('ClinicalProgram',String.valueOf(CPrecord.Name));
                        writeXMLElement('RecordType',String.valueOf(rChild.RecordType.Name));
                        
                        writeXMLElement('Age',String.valueOf(rChild.Age__c));
                        writeXMLElement('Codes',String.valueOf(rChild.Codes__r.Name));
                        writeXMLElement('ConflictCodes',String.valueOf(rChild.Conflict_Codes__c));
                        writeXMLElement('DailyDose',String.valueOf(rChild.Daily_Dose__c));
                        writeXMLElement('DaysToReview',String.valueOf(rChild.Days_to_Review__c));
                        writeXMLElement('DiagnosisCode',String.valueOf(rChild.Diagnosis_Code__c));
                        writeXMLElement('DURMessage',String.valueOf(rChild.DUR_Message__c));
                        writeXMLElement('GPI',String.valueOf(rChild.GPI__c));
                        writeXMLElement('RelatedGPI',String.valueOf(rChild.Related_GPI__c));
                        writeXMLElement('Operator',String.valueOf(rChild.Operator__c));
                        writeXMLElement('Value',String.valueOf(rChild.Value__c));
                                            
                        //write grandchild element Code
                        for(Codes__c rGrandchild : rChild.Related_Conflict_Code__r){
                            w.writeComment('Code Section');
                            w.writeStartElement(null,'Code', null);
                                writeXMLElement('CodesName',String.valueOf(rGrandchild.Name));
                                writeXMLElement('RelatedConflictCode',String.valueOf(rGrandchild.Related_Conflict_Code__r.Name));
                                writeXMLElement('ProfessionalServiceCodes',String.valueOf(rGrandchild.Professional__c));
                                writeXMLElement('ResultOfServiceCodes',String.valueOf(rGrandchild.Result_of_Service_Codes__c));
                            w.writeEndElement();
                        }
                        
                    w.writeEndElement();
                }//end of child elements
                
            }
            */
            
        //end writing parent elements
        w.writeEndElement();

        //close document
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();
        
        //updating record for custom history tracking.Added 12/28/11- Saraag
   
        CPrecord.LastSent__c=system.now();
        
        
        //end
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.CRD_GMF_Clinical_Programs__c = true;
        c.Existing_CVS_Caremark_Drug_List_ID__c = CPrecord.CVS_Caremark_Drug_List_ID__c;
        c.Subject=String.valueOf(CPrecord.Name)+' '+'-'+' '+String.valueOf(CPrecord.Clinical_Programs_Name__c);
        if(CPrecord.RecordType.DeveloperName=='RxCheck') {
            c.Effective_Date__c=CPrecord.RxCheck_Effective_Date__c;
        } else if (CPrecord.RecordType.DeveloperName=='Prescription_Savings_Program') {
            c.Effective_Date__c=CPrecord.PSP_Effective_Date__c;
        } else {
            c.Effective_Date__c=CPrecord.Effective_Date__c;
        }
        GMFBuilderUtil.updateExternalCase(c,CPrecord);//Richa added for Req 6012
        insert c;
        //Richa added below IF to update PDF/CVS dates for manual sharing of GMFs to CVS for Req 5959
        if(!batchContext){
          CPrecord.Sent_To_CVS_Date__c=system.now();
          CPrecord.PDF_Date__c=system.now();
          CPrecord.External_Case__c = c.id;
        }
        update CPrecord;
        
        Blob xmlblob=Blob.valueof(xmlOutput);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=CPrecord.Name+' '+system.now()+'.xml';
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
     * Description :- This Mehtod write XML Element
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
    
    /** 
    * =====================================================================
    *                          TEST CASE(S)
    * =====================================================================
    **/
    static testMethod void testXMLGeneration(){
        Account a = new Account();
        a.Name = 'test';
        insert a;
        
        RecordType rt = [SELECT id from RecordType WHERE SobjectType = 'Clinical_Program__c' AND DeveloperName like '%Concurrent_DUR%' AND isActive = true LIMIT 1];
        Clinical_Program__c cp = new Clinical_Program__c();
        cp.Clinical_Programs_Name__c = 'test';
        cp.Description__c = 'test';
        cp.RecordTypeId = rt.Id;
        cp.Maximum_Conflicts_per_Prescription__c = 2;
        cp.History_Window__c = 2;   
        cp.Account__c = a.Id;   
        insert cp;
        
        ApexPages.StandardController cpsc = new ApexPages.StandardController(cp);
        GMF_XML_ClinicalProgram_V2 cprc = new GMF_XML_ClinicalProgram_V2(cpsc);
        cprc.generateXML();
        
        rt = [SELECT id from RecordType WHERE SobjectType = 'Clinical_Program__c' AND DeveloperName like '%Save_A_Copay%' AND isActive = true LIMIT 1];
        cp = new Clinical_Program__c();
        cp.Clinical_Programs_Name__c = 'test';
        cp.Description__c = 'test';
        cp.RecordTypeId = rt.Id;
        cp.Maximum_Conflicts_per_Prescription__c = 2;
        cp.History_Window__c = 2;   
        cp.Account__c = a.Id;   
        insert cp;
        
        Clinical_Program_Criteria__c cpc = new Clinical_Program_Criteria__c();
        cpc.Clinical_Program__c = cp.Id;
        cpc.Drug_Type_Code__c = 'GPI';
        cpc.Effective_Date__c = system.today();
        cpc.Termination_Date__c = system.today();
        cpc.Drug_Code_Value__c = '1326*';
        insert cpc;
        
        cpsc = new ApexPages.StandardController(cp);
        cprc = new GMF_XML_ClinicalProgram_V2(cpsc);
        cprc.generateXML();
    }

}