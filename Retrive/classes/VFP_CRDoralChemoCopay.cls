/*Purpose: Apex Class for VF_CRDoralChemoCopay.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Richa                 12/22/2014       Apex Class for VF_CRDoralChemoCopay. Req 4890
     1.2 -    Richa                 03/04/2015       Added the checkboxes to ClearFields method. Req 5648
     1.3      Abhishek              12/01/2016       Mofified to implement request 06802
     1.4      Sushant           21/2/2017        Applied Check for Does Chemo Parity Apply field : Request 06893
======================================================================== 
*/
public with sharing class VFP_CRDoralChemoCopay{
    public string crdId {get;set;}
    public CRD__c crd {get;set;}
    public string groupMember{get;set;}
    public String editMode{get;set;}
    public boolean noError;
    private static final string BACKBUTTON = '/apex/VF_CRDCustomerCareAttributes_Step1?id=';
    private static final string NEXTBUTTON = '/apex/VF_RetailVaccineProgramScreen?crdid=';
    private static final string EDITMODEPARAM = 'p1';
    private static final string GROUPMEMBERPARAM = 'p2';
    private static final string CRDID1 = 'crdid';
    
    /* Constructor for VFP_CRDoralChemoCopay class*/
    public VFP_CRDoralChemoCopay(ApexPages.StandardController controller){
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        //crd = (CRD__c) controller.getRecord();
        this.crd = [Select id,Does_Chemo_Parity_Apply__c,Chemo_Parity_Drug_List__c,Oral_Chemo_Cap__c,Dollar_Amount__c,Percent__c,Copay_Calculation__c,
                Chemo_Drugs_Bypass_Deductible__c,Chemo_Drugs_Bypass_MAB__c,Chemo_Drugs_Bypass_OOP__c,Chemo_Drugs_In_Network_same_as_OON__c,Insured_type__c,Plan_Type_Paper__c,Name,Y_Schd__c
                 from CRD__c where id = :crdId LIMIT 80000];
    }
/*Method: saveRecord()
  Purpose: This function will check all the validations before saving the record 
*/    
    public boolean saveRecord() {
        try{
            noError = true;
            if(crd.Does_Chemo_Parity_Apply__c != true){
               if(crd.Chemo_Parity_Drug_List__c != null || crd.Oral_Chemo_Cap__c != null || crd.Dollar_Amount__c != null ||
                   crd.Percent__c != null || crd.Copay_Calculation__c != null || crd.Chemo_Drugs_Bypass_MAB__c == true || crd.Chemo_Drugs_Bypass_OOP__c == true || crd.Chemo_Drugs_Bypass_Deductible__c == true  
                   || crd.Chemo_Drugs_In_Network_same_as_OON__c == true){
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR0288);
                       ApexPages.addMessage(myMsg); 
                       noError = false;
                   }
            }
        }catch(exception e){
            Apexpages.addMessages(e);
         }
         return noError;              
    }
/*Method: clearFields()
  Purpose: This function clears all the fields when "Clear Fields" button is clicked
*/     
    public void clearFields() {
        
       crd.Does_Chemo_Parity_Apply__c = null;
       crd.Chemo_Parity_Drug_List__c = null;
       crd.Oral_Chemo_Cap__c = null;
       crd.Dollar_Amount__c = null;
       crd.Percent__c = null;
       crd.Copay_Calculation__c = null;  
       crd.Chemo_Drugs_Bypass_MAB__c = null;
       crd.Chemo_Drugs_Bypass_OOP__c = null;
       crd.Chemo_Drugs_Bypass_Deductible__c = null;  
       crd.Chemo_Drugs_In_Network_same_as_OON__c = null;    
    }
/*Method: redirectToCRD()
  Purpose: This function will redirect the screen to CRD tab on "Back" button click 
*/     
    public PageReference redirectToCRD() {
        try{
        if(!saveRecord()){
            return null;
        } else {
                database.update(crd);
                Pagereference pageRef = new Pagereference(BACKBUTTON + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
               }    
    }catch(exception e){return null;}
    }
    
/*Method: redirectToCRD()
  Purpose: This function will redirect the screen to CRD tab on "Back" button click for permission not in public group
*/     
    public PageReference redirectToCRD2() {
        try{
      Pagereference pageRef = new Pagereference(BACKBUTTON + crdId);
      pageRef.getParameters().put(EDITMODEPARAM,editMode);
      pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
      return pageRef;
          
    } catch(exception e){return null;}
    }   

/*Method: redirectToCopay()
  Purpose: This function will redirect the screen to Copay tab on "Save and Next" button click 
*/     
    public PageReference redirectToCopay() {
        try{
            if(!saveRecord()){
            return null;
        } else {
                // Added line below to apply the validation rule for Story #06802
               if(crd.Dollar_Amount__c != Null && crd.Percent__c != Null && crd.Copay_Calculation__c == Null){
                   //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00011);
                   //ApexPages.addMessage(myMsg); 
                   crd.Copay_Calculation__c.addError(system.Label.ERR00011);
                   return null;
               }
           //Applied Check for Does Chemo Parity Apply field : Request 06893
               if(crd.Dollar_Amount__c == Null && crd.Percent__c == Null && crd.does_chemo_parity_apply__c != false){
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00051);
                   ApexPages.addMessage(myMsg); 
                   return null;
               }
                database.update(crd);
                PageReference pageRef = new PageReference(NEXTBUTTON + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }    
    }catch(exception e){return null;}
    }
    
/*Method: redirectToCopay2()
  Purpose: This function will redirect the screen to Copay tab on "Next" button click for Next button Story
*/     
    public PageReference redirectToCopay2() {
        try{
        PageReference pageRef = new PageReference(NEXTBUTTON + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;   
    }   catch(exception e){return null;}
    }
}