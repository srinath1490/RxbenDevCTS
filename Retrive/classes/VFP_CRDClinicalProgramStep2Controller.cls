/**
 * Class Name: ClinicalProgramStep2Controller
 * Author: Accenture
 * Date: 28-Jul-2011
 * Requirement/Project Name: <Aetna>
 * Requirement/Project Description: <ACE2011>
 */
/*Purpose: Controller class of page VF_CRDClinicalProgStep2                                        
  ========================================================================
  History                                                            
  -------                                                            
  VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    SOURABH                7/28/2011       Controller class of page VF_CRDClinicalProgStep2
   1.1 -    ANUJ                   1/21/2012       Issue 1429 and 1430
   1.2 -    SOURABH                2/13/2013       Moved the validation to ClinicalProgramStep1Controller
   1.3 -    Rishabh                4/4/2013        removed all commented code
   1.4 -    Rahul                  6/18/2013       Requested by Ryan (If the field ‘Is DM Vendor the same for each condition’ equals ‘Yes’ then the fields 'PA Disease Vendor 1', 
                                                                      'PA Condition 1', 'PA DM Vendor Contract End Date 1', 'PA Custom Disease Vendor Phone # 1' need to have a value. 
                                                                      validation commented)
   2.0 -    Sushant                 02/25/2014      Comments Added  
   3.0 -    Richa                   07/30/204       Commented all Hypertension and Hyperlipidemia fields for Req4558                                                               
  ======================================================================== */
public with sharing class VFP_CRDClinicalProgramStep2Controller {
    Public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    public Attachment logo {
        get;
        set;
    }
    public List < Attachment > logoList {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    public boolean display {
        get;
        set;
    }
/**
* Method :- VFP_CRDClinicalProgramStep2Controller
* Description :- Method for ClinicalProgramStep2Controller Page
**/
    public VFP_CRDClinicalProgramStep2Controller(ApexPages.StandardController controller) {
        this.crd = (CRD__c) Controller.getRecord();
        errorMessages = new list < String > ();
        crdId = ApexPages.CurrentPage().getParameters().get('crdid');
        this.crd = [Select Name,PA_Disease_Vendor_1__c,PA_Condition_1__c,PA_DM_Vendor_Contract_End_Date_1__c,PA_Custom_Disease_Vendor_Phone_1__c,PA_Disease_Vendor_2__c,PA_Condition_2__c,PA_DM_Vendor_Contract_End_Date_2__c,PA_Custom_Disease_Vendor_Phone_2__c,PA_Disease_Vendor_3__c,PA_Condition_3__c,PA_DM_Vendor_Contract_End_Date_3__c,PA_Custom_Disease_Vendor_Phone_3__c,PA_Disease_Vendor_4__c,PA_Condition_4__c,PA_DM_Vendor_Contract_End_Date_4__c,PA_Custom_Disease_Vendor_Phone_4__c,PA_Disease_Vendor_5__c,PA_Condition_5__c,PA_DM_Vendor_Contract_End_Date_5__c,PA_Custom_Disease_Vendor_Phone_5__c,PA_Disease_Vendor_6__c,PA_Condition_6__c,PA_DM_Vendor_Contract_End_Date_6__c,PA_Custom_Disease_Vendor_Phone_6__c,PA_Disease_Vendor_7__c,PA_Condition_7__c,PA_DM_Vendor_Contract_End_Date_7__c,PA_Custom_Disease_Vendor_Phone_7__c,Y_Schd__c, Integrate_with_Medical__c, RxPlan_ID_Status__c,  Pharmacy_Advisor__c, Disease_Vendor__c, End_Date__c, /* Retail_to_Mail_Messaging__c,*/ Custom_call_center_phone_number__c, PSP_Letter_Templates__c, Enrolled_in_PA_for_other_condition__c, Implementation_Type__c, Participate_in_CVS_mail_pharmacy_service__c, Disease_Management_Referral_Messaging__c, Disease_Management_Messaging_for__c, Is_DM_vendor_the_same_for_each_condition__c, Co_Brand_Initial_Program_Welcome_Mailing__c, Value_Generic__c, Aetna_Healthy_Actions__c, Tier_1_Copay_Reduction__c, Tier_2_Copay_Reduction__c, Tier_3_Copay_Reduction__c, Extra_Care_Health_Card__c, Plan_Platform__c, Plan_Type_Paper__c, Insured_Type__c, Tier_5_Copay_Reduction__c, Tier_4_Copay_Reduction__c, Offering_Type__c, Tier_1_Rx_Reduction__c, Tier_2_Rx_Reduction__c, Tier_3_Rx_Reduction__c, Tier_4_Rx_Reduction__c, Tier_5_Rx_Reduction__c, Asthma_Inhaled_Steroids__c, Asthma_Anti_Inflammatory_Agents__c, Diabetes_Anti_Diabetic_Agents__c, Diabetes_Anti_Diabetic_Agent_Supplies__c, Heart_Failure_Beta_Blockers__c, /*Hyperlipidemia_Statins__c, Hyperlipidemia_Lipid_Lowering_Agents__c, Hypertension_ACE_Inhibitors_ARBs__c, Hypertension_All_Anti_Hypertensives__c,*/ ARH_Offering_Type__c, Heart_Failure_Beta_Blockers_ARH__c, /*Hyperlipidemia_Lipid_Lowering_Agents_ARH__c, Hypertension_All_Hypertension_Drugs__c,*/ Diabetes_Preventive__c, Asthma_Preventive__c, Aetna_Autofill__c, Client_Name_On_Communication__c, Custom_Disease_Vendor_2_Phone_Number__c, Disease_Vendor_2__c, Disease_Vendor_1_Implementation_Type__c, Disease_Vendor_2_Implementation_Type__c, Aetna_Rx_Healthy_Outcomes__c, Adherence_to_Drug_Therapy__c, DM_Vendor_2_Contract_End_Date__c
        From CRD__c
        Where ID = : crdId];
        logo = new Attachment();
        logoList = [Select Id, Name From Attachment where ParentId = : crdId AND Name Like 'logo%'];
        //display = true;
    }

/**
* Method :- redirectToNetwork
* Description :- Method for redirection to Network Page
**/
    Public PageReference redirectToNetwork() {
        try {
            errorMessages.clear();
            Boolean hasError = false;
            if (crd.Pharmacy_Advisor__c) {
                
                if (crd.Adherence_to_Drug_Therapy__c != TRUE || crd.Aetna_Autofill__c != TRUE ) {
                    errorMessages.add(system.Label.ERR00148);
                    hasError = true;
                }
            }
               
            if (crd.Is_DM_vendor_the_same_for_each_condition__c == 'Yes' && (crd.Implementation_Type__c == null || crd.Implementation_Type__c == '')) {
                errorMessages.add(System.Label.ERR00144);
                hasError = true;
            }
            if (crd.Disease_Management_Referral_Messaging__c != NULL && crd.Disease_Management_Referral_Messaging__c == 'Yes')
                {
                    if(crd.Disease_Management_Messaging_for__c == NULL || crd.Is_DM_vendor_the_same_for_each_condition__c == NULL )
                    {
                        errorMessages.add(system.label.ERR00190);
                        hasError = true;
                    }
                }
                
             if (crd.Pharmacy_Advisor__c != NULL && crd.Pharmacy_Advisor__c == TRUE)
                {
                 if(crd.Implementation_Type__c == NULL || crd.Enrolled_in_PA_for_other_condition__c == NULL || crd.Participate_in_CVS_mail_pharmacy_service__c == NULL || crd.Disease_Management_Referral_Messaging__c == NULL)
                 {
                     errorMessages.add(system.label.ERR00191);
                     hasError = true;
                 }
                            
                }
                
              if (crd.Is_DM_vendor_the_same_for_each_condition__c != NULL && crd.Is_DM_vendor_the_same_for_each_condition__c == 'No')
              {
                  if(crd.PA_Disease_Vendor_1__c == NULL || crd.PA_Condition_1__c == NULL || crd.PA_Custom_Disease_Vendor_Phone_1__c == NULL || crd.PA_DM_Vendor_Contract_End_Date_1__c == NULL || crd.PA_Disease_Vendor_2__c == NULL || crd.PA_Condition_2__c == NULL || crd.PA_Custom_Disease_Vendor_Phone_2__c == NULL || crd.PA_DM_Vendor_Contract_End_Date_2__c == NULL)
                  {
                      errorMessages.add(system.label.ERR00192);
                      hasError = true;
                  }
              }
              
              if(crd.Implementation_Type__c != NULL && crd.Implementation_Type__c == 'Pharmacy Advisor All Conditions Complete Buy-Up Option')
              {
               if((crd.PA_Condition_1__c != NULL && crd.PA_Condition_1__c != 'All Other Conditions') || (crd.PA_Condition_2__c != NULL && crd.PA_Condition_2__c != 'All Other Conditions') || (crd.PA_Condition_3__c != NULL && crd.PA_Condition_3__c != 'All Other Conditions') || (crd.PA_Condition_4__c != NULL && crd.PA_Condition_4__c != 'All Other Conditions') || (crd.PA_Condition_5__c != NULL && crd.PA_Condition_5__c != 'All Other Conditions') || (crd.PA_Condition_6__c != NULL && crd.PA_Condition_6__c != 'All Other Conditions') || (crd.PA_Condition_7__c != NULL && crd.PA_Condition_7__c != 'All Other Conditions'))
                    {
                        errorMessages.add(system.label.ERR00195);
                        haserror = true;
                    }
              }
              
              List<String> Condition_List = New List<String>();
              
              If(crd.PA_Condition_1__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_1__c);
                  }
              If(crd.PA_Condition_2__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_2__c);
                  }
              If(crd.PA_Condition_3__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_3__c);
                  }
              If(crd.PA_Condition_4__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_4__c);
                  }
              If(crd.PA_Condition_5__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_5__c);
                  }
              If(crd.PA_Condition_6__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_6__c);
                  }
              If(crd.PA_Condition_7__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_7__c);
                  }
                  
              integer SizeOfList = Condition_List.Size();
              
              for(integer i=0; i<SizeOfList ; i++)
                  {  for(integer j=i+1; j<SizeOfList ; j++)
                      {    system.debug('**************'+Condition_List[i]+'     '+Condition_List[j]+'**************');
                          if(Condition_List[i] == Condition_List[j])
                          {
                             errorMessages.add(system.label.ERR00194);
                             system.debug('**************'+hasError+'**************');
                             hasError = true;
                             //return null;
                          }
                      }
                  }
             


            if (hasError) return null;

            update crd;
        } catch (exception e) {
            return null;
        }
        Pagereference pageRef = new Pagereference('/apex/VF_SafetyEditPrograms?crdid=' + crdId);
        return pageRef;
    }
/**
* Method :- redirectToRXCheck
* Description :- Method for redirection to ToRXCheck
**/
    Public PageReference redirectToRXCheck() {
        try {
            errorMessages.clear();
            Boolean hasError = false;
           if (crd.Pharmacy_Advisor__c == true) {
                if (crd.Adherence_to_Drug_Therapy__c != TRUE || crd.Aetna_Autofill__c != TRUE  ) {
                    errorMessages.add(system.Label.ERR00148);
                    hasError = true;
                }
            }

            if (crd.Is_DM_vendor_the_same_for_each_condition__c == 'Yes' && (crd.Implementation_Type__c == null || crd.Implementation_Type__c == '')) {
                errorMessages.add(System.Label.ERR00144);
                hasError = true;
            } 

   
            if (crd.Disease_Management_Referral_Messaging__c != NULL && crd.Disease_Management_Referral_Messaging__c == 'Yes')
                {
                    if(crd.Disease_Management_Messaging_for__c == NULL || crd.Is_DM_vendor_the_same_for_each_condition__c == NULL )
                    {
                        errorMessages.add(system.label.ERR00190);
                        hasError = true;
                    }
                }
                
             if (crd.Pharmacy_Advisor__c != NULL && crd.Pharmacy_Advisor__c == TRUE)
                 {
                  if(crd.Implementation_Type__c == NULL || crd.Enrolled_in_PA_for_other_condition__c == NULL || crd.Participate_in_CVS_mail_pharmacy_service__c == NULL || crd.Disease_Management_Referral_Messaging__c == NULL)
                   {
                       errorMessages.add(system.label.ERR00191);
                       hasError = true;
                   }
                            
                 }
                 
             if (crd.Is_DM_vendor_the_same_for_each_condition__c != NULL && crd.Is_DM_vendor_the_same_for_each_condition__c == 'No')
              {
                if(crd.PA_Disease_Vendor_1__c == NULL || crd.PA_Condition_1__c == NULL || crd.PA_Custom_Disease_Vendor_Phone_1__c == NULL || crd.PA_DM_Vendor_Contract_End_Date_1__c == NULL || crd.PA_Disease_Vendor_2__c == NULL || crd.PA_Condition_2__c == NULL || crd.PA_Custom_Disease_Vendor_Phone_2__c == NULL || crd.PA_DM_Vendor_Contract_End_Date_2__c == NULL)
                {
                   errorMessages.add(system.label.ERR00192);
                   hasError = true;
                }
             }
            
              
              if(crd.Implementation_Type__c != NULL && crd.Implementation_Type__c == 'Pharmacy Advisor All Conditions Complete Buy-Up Option')
              {
               if((crd.PA_Condition_1__c != NULL && crd.PA_Condition_1__c != 'All Other Conditions') || (crd.PA_Condition_2__c != NULL && crd.PA_Condition_2__c != 'All Other Conditions') || (crd.PA_Condition_3__c != NULL && crd.PA_Condition_3__c != 'All Other Conditions') || (crd.PA_Condition_4__c != NULL && crd.PA_Condition_4__c != 'All Other Conditions') || (crd.PA_Condition_5__c != NULL && crd.PA_Condition_5__c != 'All Other Conditions') || (crd.PA_Condition_6__c != NULL && crd.PA_Condition_6__c != 'All Other Conditions') || (crd.PA_Condition_7__c != NULL && crd.PA_Condition_7__c != 'All Other Conditions'))
                    {
                        errorMessages.add(system.label.ERR00195);
                        haserror = true;
                    }
              }
               List<String> Condition_List = New List<String>();
              
              If(crd.PA_Condition_1__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_1__c);
                  }
              If(crd.PA_Condition_2__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_2__c);
                  }
              If(crd.PA_Condition_3__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_3__c);
                  }
              If(crd.PA_Condition_4__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_4__c);
                  }
              If(crd.PA_Condition_5__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_5__c);
                  }
              If(crd.PA_Condition_6__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_6__c);
                  }
              If(crd.PA_Condition_7__c != NULL)
                  {
                  Condition_List.add(crd.PA_Condition_7__c);
                  }
                  
              integer SizeOfList = Condition_List.Size();
              
              for(integer i=0; i<SizeOfList ; i++)
                  {  for(integer j=i+1; j<SizeOfList ; j++)
                      {    system.debug('**************'+Condition_List[i]+'     '+Condition_List[j]+'**************');
                          if(Condition_List[i] == Condition_List[j])
                          {   system.debug('**************'+hasError +'**************'); 
                             errorMessages.add(system.label.ERR00194);
                             hasError = true;
                           //  return null;
                          }
                      }
                  }
              
          
            
           
            if (hasError) return null;
            
                Pagereference pageRef = new Pagereference('/apex/VF_AetnaRxWaysToSave?crdid=' + crdId);
                update crd;
                return pageRef;

           
            /* if (crd.Plan_Platform__c != 'Aetna Student Health' && crd.Plan_Platform__c != 'Aetna Global Benefits') {
                Pagereference pageRef = new Pagereference('/apex/VF_AhaPrograms?crdid=' + crdId);
                update crd;
                return pageRef;
            } else {
               Pagereference pageRef = new Pagereference('/apex/VF_CRDRxCheckJunction?crdid=' + crdId);
                update crd;
                return pageRef; 
            }*/
        } catch (exception e) {
            return null;
        }
    }

/**
* Method :- upload
* Description :- Method for upload
**/
    Public PageReference upload() {
        if (logo != null) {
            logo.Name = 'logo_' + logo.Name;
            logo.OwnerId = UserInfo.getUserId();
            logo.ParentId = crd.id; // the record the file is attached to
            logo.IsPrivate = true;

            try {
                insert logo;
                pagereference pageRef = new Pagereference('/apex/VF_CRDClinicalProgStep2?crdid=' + crdId);
                return pageRef;
            } catch (DMLException e) {
                errorMessages.clear();
                errorMessages.add(system.Label.ERR00082);

            }

        } else {
            errorMessages.clear();
            errorMessages.add(system.Label.ERR00083);
            return null;
        }
        return null;
    }
/**
* Method :- showpanel
* Description :- Method for showpanel action function
**/
    public pagereference showpanel() {
        return null;

    }
/**
* Method :- aetnaRxAction
* Description :- action function to autocheck aetana Rx healthy outcomes field(anuj:01/21/2012)
**/    
    public void aetnaRxAction() {
        display = true;

        if (crd.ARH_Offering_Type__c == 'POST AMI') {
            display = false;
            crd.Heart_Failure_Beta_Blockers_ARH__c = false;
            //crd.Hyperlipidemia_Lipid_Lowering_Agents_ARH__c = false;
            //crd.Hypertension_All_Hypertension_Drugs__c = false;
        } else {
            display = true;
        }
    }
    
     

}