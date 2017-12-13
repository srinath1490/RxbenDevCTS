/*Purpose: Apex Class for VFP_FormularySelection Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 11/4/2011       Apex Class for VFP_FormularySelection Page.
======================================================================== 
*/
public with sharing class VFP_FormularySelectionController {
    public list<Formulary__c> lstFilteredFormulary{get;set;}
    public string crdId{get;set;}
    public string formularyOpenCloseValue{get;set;}
    public String tierCount;
    public String selectedRecordTypeName;    
    
    Public CRD__c crd{get;set;}
    list<CRD__c> lstCRD=new list<CRD__c>();
    public VFP_FormularySelectionController(ApexPages.StandardController controller) {
         crdId = ApexPages.CurrentPage().getParameters().get('crdid');
         formularyOpenCloseValue = ApexPages.CurrentPage().getParameters().get('closeOpenValue');
         selectedRecordTypeName= ApexPages.CurrentPage().getParameters().get('recordTypeName');
         
         lstCRD=[select id,Mail_Number_of_Tiers__c,Paper_Number_of_Tiers__c,Retail_Number_of_Tiers__c,Specialty_Number_of_Tiers__c from crd__c where id=:crdId];
         if(lstCRD!=null && lstCRD.size()>0){
             crd=lstCRD.get(0);
             if(selectedRecordTypeName=='Mail'){
                 tierCount = crd.Mail_Number_of_Tiers__c;
             }
             if(selectedRecordTypeName=='Retail'){
                 tierCount = crd.Retail_Number_of_Tiers__c;
             }
            if(selectedRecordTypeName=='Specialty'){
                 tierCount = crd.Specialty_Number_of_Tiers__c;
             }
            if(selectedRecordTypeName=='Paper'){
                 tierCount = crd.Paper_Number_of_Tiers__c;
             }
             
             lstFilteredFormulary=[select id,Name,Formulary_Name__c,Formulary_Description__c from Formulary__c where Option_Code_Open_Closed__c=:formularyOpenCloseValue /* and Option_Code_Number_of_Tiers__c=:tierCount */];
             system.debug('----'+lstFilteredFormulary);
             //lstFilteredFormulary=[select id,name,Formulary__r.Name from Formulary_Junction__c where Option_Code_Open_Closed__c=:formularyOpenCloseValue];
          }
    }

}