/**
 * Class Name: VFP_AHOProgramsController
 * Author: Accenture
 * Date: 12-Oct-2012
 * Requirement/Project Name: <Aetna>
 * Requirement/Project Description: <ACE2011>
 */
/*Purpose: Controller class of page VF_AHOPrograms                                        
  ========================================================================
  History                                                            
  -------                                                            
  VERSION     AUTHOR                 DATE                    DETAIL   
   1.0 -    Rakesh Mistry         10/12/2012       Controller class of page VF_AHOPrograms                              
   2.0      Amit                  8/23/2013        Modified for request 01125
  ======================================================================== */
  public with sharing class VFP_AHOProgramsController {

    public CRD__c crd {
        get;
        set;
    }
    public string groupMember{get;set;} //Added by Ayushi for next button story
    public String editMode{get;set;}   //Added by Ayushi for next button story
    PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
    PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
    PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
    PRIVATE STATIC FINAL STRING OPTYES = 'Yes';
    PRIVATE STATIC FINAL STRING DOLLARAMT = 'Dollar Amount';
    PRIVATE STATIC FINAL STRING AHAURL = '/apex/VF_AHAPrograms?crdid=';
    PRIVATE STATIC FINAL STRING RXWAYSURL = '/apex/VF_AetnaRxWaysToSave?crdid=';
    public String crdId {
        get;
        set;
    }
    public Boolean isChanged {
        get;
        set;
    }
    public list < Drug_List__c > drugList;
    public List < Aetna_RxHealthy_Outcomes_Junction__c > ahoList {
        get;
        set;
    }

    /* Constructor for the conrtoller class */
    public VFP_AHOProgramsController(ApexPages.StandardController controller) {
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);        //Added by Ayushi for next button story
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);    //Added by Ayushi for next button story
        isChanged = false;
        this.crd = (CRD__c) controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);

        this.crd = [SELECT Name, Y_Schd__c, Tier_1_Rx_Reduction_Type__c, Tier_2_Rx_Reduction_Type__c, Tier_3_Rx_Reduction_Type__c, Tier_4_Rx_Reduction_Type__c, Tier_5_Rx_Reduction_Type__c, Tier_1_Rx_Reduction_Amount__c, Tier_2_Rx_Reduction_Amount__c, Tier_3_Rx_Reduction_Amount__c, Tier_4_Rx_Reduction_Amount__c, Tier_5_Rx_Reduction_Amount__c, ARH_Offering_Type__c, Aetna_Rx_Healthy_Outcomes__c, Plan_Type_Paper__c, Insured_Type__c, Plan_Platform__c
        FROM CRD__c WHERE ID = : crdId LIMIT 100000];

        ahoList = new List < Aetna_RxHealthy_Outcomes_Junction__c > ([SELECT Id, Aetna_RxHealthy_Outcomes_Drug_List__c, Aetna_RxHealthy_Outcomes_Drug_List_Name__c, Selected__c FROM Aetna_RxHealthy_Outcomes_Junction__c WHERE CRD_ID__c = : crdid LIMIT 100000]);
    }

    /* Method for the functionality of the back button */
    public Pagereference backbutton() {

        Integer selected = 0;

        try {

            if (OPTYES.equalsIgnoreCase(crd.Aetna_Rx_Healthy_Outcomes__c)  && crd.ARH_Offering_Type__c == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00146);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_1_Rx_Reduction_Type__c) && crd.Tier_1_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00153);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_2_Rx_Reduction_Type__c) && crd.Tier_2_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00154);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_3_Rx_Reduction_Type__c) && crd.Tier_3_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00155);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_4_Rx_Reduction_Type__c) && crd.Tier_4_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00156);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_5_Rx_Reduction_Type__c) && crd.Tier_5_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00157);
                ApexPages.addMessage(myMsg);
            }

            if (ahoList.size() != 0) {
                for (Aetna_RxHealthy_Outcomes_Junction__c aho: ahoList) {
                    if (aho.Selected__c) selected = selected + 1;
                }
            }

            if (isChanged) {
                List < Aetna_RxHealthy_Outcomes_Junction__c > deleteAhoList = new List < Aetna_RxHealthy_Outcomes_Junction__c > ([Select Id from Aetna_RxHealthy_Outcomes_Junction__c where CRD_ID__c = : crdid LIMIT 100000]);
                if (deleteAhoList.size() != 0) database.delete(deleteAhoList);
                if (selected >= 1) {
                    database.insert(ahoList);
                    database.update(crd);
                } else if (ahoList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            } else {
                if (selected >= 1) {
                    database.upsert(ahoList);
                    database.update(crd);
                } else if (ahoList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }

            if (ApexPages.hasMessages()) {
                return null;
            } else {
                Pagereference pageRef = new Pagereference(AHAURL + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            }
        } catch (exception e) {
            return null;
        }
    }

    /**
     * Method :- backbutton2
     * Description :- Method that is invoked when user not in public group clicks on the back button. Changes done on the VF page are not saved and wizard moves on to the previous page.
     **/
    public Pagereference backbutton2() {
       try { 
        Pagereference pageRef = new Pagereference(AHAURL + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;
      }
      catch (exception e)
      {
            return null;
      }  
    }

    /* Method for the functionality of the next button */
    public Pagereference nextbutton() {

        Integer selected = 0;

        try {

            if (OPTYES.equalsIgnoreCase(crd.Aetna_Rx_Healthy_Outcomes__c) && crd.ARH_Offering_Type__c == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00146);
                ApexPages.addMessage(myMsg);
                //return null;
            }

            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_1_Rx_Reduction_Type__c) && crd.Tier_1_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00153);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_2_Rx_Reduction_Type__c) && crd.Tier_2_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00154);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_3_Rx_Reduction_Type__c) && crd.Tier_3_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00155);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_4_Rx_Reduction_Type__c) && crd.Tier_4_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00156);
                ApexPages.addMessage(myMsg);
            }
            if (DOLLARAMT.equalsIgnoreCase(crd.Tier_5_Rx_Reduction_Type__c) && crd.Tier_5_Rx_Reduction_Amount__c > 500.00) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00157);
                ApexPages.addMessage(myMsg);
            }

            if (ahoList.size() != 0) {
                for (Aetna_RxHealthy_Outcomes_Junction__c aho: ahoList) {
                    if (aho.Selected__c) selected = selected + 1;
                }
            }

            if (isChanged) {
                List < Aetna_RxHealthy_Outcomes_Junction__c > deleteAhoList = new List < Aetna_RxHealthy_Outcomes_Junction__c > ([SELECT Id FROM Aetna_RxHealthy_Outcomes_Junction__c WHERE CRD_ID__c = : crdid LIMIT 100000]);
                if (deleteAhoList.size() != 0) database.delete(deleteAhoList);
                if (selected >= 1) {
                    database.insert(ahoList);
                    database.update(crd);
                } else if (ahoList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, System.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            } else {
                if (selected >= 1) {
                    database.upsert(ahoList);
                    database.update(crd);
                } else if (ahoList.size() == 0) {
                    database.update(crd);
                } else {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.error, system.label.ERR00137);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }

            if (ApexPages.hasMessages()) {
                return null;
            } 
            //Modified by Amit Jain For Request 01125
                Pagereference pageRef = new Pagereference(RXWAYSURL + crdId);
                pageRef.getParameters().put(EDITMODEPARAM,editMode);
                pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
                return pageRef;
            //##Ends    
                
        } catch (exception e) {
            return null;
        }
    }
    
    /**
     * Method :- nextbutton2
     * Description :- Method that is invoked when user not in public group clicks on the next button. Changes done on the VF page are not saved and wizard moves on to the next page.
     **/
    public Pagereference nextbutton2() {
        try {
            Pagereference pageRef = new Pagereference(RXWAYSURL + crdId);
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