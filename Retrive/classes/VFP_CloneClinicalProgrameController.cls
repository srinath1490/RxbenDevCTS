/*Purpose: Apex Class for Cloning the  Clinical Programs                                       
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 02/21/2012       Apex Class for Cloning the Clinical Programs
   1.1 -    Abhishek goel         01/28/2015                 #5471 Removed field CVS_Caremark_Stellant_ID__c
======================================================================== */
/**
     *Method :- VFP_CloneClinicalProgrameController
     *Description :- Apex Class for Cloning the  Clinical Programs
**/ 
public class VFP_CloneClinicalProgrameController {
    
    public Clinical_Program__c originalClinical{get;set;}
    public string clinicalProgramId; 
    List<Clinical_Program_Criteria__c> criteriaList = new List<Clinical_Program_Criteria__c>(); 
    Clinical_Program__c cloneClinical;
/**
     *Method :- VFP_CloneClinicalProgrameController
     *Description :- Constructor for Cloning the  Clinical Programs
**/   
    public VFP_CloneClinicalProgrameController(ApexPages.StandardController controller) {
        this.originalClinical = (Clinical_Program__c)controller.getRecord();
        clinicalProgramId = originalClinical.Id;
        //Hix field added as per Request 01100, By Rahul Nasa
        originalClinical=[Select c.Therapeutic_Overlap_Allowed__c, c.Therapeutic_Overlap_Allowed_Days__c, c.State__c, c.Standard__c,
                       c.Slow_Consumption_Assumption__c, c.Severity_None_Same_Pharmacy__c, c.Severity_None_Priority__c,
                       c.Severity_None_Other_Pharmacy__c, c.Severity_Moderate_Same_Pharmacy__c, c.Severity_Moderate_Priority__c, 
                       c.Severity_Moderate_Other_Pharmacy__c, c.Severity_Minor_Same_Pharmacy__c, c.Severity_Minor_Priority__c,
                       c.Severity_Minor_Other_Pharmacy__c, c.Severity_Major_Same_Pharmacy__c, c.Severity_Major_Priority__c, c.Severity_Major_Other_Pharmacy__c,
                       c.Segment__c, c.RxCheck_Termination_Date__c, c.RxCheck_Effective_Date__c, c.RecordTypeName__c, c.RecordTypeId, c.Platform__c,
                       c.Pediatric_dosage_not_available__c, c.PSP_Expiration_Date__c, c.PSP_Effective_Date__c, c.PPS_Code_Name_HD__c, c.PPS_Code_Name_DT__c, 
                       c.PPS_Code_Name_DD__c, c.PPS_Code_Name_DDI__c, c.PPS_Code_Name_DA__c, c.POS_Dose_Quantity_Limit__c, c.POS_Dose_Override_Drug_List__c,
                       c.POS_Dose_Override_Drug_Group__c, c.SAC_Campaign_ID__c,c.Letter_Description__c,/*c.CVS_Caremark_Stellant_ID__c, */c.OwnerId, c.Override_Options__c, c.Onset__c, c.Name, c.Minimum_Days_for_Inclusion__c,
                       c.Maximum_days_below_fill_for_life_of_Rx__c, c.Maximum_Conflicts_per_Prescription__c, c.Max_Dose_per_Day__c, c.Mark_for_Deletion__c,
                       c.Letter_Id__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Inferred_Disease_Priority__c, c.Inferred_Disease_Response__c, 
                       c.Inferred_Disease_Contradiction_Level__c, c.Indication_Level__c, c.Include_Maintenance_Drugs__c, c.Inactive__c, c.Id, c.History_Window__c, 
                       c.History_Check_Days__c, c.Historical_Days_Extension__c, c.Geriatrics_dosage_info_not_available__c, c.Gender_Priority__c,  c.Gender_Response__c,
                       c.Gender_Contraindication__c, c.Funding__c, c.Expiration_Date__c, c.Effective_Date__c, c.Duration_of_therapy__c, 
                       c.Duplicate_Rx_Therapy_Same_Pharmacy__c, c.Duplicate_Therapy_Priority__c, c.Duplicate_Rx_Therapy_Other_Pharmacy__c, 
                       c.Duplicate_Exact_GPI_Same_Pharmacy__c, c.Duplicate_Exact_GPI_Priority__c, c.Duplicate_Exact_GPI_Other_Pharmacy__c, c.Drug_Regimen_Priority__c,
                       c.Drug_Regimen_Response__c, c.Drug_Age_Priority__c, c.Drug_Age_Response__c,  c.Drug_Age_Contraindication_Level__c, c.Dosing_Priority__c, 
                       c.Dosing_Response__c, c.Dosage_info_not_available__c, c.Dosage_Thresholds__c, c.SAC_Letter_Templates__c, c.Documentation_Level__c, c.Description__c, c.Deletion_Requestor__c, 
                       c.Deletion_Reason__c, c.Days_below_per_fill__c, c.Extend_Historical_Days_Supply__c, c.Date_Marked_for_Deletion__c, c.Controlled_Substance_Priority__c, 
                       c.Controlled_Substance_Response__c, c.Conflict_Code_Name_HD__c, c.Conflict_Code_Name_DT__c, c.Conflict_Code_Name_DD__c, c.Conflict_Code_Name_DDI__c, 
                       c.Conflict_Code_Name_DA__c, c.Conflict_Code_High_Dose__c, c.Conflict_Code_Duplicate_Therapy__c, c.Conflict_Code_Drug_to_Drug_Interaction__c, 
                       c.Conflict_Code_Drug_Disease__c, c.Conflict_Code_Drug_Age__c, c.Codes_High_Dose__c, c.Codes_Duplicate_Therapy__c, c.Codes_Drug_to_Drug_Interaction__c, 
                       c.Codes_Drug_Disease__c, c.Codes_Drug_Age__c, c.Clinical_Programs_Name__c, c.Claim_Threshold__c, c.Available_to_be_Picked__c, c.Available_Date__c, 
                       c.Adjust_Historical_Days_Supply__c, c.Account__c,c.Member_ID_Level__c,c.SBM_Sex_Code__c,c.SBM_Date_of_Birth__c,c.SBM_Person_Code__c,c.of_months_for_Copay_Waiver__c,/*c.SAC_Letter_Templates__c,*/c.Duplicate_Therapy_Response__c,
                       c.Duplicate_Therapy_Same_Pharmacy_Response__c,c.Significance_Level__c,c.Adjust_Historical_Rx_Days_Supply__c,c.Duplications_to_Report__c,c.Severity_Major_Status__c,
                       c.Severity_Minor_Status__c,c.Severity_Moderate_Status__c,c.Severity_None_Status__c,c.Severity_Major_Onset__c,c.Severity_Minor_Onset__c,c.Severity_Moderate_Onset__c,
                       c.Severity_None_Onset__c,c.Severity_Major_Documentation_Level__c,c.Severity_Minor_Documentation_Level__c,c.Severity_Moderate_Documentation_Level__c,
                       c.Severity_None_Documentation_Level__c,c.Inferred_Disease_Contraindication_Priori__c,c.Therapeutic_Overlap_Allowed_DT__c,c.of_Days_Therapeutic_Overlap_Allowed__c,
                       c.Duplicate_Rx_Therapy_Priority__c, c.CVS_Caremark_DUR_ID__c,c.Hix__c,(Select Id, OwnerId, IsDeleted, Name, RecordTypeId, Clinical_Program__c, Effective_Date__c, 
                       Termination_Date__c, Drug_Type_Code__c, Drug_Code_Value__c, MS_Code_M__c, MS_Code_N__c, MS_Code_O__c, MS_Code_Y__c, Rx__c, OTC__c, Repack__c, DESI__c, 
                       Maintenance__c, Non_Maintenance__c, Route_of_Administration__c, Alternative_Drug_List__c, Mark_for_Deletion__c, Deletion_Reason__c, 
                       Date_Marked_for_Deletion__c, Deletion_Requestor__c From Clinical_Program_Criterias__r) From Clinical_Program__c c where Id=:clinicalProgramId];
    
    cloneClinical = new Clinical_Program__c();
         cloneClinical =originalClinical.clone(false);
         criteriaList = originalClinical.Clinical_Program_Criterias__r;
    }
/**
     *Method :- redirect
     *Description :- Method to handle cloned criteria lists cloned
**/ 
    public Pagereference redirect(){
           Savepoint sp = Database.setSavepoint(); 
           List<Clinical_Program_Criteria__c> clonedCriteriaList = new List<Clinical_Program_Criteria__c>(); 
            try{
            	cloneClinical.ownerid = userinfo.getUserId();
                insert cloneClinical;
                if(criteriaList.size() >0){
                    for(Clinical_Program_Criteria__c criteria:criteriaList){
                            Clinical_Program_Criteria__c clonedCriteria = new Clinical_Program_Criteria__c();
                                clonedCriteria = criteria.clone(false);
                                clonedCriteria.Clinical_Program__c = cloneClinical.Id;
                            clonedCriteriaList.add(clonedCriteria);
                        }
                    insert clonedCriteriaList;
                } 
                Pagereference pageref= new Pagereference('/'+cloneClinical.Id+'/e?retURL='+cloneClinical.Id);
                return pageref ;    
              }catch(exception e){
                     // roll everything back in case of error
                    Database.rollback(sp);
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
                    ApexPages.addMessage(myMsg);  
                   return null; 
               }
    }
/**
     *Method :- previouspage
     *Description :- Method to redirect to previous page
**/ 
    public Pagereference previouspage(){
          Pagereference pageref= new Pagereference('/'+originalClinical.Id+'/d?retURL='+originalClinical.Id);
          return pageref;       
    }
}