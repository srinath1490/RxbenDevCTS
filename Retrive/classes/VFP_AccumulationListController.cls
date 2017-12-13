/*Purpose: Apex Class for Accumalation Screen on CRD Wizard.                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ABHAY                  08/05/2011        Apex Class for Accumalation Screen on CRD Wizard
   2.0      rakesh                 10 Aug'12         As per req. 761
                                                     Commented 'Pays_the_DAW_difference_after_deductible' field.
                                                     Added field 'DAW_Differential_Penalty_Applies_to_MOOP'
======================================================================== */

public with sharing class VFP_AccumulationListController {
   
    public string crdId{set;get;}
    public string selectedAccumId{set;get;}
    public CRD__c crd{get;set;}
    public boolean isAccumulationSelected{get;set;}
    public Accumulations__c accumulation{get;set;}
    public list<Accumulations__c> lstAccumulation {get;set;}
    
    public VFP_AccumulationListController(ApexPages.StandardController controller) {
         lstAccumulation = new list<Accumulations__c>();
         crdId= ApexPages.CurrentPage().getParameters().get('crdid');
         if(crdId!=null){ 
             lstAccumulation =[Select Id, OwnerId, IsDeleted, Name, RecordTypeId,RecordType.Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, CRD_ID__c, Carry_Balance_when_member_moves__c, Deductible_Amount__c,  Deductible_Applies_towards_the_MOOP__c, Deductible_Period__c,MAB_Dedictible_Amount__c, MAB_Period__c, MOOP_Dedictible_Amount__c, MOOP_Period__c, What_happens_when_the_MAB_is_met__c, Family_Members_to_meet_Family_Deduct__c, DAW_Differential_Penalty_Applies_to_MOOP__c, /*Pays_the_DAW_difference_after_deductible__c,*/ Start_Month__c,Deuductible_Accumulation_from_4th_Qtr__c,Are_there_any_drug_specific_deductibles__c, Are_there_any_drug_specific_MAB__c, Are_there_any_drug_specifc_MOOP__c,Noof_Family_Members_to_Meet_Family_MOOP__c From Accumulations__c where CRD_ID__c=:crdId];
         }
    }
 
   public String showDetail(){
   if(selectedAccumId!=null){
       isAccumulationSelected=true;
   }
   return null;  
   }
}