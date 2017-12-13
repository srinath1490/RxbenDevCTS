/**
 * Class Name: VFP_AetnaRxWaysToSave
 * Author: Accenture
 * Date: 1-May-2013
 * Requirement/Project Name: <Aetna>
 * Requirement/Project Description: <ACE2011>
 */
/*Purpose: Controller class of page VF_AetnaRxWaysToSave                                        
  ========================================================================
  History                                                            
  -------                                                            
  VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Sushant                  5/1/2013       Controller class of page VF_AetnaRxWaysToSave
   2.0      Amit                  8/23/2013        Modified for request 01125
  ======================================================================== */
  public with sharing class VFP_AetnaRxWaysToSave {

public CRD__c crd {
        get;
        set;
    }
    
    public String crdId {
        get;
        set;
    }
      // Flags for Showing fields
    public Boolean showField { get; set; }       
    public Boolean showField3 { get; set; }
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING OPTNO = 'No';
    PRIVATE STATIC FINAL STRING AHOURL = '/apex/VF_AHOPrograms?crdid=';
    PRIVATE STATIC FINAL STRING COMPLETEURL = '/apex/VF_CRDCompleteProcess?crdid=';
    public string managementUser {get;set;}
   

    /* Constructor for the controller class */
    public VFP_AetnaRxWaysToSave(ApexPages.StandardController controller) {
        GC_Utils_Method  chkMang = new GC_Utils_Method();
        chkMang.checkManagementUser();
        managementUser = chkMang.managementUser;

        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        this.crd = (CRD__c) controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        if (crdId != null) {
        this.crd = [SELECT Name, Enroll_in_Aetna_Ways_to_Save__c, Introductory_Paragraph_to_Include__c, Minimum_Member_Savings_Projection__c,  Preferred_Manufacturer_Brands_Code__c, Member_Letter_Selection__c, If_Not_18_Indicate_Age__c, Target_Pref_Manufacturer_Brand_Opportun__c, Target_Participants_18_years_and_older__c, Target_Generic_Opportunities__c, Target_Formulary_Brand_Opportunities__c, Requested_mailing_received_on__c, Mail_Request_Date__c, Plan_Platform__c, Insured_Type__c, Plan_Type_Paper__c 
        FROM CRD__c WHERE ID = : crdId LIMIT 100000];
        }
        showField = false;
    

    }
   
 
   /* Conditions as per request 00885  */
   public pagereference showFields(){
       try {
        If(OPTNO.equalsIgnoreCase(crd.Target_Pref_Manufacturer_Brand_Opportun__c))
            showField = true;
        else
            showField = false;
        return null;
       }
       catch (exception e)
       {
           return null;
       } 
    } 
    /* Method to show the fields based on value of Target_Participants_18_years_and_older__c */
    public pagereference showFields3(){
      try {
        If(OPTNO.equalsIgnoreCase(crd.Target_Participants_18_years_and_older__c))
            showField3 = true;
        else
            showField3 = false;
        return null;
       }
       catch (exception e)
       {
           return null;
       } 
    } 
    
    /* Method for the functionality of the clear fields button on the screen */
    public void clearfields() {
    // Conditions as per request 00885
    try {
    if (OPTNO.equalsIgnoreCase(crd.Enroll_in_Aetna_Ways_to_Save__c)){
    
    crd.Requested_mailing_received_on__c = null;
    crd.Mail_Request_Date__c= null;
    crd.Target_Generic_Opportunities__c= null;
    crd.Target_Formulary_Brand_Opportunities__c= null;
    crd.Target_Pref_Manufacturer_Brand_Opportun__c= null;
    crd.Preferred_Manufacturer_Brands_Code__c= null;
    crd.Target_Participants_18_years_and_older__c= null;
    crd.If_Not_18_Indicate_Age__c= null;
    crd.Minimum_Member_Savings_Projection__c= null;
    crd.Member_Letter_Selection__c= null;
    crd.Introductory_Paragraph_to_Include__c= null;
    
    }
    }
    catch (exception e)
    {
       throw e;
    }
    }
    
    /* Method with Code for Back button */
    public pagereference backbutton() {
    database.update(crd);
    clearfields();
    Integer selected = 0;
    
    try {
    
    if (ApexPages.hasMessages()) {
                return null;
            } else {
                Pagereference pageRef = new Pagereference(AHOURL + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }
            
            return null;
    } catch (exception e) {
            return null;
        }
    
    
    }
    
    /**
     * Method :- backbutton2
     * Description :- Method that is invoked when user not in public group clicks on the back button. Changes done on the VF page are not saved and wizard moves on to the previous page.
     **/
    public pagereference backbutton2() {
       try { 
        Pagereference pageRef = new Pagereference(AHOURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
       }
       catch (exception e)
       {
           return null;
       } 
    }    
    
    /* Method with Code for next button */
    public pagereference nextbutton(){
        clearfields();
         try {
         database.update(crd); 
           if (ApexPages.hasMessages()) {
                return null;
            } 
            //Modified by Amit Jain for Request 01125
             else {
               Pagereference pageRef = new Pagereference(COMPLETEURL + crdId);
               pageRef.getParameters().put(EDITMODEPARAM,editMode);
               pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                database.update(crd);
                return pageRef; 
            }
            //##Ends                        
             return null;
    }catch (exception e) {
            return null;
        }
       
}

    /**
     * Method :- nextbutton2
     * Description :- Method that is invoked when user not in public group clicks on the next button. Changes done on the VF page are not saved and wizard moves on to the next page.
     **/
    public pagereference nextbutton2(){
      try {  
       Pagereference pageRef = new Pagereference(COMPLETEURL + crdId);
       pageRef.getParameters().put(EDITMODEPARAM,editMode);
       pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef; 
      }
      catch (exception e)
       {
           return null;
       }  
    }

}