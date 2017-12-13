/*Purpose: Apex Class for Cloning the Drug List                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 02/16/2012       Apex Class for Cloning the Drug List
   1.1 -    Sourabh              05/01/2012       Request # 105
   2.0      Sushant              02/25/2014       comments added.
   2.1      Nitish               06/27/2014       Request No 4923
   2.2      Richa                08/12/2014       Request No 5338 - 5 new fields added
   2.3      Richa                10/03/2015       Req 5600 - 5 new field added to DLC object
   2.4      Joognu                06/12/2015        Implemented request 05845
   3.0      Amit                 8th July2015     Separated the DLC Child query from parent query for Support Ticket 216
   3.1      Nitish               09/11/2015       Request No 06007
   3.2      Sushant              09/11/2015       Request No 06008
   3.3      Bhaskar              08/03/2016       Request No 06587
======================================================================== */
public class VFP_CloneDrugListController{
    Public Drug_List__c originalDrugList{get;set;}
    Drug_List__c cloneDrugList;
    List<Drug_List_Criteria__c> listOfCriteria =new list<Drug_List_Criteria__c>();
    set<Id> criteriaId = new set<Id>();
    set<Id> steptherapyId = new set<Id>();
    public string drugListId{get;set;}
    List<Denial_Letter_Junction__c>  denialLetter = new List<Denial_Letter_Junction__c>();
    List<Step_Therapy_PreRequisite_Drug__c> stepTherapyList = new List<Step_Therapy_PreRequisite_Drug__c>();
    List<Step_Therapy_PreRequisite_Drug__c> childstepTherpyList = new List<Step_Therapy_PreRequisite_Drug__c>();
    List<Stepped_Over_Time__c> overTimeList = new List<Stepped_Over_Time__c>();
    List<Restricted_NDC_List__c> RestrictNDCList = new List<Restricted_NDC_List__c>();
    List<Restricted_NDC_List__c> RestrictNDCListStep = new List<Restricted_NDC_List__c>();
    List<Drug_List__c> drugList = new List<Drug_List__c>();
/**
* Method :- VFP_CloneDrugListController
* Description :- Method for cloning the Drug List
**/
   
 public VFP_CloneDrugListController(ApexPages.StandardController controller) {
        this.originalDrugList = (Drug_List__c)controller.getRecord();
        listOfCriteria= new List<Drug_List_Criteria__c>();
        drugListId = originalDrugList.Id;
        //Hix Field Added , Request No. 01100 , By Rahul Nasa
        
        originalDrugList = [Select d.Termination_Date__c, d.State__c, d.Standard__c, d.Special_Use__c, d.Segment__c, d.RecordType_Name__c, d.RecordTypeId, 
                              d.Platform__c, d.Name, d.Mark_for_Deletion__c, d.Inactive__c, d.Funding__c, d.Effective_Date__c, d.Drug_List_Name__c, d.Description__c,
                              d.Deletion_Requestor__c, d.Deletion_Reason__c, d.Date_Marked_for_Deletion__c, d.Account__c,d.Clinical_Edit_Code__c,d.Clinical_Edit_Code_Description__c,
                              /*(Select Id, Name, RecordTypeId, CreatedDate,
                              Drug_List__c, Force_to_Specialty__c, Sequence__c, Start_Age_Type__c, End_Age_Type__c, Drug_Type_Code__c, Drug_Code_Value__c, MS_Code_M__c, MS_Code_N__c,
                              MS_Code_O__c, MS_Code_Y__c, Rx__c, OTC__c, Repack__c, DESI__c, Maintenance__c, Non_Maintenance__c, Route__c, Term__c, Effective__c, Description__c, 
                              Drug_List_Name__c, Clinical_Edit_Option_Code__c, Prescriber_Name__c, Prescriber_Description__c, Specialty_Name__c, Start_Age__c, End_Age__c, Gender__c, 
                              Maximum_Days__c, Maximum_Quantity__c, Maximum_Dollars__c, Maximum_Fills__c, Specialty_Description__c, Lab_Tests_Name__c, Rule__c, 
                              Prescriber__c, Speciality__c, Lab_Tests__c, Diagnosis__c, Grandfathering__c, Message__c,Member_Message__C, Minimum_Days__c, Minimum_Quantity__c, Transition_of_Care__c, 
                              Drug_List_Criteria_Description__c, RecordTypeName__c, Status__c, Per__c, Unit_Cost__c, Lab_Test_Description__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                              Required__c, Number_of_pre_requisites__c, Notes__c, Bypass_days__c, Non_Compliance__c, Daily_Dose__c, Days_over_Time_of_Days__c, Days_over_Time_Time_Period__c, 
                              Days_over_Time_Time_Value__c, Quantity_over_Time_Quantity__c, Quantity_over_Time_Time_Period__c, Quantity_over_Time_Time_Value__c, Max_Days_per_Fill__c, 
                              Max_Quantity_per_Fill__c, Provider__c, Provider_Name__c, Provider_Descriptoin__c, X100_Copay__c, Funding__c, NDC__c, Description_of_NDC_Drug_List_Criteria__c, 
                              Mark_for_Deletion__c, Deletion_Reason__c, Date_Marked_for_Deletion__c, Deletion_Requestor__c, Message_Form__c, Message_Text__c,Zero_Copay__c,Excluded_from_Deductible__c,DAW_Code__c,
                              Clinical_Edit_Code_Description__c, By_pass_Aetna_Health_Fund__c,Allow_Transition_Fill__c,TOC_applies__c,Should_count_towards_meeting_ST_Protocol__c,Edit_Code__c,Alt_Drug_Message_1__c,Alt_Drug_Message_2__c
                              ,Alt_Drug_Message_3__c,Alt_Drug_Message_4__c,Maximum_Fills_Over_Time_Time_Period__c,Start_Date__c,Maxiumum_Fills_Over_Time_Time_Value__c From Drug_List_Search__r) ,*/
                              d.Allowable_Actions__c,Hix__c, Aetna_Internal_Notes__c ,GMF_Group_Identifier__c  From Drug_List__c d where Id =: drugListId limit 1];  
          //Added By Amit for Ticket 216                            
          for(Drug_List_Criteria__c dlcRecord: [Select Id, Name, RecordTypeId, CreatedDate,
                              Drug_List__c, Force_to_Specialty__c, Sequence__c, Start_Age_Type__c, End_Age_Type__c, Drug_Type_Code__c, Drug_Code_Value__c, MS_Code_M__c, MS_Code_N__c,
                              MS_Code_O__c, MS_Code_Y__c, Rx__c, OTC__c, Repack__c, DESI__c, Maintenance__c, Non_Maintenance__c, Route__c, Term__c, Effective__c, Description__c, 
                              Drug_List_Name__c, Clinical_Edit_Option_Code__c, Prescriber_Name__c, Prescriber_Description__c, Specialty_Name__c, Start_Age__c, End_Age__c, Gender__c, 
                              Maximum_Days__c, Maximum_Quantity__c, Maximum_Dollars__c, Maximum_Fills__c, Specialty_Description__c, Lab_Tests_Name__c, Rule__c, 
                              Prescriber__c, Speciality__c, Lab_Tests__c, Diagnosis__c, Grandfathering__c, Message__c,Member_Message__C, Minimum_Days__c, Minimum_Quantity__c, Transition_of_Care__c, 
                              Drug_List_Criteria_Description__c, RecordTypeName__c, Status__c, Per__c, Unit_Cost__c, Lab_Test_Description__c, Diagnosis_Name__c, Diagnosis_Description__c, 
                              Required__c, Number_of_pre_requisites__c, Notes__c, Bypass_days__c, Non_Compliance__c, Daily_Dose__c, Days_over_Time_of_Days__c, Days_over_Time_Time_Period__c, 
                              Days_over_Time_Time_Value__c, Quantity_over_Time_Quantity__c, Quantity_over_Time_Time_Period__c, Quantity_over_Time_Time_Value__c, Max_Days_per_Fill__c, 
                              Max_Quantity_per_Fill__c, Provider__c, Provider_Name__c, Provider_Descriptoin__c, X100_Copay__c, Funding__c, NDC__c, Description_of_NDC_Drug_List_Criteria__c, 
                              Mark_for_Deletion__c, Deletion_Reason__c, Date_Marked_for_Deletion__c, Deletion_Requestor__c, Message_Form__c, Message_Action__c,Message_Text__c,Zero_Copay__c,Excluded_from_Deductible__c,DAW_Code__c,
                              Clinical_Edit_Code_Description__c, By_pass_Aetna_Health_Fund__c,Allow_Transition_Fill__c,TOC_applies__c,Should_count_towards_meeting_ST_Protocol__c
                              ,Edit_Code__c,Alt_Drug_Message_1__c,Alt_Drug_Message_2__c,Alt_Drug_Message_3__c,Alt_Drug_Message_4__c,Maximum_Fills_Over_Time_Time_Period__c,Start_Date__c
                              ,Maxiumum_Fills_Over_Time_Time_Value__c,Intent__c,Qualifiers__c From Drug_List_Criteria__c Where Drug_List__c  =: drugListId ]){
                                
                                listOfCriteria.add(dlcRecord);
                                criteriaId.add(dlcRecord.Id);
                              }         
        //Ends
        denialLetter=[Select d.Record_Type__c,d.OwnerId, d.Name, d.IsDeleted, d.Id, d.Form_ID__c, d.Drug_List_Name__c, d.Drug_List_Criteria__c, d.Drug_List_Criteria_ID__c, d.Denial_Letter_Name__c,
                     d.Denial_Letter_ID__c, d.Denial_Letter_Description__c From Denial_Letter_Junction__c d where d.Drug_List_Criteria_ID__c IN: criteriaId Limit 50000];

        stepTherapyList=[Select s.Termination_Date__c, s.SystemModstamp, s.Step_Therapy_Pre_Requisite_Drug_Parent__c, s.Step_Therapy_Pre_Requisite_Drug_Name__c, s.Specialty_Name__c, s.Specialty_Description__c,
                     s.Speciality__c, s.Sequence__c, s.Remaining__c, s.Related_Drug_List_Criteria__c, s.Provider__c, s.Provider_Name__c, s.Provider_Descriptoin__c, s.Prescriber__c, s.Prescriber_Name__c, 
                     s.Prescriber_Description__c, s.Parent_StepTherapy_DrugList_Criteria__c, s.OwnerId, s.Object_List__c, s.No_of_Distinct_Drugs__c, s.Name, s.NDC__c, s.Minimum_Day_Supply__c, s.Mandatory__c,
                     s.MS_Code_Y__c, s.MS_Code_O__c, s.MS_Code_N__c, s.MS_Code_M__c, s.Lookback__c, s.Lookback_Period__c, s.LastModifiedDate, s.LastModifiedById, s.Lab_Tests__c, s.Lab_Tests_Name__c,
                     s.Lab_Test_Description__c, s.IsDeleted, s.Id, s.GPI__c, s.Effective_Date__c, s.Drug_Type_Code__c, s.Drug_List_Name__c, s.Drug_Code_Value__c, s.Diagnosis_Name__c, s.Diagnosis_Description__c,
                     s.Description_of_Pre_Requisite_Drug__c, s.Days_Remaining__c,s.Modifier__c, s.Priority__c,s.Override_Primary_Edit__c,s.Smart_Edit_Type__c
             
              From Step_Therapy_PreRequisite_Drug__c s where Related_Drug_List_Criteria__c IN: criteriaId Limit 50000];

        for(Step_Therapy_PreRequisite_Drug__c idset:stepTherapyList){
                steptherapyId.add(idset.Id);
        }
        
        childstepTherpyList =[Select s.Termination_Date__c, s.SystemModstamp, s.Step_Therapy_Pre_Requisite_Drug_Parent__c, s.Step_Therapy_Pre_Requisite_Drug_Name__c, s.Specialty_Name__c, s.Specialty_Description__c,
                     s.Speciality__c, s.Sequence__c, s.Remaining__c, s.Related_Drug_List_Criteria__c, s.Provider__c, s.Provider_Name__c, s.Provider_Descriptoin__c, s.Prescriber__c, s.Prescriber_Name__c, 
                     s.Prescriber_Description__c, s.Parent_StepTherapy_DrugList_Criteria__c, s.OwnerId, s.Object_List__c, s.No_of_Distinct_Drugs__c, s.Name, s.NDC__c, s.Minimum_Day_Supply__c, s.Mandatory__c,
                     s.MS_Code_Y__c, s.MS_Code_O__c, s.MS_Code_N__c, s.MS_Code_M__c, s.Lookback__c, s.Lookback_Period__c,  s.LastModifiedDate, s.LastModifiedById, s.Lab_Tests__c, s.Lab_Tests_Name__c,
                     s.Lab_Test_Description__c, s.IsDeleted, s.Id, s.GPI__c, s.Effective_Date__c, s.Drug_Type_Code__c, s.Drug_List_Name__c, s.Drug_Code_Value__c, s.Diagnosis_Name__c, s.Diagnosis_Description__c,
                     s.Description_of_Pre_Requisite_Drug__c, s.Days_Remaining__c,s.Modifier__c, s.Priority__c From Step_Therapy_PreRequisite_Drug__c s where Step_Therapy_Pre_Requisite_Drug_Parent__c IN: steptherapyId Limit 50000];

        overTimeList =[Select s.of_Days_Supply__c, s.Time_Value__c, s.Time_Period__c, s.SystemModstamp, s.Step_Type__c, s.Related_Drug_List_Criteria__c, s.Quantity__c, s.Percent_Minimum_Use__c, s.Name, s.Id, 
                        s.End_Range__c, s.Beginning_Range__c From Stepped_Over_Time__c s where Related_Drug_List_Criteria__c =:criteriaId Limit 50000];
        RestrictNDCList = [Select Id,Effective_Date__c,key__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c,OTC__c,Related_DLC_Drug_Code_Value__c,Related_Drug_List_Criteria__c,    Restrict_NDC__c,Rx__c,Termination_Date__c From Restricted_NDC_List__c Where Related_Drug_List_Criteria__c IN:criteriaId Limit 50000];
        RestrictNDCListStep = [Select Id,Effective_Date__c,key__c,MS_Code_M__c,MS_Code_N__c,MS_Code_O__c,MS_Code_Y__c,OTC__c,Related_DLC_Drug_Code_Value__c,Related_Step_Therapy_Pre_Requisite_Drug__c,Restrict_NDC__c,Rx__c,Termination_Date__c From Restricted_NDC_List__c Where Related_Step_Therapy_Pre_Requisite_Drug__c IN:steptherapyId Limit 50000];


        cloneDrugList = new Drug_List__c(); 
        cloneDrugList =  originalDrugList.clone(false);
    }
/**
* Method :- redirect
* Description :- Method to insert cloned records
**/

    Public Pagereference redirect(){
         Savepoint sp = Database.setSavepoint(); 
         Map<Id,Drug_List_Criteria__c> EntryList = new Map<Id,Drug_List_Criteria__c>();
         Map<Id,Step_Therapy_PreRequisite_Drug__c> stepTherapyMap = new Map<Id,Step_Therapy_PreRequisite_Drug__c>();
         List<Denial_Letter_Junction__c> denialJunction = new List<Denial_Letter_Junction__c>();
         List<Step_Therapy_PreRequisite_Drug__c> stepTherapyList1 = new List<Step_Therapy_PreRequisite_Drug__c>();
         List<Stepped_Over_Time__c> cloneOverTimeList = new List<Stepped_Over_Time__c>();        
         List<Restricted_NDC_List__c> cloneRestrictedNDCList = new List<Restricted_NDC_List__c>();    
         List<Restricted_NDC_List__c> cloneRestrictedNDCListStep = new List<Restricted_NDC_List__c>();   
        try{
            insert cloneDrugList;
            if(listOfCriteria.size()>0){
                for(Drug_List_Criteria__c  entry: listOfCriteria){
                    Drug_List_Criteria__c cloneEntry = new Drug_List_Criteria__c();
                        cloneEntry = entry.clone(false);
                        cloneEntry.Drug_List__c= cloneDrugList.Id;
                    EntryList.put(entry.Id,cloneEntry);
                }
                insert EntryList.values();

            }
            if(denialLetter.size() >0){
                    for(Denial_Letter_Junction__c junction:denialLetter){
                        Denial_Letter_Junction__c cloneJunction = new Denial_Letter_Junction__c();
                        cloneJunction = junction.clone(false);
                        cloneJunction.Drug_List_Criteria_ID__c = EntryList.get(junction.Drug_List_Criteria_ID__c).Id;
                denialJunction.add(cloneJunction);
                    }
                    insert denialJunction;
                }
                if(stepTherapyList.size() >0){
                        for(Step_Therapy_PreRequisite_Drug__c therapy:stepTherapyList){
                                Step_Therapy_PreRequisite_Drug__c clonestepTherapy = new Step_Therapy_PreRequisite_Drug__c();
                                clonestepTherapy = therapy.clone(false);
                                clonestepTherapy.Related_Drug_List_Criteria__c = EntryList.get(therapy.Related_Drug_List_Criteria__c).Id;
                                stepTherapyMap.put(therapy.Id,clonestepTherapy);                        
                        }
                        insert stepTherapyMap.Values();
                }
                if(childstepTherpyList.size() >0){
                        for(Step_Therapy_PreRequisite_Drug__c therapy: childstepTherpyList){
                                Step_Therapy_PreRequisite_Drug__c clonestepTherapy = new Step_Therapy_PreRequisite_Drug__c();
                                clonestepTherapy = therapy.clone(false);
                                clonestepTherapy.Step_Therapy_Pre_Requisite_Drug_Parent__c = stepTherapyMap.get(therapy.Step_Therapy_Pre_Requisite_Drug_Parent__c).Id;
                                stepTherapyList1.add(clonestepTherapy);
                        }
                        insert stepTherapyList1;
                }
                if(overTimeList.size()>0){
                        for(Stepped_Over_Time__c overTime:overTimeList){
                            Stepped_Over_Time__c cloneOverTime = new Stepped_Over_Time__c();
                            cloneOverTime = overTime.clone(false);
                            cloneOverTime.Related_Drug_List_Criteria__c =EntryList.get(overTime.Related_Drug_List_Criteria__c).Id;
                            cloneOverTimeList.add(cloneOverTime);
                        }
                    insert cloneOverTimeList;
                }
                //Clone DLC - Restricted NDC
                if(RestrictNDCList.Size()>0){
                        
                        for(Restricted_NDC_List__c RestrictNDC : RestrictNDCList){
                            Restricted_NDC_List__c cloneRestrictedNDC = new Restricted_NDC_List__c();
                            cloneRestrictedNDC = RestrictNDC.clone(false);
                            cloneRestrictedNDC.Related_Drug_List_Criteria__c = EntryList.get(RestrictNDC.Related_Drug_List_Criteria__c).Id;
                            cloneRestrictedNDC.Effective_Date__c = RestrictNDC.Effective_Date__c;
                            cloneRestrictedNDC.MS_Code_M__c = RestrictNDC.MS_Code_M__c;
                            cloneRestrictedNDC.MS_Code_N__c = RestrictNDC.MS_Code_N__c;
                            cloneRestrictedNDC.MS_Code_O__c = RestrictNDC.MS_Code_O__c;
                            cloneRestrictedNDC.MS_Code_Y__c = RestrictNDC.MS_Code_Y__c;
                            cloneRestrictedNDC.OTC__c = RestrictNDC.OTC__c;
                            cloneRestrictedNDC.Restrict_NDC__c = RestrictNDC.Restrict_NDC__c;
                            cloneRestrictedNDC.Rx__c = RestrictNDC.Rx__c;
                            cloneRestrictedNDC.Termination_Date__c = RestrictNDC.Termination_Date__c;
                            cloneRestrictedNDC.key__c = '';
                            cloneRestrictedNDCList.add(cloneRestrictedNDC);
                            
                        }
                    insert cloneRestrictedNDCList;
                }
                
               //  Clone Step Therapy Pre - Requisite NDC
                if(RestrictNDCListStep.Size()>0){
                        
                        for(Restricted_NDC_List__c RestrictNDCStep : RestrictNDCListStep){
                            Restricted_NDC_List__c cloneRestrictedNDCStep = new Restricted_NDC_List__c();
                            cloneRestrictedNDCStep = RestrictNDCStep.clone(false);
                            cloneRestrictedNDCStep.Related_Step_Therapy_Pre_Requisite_Drug__c = stepTherapyMap.get(RestrictNDCStep.Related_Step_Therapy_Pre_Requisite_Drug__c).Id;
                            cloneRestrictedNDCStep.Effective_Date__c = RestrictNDCStep.Effective_Date__c;
                            cloneRestrictedNDCStep.MS_Code_M__c = RestrictNDCStep.MS_Code_M__c;
                            cloneRestrictedNDCStep.MS_Code_N__c = RestrictNDCStep.MS_Code_N__c;
                            cloneRestrictedNDCStep.MS_Code_O__c = RestrictNDCStep.MS_Code_O__c;
                            cloneRestrictedNDCStep.MS_Code_Y__c = RestrictNDCStep.MS_Code_Y__c;
                            cloneRestrictedNDCStep.OTC__c = RestrictNDCStep.OTC__c;
                            cloneRestrictedNDCStep.Restrict_NDC__c = RestrictNDCStep.Restrict_NDC__c;
                            cloneRestrictedNDCStep.Rx__c = RestrictNDCStep.Rx__c;
                            cloneRestrictedNDCStep.Termination_Date__c = RestrictNDCStep.Termination_Date__c;
                            cloneRestrictedNDCStep.key__c = '';
                            cloneRestrictedNDCListStep.add(cloneRestrictedNDCStep);
                            
                        }
                        
                    insert cloneRestrictedNDCListStep;
                }
        Pagereference pageref= new Pagereference('/'+cloneDrugList.Id+'/e?retURL='+cloneDrugList.Id);
           return pageref ;
        } catch(exception e){
            // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
            ApexPages.addMessage(myMsg);  
           return null;    
        }
    }
/**
* Method :- previouspage
* Description :- Method to redirect to previous page
**/
    
    Public Pagereference previouspage(){
            Pagereference pageref= new Pagereference('/'+originalDrugList.Id+'/d?retURL='+originalDrugList.Id);
           return pageref; 
    }
}