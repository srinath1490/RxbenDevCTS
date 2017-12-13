/*Purpose: Apex  Class to generate the XML of DrugList and other related list and attach it with case
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Amit Jain           28th Jan 2014          Generate Follow Me Logic XML
   1.1 -    Sushant Sethi       05 Feb 2014            Added fields under Main Edits section
======================================================================== */   
public class GMF_XML_FML_Controller{
    private Follow_Me_Logic__c FMLRecord;
    private Map<String,String> FMLMap = new Map<String,String>();
    private XmlStreamWriter w = new XmlStreamWriter();
    private id parentid;
    /*
     * Constructor of class GMF_XML_FML_Controller
     */  
    public GMF_XML_FML_Controller(ApexPages.StandardController controller){
        parentid = controller.getid();
    }
    /*
     * Method :- generateXML
     * Description :- This Method transfer page to case detail page and generates XML Element
     */   
    public PageReference generateXML(){
        try{
        
        FMLRecord = [Select Account__c,Account__r.Name,owner.Name,Carrier_Number__c,Admin_Prior_Authorization_Account_Change__c,Admin_Prior_Authorization_Carrier_Change__c,
                        Admin_Prior_Authorization_Group_Change__c,All_DUR_Services_Account_Change__c,All_DUR_Services_Carrier_Change__c,All_DUR_Services_Group_Change__c,
                        Amount_Due_QvT_Account_Change__c,Amount_Due_QvT_Carrier_Change__c,Amount_Due_QvT_Group_Change__c,Carrier_Exclusion_List__c,Clinical_Prior_Auth_Account_Change__c,
                        Clinical_Prior_Auth_Carrier_Change__c,Clinical_Prior_Auth_Group_Change__c,ConnectionReceivedId,ConnectionSentId,CreatedById,CreatedDate,Cumulative_RTS_Account_Change__c,
                        Cumulative_RTS_Carrier_Change__c,Cumulative_RTS_Group_Change__c,Deductible_Family_Account_Change__c,Deductible_Family_Carrier_Change__c,Deductible_Family_Group_Change__c,
                        Deductible_Individual_Account_Change__c,Deductible_Individual_Carrier_Change__c,Deductible_Individual_Group_Change__c,Dosage_Refill_too_Soon_Account_Change__c,
                        Dosage_Refill_too_Soon_Carrier_Change__c,Dosage_Refill_too_Soon_Group_Change__c,Effective_Date__c,First_Fill_Logic_Account_Change__c,First_Fill_Logic_Carrier_Change__c,
                        First_Fill_Logic_Group_Change__c,Follow_Me_Logic_Description__c,Follow_Me_Logic_ID__c,Id,/*IsDeleted,LastModifiedById,/*LastModifiedDate,LastReferencedDate,LastViewedDate,*/
                        Life_Plan_Max_Ben_Fam_Account_Change__c,Life_Plan_Max_Ben_Fam_Carrier_Change__c,Life_Plan_Max_Ben_Fam_Group_Change__c,Life_Plan_Max_Ben_Ind_Account_Change__c,
                        Life_Plan_Max_Ben_Ind_Carrier_Change__c,Life_Plan_Max_Ben_Ind_Group_Change__c,Life_Prod_Max_Ben_Fam_Account_Change__c,Life_Prod_Max_Ben_Fam_Carrier_Change__c,
                        Life_Prod_Max_Ben_Fam_Group_Change__c,Life_Prod_Max_Ben_Ind_Account_Change__c,Life_Prod_Max_Ben_Ind_Carrier_Change__c,Life_Prod_Max_Ben_Ind_Group_Change__c,
                        Maintenance_Choice_Account_Change__c,Maintenance_Choice_Carrier_ChangeSelect__c,Maintenance_Choice_Group_Change__c,Mandatory_Mail_All_Opt_Account_Change__c,
                        Mandatory_Mail_All_Opt_Carrier_Change__c,Mandatory_Mail_All_Opt_Group_Change__c,Mandatory_Retail_Account_Change__c,Mandatory_Retail_Carrier_Change__c,
                        Mandatory_Retail_Group_Change__c,Maximum_Fills_Account_Change__c,Maximum_Fills_Carrier_Change__c,Maximum_Fills_Group_Change__c,Name,OOP_Family_Account_Change__c,
                        OOP_Family_Carrier_Change__c,OOP_Family_Group_Change__c,OOP_Individual_Account_Change__c,OOP_Individual_Carrier_Change__c,OOP_Individual_Group_Change__c,OwnerId,
                        Partial_Grandfathering_Account_Change__c,Partial_Grandfathering_Carrier_Change__c,Partial_Grandfathering_Group_Change__c,Plan_Max_Benefit_Fam_Account_Change__c,
                        Plan_Max_Benefit_Fam_Carrier_Change__c,Plan_Max_Benefit_Fam_Group_Change__c,Plan_Max_Benefit_Ind_Account_Change__c,Plan_Max_Benefit_Ind_Carrier_Change__c,
                        Plan_Max_Benefit_Ind_Group_Change__c,Plan_Refill_Too_Soon_Account_Change__c,Plan_Refill_Too_Soon_Carrier_Change__c,Plan_Refill_Too_Soon_Group_Change__c,
                        Product_Level_RTS_Account_Change__c,Product_Level_RTS_Carrier_Change__c,Product_Level_RTS_Group_Change__c,Prod_Max_Benefit_Fam_Account_Change__c,
                        Prod_Max_Benefit_Fam_Carrier_Change__c,Prod_Max_Benefit_Fam_Group_Change__c,Prod_Max_Benefit_Ind_Account_Change__c,Prod_Max_Benefit_Ind_Carrier_Change__c,
                        Prod_Max_Benefit_Ind_Group_Change__c,Qty_vs_Time_Account_Change__c,Qty_vs_Time_Carrier_Change__c,Qty_vs_Time_Group_Change__c,Qvt_vs_Time_Schedule_Account_Change__c,
                        Qvt_vs_Time_Schedule_Carrier_Change__c,Qvt_vs_Time_Schedule_Group_Change__c,Record_Type__c,Retail_Refill_Exceptions_Account_Change__c,Retail_Refill_Exceptions_Carrier_Change__c,
                        Retail_Refill_Exceptions_Group_Change__c,Step_Therapy_Account_Change__c,Step_Therapy_Carrier_Change__c,Step_Therapy_Group_Change__c,SystemModstamp,Termination_Date__c,
                        Trans_of_Cov_Comm_Account_Change__c,Trans_of_Cov_Comm_Carrier_Change__c,Trans_of_Cov_Comm_Group_Change__c,Flexible_Copay_Incentive_Account_Change__c,
                        Flexible_Copay_Incentive_Carrier_Change__c,Flexible_Copay_Incentive_Group_Change__c,PAMC_Prd_level_Daily_Dose_Account_Change__c,PAMC_Prd_level_Daily_Dose_Carrier_Chang__c,
                        PAMC_Prd_level_Daily_Dose_Group_Change__c,Max_DS_by_calendar_year_Account_Change__c,Max_DS_by_calendar_year_Carrier_Change__c,Max_DS_by_calendar_year_Group_Change__c,
                        X3_DS_R70_PA_MC_Overrd_Account_Change__c,X3_DS_R70_PA_MC_Overrd_Carrier_Change__c,X3_DS_R70_PA_MC_Overrd_Group_Change__c,DE_PA_MC_Non_MedD_Account_Change__c,
                        DE_PA_MC_Non_MedD_Carrier_Change__c,DE_PA_MC_Non_MedD_Group_Change__c,DF_PA_MC_Non_MedD_Account_Change__c,DF_PA_MC_Non_MedD_Carrier_Change__c,DF_PA_MC_Non_MedD_Group_Change__c,
                        PA_MC_for_MIC_PA_Account_Change__c,PA_MC_for_MIC_PA_Carrier_Change__c,PA_MC_for_MIC_PA_Group_Change__c,SRX_GF_over_GPI_Account_Change__c,SRX_GF_over_GPI_Carrier_Change__c,
                        SRX_GF_over_GPI_Group_Change__c,Starter_Dose_Account_Change__c,Starter_Dose_Carrier_Change__c,Starter_Dose_Group_Change__c,Grandfather_History_Fills_Account_Change__c,
                        Grandfather_History_Fills_Carrier_Change__c,Grandfather_History_Fills_Group_Change__c,TF_Var_DS_for_PAMC_72_hr_Account_Change__c,TF_Var_DS_for_PAMC_72_hr_Carrier_Change__c,
                        TF_Var_DS_for_PAMC_72_hr_Group_Change__c
                    FROM Follow_Me_Logic__c where Id =:parentid LIMIT 1];
        w.writeStartDocument(null, '1.0');
        
        w.writeComment('FollowMeLogicSection');
        w.writeStartElement(null,'FollowMeLogic', null);
        writeXMLElement('FMLXMLVersion',String.valueOf('1.6'));        
            writeXMLElement('FollowMeLogicID',String.valueOf(FMLRecord.Follow_Me_Logic_ID__c));
            writeXMLElement('FollowMeLogicName',String.valueOf(FMLRecord.Name));
            writeXMLElement('FollowMeLogicDescription',String.valueOf(FMLRecord.Follow_Me_Logic_Description__c));
            writeXMLElement('EffectiveDate',String.valueOf(FMLRecord.Effective_Date__c));
            writeXMLElement('TerminationDate',String.valueOf(FMLRecord.Termination_Date__c));
            writeXMLElement('Owner',String.valueOf(FMLRecord.Owner.Name));
            writeXMLElement('RecordType',String.valueOf(FMLRecord.Record_Type__c));
            writeXMLElement('Account',String.valueOf(FMLRecord.Account__r.Name));
            writeXMLElement('CarrierNumber',String.valueOf(FMLRecord.Carrier_Number__c));
            writeXMLElement('CarrierExclusionList',String.valueOf(FMLRecord.Carrier_Exclusion_List__c));
        
        w.writeComment('MainEditsSection');
            writeXMLElement('AllDURServices-CarrierChange',String.valueOf(FMLRecord.All_DUR_Services_Carrier_Change__c));
            writeXMLElement('AllDURServices-AccountChange',String.valueOf(FMLRecord.All_DUR_Services_Account_Change__c));
            writeXMLElement('AllDURServices-GroupChange',String.valueOf(FMLRecord.All_DUR_Services_Group_Change__c));
            writeXMLElement('StepTherapy-CarrierChange',String.valueOf(FMLRecord.Step_Therapy_Carrier_Change__c));
            writeXMLElement('StepTherapy-AccountChange',String.valueOf(FMLRecord.Step_Therapy_Account_Change__c));
            writeXMLElement('StepTherapy-GroupChange',String.valueOf(FMLRecord.Step_Therapy_Group_Change__c));
            writeXMLElement('PartialGrandfathering-CarrierChange',String.valueOf(FMLRecord.Partial_Grandfathering_Carrier_Change__c));
            writeXMLElement('PartialGrandfathering-AccountChange',String.valueOf(FMLRecord.Partial_Grandfathering_Account_Change__c));
            writeXMLElement('PartialGrandfathering-GroupChange',String.valueOf(FMLRecord.Partial_Grandfathering_Group_Change__c));
            writeXMLElement('TransofCov-Comm-CarrierChange',String.valueOf(FMLRecord.Trans_of_Cov_Comm_Carrier_Change__c));
            writeXMLElement('TransofCov-Comm-AccountChange',String.valueOf(FMLRecord.Trans_of_Cov_Comm_Account_Change__c));
            writeXMLElement('TransofCov-Comm-GroupChange',String.valueOf(FMLRecord.Trans_of_Cov_Comm_Group_Change__c));
            writeXMLElement('PlanRefillTooSoon-CarrierChange',String.valueOf(FMLRecord.Plan_Refill_Too_Soon_Carrier_Change__c));
            writeXMLElement('PlanRefillTooSoon-AccountChange',String.valueOf(FMLRecord.Plan_Refill_Too_Soon_Account_Change__c));
            writeXMLElement('PlanRefillTooSoon-GroupChange',String.valueOf(FMLRecord.Plan_Refill_Too_Soon_Group_Change__c));
            writeXMLElement('CumulativeRTS-CarrierChange',String.valueOf(FMLRecord.Cumulative_RTS_Carrier_Change__c));
            writeXMLElement('CumulativeRTS-AccountChange',String.valueOf(FMLRecord.Cumulative_RTS_Account_Change__c));
            writeXMLElement('CumulativeRTS-GroupChange',String.valueOf(FMLRecord.Cumulative_RTS_Group_Change__c));
            writeXMLElement('DosageRefilltooSoon-CarrierChange',String.valueOf(FMLRecord.Dosage_Refill_too_Soon_Carrier_Change__c));
            writeXMLElement('DosageRefilltooSoon-AccountChange',String.valueOf(FMLRecord.Dosage_Refill_too_Soon_Account_Change__c));
            writeXMLElement('DosageRefilltooSoon-GroupChange',String.valueOf(FMLRecord.Dosage_Refill_too_Soon_Group_Change__c));
            writeXMLElement('ProductLevelRTS-CarrierChange',String.valueOf(FMLRecord.Product_Level_RTS_Carrier_Change__c));
            writeXMLElement('ProductLevelRTS-AccountChange',String.valueOf(FMLRecord.Product_Level_RTS_Account_Change__c));
            writeXMLElement('ProductLevelRTS-GroupChange',String.valueOf(FMLRecord.Product_Level_RTS_Group_Change__c));
            writeXMLElement('QtyvsTime-CarrierChange',String.valueOf(FMLRecord.Qty_vs_Time_Carrier_Change__c));
            writeXMLElement('QtyvsTime-AccountChange',String.valueOf(FMLRecord.Qty_vs_Time_Account_Change__c));
            writeXMLElement('QtyvsTime-GroupChange',String.valueOf(FMLRecord.Qty_vs_Time_Group_Change__c));
            writeXMLElement('QvtvsTimeSchedule-CarrierChange',String.valueOf(FMLRecord.Qvt_vs_Time_Schedule_Carrier_Change__c));
            writeXMLElement('QvtvsTimeSchedule-AccountChange',String.valueOf(FMLRecord.Qvt_vs_Time_Schedule_Account_Change__c));
            writeXMLElement('QvtvsTimeSchedule-GroupChange',String.valueOf(FMLRecord.Qvt_vs_Time_Schedule_Group_Change__c));
            writeXMLElement('AmountDue-QvT-CarrierChange',String.valueOf(FMLRecord.Amount_Due_QvT_Carrier_Change__c));
            writeXMLElement('AmountDue-QvT-AccountChange',String.valueOf(FMLRecord.Amount_Due_QvT_Account_Change__c));
            writeXMLElement('AmountDue-QvT-GroupChange',String.valueOf(FMLRecord.Amount_Due_QvT_Group_Change__c));
            writeXMLElement('GrandfatherHistoryFills-CarrierChange',String.valueOf(FMLRecord.Grandfather_History_Fills_Carrier_Change__c));
            writeXMLElement('GrandfatherHistoryFills-AccountChange',String.valueOf(FMLRecord.Grandfather_History_Fills_Account_Change__c));
            writeXMLElement('GrandfatherHistoryFills-GroupChange',String.valueOf(FMLRecord.Grandfather_History_Fills_Group_Change__c));
            writeXMLElement('AdminPriorAuthorization-CarrierChange',String.valueOf(FMLRecord.Admin_Prior_Authorization_Carrier_Change__c));
            writeXMLElement('AdminPriorAuthorization-AccountChange',String.valueOf(FMLRecord.Admin_Prior_Authorization_Account_Change__c));
            writeXMLElement('AdminPriorAuthorization-GroupChange',String.valueOf(FMLRecord.Admin_Prior_Authorization_Group_Change__c));
            writeXMLElement('ClinicalPriorAuth-CarrierChange',String.valueOf(FMLRecord.Clinical_Prior_Auth_Carrier_Change__c));
            writeXMLElement('ClinicalPriorAuth-AccountChange',String.valueOf(FMLRecord.Clinical_Prior_Auth_Account_Change__c));
            writeXMLElement('ClinicalPriorAuth-GroupChange',String.valueOf(FMLRecord.Clinical_Prior_Auth_Group_Change__c));
            writeXMLElement('FlexibleCopayIncentive-CarrierChange',String.valueOf(FMLRecord.Flexible_Copay_Incentive_Carrier_Change__c));
            writeXMLElement('FlexibleCopayIncentive-AccountChange',String.valueOf(FMLRecord.Flexible_Copay_Incentive_Account_Change__c));
            writeXMLElement('FlexibleCopayIncentive-GroupChange',String.valueOf(FMLRecord.Flexible_Copay_Incentive_Group_Change__c));
            writeXMLElement('PAMCPrdlevelDailyDose-CarrierChange',String.valueOf(FMLRecord.PAMC_Prd_level_Daily_Dose_Carrier_Chang__c));
            writeXMLElement('PAMCPrdlevelDailyDose-AccountChange',String.valueOf(FMLRecord.PAMC_Prd_level_Daily_Dose_Account_Change__c));
            writeXMLElement('PAMCPrdlevelDailyDose-GroupChange',String.valueOf(FMLRecord.PAMC_Prd_level_Daily_Dose_Group_Change__c));
            writeXMLElement('MaxDSbycalendaryear-CarrierChange',String.valueOf(FMLRecord.Max_DS_by_calendar_year_Carrier_Change__c));
            writeXMLElement('MaxDSbycalendaryear-AccountChange',String.valueOf(FMLRecord.Max_DS_by_calendar_year_Account_Change__c));
            writeXMLElement('MaxDSbycalendaryear-GroupChange',String.valueOf(FMLRecord.Max_DS_by_calendar_year_Group_Change__c));
            writeXMLElement('PA-MCforMICPA-CarrierChange',String.valueOf(FMLRecord.PA_MC_for_MIC_PA_Carrier_Change__c));
            writeXMLElement('PA-MCforMICPA-AccountChange',String.valueOf(FMLRecord.PA_MC_for_MIC_PA_Account_Change__c));
            writeXMLElement('PA-MCforMICPA-GroupChange',String.valueOf(FMLRecord.PA_MC_for_MIC_PA_Group_Change__c));
            writeXMLElement('SRXGFoverGPI-CarrierChange',String.valueOf(FMLRecord.SRX_GF_over_GPI_Carrier_Change__c));
            writeXMLElement('SRXGFoverGPI-AccountChange',String.valueOf(FMLRecord.SRX_GF_over_GPI_Account_Change__c));
            writeXMLElement('SRXGFoverGPI-GroupChange',String.valueOf(FMLRecord.SRX_GF_over_GPI_Group_Change__c));
            writeXMLElement('StarterDose-CarrierChange',String.valueOf(FMLRecord.Starter_Dose_Carrier_Change__c));
            writeXMLElement('StarterDose-AccountChange',String.valueOf(FMLRecord.Starter_Dose_Account_Change__c));
            writeXMLElement('StarterDose-GroupChange',String.valueOf(FMLRecord.Starter_Dose_Group_Change__c));
            writeXMLElement('DFPAMC-NonMedD-CarrierChange',String.valueOf(FMLRecord.DF_PA_MC_Non_MedD_Carrier_Change__c));
            writeXMLElement('DFPAMC-NonMedD-AccountChange',String.valueOf(FMLRecord.DF_PA_MC_Non_MedD_Account_Change__c));
            writeXMLElement('DFPAMC-NonMedD-GroupChange',String.valueOf(FMLRecord.DF_PA_MC_Non_MedD_Group_Change__c));
            writeXMLElement('DEPAMC-NonMedD-CarrierChange',String.valueOf(FMLRecord.DE_PA_MC_Non_MedD_Carrier_Change__c));
            writeXMLElement('DEPAMC-NonMedD-AccountChange',String.valueOf(FMLRecord.DE_PA_MC_Non_MedD_Account_Change__c));
            writeXMLElement('DEPAMC-NonMedD-GroupChange',String.valueOf(FMLRecord.DE_PA_MC_Non_MedD_Group_Change__c));
            writeXMLElement('TF-VarDSforPAMC-72hr-CarrierChange',String.valueOf(FMLRecord.TF_Var_DS_for_PAMC_72_hr_Carrier_Change__c));
            writeXMLElement('TF-VarDSforPAMC-72hr-AccountChange',String.valueOf(FMLRecord.TF_Var_DS_for_PAMC_72_hr_Account_Change__c));
            writeXMLElement('TF-VarDSforPAMC-72hr-GroupChange',String.valueOf(FMLRecord.TF_Var_DS_for_PAMC_72_hr_Group_Change__c));
            writeXMLElement('DSR70PAMCOverrd-CarrierChange',String.valueOf(FMLRecord.X3_DS_R70_PA_MC_Overrd_Carrier_Change__c));
            writeXMLElement('DSR70PAMCOverrd-AccountChange',String.valueOf(FMLRecord.X3_DS_R70_PA_MC_Overrd_Account_Change__c));
            writeXMLElement('DSR70PAMCOverrd-GroupChange',String.valueOf(FMLRecord.X3_DS_R70_PA_MC_Overrd_Group_Change__c));
            
            
        w.writeComment('OtherEditsSection');    
            writeXMLElement('MaintenanceChoice-CarrierChange',String.valueOf(FMLRecord.Maintenance_Choice_Carrier_ChangeSelect__c));
            writeXMLElement('MaintenanceChoice-AccountChange',String.valueOf(FMLRecord.Maintenance_Choice_Account_Change__c));
            writeXMLElement('MaintenanceChoice-GroupChange',String.valueOf(FMLRecord.Maintenance_Choice_Group_Change__c));
            writeXMLElement('MandatoryMail-AllOpt-CarrierChange',String.valueOf(FMLRecord.Mandatory_Mail_All_Opt_Carrier_Change__c));
            writeXMLElement('MandatoryMail-AllOpt-AccountChange',String.valueOf(FMLRecord.Mandatory_Mail_All_Opt_Account_Change__c));
            writeXMLElement('MandatoryMail-AllOpt-GroupChange',String.valueOf(FMLRecord.Mandatory_Mail_All_Opt_Group_Change__c));
            writeXMLElement('MandatoryRetail-CarrierChange',String.valueOf(FMLRecord.Mandatory_Retail_Carrier_Change__c));
            writeXMLElement('MandatoryRetail-AccountChange',String.valueOf(FMLRecord.Mandatory_Retail_Account_Change__c));
            writeXMLElement('MandatoryRetail-GroupChange',String.valueOf(FMLRecord.Mandatory_Retail_Group_Change__c));
            writeXMLElement('FirstFillLogic-CarrierChange',String.valueOf(FMLRecord.First_Fill_Logic_Carrier_Change__c));
            writeXMLElement('FirstFillLogic-AccountChange',String.valueOf(FMLRecord.First_Fill_Logic_Account_Change__c));
            writeXMLElement('FirstFillLogic-GroupChange',String.valueOf(FMLRecord.First_Fill_Logic_Group_Change__c));
            writeXMLElement('RetailRefillExceptions-CarrierChange',String.valueOf(FMLRecord.Retail_Refill_Exceptions_Carrier_Change__c));
            writeXMLElement('RetailRefillExceptions-AccountChange',String.valueOf(FMLRecord.Retail_Refill_Exceptions_Account_Change__c));
            writeXMLElement('RetailRefillExceptions-GroupChange',String.valueOf(FMLRecord.Retail_Refill_Exceptions_Group_Change__c));
            writeXMLElement('MaximumFills-CarrierChange',String.valueOf(FMLRecord.Maximum_Fills_Carrier_Change__c));
            writeXMLElement('MaximumFills-AccountChange',String.valueOf(FMLRecord.Maximum_Fills_Account_Change__c));
            writeXMLElement('MaximumFills-GroupChange',String.valueOf(FMLRecord.Maximum_Fills_Group_Change__c));    
            
        w.writeComment('AccumulationEditsSection');     
            writeXMLElement('Deductible-Individual-CarrierChange',String.valueOf(FMLRecord.Deductible_Individual_Carrier_Change__c));
            writeXMLElement('Deductible-Individual-AccountChange',String.valueOf(FMLRecord.Deductible_Individual_Account_Change__c));
            writeXMLElement('Deductible-Individual-GroupChange',String.valueOf(FMLRecord.Deductible_Individual_Group_Change__c));
            writeXMLElement('Deductible-Family-CarrierChange',String.valueOf(FMLRecord.Deductible_Family_Carrier_Change__c));
            writeXMLElement('Deductible-Family-AccountChange',String.valueOf(FMLRecord.Deductible_Family_Account_Change__c));
            writeXMLElement('Deductible-Family-GroupChange',String.valueOf(FMLRecord.Deductible_Family_Group_Change__c));
            writeXMLElement('OOP-Individual-CarrierChange',String.valueOf(FMLRecord.OOP_Individual_Carrier_Change__c));
            writeXMLElement('OOP-Individual-AccountChange',String.valueOf(FMLRecord.OOP_Individual_Account_Change__c));
            writeXMLElement('OOP-Individual-GroupChange',String.valueOf(FMLRecord.OOP_Individual_Group_Change__c));
            writeXMLElement('OOP-Family-CarrierChange',String.valueOf(FMLRecord.OOP_Family_Carrier_Change__c));
            writeXMLElement('OOP-Family-AccountChange',String.valueOf(FMLRecord.OOP_Family_Account_Change__c));
            writeXMLElement('OOP-Family-GroupChange',String.valueOf(FMLRecord.OOP_Family_Group_Change__c));
            writeXMLElement('PlanMaxBenefit-Ind-CarrierChange',String.valueOf(FMLRecord.Plan_Max_Benefit_Ind_Carrier_Change__c));
            writeXMLElement('PlanMaxBenefit-Ind-AccountChange',String.valueOf(FMLRecord.Plan_Max_Benefit_Ind_Account_Change__c));
            writeXMLElement('PlanMaxBenefit-Ind-GroupChange',String.valueOf(FMLRecord.Plan_Max_Benefit_Ind_Group_Change__c));
            writeXMLElement('PlanMaxBenefit-Fam-CarrierChange',String.valueOf(FMLRecord.Plan_Max_Benefit_Fam_Carrier_Change__c));
            writeXMLElement('PlanMaxBenefit-Fam-AccountChange',String.valueOf(FMLRecord.Plan_Max_Benefit_Fam_Account_Change__c));
            writeXMLElement('PlanMaxBenefit-Fam-GroupChange',String.valueOf(FMLRecord.Plan_Max_Benefit_Fam_Group_Change__c));
            writeXMLElement('ProdMaxBenefit-Ind-CarrierChange',String.valueOf(FMLRecord.Prod_Max_Benefit_Ind_Carrier_Change__c));
            writeXMLElement('ProdMaxBenefit-Ind-AccountChange',String.valueOf(FMLRecord.Prod_Max_Benefit_Ind_Account_Change__c));
            writeXMLElement('ProdMaxBenefit-Ind-GroupChange',String.valueOf(FMLRecord.Prod_Max_Benefit_Ind_Group_Change__c));
            writeXMLElement('ProdMaxBenefit-Fam-CarrierChange',String.valueOf(FMLRecord.Prod_Max_Benefit_Fam_Carrier_Change__c));
            writeXMLElement('ProdMaxBenefit-Fam-AccountChange',String.valueOf(FMLRecord.Prod_Max_Benefit_Fam_Account_Change__c));
            writeXMLElement('ProdMaxBenefit-Fam-GroupChange',String.valueOf(FMLRecord.Prod_Max_Benefit_Fam_Group_Change__c));
            writeXMLElement('LifePlanMaxBen-Ind-CarrierChange',String.valueOf(FMLRecord.Life_Plan_Max_Ben_Ind_Carrier_Change__c));
            writeXMLElement('LifePlanMaxBen-Ind-AccountChange',String.valueOf(FMLRecord.Life_Plan_Max_Ben_Ind_Account_Change__c));
            writeXMLElement('LifePlanMaxBen-Ind-GroupChange',String.valueOf(FMLRecord.Life_Plan_Max_Ben_Ind_Group_Change__c));
            writeXMLElement('LifePlanMaxBen-Fam-CarrierChange',String.valueOf(FMLRecord.Life_Plan_Max_Ben_Fam_Carrier_Change__c));
            writeXMLElement('LifePlanMaxBen-Fam-AccountChange',String.valueOf(FMLRecord.Life_Plan_Max_Ben_Fam_Account_Change__c));
            writeXMLElement('LifePlanMaxBen-Fam-GroupChange',String.valueOf(FMLRecord.Life_Plan_Max_Ben_Fam_Group_Change__c));
            writeXMLElement('LifeProdMaxBen-Ind-CarrierChange',String.valueOf(FMLRecord.Life_Prod_Max_Ben_Ind_Carrier_Change__c));
            writeXMLElement('LifeProdMaxBen-Ind-AccountChange',String.valueOf(FMLRecord.Life_Prod_Max_Ben_Ind_Account_Change__c));
            writeXMLElement('LifeProdMaxBen-Ind-GroupChange',String.valueOf(FMLRecord.Life_Prod_Max_Ben_Ind_Group_Change__c));
            writeXMLElement('LifeProdMaxBen-Fam-CarrierChange',String.valueOf(FMLRecord.Life_Prod_Max_Ben_Fam_Carrier_Change__c));
            writeXMLElement('LifeProdMaxBen-Fam-AccountChange',String.valueOf(FMLRecord.Life_Prod_Max_Ben_Fam_Account_Change__c));
            writeXMLElement('LifeProdMaxBen-Fam-GroupChange',String.valueOf(FMLRecord.Life_Prod_Max_Ben_Fam_Group_Change__c));
        
        //end writing parent elements
        w.writeEndElement();
        
        //close document    
        w.writeEndDocument();
        String xmlOutput = w.getXmlString();
        w.close();    
            
        
        case c = new case();
        c.Aetna_case_type__c = 'GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Subject=String.valueOf(FMLRecord.Follow_Me_Logic_ID__c)+' '+'-'+' '+String.valueOf(FMLrecord.Name);
        database.insert (c);
        
        Blob xmlblob = blob.valueof(xmlOutput);
        Attachment xmlattach = new attachment();
        xmlAttach.body=xmlblob;
        xmlAttach.Name=String.valueOf(FMLrecord.Follow_Me_Logic_ID__c)+' '+system.now()+'.xml';
        xmlAttach.parentId=c.Id;
        xmlAttach.contentType='XML';
        database.insert (xmlAttach);
        
        String urlStr = '/'+String.valueOf(c.Id);
        PageReference MyObjectPR = new PageReference(urlStr);
        
        return MyObjectPR;
        }catch(exception e){return null;}    
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