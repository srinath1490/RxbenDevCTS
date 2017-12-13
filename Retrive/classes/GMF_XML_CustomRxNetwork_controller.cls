/*Purpose: Apex  Class to generate the XML of Custom Network and attach it with case
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Saraag                Not known          generate Custom network  XML
   1.1      Becca                 07/09/2012         Unchecked checkbox for PGs associated with GMF on new case
   1.2 -    Becca                 12/10/2012         updated with Last Modified Date, etc.
   1.3      Rahul                 06/24/2013         Request No.: 01037
   1.4      Becca                 06/29/2015         Updated per request from JV
======================================================================== */
public with sharing class GMF_XML_CustomRxNetwork_controller {
    
    Custom_Rx_Network__c record;
    //Drug Specific Copay
    List<Network_Drug_Specific_Copay__c> lstNetworkDrugSpecificCopay =new List<Network_Drug_Specific_Copay__c>();
    List<Network_Drug_Specific_Copay_Stepped__c> lstNetworkDrugSpecificCopayStepped =new List<Network_Drug_Specific_Copay_Stepped__c>();        
    set<Id> setNetworkDrugSpecificCopay =new set<Id>();
    //Network Copay
    List<Network_Copay__c> lstNetworkCopay =new List<Network_Copay__c>();
    Set<ID> setNetworkCopay =new set<Id>(); 
    List<Network_Copay_Stepped__c> lstNetworkCopayStepped=new List<Network_Copay_Stepped__c>();
    //Network Accumulation
    List<Network_Accumulation__c> lstNetworkAccumulation =new List<Network_Accumulation__c>();
    Set<Id> setNetworkAccumulation = new Set<Id>();
    List<Network_Accumulation_Specific_Drug__c> lstNetworkAccumulationSpecificDrug =new List<Network_Accumulation_Specific_Drug__c>();
    //Network Drug Coverage
    List<Network_Drug_Coverage__c> lstNetworkDrugCoverage =new List<Network_Drug_Coverage__c>();
    Set<Id> setNetworkDrugCoverage = new Set<Id>();
    List<Network_DC_Drug_List_Group__c> lstNetworkDCDrugListGroup = new List<Network_DC_Drug_List_Group__c>();
    //Network Testing Scenerio
    List<Network_Test_Scenario__c> lstNetworkTestScenerio =new List<Network_Test_Scenario__c>();
    //Network Pharmacy Junction
    List<Network_Pharmacy_Junction__c> lstNetworkPharmacyJunction =new List<Network_Pharmacy_Junction__c>();
    
    Map<String,String> rmap = new Map<String,String>();
    Map<String,String> cmap_2 = new Map<String,String>();
    List<Map<String,String>> cmap = new List<Map<String,String>>();
    public XmlStreamWriter w = new XmlStreamWriter();
    Id parentId;
  
    public GMF_XML_CustomRxNetwork_controller(ApexPages.StandardController controller) {
        
        parentId=controller.getId();
        record=[SELECT 
                        c.Traditional_Network_ID__c, c.LastModifiedDate, c.Super_Network_ID__c,c.Tiered_Network_Product__c, c.Summary_of_Request_Intent__c, c.Submission_Date__c, 
                        c.Standard_Network_Access_Comments__c, c.Stage__c, c.Spread_Super_Network_ID__c, 
                        c.Spread_Pricing_Applies_to_In_House_Pharm__c, c.Split_Funded__c, c.Self_Insured__c, c.Segment__c, 
                        c.Segment_Account_Executive_Phone_Number__c, c.Segment_Account_Executive_Name__c, c.Segment_Account_Executive_Email__c, 
                        c.Rework_Needed_Comments__c, c.Retail_Generic_and_MAC_Dispensing_Fee__c, c.Retail_Generic_AWP_Discount__c, 
                        c.Retail_Custom_Rates_Comments_Explanation__c, c.Retail_Brand_Dispensing_Fee__c, c.Retail_Brand_AWP_Discount__c, 
                        c.Response_to_Network__c, c.Response_to_Installations__c, c.Required_to_Support_Custom_Copay_Design__c, 
                        c.Requester_ID__c, c.Requester_Account_Manager_Phone_Number__c, c.Requester_Account_Manager_Name__c, 
                        c.Requester_Account_Manager_Email__c, c.Removal_of_Access_for_Standard_Networks__c, c.Region__c, c.Question_Posed_To__c, 
                        c.Price_Schedule__c, c.Plan_Sponsor_Name__c, c.Pharmacy_5_Participation_Status__c,c.Plan_Letter__c, c.Pharmacy_5_Name__c, 
                        c.Pharmacy_5_NCPDP__c, c.Pharmacy_5_Contact_Phone_Number__c, c.Pharmacy_5_Contact_Name__c, c.Pharmacy_5_Contact_Email__c, 
                        c.Pharmacy_5_Address__c, c.Pharmacy_4_Participation_Status__c, c.Pharmacy_4_Name__c, c.Pharmacy_4_NCPDP__c, 
                        c.Pharmacy_4_Contact_Phone_Number__c, c.Pharmacy_4_Contact_Name__c, c.Pharmacy_4_Contact_Email__c, c.Pharmacy_4_Address__c, 
                        c.Pharmacy_3_Participation_Status__c, c.Pharmacy_3_Name__c, c.Pharmacy_3_NCPDP__c, c.Pharmacy_3_Contact_Phone_Number__c, 
                        c.Pharmacy_3_Contact_Name__c, c.Pharmacy_3_Contact_Email__c, c.Pharmacy_3_Address__c, c.Pharmacy_2_Participation_Status__c, 
                        c.Pharmacy_2_Name__c, c.Pharmacy_2_NCPDP__c, c.Pharmacy_2_Contact_Phone_Number__c, c.Pharmacy_2_Contact_Name__c, 
                        c.Pharmacy_2_Contact_Email__c, c.Pharmacy_2_Address__c, c.Pharmacy_1_Participation_Status__c, c.Pharmacy_1_Name__c, 
                        c.Pharmacy_1_NCPDP__c, c.Pharmacy_1_Contact_Phone_Number__c, c.Pharmacy_1_Contact_Name__c, c.Pharmacy_1_Contact_Email__c, 
                        c.Pharmacy_1_Address__c, c.PSUnique__c, c.Network_Team_General_Inbox__c,c.No_Bill_No_Pay_NBNP__c, c.Network_Coordinator_s_Questions__c, 
                        c.Network_Coordinator__r.Name, c.Network_Coordinator_Phone_Number__c, c.Network_Coordinator_Email__c, 
                        c.Network_Coordinator_Email_Value__c, c.Name, c.NBID_has_been_submitted__c, c.MOEL_ID__c, 
                        c.MOEL_Applies__c, c.Mail_Order_Generic_MAC_Dispensing_Fee__c, c.Mail_Order_Generic_AWP_Discount__c, c.Mail_Order_Brand_Dispensing_Fee__c, 
                        c.Mail_Order_Brand_AWP_Discount__c, c.MAC_at_Retail_Applies__c, c.MAC_applies_at_MOD__c, 
                        c.Is_Custom_Network_for_In_House_Pharmacy__c, c.Is_Custom_Network_for_Chain_Pharmacy__c, c.Pharmacy_1_NPI__c, c.Pharmacy_2_NPI__c, c.Pharmacy_3_NPI__c, c.Pharmacy_4_NPI__c, c.Pharmacy_5_NPI__c,
                        c.Installation_Team_General_Inbox__c, c.Installation_Coordinator_s_Questions__c, c.Installation_Coordinator__r.Name, 
                        c.Installation_Coordinator_Phone_Number__c, c.Installation_Coordinator_Email__c, c.Installation_Coordinator_Email_Value__c, 
                        c.In_House_Pharmacy_Spread_Comments__c, c.In_House_Pharmacy_NCPDP__c, c.In_House_Pharmacy_NPI__c, In_House_Pharmacy_Custom_Max_Day_Supply__c, 
                        c.In_House_Pharmacy_Custom_Copay_Design__c, c.Id, c.Fully_Insured__c,c.Home_Host_Tiered_Medical_Rx_Benefits__c, c.Full_Name_and_Corporate_Address__c, 
                        c.Estimated_Completion_Date__c, c.Entire_Chain_or_Select_Pharmacies__c, c.Effective_Date_of_Benefit_Plan__c, 
                        c.Does_spread_pricing_apply__c,c.Drug_Coverage_Strategy__c,c.DUR_Strategy__c, c.Does_Network_Apply_to_Entire_PSU__c, c.Custom_Retail__c, c.Custom_Rates_at_Retail__c, 
                        c.Custom_MOD_at_ARxHD__c, c.Custom_MOD_Comments_Explanation__c, c.Custom_Benefits_at_ASRx__c, 
                        c.Custom_ASRx_Copay_Design__c, c.Custom_ASRx_Comments_Explanation__c, c.Custom_ASRx_Approval_Attached__c, 
                        c.Control_Group_Number__c,c.Copay_Strategy__c, c.Complexity__c, c.Platform__c,c.Preferred_Maintenance_Strategy__c,c.Preferred_Retail_Net_For_Medical_Accumu__c, c.Retail_Discount_Basis__c, c.Chain_Affiliation_Code__c, 
                        c.Approval_Attached_for_MOEL_Not_Applying__c, c.Additional_Comments__c, c.Acquisition_Submitted_Rate__c, 
                        c.Acquisition_Submitted_Dispensing_Fee__c, c.Account_Name__r.Name, c.ASRx_Custom_Max_Day_Supply__c, c.Current_Status__c,c.Rx_Account_Manager__c, c.Use_Custom_Pricing_for_In_House_Pharmacy__c, c.Plan_Sponsor_Funding_Type__c, c.What_funding_type_does_RX_CN_apply_to__c, c.School_Name__c, c.Network_Copays__c, c.Network_Drug_Specific_Copays__c, c.Network_Drug_Coverage__c, c.Network_Accumulations__c, c.Date_Sent_to_Network__c,
                         

                         
                        (Select 
                                Name 
                            From Pricing__r
                            WHERE isDeleted = false) 
                    From Custom_Rx_Network__c c
                    WHERE Id=:parentId AND isDeleted = false LIMIT 1];
        lstNetworkDrugSpecificCopay = [Select Name,Related_Network_Pharmacy_Junction_ID__r.Name,Related_Pharmacy_Name__c,Drug_Specific_Copay_Record_Type__c,Drug_Specific_Copay_Drug_List__r.Name,
                                       Drug_Specific_Copay_Drug_Group__r.Name,Drug_Specific_Copay_Stepped__c,Drug_Specific_Copay_Dollar_Amount__c,Drug_Specific_Copay_Percent__c,
                                       Drug_Specific_Copay_Calculation__c,Drug_Specific_Copay_Minimum_Dollar__c,Drug_Specific_Copay_Maximum_Dollar__c from 
                                       Network_Drug_Specific_Copay__c where Custom_Rx_Network_ID__c=:parentId];
        If (lstNetworkDrugSpecificCopay.size()>0)
        {
            for(Network_Drug_Specific_Copay__c objNetworkDrugSpecificCopay : lstNetworkDrugSpecificCopay)
            {
                setNetworkDrugSpecificCopay.add(objNetworkDrugSpecificCopay.Id);
            }
        }
        lstNetworkDrugSpecificCopayStepped =[Select Name,Network_Drug_Specific_Copay_ID__r.Name,Network_DSC_Stepped_Type__c,Network_DSC_Stepped_Beginning_Range__c,Network_DSC_Stepped_End_Range__c,
                                             Network_DSC_Stepped_Dollar_Amount__c,Network_DSC_Stepped_Percent__c,Network_DSC_Stepped_Copay_Calculation__c,Network_DSC_Stepped_Maximum_Dollar__c,                                            
                                             Network_DSC_Stepped_Minimum_Dollar__c from  Network_Drug_Specific_Copay_Stepped__c where  Network_Drug_Specific_Copay_ID__c In : setNetworkDrugSpecificCopay];

        lstNetworkCopay =[Select Name,Related_Network_Pharmacy_Junction_ID__r.Name,Related_Pharmacy_Name__c, Copay_Record_Type__c,Copay_Tier_Type__c,Stepped__c, Copay_Dollar_Amount__c,
                            Copay_Percent__c,Copay_Calculation__c,Copay_Maximum_Dollar__c,  Copay_Minimum_Dollar__c from Network_Copay__c where Custom_Rx_Network_ID__c=:parentId];

        If (lstNetworkCopay.size()>0)
        {
            for(Network_Copay__c objNetworkCopay : lstNetworkCopay)
            {
                setNetworkCopay.add(objNetworkCopay.Id);
            }
        }
      // lstNetworkCopayStepped=[Select Network_Copay_Stepped__c.Name , Network_Copay_Id__r.Name from Network_Copay_Stepped__c where Network_Copay_Stepped__c.Network_Copay_ID__c In : setNetworkCopay];
        lstNetworkCopayStepped=[Select Name,Network_Copay_Id__r.Name,Network_Copay_Stepped_Type__c,Network_Copay_Stepped_Beginning_Range__c, Network_Copay_Stepped_End_Range__c,
                                             Network_Copay_Stepped_Dollar_Amount__c,Network_Copay_Stepped_Percent__c,Network_Copay_Stepped_Copay_Calculation__c,Network_Copay_Stepped_Maximum_Dollar__c,                                            
                                             Network_Copay_Stepped_Minimum_Dollar__c from Network_Copay_Stepped__c where Network_Copay_ID__c In : setNetworkCopay];
       
        lstNetworkAccumulation =[Select Name,Related_Network_Pharmacy_Junction_ID__r.Name,Related_Pharmacy_Name__c,Accumulation_Record_Type__c,What_is_the_Deductible_Amount__c,What_is_the_Deductible_Period__c,
                                 Accums_carry_over_from_the_4th_Quarter__c,DED_Exclude_In_Network__c,DED_Exclude_Out_of_Network__c,DED_Exclude_Generic_Drugs__c,DED_Exclude_Brand_Drugs_w_Generics__c,
                                 DED_Exclude_Brand_Drugs_w_no_Generics__c,DED_Exclude_Maintenance_Drugs__c from Network_Accumulation__c  where Custom_Rx_Network_ID__c=:parentId];
        If (lstNetworkAccumulation .size()>0)
        {
            for(Network_Accumulation__c objNetworkAccumulation : lstNetworkAccumulation)
            {
                setNetworkAccumulation.add(objNetworkAccumulation.Id);
            }
        } 
        lstNetworkAccumulationSpecificDrug =[Select Name,Network_Accumulation_ID__r.Name,Network_ASD_Drug_Group__r.Name,Network_ASD_Drug_List__r.Name,What_is_the_Deductible_Amount__c,What_is_the_Deductible_Period__c,
                                             Accums_carry_over_from_the_4th_Quarter__c from Network_Accumulation_Specific_Drug__c where Network_Accumulation_ID__c IN: setNetworkAccumulation];
        lstNetworkDrugCoverage =[Select Name,RecordType.DeveloperName,Related_Network_Pharmacy_Junction_ID__r.Name,Related_Pharmacy_Name__c,Record_Type__c,Formulary_Open_Closed__c,Formulary__r.Name,Exception_Drug_Group__r.Name,
                                    Exception_Drug_List__r.Name,Override_Standard_Refill_too_Soon__c,Custom_Refill_too_Soon__r.Name,Minimum_Days_Supplied__c, Maximum_Days_Supplied__c,
                                    Minimum_Quantity__c,Maximum_Quantity__c,Rules_for_Supply_Quantity__c,Do_you_have_Mandatory_Generic__c,What_Option__c,What_is_the_Penalty__c,
                                    Apply_Difference_of_Cost__c,Cost_Type__c,Cost_Amount__c,Mandatory_Generic_Copay_Diff_Exclusion__c,Do_you_have_Specialty__c,Aetna_Specialty_Care_Rx__c,
                                    Specialty_Drug_List__r.Name, Force_to_Specialty__c,fills_before_force_to_specialty__c from Network_Drug_Coverage__c where Custom_Rx_Network_ID__c=:parentId];
                                    
         If (lstNetworkDrugCoverage.size()>0)
        {
            for(Network_Drug_Coverage__c objNetworkDrugCoverage : lstNetworkDrugCoverage)
            {
                setNetworkDrugCoverage.add(objNetworkDrugCoverage.Id);
            }
        }
        lstNetworkDCDrugListGroup=[Select Name,Network_Drug_Coverage_ID__r.Name,Inclusion_Exclusion__c,Inclusion_Exclusion_Drug_Class__c,Network_DC_Drug_List__r.Name,Network_DC_Drug_Group__r.Name,
                                   Apply_Limitations__c,Start_Age__c,Start_Age_Type__c,End_Age__c,End_Age_Type__c,Gender__c,Minimum_Days__c,Maximum_Days__c,Minimum_Quantity__c,
                                   Maximum_Quantity__c,Day_Quantity_Rule__c,Maximum_Fill__c,Maximum_Days_Per_Fill__c,Maximum_Quantity_Per_Fill__c,Maximum_Dollars__c,
                                   Daily_Dose__c,Days_Over_Time_of_Days__c,Days_Over_Time_Time_Value__c,Days_Over_Time_Time_Period__c,Quantity_Over_Time_Quantity__c,
                                   Quantity_Over_Time_Time_Value__c,Quantity_Over_Time_Time_Period__c from Network_DC_Drug_List_Group__c where Network_Drug_Coverage_ID__c IN:setNetworkDrugCoverage];
                                   
       lstNetworkTestScenerio =[Select Name,Drug_to_Test__c,Tier__c,Tier_Record_Type__c,Day_Supply__c,Quantity__c,Standard_Copay_Type__c,Standard_Copay__c,
                                Custom_Copay_Type__c,Custom_Copay__c, Additional_Testing_Information__c from Network_Test_Scenario__c where Custom_Rx_Network_ID__c=:parentId];
              
                 
       lstNetworkPharmacyJunction =[Select Name,Pharmacy_Number__c,Network_Pharmacy_ID__r.Name,Pharmacy_Participation_Status__c,Pharmacy_NCPDP__c,Pharmacy_NPI__c
                                       , Pharmacy_Name__c from  Network_Pharmacy_Junction__c where  Custom_Rx_Network_ID__c=:parentId];
       
        }
    
    public PageReference generateXML(){
    /*
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
         String CurrentVersion='1.2';
        String s=gmfwriter.getparentXml(CurrentVersion,'CustomRxNetwork','Pricing',rmap,cmap);
        */
         w.writeStartDocument(null, '1.0');

        w.writeComment('Custom Rx Section');
        w.writeStartElement(null, 'CustomRxNetwork', null);
        writeXMLElement('CustomRxNetwork-XMLVersion', String.valueOf('1.4'));
        writeXMLElement('XMLDate-TimeStamp', String.valueOf(system.now()));
      


       writeXMLElement('CustomRxNetworkName',String.valueOf(record.Name));
        //writeXMLElement('Stage',String.valueOf(record.Stage__c));
        writeXMLElement('SummaryOfRequestIntent',String.valueOf(record.Summary_of_Request_Intent__c));
        writeXMLElement('CVSHNetworkID',String.valueOf(record.Traditional_Network_ID__c));
        writeXMLElement('CurrentStatus',String.valueOf(record.Current_Status__c));
        
        //writeXMLElement('Complexity',String.valueOf(record.Complexity__c));
        //writeXMLElement('EstimatedCompletionDate',String.valueOf(record.Estimated_Completion_Date__c));
        //writeXMLElement('TraditionalNetworkID',String.valueOf(record.Traditional_Network_ID__c));
        //writeXMLElement('SuperNetworkID',String.valueOf(record.Super_Network_ID__c));
        //writeXMLElement('SpreadSuperNetworkID',String.valueOf(record.Spread_Super_Network_ID__c));
        //writeXMLElement('MOELID',String.valueOf(record.MOEL_ID__c));
        //writeXMLElement('PriceSchedule',String.valueOf(record.Price_Schedule__c));
        writeXMLElement('LastModifiedDate',String.valueOf(record.LastModifiedDate));
        writeXMLElement('TimeStamp',String.valueOf(system.now()));
        
        writeXMLElement('SubmissionDate',String.valueOf(record.Submission_Date__c));
        writeXMLElement('RequesterName',String.valueOf(record.Requester_Account_Manager_Name__c));
        writeXMLElement('RequesterEmail',String.valueOf(record.Requester_Account_Manager_Email__c));
        writeXMLElement('RequesterPhoneNumber',String.valueOf(record.Requester_Account_Manager_Phone_Number__c));
        //writeXMLElement('SegmentAccountExecutiveName',String.valueOf(record.Segment_Account_Executive_Name__c));
        //writeXMLElement('SegmentAccountExecutiveEmail',String.valueOf(record.Segment_Account_Executive_Email__c));
        //writeXMLElement('SegmentAccountExecutivePhoneNumber',String.valueOf(record.Segment_Account_Executive_Phone_Number__c));
        //riteXMLElement('NetworkCoordinator',String.valueOf(record.Network_Coordinator__r.Name));
        //writeXMLElement('NetworkCoordinatorEmail',String.valueOf(record.Network_Coordinator_Email__c));
        //writeXMLElement('NetworkCoordinatorPhoneNumber',String.valueOf(record.Network_Coordinator_Phone_Number__c));
        //writeXMLElement('InstallationCoordinator',String.valueOf(record.Installation_Coordinator__r.Name));
        //writeXMLElement('InstallationCoordinatorEmail',String.valueOf(record.Installation_Coordinator_Email__c));
        //writeXMLElement('InstallationCoordinatorPhoneNumber',String.valueOf(record.Installation_Coordinator_Phone_Number__c));
        
        writeXMLElement('AccountName',String.valueOf(record.Account_Name__r.Name));
        writeXMLElement('SchoolName',String.valueOf(record.School_Name__c));
        //writeXMLElement('Platform',String.valueOf(record.Platform__c));
        writeXMLElement('PSUnique',String.valueOf(record.PSUnique__c));
        writeXMLElement('Region',String.valueOf(record.Region__c));
        writeXMLElement('Segment',String.valueOf(record.Segment__c));
        writeXMLElement('RxAccountManager',String.valueOf(record.RX_Account_Manager__c)); //added by BA 5-29-15
        writeXMLElement('DoesNetworkApplytoEntirePSU',String.valueOf(record.Does_Network_Apply_to_Entire_PSU__c));
        writeXMLElement('ControlGroupNumber',String.valueOf(record.Control_Group_Number__c));
        writeXMLElement('PlanLetter',String.valueOf(record.Plan_Letter__c));
        writeXMLElement('EffectiveDateofRXCustomNetwork',String.valueOf(record.Effective_Date_of_Benefit_Plan__c));
        writeXMLElement('PlanSponsorFundingType',String.valueOf(record.Plan_Sponsor_Funding_Type__c));
        writeXMLElement('WhatFundingTypeDoesRxCNApplyTo',String.valueOf(record.What_funding_type_does_RX_CN_apply_to__c));
        //writeXMLElement('SelfInsured',String.valueOf(record.Self_Insured__c));
        writeXMLElement('Doesspreadpricingapply',String.valueOf(record.Does_spread_pricing_apply__c));
        writeXMLElement('NoBillNoPay',String.valueOf(record.No_Bill_No_Pay_NBNP__c));
        //writeXMLElement('FullyInsured',String.valueOf(record.Fully_Insured__c));
        //writeXMLElement('SplitFunded',String.valueOf(record.Split_Funded__c));
        //writeXMLElement('NBIDHasBeenSubmitted',String.valueOf(record.NBID_has_been_submitted__c));
        
        /*writeXMLElement('CustomMODatARxHD',String.valueOf(record.Custom_MOD_at_ARxHD__c));
        writeXMLElement('MailOrderBrandAWPDiscount',String.valueOf(record.Mail_Order_Brand_AWP_Discount__c));
        writeXMLElement('MODBrandDispensingFee',String.valueOf(record.Mail_Order_Brand_Dispensing_Fee__c));
        writeXMLElement('MODGenericAWPDiscount',String.valueOf(record.Mail_Order_Generic_AWP_Discount__c));
        writeXMLElement('MODGenericandMACDispensingFee',String.valueOf(record.Mail_Order_Generic_MAC_Dispensing_Fee__c));
        writeXMLElement('MACatMODApplies',String.valueOf(record.MAC_applies_at_MOD__c));
        writeXMLElement('MOELApplies',String.valueOf(record.MOEL_Applies__c));
        writeXMLElement('ApprovalAttachedforMOELNotApplying',String.valueOf(record.Approval_Attached_for_MOEL_Not_Applying__c));
        writeXMLElement('CustomMODCommentsExplanation',String.valueOf(record.Custom_MOD_Comments_Explanation__c));
        
        writeXMLElement('CustomBenefitsatASRx',String.valueOf(record.Custom_Benefits_at_ASRx__c));
        writeXMLElement('RequiredtoSupportCustomCopayDesign',String.valueOf(record.Required_to_Support_Custom_Copay_Design__c));
        writeXMLElement('CustomASRxCopayDesign',String.valueOf(record.Custom_ASRx_Copay_Design__c));
        writeXMLElement('ASRxCustomMaxDaySupply',String.valueOf(record.ASRx_Custom_Max_Day_Supply__c));        
        writeXMLElement('CustomASRxApprovalAttached',String.valueOf(record.Custom_ASRx_Approval_Attached__c));
        writeXMLElement('CustomASRxCommentsExplanation',String.valueOf(record.Custom_ASRx_Comments_Explanation__c));*/
        
        writeXMLElement('CustomRatesatRetail',String.valueOf(record.Custom_Rates_at_Retail__c));
        writeXMLElement('RetailBrandAWPDiscount',String.valueOf(record.Retail_Brand_AWP_Discount__c));
        writeXMLElement('RetailBrandDispensingFee',String.valueOf(record.Retail_Brand_Dispensing_Fee__c));
        writeXMLElement('RetailGenericAWPDiscount',String.valueOf(record.Retail_Generic_AWP_Discount__c));
        writeXMLElement('RetailGenericandMACDispensingFee',String.valueOf(record.Retail_Generic_and_MAC_Dispensing_Fee__c));
        writeXMLElement('RetailDiscountBasis',String.valueOf(record.Retail_Discount_Basis__c));
        writeXMLElement('MACatRetailApplies',String.valueOf(record.MAC_at_Retail_Applies__c));
        writeXMLElement('AcquisitionSubmittedRate',String.valueOf(record.Acquisition_Submitted_Rate__c));
        writeXMLElement('AcquisitionSubmittedDispensingFee',String.valueOf(record.Acquisition_Submitted_Dispensing_Fee__c));
        writeXMLElement('RetailCustomRatesCommentsExceptions',String.valueOf(record.Retail_Custom_Rates_Comments_Explanation__c));
        
        //writeXMLElement('CustomRetail',String.valueOf(record.Custom_Retail__c));
        writeXMLElement('UseClientPricingforInHousePharmacy',String.valueOf(record.Use_Custom_Pricing_for_In_House_Pharmacy__c));
        writeXMLElement('IsCustomNetworkforChainPharmacy',String.valueOf(record.Is_Custom_Network_for_Chain_Pharmacy__c));
        writeXMLElement('ChainAffiliationCode',String.valueOf(record.Chain_Affiliation_Code__c));
        writeXMLElement('FullNameandCorporateAddress',String.valueOf(record.Full_Name_and_Corporate_Address__c));
        writeXMLElement('EntireChainorSelectPharmacies',String.valueOf(record.Entire_Chain_or_Select_Pharmacies__c));
        writeXMLElement('IsCustomNetworkforInHousePharmacy',String.valueOf(record.Is_Custom_Network_for_In_House_Pharmacy__c));
        //writeXMLElement('UseCustomPricingforInHousePharmacy',String.valueOf(record.Use_Custom_Pricing_for_In_House_Pharmacy__c));
        //writeXMLElement('InHousePharmacyNCPDP',String.valueOf(record.In_House_Pharmacy_NCPDP__c));
        //writeXMLElement('InHousePharmacyNPI',String.valueOf(record.In_House_Pharmacy_NPI__c));
        writeXMLElement('SpreadPricingAppliestoInHousePharm',String.valueOf(record.Spread_Pricing_Applies_to_In_House_Pharm__c));
        writeXMLElement('InHousePharmacySpreadComments',String.valueOf(record.In_House_Pharmacy_Spread_Comments__c));
        //writeXMLElement('InHousePharmacyCustomCopayDesign',String.valueOf(record.In_House_Pharmacy_Custom_Copay_Design__c));
        writeXMLElement('InHousePharmacyCustomMaxDaySupply',String.valueOf(record.In_House_Pharmacy_Custom_Max_Day_Supply__c));
        writeXMLElement('NetworkCopays',String.valueOf(record.Network_Copays__c));
        writeXMLElement('NetworkDrugSpecificCopays',String.valueOf(record.Network_Drug_Specific_Copays__c));
        writeXMLElement('NetworkDrugCoverage',String.valueOf(record.Network_Drug_Coverage__c));
        writeXMLElement('NetworkAccumulations',String.valueOf(record.Network_Accumulations__c));
        writeXMLElement('HomeHostTieredMedRxBenefits',String.valueOf(record.Home_Host_Tiered_Medical_Rx_Benefits__c));
        writeXMLElement('TieredNetworkProduct',String.valueOf(record.Tiered_Network_Product__c));
        writeXMLElement('PreferredRetailNetforMedicalAccumulations',String.valueOf(record.Preferred_Retail_Net_For_Medical_Accumu__c));
        /*writeXMLElement('Pharmacy1_NCPCP',String.valueOf(record.Pharmacy_1_NCPDP__c));
        writeXMLElement('Pharmacy1_NPI',String.valueOf(record.Pharmacy_1_NPI__c));
        writeXMLElement('Pharmacy1_Name',String.valueOf(record.Pharmacy_1_Name__c));
        writeXMLElement('Pharmacy1_Address',String.valueOf(record.Pharmacy_1_Address__c));
        writeXMLElement('Pharmacy1_ParticipationStatus',String.valueOf(record.Pharmacy_1_Participation_Status__c));
        writeXMLElement('Pharmacy1_ContactName',String.valueOf(record.Pharmacy_1_Contact_Name__c));
        writeXMLElement('Pharmacy1_ContactEmail',String.valueOf(record.Pharmacy_1_Contact_Email__c));
        writeXMLElement('Pharmacy1_ContactPhoneNumber',String.valueOf(record.Pharmacy_1_Contact_Phone_Number__c));
        writeXMLElement('Pharmacy2_NCPDP',String.valueOf(record.Pharmacy_2_NCPDP__c));
        writeXMLElement('Pharmacy2_NPI',String.valueOf(record.Pharmacy_2_NPI__c));
        writeXMLElement('Pharmacy2_Name',String.valueOf(record.Pharmacy_2_Name__c));
        writeXMLElement('Pharmacy2_Address',String.valueOf(record.Pharmacy_2_Address__c));
        writeXMLElement('Pharmacy2_ParticipationStatus',String.valueOf(record.Pharmacy_2_Participation_Status__c));
        writeXMLElement('Pharmacy2_ContactName',String.valueOf(record.Pharmacy_2_Contact_Name__c));
        writeXMLElement('Pharmacy2_ContactEmail',String.valueOf(record.Pharmacy_2_Contact_Email__c));
        writeXMLElement('Pharmacy2_ContactPhoneNumber',String.valueOf(record.Pharmacy_2_Contact_Phone_Number__c));
        writeXMLElement('Pharmacy3_NCPDP',String.valueOf(record.Pharmacy_3_NCPDP__c));
        writeXMLElement('Pharmacy3_NPI',String.valueOf(record.Pharmacy_3_NPI__c));
        writeXMLElement('Pharmacy3_Name',String.valueOf(record.Pharmacy_3_Name__c));
        writeXMLElement('Pharmacy3_Address',String.valueOf(record.Pharmacy_3_Address__c));
        writeXMLElement('Pharmacy3_ParticipationStatus',String.valueOf(record.Pharmacy_3_Participation_Status__c));
        writeXMLElement('Pharmacy3_ContactName',String.valueOf(record.Pharmacy_3_Contact_Name__c));
        writeXMLElement('Pharmacy3_ContactEmail',String.valueOf(record.Pharmacy_3_Contact_Email__c));
        writeXMLElement('Pharmacy3_ContactPhoneNumber',String.valueOf(record.Pharmacy_3_Contact_Phone_Number__c));
        writeXMLElement('Pharmacy4_NCPDP',String.valueOf(record.Pharmacy_4_NCPDP__c));
        writeXMLElement('Pharmacy4_NPI',String.valueOf(record.Pharmacy_4_NPI__c));
        writeXMLElement('Pharmacy4_Name',String.valueOf(record.Pharmacy_4_Name__c));
        writeXMLElement('Pharmacy4_Address',String.valueOf(record.Pharmacy_4_Address__c));
        writeXMLElement('Pharmacy4_ParticipationStatus',String.valueOf(record.Pharmacy_4_Participation_Status__c));
        writeXMLElement('Pharmacy4_ContactName',String.valueOf(record.Pharmacy_4_Contact_Name__c));
        writeXMLElement('Pharmacy4_ContactEmail',String.valueOf(record.Pharmacy_4_Contact_Email__c));
        writeXMLElement('Pharmacy4_ContactPhoneNumber',String.valueOf(record.Pharmacy_4_Contact_Phone_Number__c));
        writeXMLElement('Pharmacy5_NCPDP',String.valueOf(record.Pharmacy_5_NCPDP__c));
        writeXMLElement('Pharmacy5_NPI',String.valueOf(record.Pharmacy_5_NPI__c));
        writeXMLElement('Pharmacy5_Name',String.valueOf(record.Pharmacy_5_Name__c));
        writeXMLElement('Pharmacy5_Address',String.valueOf(record.Pharmacy_5_Address__c));
        writeXMLElement('Pharmacy5_ParticipationStatus',String.valueOf(record.Pharmacy_5_Participation_Status__c));
        writeXMLElement('Pharmacy5_ContactName',String.valueOf(record.Pharmacy_5_Contact_Name__c));
        writeXMLElement('Pharmacy5_ContactEmail',String.valueOf(record.Pharmacy_5_Contact_Email__c));
        writeXMLElement('Pharmacy5_ContactPhoneNumber',String.valueOf(record.Pharmacy_5_Contact_Phone_Number__c));*/
        
        writeXMLElement('RemovalOfAccessForStandardNetworks',String.valueOf(record.Removal_of_Access_for_Standard_Networks__c));
        writeXMLElement('StandardNetworkAccessComments',String.valueOf(record.Standard_Network_Access_Comments__c));
        writeXMLElement('AdditionalComments',String.valueOf(record.Additional_Comments__c));
        
        //writeXMLElement('NetworkCoordinatorsQuestions',String.valueOf(record.Network_Coordinator_s_Questions__c));
        //writeXMLElement('ResponseToNetwork',String.valueOf(record.Response_to_Network__c));
        //writeXMLElement('InstallationCoordinatorsQuestions',String.valueOf(record.Installation_Coordinator_s_Questions__c));
        //writeXMLElement('QuestionPosedTo',String.valueOf(record.Question_Posed_To__c));
        //writeXMLElement('ResponseToInstallations',String.valueOf(record.Response_to_Installations__c));
        
        //writeXMLElement('ReworkNeededComments',String.valueOf(record.Rework_Needed_Comments__c));
        
        //Added By Rahul Nasa 06/24/2013 Request No.: 01037
        //writeXMLElement('NoBillNoPayNBNP',String.valueOf(record.No_Bill_No_Pay_NBNP__c));
        //writeXMLElement('CopayStrategy',String.valueOf(record.Copay_Strategy__c));
        //writeXMLElement('PreferredMaintenanceStrategy',String.valueOf(record.Preferred_Maintenance_Strategy__c));
        //writeXMLElement('DrugCoverageStrategy',String.valueOf(record.Drug_Coverage_Strategy__c));
        //writeXMLElement('DURStrategy',String.valueOf(record.DUR_Strategy__c));
        //writeXMLElement('PlanLetter',String.valueOf(record.Plan_Letter__c));
        writeXMLElement('HomeHostTieredMedicalRxBenefits',String.valueOf(record.Home_Host_Tiered_Medical_Rx_Benefits__c));
        writeXMLElement('TieredNetworkProduct',String.valueOf(record.Tiered_Network_Product__c));
        writeXMLElement('PreferredRetailNetForMedicalAccumu',String.valueOf(record.Preferred_Retail_Net_For_Medical_Accumu__c));
        
          for(Pricing__c c : record.Pricing__r){
            w.writeComment('Pricing Section');
            w.writeStartElement(null, 'Pricing', null);
            writeXMLElement('PricingId',String.valueOf(c.Name));
            w.writeEndElement();
        }
      
                                       
      for (Network_Pharmacy_Junction__c networkPharmacyJunctionRecord: lstNetworkPharmacyJunction ) {
                        w.writeComment('Network Pharmacy Junction Section');                  
                        w.writeStartElement(null, 'NetworkPharmacyJunction', null);
                        writeXMLElement('NetworkPharmacyJunctionID', String.valueOf(networkPharmacyJunctionRecord.Name));
                        writeXMLElement('PharmacyNumber', String.valueOf(networkPharmacyJunctionRecord.Pharmacy_Number__c));
                        writeXMLElement('NetworkPharmacyId', String.valueOf(networkPharmacyJunctionRecord.Network_Pharmacy_ID__r.Name));
                        writeXMLElement('PharmacyParticipationStatus', String.valueOf(networkPharmacyJunctionRecord.Pharmacy_Participation_Status__c));
                        //writeXMLElement('CRDID',String.valueOf(networkCopayRecord.CRD_ID__c));
                        writeXMLElement('PharmacyNCPDP', String.valueOf(networkPharmacyJunctionRecord.Pharmacy_NCPDP__c));
                        writeXMLElement('PharmacyNPI', String.valueOf(networkPharmacyJunctionRecord.Pharmacy_NPI__c));
                        writeXMLElement('PharmacyName', String.valueOf(networkPharmacyJunctionRecord.Pharmacy_Name__c));
                         w.writeEndElement();
                   
                }             
                       
      
          
                for (Network_Copay__c networkCopayRecord: lstNetworkCopay) { 
                        w.writeComment('Network Copay Section');                  
                        w.writeStartElement(null, 'NetworkCopay', null);
                        writeXMLElement('NetworkCopayID', String.valueOf(networkCopayRecord.Name));
                        writeXMLElement('RelatedNetworkPharmacyJunctionID', String.valueOf(networkCopayRecord.Related_Network_Pharmacy_Junction_ID__r.Name));
                        writeXMLElement('RelatedPharmacyName', String.valueOf(networkCopayRecord.Related_Pharmacy_Name__c));
                        writeXMLElement('CopayRecordType', String.valueOf(networkCopayRecord.Copay_Record_Type__c));
                        //writeXMLElement('CRDID',String.valueOf(networkCopayRecord.CRD_ID__c));
                        writeXMLElement('CopayTierType', String.valueOf(networkCopayRecord.Copay_Tier_Type__c));
                        writeXMLElement('Stepped', String.valueOf(networkCopayRecord.Stepped__c));
                        writeXMLElement('CopayDollarAmount', String.valueOf(networkCopayRecord.Copay_Dollar_Amount__c));
                        writeXMLElement('CopayPercent', String.valueOf(networkCopayRecord.Copay_Percent__c));
                        writeXMLElement('CopayCalculation', String.valueOf(networkCopayRecord.Copay_Calculation__c));
                        writeXMLElement('CopayMaximumDollar', String.valueOf(networkCopayRecord.Copay_Maximum_Dollar__c));
                        writeXMLElement('CopayMinimumDollar', String.valueOf(networkCopayRecord.Copay_Minimum_Dollar__c));
                      
                       
                        for (Network_Copay_Stepped__c ncSteppedRecord: lstNetworkCopayStepped) {
                            if (ncSteppedRecord.Network_Copay_ID__c == networkCopayRecord.Id) {
                            w.writeComment('Network Copay Stepped Section');
                            w.writeStartElement(null, 'NetworkCopayStepped', null);
                            writeXMLElement('NetworkCopaySteppedID', String.valueOf(ncSteppedRecord.Name));
                            writeXMLElement('NetworkCopayID', String.valueOf(ncSteppedRecord.Network_Copay_Id__r.Name));
                            writeXMLElement('NetworkCopaySteppedType', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_Type__c));
                            writeXMLElement('NetworkCopaySteppedBeginningRange', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_Beginning_Range__c));
                            writeXMLElement('NetworkCopaySteppedEndRange', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_End_Range__c));
                            writeXMLElement('NetworkCopaySteppedDollarAmount', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_Dollar_Amount__c));
                            writeXMLElement('NetworkCopaySteppedPercent', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_Percent__c));
                            //writeXMLElement('BeginningRange', String.valueOf(ncSteppedRecord.Beginning_Range__c));
                            writeXMLElement('NetworkCopaySteppedCopayCalculation', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_Copay_Calculation__c));
                            writeXMLElement('NetworkCopaySteppedMaximumDollar', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_Maximum_Dollar__c));
                            writeXMLElement('NetworkCopaySteppedMinimumDollar', String.valueOf(ncSteppedRecord.Network_Copay_Stepped_Minimum_Dollar__c));
                          
                            w.writeEndElement();
                            }

                        }
                        w.writeEndElement();
                   
                }             
        
        for (Network_Drug_Specific_Copay__c networkDrugSpecificCopayRecord: lstNetworkDrugSpecificCopay ) { 
                w.writeComment('Network Drug Specific Copay Section');                  
                        w.writeStartElement(null, 'NetworkDrugSpecificCopay', null);
                        writeXMLElement('NetworkDrugSpecificCopayID', String.valueOf(networkDrugSpecificCopayRecord.Name));
                        writeXMLElement('RelatedNetworkPharmacyJunctionID', String.valueOf(networkDrugSpecificCopayRecord.Related_Network_Pharmacy_Junction_ID__r.Name));
                        writeXMLElement('RelatedPharmacyName', String.valueOf(networkDrugSpecificCopayRecord.Related_Pharmacy_Name__c));
                        writeXMLElement('DrugSpecificCopayRecordType', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Record_Type__c));
                        //writeXMLElement('CRDID',String.valueOf(networkCopayRecord.CRD_ID__c));
                        
                        writeXMLElement('DrugSpecificCopayDrugList', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Drug_List__r.Name));
                        writeXMLElement('DrugSpecificCopayDrugGroup', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Drug_Group__r.Name));
                       // writeXMLElement('CopayTierType', String.valueOf(networkDrugSpecificCopayRecord.Copay_Tier_Type__c));
                        writeXMLElement('DrugSpecificCopayStepped', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Stepped__c));
                        writeXMLElement('DrugSpecificCopayDollarAmount', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Dollar_Amount__c));
                        writeXMLElement('DrugSpecificCopayPercent', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Percent__c));
                        writeXMLElement('DrugSpecificCopayCalculation', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Calculation__c));
                        writeXMLElement('DrugSpecificCopayMinimumDollar', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Minimum_Dollar__c));
                        writeXMLElement('Drug_Specific_Copay_Maximum_Dollar__c', String.valueOf(networkDrugSpecificCopayRecord.Drug_Specific_Copay_Maximum_Dollar__c));
                      
                       
                        for (Network_Drug_Specific_Copay_Stepped__c ndsCopaySteppedRecord: lstNetworkDrugSpecificCopayStepped) {
                            if (ndsCopaySteppedRecord.Network_Drug_Specific_Copay_ID__c == networkDrugSpecificCopayRecord.Id) {
                            w.writeComment('Network Drug Specific Copay Stepped Section');
                            w.writeStartElement(null, 'NetworkDrugSpecificCopayStepped', null);
                            writeXMLElement('NetworkDrugSpecificCopaySteppedID', String.valueOf(ndsCopaySteppedRecord.Name));
                            writeXMLElement('NetworkDrugSpecificCopayID', String.valueOf(ndsCopaySteppedRecord.Network_Drug_Specific_Copay_ID__r.Name));
                            writeXMLElement('NetworkDSCSteppedType', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_Type__c));
                            writeXMLElement('NetworkDSCSteppedBeginningRange', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_Beginning_Range__c));
                            writeXMLElement('NetworkDSCSteppedEndRange', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_End_Range__c));
                            writeXMLElement('NetworkDSCSteppedDollarAmount', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_Dollar_Amount__c));
                            writeXMLElement('NetworkDSCSteppedPercent', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_Percent__c));
                            //writeXMLElement('BeginningRange', String.valueOf(ncSteppedRecord.Beginning_Range__c));
                            writeXMLElement('NetworkDSCSteppedCopayCalculation', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_Copay_Calculation__c));
                            writeXMLElement('NetworkDSCSteppedMaximumDollar', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_Maximum_Dollar__c));
                            writeXMLElement('NetworkDSCSteppedMinimumDollar', String.valueOf(ndsCopaySteppedRecord.Network_DSC_Stepped_Minimum_Dollar__c));
                          
                            w.writeEndElement();
                            }

                        }
                        w.writeEndElement();
                   
                }
             
       
                                   
                    for (Network_Drug_Coverage__c networkDrugCoverageRecord: lstNetworkDrugCoverage ) { 
                        w.writeComment('Network Drug Coverage Section');                  
                        w.writeStartElement(null, 'NetworkDrugCoverage', null);
                        writeXMLElement('NetworkDrugCoverageID', String.valueOf(networkDrugCoverageRecord.Name));
                        writeXMLElement('RelatedNetworkPharmacyJunctionID', String.valueOf(networkDrugCoverageRecord.Related_Network_Pharmacy_Junction_ID__r.Name));
                        writeXMLElement('RelatedPharmacyName', String.valueOf(networkDrugCoverageRecord.Related_Pharmacy_Name__c));
                        writeXMLElement('RecordType', String.valueOf(networkDrugCoverageRecord.Record_Type__c));
                        //writeXMLElement('CRDID',String.valueOf(networkCopayRecord.CRD_ID__c));
                        
                        writeXMLElement('FormularyOpenClosed', String.valueOf(networkDrugCoverageRecord.Formulary_Open_Closed__c));
                        writeXMLElement('Formulary', String.valueOf(networkDrugCoverageRecord.Formulary__r.Name));
                       // writeXMLElement('CopayTierType', String.valueOf(networkDrugSpecificCopayRecord.Copay_Tier_Type__c));
                        writeXMLElement('ExceptionDrugGroup', String.valueOf(networkDrugCoverageRecord.Exception_Drug_Group__r.Name));
                        writeXMLElement('ExceptionDrugList', String.valueOf(networkDrugCoverageRecord.Exception_Drug_List__r.Name));
                        writeXMLElement('OverrideStandardRefilltooSoon', String.valueOf(networkDrugCoverageRecord.Override_Standard_Refill_too_Soon__c));
                        writeXMLElement('CustomRefilltooSoon', String.valueOf(networkDrugCoverageRecord.Custom_Refill_too_Soon__r.Name));
                         if ('retail'.equalsIgnoreCase(networkDrugCoverageRecord.RecordType.DeveloperName)) {
                        writeXMLElement('DoyouhaveSpecialty', String.valueOf(networkDrugCoverageRecord.Do_you_have_Specialty__c));
                        writeXMLElement('AetnaSpecialtyCareRx', String.valueOf(networkDrugCoverageRecord.Aetna_Specialty_Care_Rx__c));                       
                        writeXMLElement('SpecialtyDrugList', String.valueOf(networkDrugCoverageRecord.Specialty_Drug_List__r.Name));
                        writeXMLElement('ForcetoSpecialty', String.valueOf(networkDrugCoverageRecord.Force_to_Specialty__c));
                        writeXMLElement('fillsbeforeforcetospecialty', String.valueOf(networkDrugCoverageRecord.fills_before_force_to_specialty__c));
                       }
                        writeXMLElement('MinimumDaysSupplied', String.valueOf(networkDrugCoverageRecord.Minimum_Days_Supplied__c));
                        writeXMLElement('MaximumDaysSupplied', String.valueOf(networkDrugCoverageRecord.Maximum_Days_Supplied__c));
                        writeXMLElement('MinimumQuantity', String.valueOf(networkDrugCoverageRecord.Minimum_Quantity__c));
                        writeXMLElement('MaximumQuantity', String.valueOf(networkDrugCoverageRecord.Maximum_Quantity__c));
                        writeXMLElement('RulesforSupplyQuantity', String.valueOf(networkDrugCoverageRecord.Rules_for_Supply_Quantity__c));
                        writeXMLElement('DoyouhaveMandatoryGeneric', String.valueOf(networkDrugCoverageRecord.Do_you_have_Mandatory_Generic__c));
                        writeXMLElement('WhatOption', String.valueOf(networkDrugCoverageRecord.What_Option__c));
                        writeXMLElement('WhatisthePenalty', String.valueOf(networkDrugCoverageRecord.What_is_the_Penalty__c));
                        writeXMLElement('ApplyDifferenceofCost', String.valueOf(networkDrugCoverageRecord.Apply_Difference_of_Cost__c));
                        writeXMLElement('CostType', String.valueOf(networkDrugCoverageRecord.Cost_Type__c));
                        writeXMLElement('CostAmount', String.valueOf(networkDrugCoverageRecord.Cost_Amount__c));
                        writeXMLElement('MandatoryGenericCopayDiffExclusion', String.valueOf(networkDrugCoverageRecord.Mandatory_Generic_Copay_Diff_Exclusion__c));
                       
                         for (Network_DC_Drug_List_Group__c ndcDrugListGroupRecord: lstNetworkDCDrugListGroup) {
                            if (ndcDrugListGroupRecord.Network_Drug_Coverage_ID__c == networkDrugCoverageRecord.Id) {
                            w.writeComment('Network DC Drug List/Group Section');
                            w.writeStartElement(null, 'NetworkDCDrugListGroup', null);
                            writeXMLElement('NetworkDCDrugListGroupID', String.valueOf(ndcDrugListGroupRecord.Name));
                            writeXMLElement('NetworkDruCoverageID', String.valueOf(ndcDrugListGroupRecord.Network_Drug_Coverage_ID__r.Name));
                            writeXMLElement('InclusionExclusion', String.valueOf(ndcDrugListGroupRecord.Inclusion_Exclusion__c));
                            writeXMLElement('InclusionExclusionDrugClass', String.valueOf(ndcDrugListGroupRecord.Inclusion_Exclusion_Drug_Class__c));
                            writeXMLElement('NetworkDCDrugList', String.valueOf(ndcDrugListGroupRecord.Network_DC_Drug_List__r.Name));
                            writeXMLElement('NetworkDCDrugGroup', String.valueOf(ndcDrugListGroupRecord.Network_DC_Drug_Group__r.Name));
                            writeXMLElement('ApplyLimitations', String.valueOf(ndcDrugListGroupRecord.Apply_Limitations__c));
                            //writeXMLElement('BeginningRange', String.valueOf(ncSteppedRecord.Beginning_Range__c));
                            writeXMLElement('StartAge', String.valueOf(ndcDrugListGroupRecord.Start_Age__c));
                            writeXMLElement('StartAgeType', String.valueOf(ndcDrugListGroupRecord.Start_Age_Type__c));
                            writeXMLElement('EndAge', String.valueOf(ndcDrugListGroupRecord.End_Age__c));
                            writeXMLElement('EndAgeType', String.valueOf(ndcDrugListGroupRecord.End_Age_Type__c));
                            writeXMLElement('Gender', String.valueOf(ndcDrugListGroupRecord.Gender__c));
                            writeXMLElement('MinimumDays', String.valueOf(ndcDrugListGroupRecord.Minimum_Days__c));
                            writeXMLElement('MaximumDays', String.valueOf(ndcDrugListGroupRecord.Maximum_Days__c));
                            writeXMLElement('MinimumQuantity', String.valueOf(ndcDrugListGroupRecord.Minimum_Quantity__c));
                            writeXMLElement('MaximumQuantity', String.valueOf(ndcDrugListGroupRecord.Maximum_Quantity__c));
                            writeXMLElement('DayQuantityRule', String.valueOf(ndcDrugListGroupRecord.Day_Quantity_Rule__c));
                            writeXMLElement('MaximumFill', String.valueOf(ndcDrugListGroupRecord.Maximum_Fill__c));
                            writeXMLElement('MaximumDaysPerFill', String.valueOf(ndcDrugListGroupRecord.Maximum_Days_Per_Fill__c));
                            writeXMLElement('MaximumQuantityPerFill', String.valueOf(ndcDrugListGroupRecord.Maximum_Quantity_Per_Fill__c));
                            writeXMLElement('MaximumDollars', String.valueOf(ndcDrugListGroupRecord.Maximum_Dollars__c));
                            writeXMLElement('DailyDose', String.valueOf(ndcDrugListGroupRecord.Daily_Dose__c));
                            writeXMLElement('DaysOverTimeofDays', String.valueOf(ndcDrugListGroupRecord.Days_Over_Time_of_Days__c));
                            writeXMLElement('DaysOverTimeTimeValue', String.valueOf(ndcDrugListGroupRecord.Days_Over_Time_Time_Value__c));
                            writeXMLElement('DaysOverTimeTimePeriod', String.valueOf(ndcDrugListGroupRecord.Days_Over_Time_Time_Period__c));
                            writeXMLElement('QuantityOverTimeQuantity', String.valueOf(ndcDrugListGroupRecord.Quantity_Over_Time_Quantity__c));
                            writeXMLElement('QuantityOverTimeTimeValue', String.valueOf(ndcDrugListGroupRecord.Quantity_Over_Time_Time_Value__c));
                            writeXMLElement('QuantityOverTimeTimePeriod', String.valueOf(ndcDrugListGroupRecord.Quantity_Over_Time_Time_Period__c));
                         
                            w.writeEndElement();
                            }

                        }
                        w.writeEndElement();
                   
                }   


        
                 
                    
                       for (Network_Accumulation__c networkaccumulationRecord: lstNetworkAccumulation ) { 
                        w.writeComment('Network Accumulation Section');                  
                        w.writeStartElement(null, 'NetworkAccumulation', null);
                        writeXMLElement('NetworkAccumulationID', String.valueOf(networkaccumulationRecord.Name));
                        writeXMLElement('RelatedNetworkPharmacyJunctionID', String.valueOf(networkaccumulationRecord.Related_Network_Pharmacy_Junction_ID__r.Name));
                        writeXMLElement('RelatedPharmacyName', String.valueOf(networkaccumulationRecord.Related_Pharmacy_Name__c));
                        writeXMLElement('AccumulationRecordType', String.valueOf(networkaccumulationRecord.Accumulation_Record_Type__c));
                      
                        
                        writeXMLElement('WhatistheDeductibleAmount', String.valueOf(networkaccumulationRecord.What_is_the_Deductible_Amount__c));
                        writeXMLElement('WhatistheDeductiblePeriod', String.valueOf(networkaccumulationRecord.What_is_the_Deductible_Period__c));               
                        writeXMLElement('Accumscarryoverfromthe4thQuarter', String.valueOf(networkaccumulationRecord.Accums_carry_over_from_the_4th_Quarter__c));
                        writeXMLElement('DEDExcludeInNetwork', String.valueOf(networkaccumulationRecord.DED_Exclude_In_Network__c));
                        writeXMLElement('DEDExcludeOutofNetwork', String.valueOf(networkaccumulationRecord.DED_Exclude_Out_of_Network__c));
                        writeXMLElement('DEDExcludeGenericDrugs', String.valueOf(networkaccumulationRecord.DED_Exclude_Generic_Drugs__c));
                        
                        writeXMLElement('DEDExcludeBrandDrugswGenerics', String.valueOf(networkaccumulationRecord.DED_Exclude_Brand_Drugs_w_Generics__c));
                        writeXMLElement('DEDExcludeBrandDrugswnoGenerics', String.valueOf(networkaccumulationRecord.DED_Exclude_Brand_Drugs_w_no_Generics__c));
                        writeXMLElement('DEDExcludeMaintenanceDrugs ', String.valueOf(networkaccumulationRecord.DED_Exclude_Maintenance_Drugs__c ));
                      
                       
                         for (Network_Accumulation_Specific_Drug__c  nasDrugRecord: lstNetworkAccumulationSpecificDrug ) {
                            if (nasDrugRecord.Network_Accumulation_ID__c == networkaccumulationRecord.Id) {
                            w.writeComment('Network Accumulation Specific Drug Section');
                            w.writeStartElement(null, 'NetworkAccumulationSpecificDrug', null);
                            writeXMLElement('NetworkAccumulationSpecificDrugID', String.valueOf(nasDrugRecord.Name));
                            writeXMLElement('RelatedNetworkAccumulationId', String.valueOf(nasDrugRecord.Network_Accumulation_ID__r.Name));
                            writeXMLElement('NetworkASDDrugGroup', String.valueOf(nasDrugRecord.Network_ASD_Drug_Group__r.Name));
                            writeXMLElement('NetworkASDDrugList', String.valueOf(nasDrugRecord.Network_ASD_Drug_List__r.Name));
                            writeXMLElement('WhatistheDeductibleAmount', String.valueOf(nasDrugRecord.What_is_the_Deductible_Amount__c));
                            writeXMLElement('WhatistheDeductiblePeriod', String.valueOf(nasDrugRecord.What_is_the_Deductible_Period__c));
                            writeXMLElement('Accumscarryoverfromthe4thQuarter', String.valueOf(nasDrugRecord.Accums_carry_over_from_the_4th_Quarter__c));
                          
                         
                            w.writeEndElement();
                            }

                        }
                        w.writeEndElement();
                   
                }                    
                for (Network_Test_Scenario__c nTestScenerioRecord: lstNetworkTestScenerio ) {
                           
                            w.writeComment('Network Test Scenerio Section');
                            w.writeStartElement(null, 'NetworkTestingScenerio', null);
                            writeXMLElement('NetworkTestScenarioID', String.valueOf(nTestScenerioRecord.Name));
                            writeXMLElement('DrugtoTest', String.valueOf(nTestScenerioRecord.Drug_to_Test__c));
                            writeXMLElement('Tier', String.valueOf(nTestScenerioRecord.Tier__c));
                            writeXMLElement('TierRecordType', String.valueOf(nTestScenerioRecord.Tier_Record_Type__c));
                            writeXMLElement('DaySupply', String.valueOf(nTestScenerioRecord.Day_Supply__c));
                            writeXMLElement('Quantity', String.valueOf(nTestScenerioRecord.Quantity__c));
                            writeXMLElement('StandardCopayType', String.valueOf(nTestScenerioRecord.Standard_Copay_Type__c));
                            //writeXMLElement('BeginningRange', String.valueOf(ncSteppedRecord.Beginning_Range__c));
                            writeXMLElement('StandardCopay', String.valueOf(nTestScenerioRecord.Standard_Copay__c));
                            writeXMLElement('CustomCopayType', String.valueOf(nTestScenerioRecord.Custom_Copay_Type__c));
                            writeXMLElement('CustomCopay', String.valueOf(nTestScenerioRecord.Custom_Copay__c));
                            writeXMLElement('AdditionalTestingInformation', String.valueOf(nTestScenerioRecord.Additional_Testing_Information__c));
                        
                          
                            w.writeEndElement();
                            

                        }
                       
        
        w.writeEndElement(); 
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();
        
        
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.CRD_GMF_Case_Status__c='Submitted';
        c.CRD_GMF_Case_Types__c='New GMF';
        c.CRD_GMF_Network__c=true;
        c.Is_there_a_PG_associated_with_GMF__c=false;
        c.Subject='New Custom Rx Network Request'+' '+String.valueOf(record.Name);
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=record.Effective_Date_of_Benefit_Plan__c;
        c.AccountId=record.Account_Name__c;
        
        insert c;
        
        Blob xmlblob = Blob.valueof(xmlOutput);
        Attachment xmlAttach = new Attachment();
        xmlAttach.body = xmlblob;
        xmlAttach.Name = record.Name+' '+system.now()+'.xml';
        xmlAttach.parentId = c.Id;
        xmlAttach.contentType = 'XML';
        insert xmlAttach;

         String urlStr = '/'+String.valueOf(c.Id);
        PageReference MyObjectPR = new 
        PageReference(urlStr);
    /*
       
        //updating the CRD Status
        //record.Status__c = 'XML & Case Generated. CRD Complete.';
        //updating the record for custom history tracking.
        record.LastSent__c = system.Now();
        record.XMLDate_Time_Stamp__c = system.now();
        update record;
*/
        record.Date_Sent_to_Network__c=system.today();
        update record;
        
        return MyObjectPR;
        
     
        
      
    }
     private void writeXMLElement(String elementName, String elementValue) {
        w.writeStartElement(null, elementName, null);
        if (elementValue != NULL) {
            w.writeCharacters(elementValue);
        } else {
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
        a.Name = 'account';
        insert a;
        
        CRD__c testCrd=new CRD__c();        
        insert testCrd;
        
        Custom_Rx_Network__c r = new Custom_Rx_Network__c();
        r.Summary_of_Request_Intent__c = 'test';
        r.Account_Name__c = a.Id;
        r.Effective_Date_of_Benefit_Plan__c = system.today();
        r.Custom_MOD_at_ARxHD__c = 'No';
        r.Custom_Benefits_at_ASRx__c = 'No';
        r.Custom_Rates_at_Retail__c = 'No';
        r.Custom_Retail__c = 'No';
        r.Control_Group_Number__c = '123456';
        r.Split_Funded__c = true;
        insert r;
        
        Pricing__c p = new Pricing__c();
        p.Additional_Custom_Network_ID__c = r.Id;
        p.CRD__c = testCrd.id;
        insert p;
        
       
                        
        Network_Pharmacy__c np=new Network_Pharmacy__c();
        np.Pharmacy_Name__c='Test Pharmacy';
        
        insert np;
        
        
        //AggregateResult[] groupedResults=[Select Max(Pharmacy_Number__c) pharmacyNumber from Network_Pharmacy_Junction__c];
        //Object pharmacyNumber = groupedResults[0].get('pharmacyNumber');         
        Network_Pharmacy_Junction__c npj=new Network_Pharmacy_Junction__c();
        npj.Custom_Rx_Network_ID__c=r.Id;
        npj.Network_Pharmacy_ID__c=np.Id;
        //npj.Pharmacy_Number__c=Integer.valueOf(pharmacyNumber)+1;
        npj.Pharmacy_Number__c=1;
        insert npj;
        
        Network_Drug_Specific_Copay__c ndsc = new Network_Drug_Specific_Copay__c();
        ndsc.Custom_Rx_Network_ID__c=r.Id;
        ndsc.Related_Network_Pharmacy_Junction_ID__c=npj.Id;
        ndsc.Drug_Specific_Copay_Dollar_Amount__c=20;
        //ndsc.Drug_Specific_Copay_Percent__c=15;
        
        insert ndsc;
        
        Network_Drug_Specific_Copay_Stepped__c ndscs =new Network_Drug_Specific_Copay_Stepped__c();
        ndscs.Network_Drug_Specific_Copay_ID__c =ndsc.Id;
        ndscs.Network_DSC_Stepped_Beginning_Range__c=10;
        ndscs.Network_DSC_Stepped_Percent__c=20;
        
        insert ndscs;
        
        Network_Copay__c nc=new Network_Copay__c();
        nc.Custom_Rx_Network_ID__c=r.Id;
        nc.Copay_Maximum_Dollar__c=20;
        nc.Copay_Minimum_Dollar__c=10;
        nc.Related_Network_Pharmacy_Junction_ID__c=npj.Id;
        nc.Copay_Dollar_Amount__c=20;
        insert nc;
        
        Network_Copay_Stepped__c ncs=new Network_Copay_Stepped__c();
        ncs.Network_Copay_ID__c=nc.Id;
        ncs.Network_Copay_Stepped_Maximum_Dollar__c=20;
        ncs.Network_Copay_Stepped_Dollar_Amount__c=20;
        insert ncs; 
                                    
         Network_Accumulation__c na=new Network_Accumulation__c();
         na.Custom_Rx_Network_ID__c=r.Id;
         na.Related_Network_Pharmacy_Junction_ID__c=npj.Id;
         na.What_is_the_Deductible_Amount__c=20;
         
         insert na;
         
         Network_Accumulation_Specific_Drug__c nasd=new Network_Accumulation_Specific_Drug__c();
         nasd.Network_Accumulation_ID__c=na.Id;
         nasd.What_is_the_Deductible_Amount__c=20;
         insert nasd;
         
         map<string,Id> mapRecordType=new map<string,Id>();
         List<RecordType> lstRecordType=[SELECT DeveloperName,Id FROM RecordType where SobjectType='Network_Drug_Coverage__c' ];
         if(lstRecordType !=null && lstRecordType.size()>0)
         {
            for(RecordType objRecordType:lstRecordType)
            {
                mapRecordType.put(objRecordType.DeveloperName,objRecordType.Id);
            }
            
         } 
         Network_Drug_Coverage__c ndc=new Network_Drug_Coverage__c();
         ndc.Custom_Rx_Network_ID__c=r.Id;
         ndc.RecordTypeId =mapRecordType.get('Mail');
         ndc.Maximum_Days_Supplied__c=20;
         ndc.Related_Network_Pharmacy_Junction_ID__c=npj.Id;
         
         insert ndc;    
         
         Network_Drug_Coverage__c ndcRetail=new Network_Drug_Coverage__c();
         ndcRetail.Custom_Rx_Network_ID__c=r.Id;
         ndcRetail.RecordTypeId =mapRecordType.get('Retail');
         ndcRetail.Maximum_Days_Supplied__c=20;
         ndcRetail.Related_Network_Pharmacy_Junction_ID__c=npj.Id;
         
         insert ndcRetail;      
         
         Network_DC_Drug_List_Group__c ndcdlg=new Network_DC_Drug_List_Group__c();
         ndcdlg.Network_Drug_Coverage_ID__c=ndcRetail.Id;
         ndcdlg.Minimum_Days__c=3;
         
         insert ndcdlg;
                     
        ApexPages.StandardController rsc = new ApexPages.StandardController(r);
        GMF_XML_CustomRxNetwork_controller rc = new GMF_XML_CustomRxNetwork_controller(rsc);
        rc.generateXML();
    }
    
}