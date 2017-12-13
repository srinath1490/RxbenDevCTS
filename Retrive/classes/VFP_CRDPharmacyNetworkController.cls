/*Purpose: Apex Class for VFP_CRDPharmacyNetwork Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Anuj                 9/2/2011       Apex Class for VFP_CRDPharmacyNetwork Page .
     2.0      Amit                 8/18/2013      Modified for Request 01125
     3.0 -    Amit                 5 Nov'2014     Modified for Request 5043
     4.0 -    Sushant              03/06/2015     Modified for Request 05807
     5.0 -    Amit                 04/06/2017     Modified by Amit for request 6938, Added logic on Back and Save and Next button to update Y-Schedule from Pricing Network
                                                  Crosswalk Table.
======================================================================== 
*/
public with sharing class VFP_CRDPharmacyNetworkController {
    public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }
    public boolean isNetworkretailSelected {
        get;
        set;
    }
    public string pageName {
        get;
        set;
    }
    public  transient List < Schema.PicklistEntry > networkRetail = Network_Junction__c.Network_Retail__c.getDescribe().getPicklistValues();
    List<Pricing_Network__c> pricingNetworkCrosswalkList = new list<Pricing_Network__c>();
    List<Pricing_Network__c> pncList = new list<Pricing_Network__c>();
    Public string speciality;
    Public Network_Junction__c networkJunction {
        get;
        set;
    }
    // Request no 05963 by Nitish
    public List <SelectOption> NetworkRetailValues{
        get;
        set;
    }
   private static string subSegmentValue;
   private static final string AZ = 'AZ Rx Narrow Network';
   private static final string PA= 'PA Rx Narrow Network';
   private static final string VA= 'VA SE Regional Rx Narrow Network';
   private static final string NC= 'NC SE Regional Rx Narrow Network';
   private static final string SC= 'SC SE Regional Rx Narrow Network';
   private static final string SEVALUE = 'SE Regional Rx Narrow Network';
   private static final string NCTIER = 'NC SE REGIONAL RX NARROW NETWORK WITH MEDICAL TIER 1 MAX SAVINGS'; //Added as part of Request no 06068
   private static final string SCTIER = 'SC SE REGIONAL RX NARROW NETWORK WITH MEDICAL TIER 1 MAX SAVINGS';  //Added as part of Request no 06068
   private static final string PATIER = 'PA RX NARROW NETWORK WITH MEDICAL TIER 1 MAX SAVINGS';              //Added as part of Request no 06068
   private static final string CREATECONSUMERBUSINESS = 'Creating a packaged consumer business plan';
   private static final string CLONECONSUMERBUSINESS = 'Cloning a packaged consumer business plan from an existing CRD';
   private static final string CREATEPACKAGEPLAN = 'Creating a package plan';
   private static final string CLONEPACKAGEPLAN = 'Cloning a package plan from existing CRD';
   private static final string CREATEHIXPLAN = 'Creating a HIX plan';
   private static final string CLONEHIXPLAN = 'Cloning a HIX plan from existing CRD';
   private static final string FULLYINSURED = 'Fully Insured';
   private static final string SPLITFUNDED = 'Split Funded';
   private static final string SELFINSURED = 'Self Insured';
   private static final string NARROW = 'Narrow';
   PRIVATE STATIC FINAL STRING EDITMODEPARAM = 'p1';
   PRIVATE STATIC FINAL STRING GROUPMEMBERPARAM = 'p2';
   PRIVATE STATIC FINAL STRING CRDID1 = 'crdid';
   PRIVATE STATIC FINAL STRING RETAIL = 'Retail';
   PRIVATE STATIC FINAL STRING PN = 'PharmacyNetwork';
   PRIVATE STATIC FINAL STRING ACCUMPAGE = '/apex/VF_AccumulationsStep2?crdid=';
   PRIVATE STATIC FINAL STRING PROGRAMSCREEN = '/apex/VF_CRDClinicalProgStep1?crdid=';
   PRIVATE STATIC FINAL STRING NO = 'No';
   PRIVATE STATIC FINAL STRING CUSTOM  = 'Custom';
   PRIVATE STATIC FINAL STRING OPEN = 'Open';
   PRIVATE STATIC FINAL STRING PREFERED = 'Preffered';
   PRIVATE STATIC FINAL STRING EXC = 'Exclusive';
   private static final string ARX = 'Aetna Rx Value Network';
   private static final string ARXFI = 'Aetna Rx value Network -FI';
   private static final string NONE = 'None';
   private static final string NONEHYPHEN = '--None--';
   private static final string NULLSTRING = '';
   private static final string AMPN = 'Aetna Managed Pharmacy Network';
   private static final string ANN = 'Aetna National Network';
   private static final string Y4 = 'Y4';
   public string groupMember{get;set;}
   public String editMode{get;set;}
   string networkRetailValue; 
   string crdMedicalPlatform;
   string crdSubSegment;
   string networkRetailYSchedule{get;set;}
   boolean overrideNetworkYSchedule;
   public List < Network_Junction__c > networkJunctionList{get;set;}
   //Added by Nitish for 6900
   private transient List<schema.PicklistEntry> contractState = crd__c.contract_state__c.getDescribe().getPickListValues();
   private transient List<string> NetworkRetailValueWithCS = new List<string>();
   private transient List<string> NetworkRetailValueWithoutCS = new List<string>();
   private set<string> csValue = new set<string>();
    /*Constructor for Pharmacy Network Screen controller*/
   
public VFP_CRDPharmacyNetworkController(ApexPages.StandardController controller) {
        speciality = NULLSTRING;
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get(CRDID1);
        editMode=System.currentPagereference().getParameters().get(EDITMODEPARAM);  
        groupMember=System.currentPagereference().getParameters().get(GROUPMEMBERPARAM);   
        crd = [Select Id, Y_Schd__c,Sub_segment__c,Control__c,Partial_Control_Group__c,Are_you_creating_a_Package_Plan__c,Override_Retail_Y_Schedule__c,Retail_Y_Schedule_Override__c,Which_system_will_the_plan_be_installed__c,Subsegment__c, Name, Plan_Type_Specialty__c, Plan_Type_Retail__c,Standard_or_Custom_Plan__c, Plan_Type_Mail__c, Custom_Network_Flag__c, Integrate_with_Medical__c, Plan_Type_Paper__c, Insured_Type__c,Plan_Platform__c From CRD__c Where ID = : crdId LIMIT 80000];
        List < Drug_Coverage__c > specialityDrugCoverage = new List < Drug_Coverage__c > ([Select Id, Name, RecordtypeId, Force_to_Specialty__c from Drug_Coverage__c where CRD_ID__c = : crdId and Recordtype.Name =: RETAIL LIMIT 80000]);
        if (specialityDrugCoverage.size() != 0) {
            speciality = specialityDrugCoverage[0].Force_to_Specialty__c;
        }
        networkJunctionList = [select Id,name,(select CreatedById,CreatedDate,Field,Id,IsDeleted,NewValue,OldValue,ParentId,parent.name from Histories where Field NOT IN('created') order by Createddate desc), CRD_ID__c, Does_client_have_suppression__c, Mail_Custom__c, Retail_Custom__c, Specialty_Custom__c, Network_Mail__c, Network_Retail__c, Network_Specialty__c, Enroll_in_Medvantix__c, Medvantix_Copay_Dollar_Amount__c /* Medvantix_Copay_Percent__c, Medvantix_Copay_Calculation__c, Medvantix_Copay_Min_Dollar__c, Medvantix_Copay_Max_Dollar__c */ from Network_Junction__c where CRD_ID__c = : crdId limit 1];
        networkJunction = new Network_Junction__c();
        pricingNetworkCrosswalkList = [select id,name,End_date__c,Network_Name__c,Start_Date__c,Y_Schedule__c,Medical_Platform__c,Sub_Segment__c from Pricing_Network__c limit 10000];
        if (networkJunctionList.size() != 0) networkJunction = networkJunctionList[0];
        pageName = PN;
        //Request No 05963
        NetworkRetailValues = new List<SelectOption>();
        // Updated By Nitish For Request - 6900
      try{
        for(schema.PicklistEntry cs : contractState){
            csValue.add(cs.getvalue());
        }
        if(!(CREATECONSUMERBUSINESS.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CLONECONSUMERBUSINESS.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c))){
            for (Schema.PicklistEntry NR: networkRetail){     
                    if(NR.getValue().contains(AZ)||NR.getValue().contains(PA)||NR.getValue().contains(NCTIER)||NR.getValue().contains(SCTIER)||NR.getValue().contains(PATIER)){
              //Skip These as we dont have to show them   
                      }
                      else{
                         
                          string netRetSub = string.valueof(NR.getvalue()).substring(0,2);
                          if(!csValue.contains(netRetSub)){    
                            NetworkRetailValueWithoutCS.add(string.valueof(NR.getValue()));
                            NetworkRetailValueWithoutCS.sort();
                            }
                          else{
                              NetworkRetailValueWithCS.add(string.valueof(NR.getValue()));
                              NetworkRetailValueWithCS.sort();
                              }
                          }
                }
          }
       else if((crd.Standard_or_Custom_Plan__c!=null) && (CREATECONSUMERBUSINESS.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c) || CLONECONSUMERBUSINESS.equalsIgnoreCase(crd.Standard_or_Custom_Plan__c))){
                    
                    
                    /*NetworkRetailValues.add(new SelectOption (AZ,AZ));
                    NetworkRetailValues.add(new SelectOption (PA,PA));
                    NetworkRetailValues.add(new SelectOption (VA,VA));
                    NetworkRetailValues.add(new SelectOption (NC,NC));
                    NetworkRetailValues.add(new SelectOption (SC,SC));*/
                    for (Schema.PicklistEntry NR: networkRetail){
                        if(NR.getvalue().equalsIgnorecase(SEValue)){
                            //Have to remove SE Regional Rx Narrow Network for consumer business
                        }
                    else{
                         
                          string netRetSub = string.valueof(NR.getvalue()).substring(0,2);
                          if(!csValue.contains(netRetSub)){    
                            NetworkRetailValueWithoutCS.add(string.valueof(NR.getValue()));
                            NetworkRetailValueWithoutCS.sort();
                            }
                          else{
                              NetworkRetailValueWithCS.add(string.valueof(NR.getValue()));
                              NetworkRetailValueWithCS.sort();
                              }
                          }
                }
           }
            
        if(NetworkRetailValueWithoutCS.size()>0 || NetworkRetailValueWithCS.size()>0){
            for(string NR1 : NetworkRetailValueWithoutCS){
                NetworkRetailValues.add(new SelectOption(NR1,NR1));              
            }
         
             for(string NR3 : NetworkRetailValueWithCS){
                NetworkRetailValues.add(new SelectOption(NR3,NR3));
            }
        }
     if(networkJunction.Network_Retail__c == null || networkJunction.Network_Retail__c ==''){
         networkJunction.Network_Retail__c = ANN;
      }
    }
    catch(Exception e){
        Throw e;
    }
              //Code changes done by ankur Narrow Network pricing crosswalk story - Obsevation by kathy -  07/06/2016
              
              if(networkJunction.Network_Retail__c == null){
                  NetworkRetailValues[0].getvalue();
              }              
       }     

    /*Method to redirect to Programs screen for Next button story*/
    Public PageReference redirectToClinicalProgStep22(){
        try{
        //Added as part of request 06995 to clear the "Network: Specialty" field value when the user clicks back button
        //Commented by Sushant after removal of acceptance Criteria. Now we dont need to clear this value.
            /*if(networkJunction.Network_Specialty__c == null || networkJunction.Network_Specialty__c == 'Banner Health Aetna Specialty Network'){
            networkJunction.Network_Specialty__c = null;
            }*/
            
            Pagereference pageRef = new Pagereference(ACCUMPAGE + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
        }catch(exception e){return null;}
    }
    /*Method to redirect to Programs screen*/
    Public PageReference redirectToClinicalProgStep2() {
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
           try {
                /* Commented for Request 05807 by Sushant
            if((networkJunction.Network_Retail__c != CUSTOM && networkJunction.Network_Retail__c != Null && networkJunction.Retail_Custom__c != NULL) 
                        ||(networkJunction.Network_Mail__c !=CUSTOM && networkJunction.Network_Mail__c != Null && networkJunction.Mail_Custom__c != NULL) 
                        ||(networkJunction.Network_Specialty__c !=CUSTOM && networkJunction.Network_Specialty__c != Null && networkJunction.Specialty_Custom__c != NULL)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR0283);
                ApexPages.addMessage(myMsg);
                return null;
               }
               */ 
//Added as part of request 06995 to clear the "Network: Specialty" field value when the user clicks back button
        //Commented by Sushant after removal of acceptance Criteria. Now we dont need to clear this value.
            /*if(networkJunction.Network_Specialty__c == null || networkJunction.Network_Specialty__c == 'Banner Health Aetna Specialty Network'){
            networkJunction.Network_Specialty__c = null;
            }*/
            if ((networkJunction.Retail_Custom__c != null) || (networkJunction.Mail_Custom__c != null) || (networkJunction.Specialty_Custom__c != null)) {
                crd.Custom_Network_Flag__c = true;
            } else {
                crd.Custom_Network_Flag__c = false;
            }
            networkJunction.CRD_ID__c = crdId;
            database.upsert(networkJunction);
                    if(networkJunction.Network_Retail__c != null && (crd.Standard_or_Custom_Plan__c == CREATECONSUMERBUSINESS || crd.Standard_or_Custom_Plan__c == CLONECONSUMERBUSINESS
                        || crd.Standard_or_Custom_Plan__c == CREATEPACKAGEPLAN || crd.Standard_or_Custom_Plan__c == CLONEPACKAGEPLAN
                        || crd.Standard_or_Custom_Plan__c == CREATEHIXPLAN || crd.Standard_or_Custom_Plan__c == CLONEHIXPLAN)
                ){
            networkRetailValue = string.valueof(networkJunction.Network_Retail__c);
            crdMedicalPlatform = string.valueof(crd.Which_system_will_the_plan_be_installed__c);
            crdSubSegment = string.valueof(crd.Sub_segment__c);
            for(Pricing_Network__c pnc : pricingNetworkCrosswalkList){
                if(pnc.Network_Name__c == networkRetailValue && pnc.Medical_Platform__c == crdMedicalPlatform && pnc.Sub_Segment__c == crdSubSegment){
                    pncList.add(pnc);
                    }
            }
            if(pncList.size() > 0 && crd.Override_Retail_Y_Schedule__c == NO ){
                networkRetailYSchedule = pncList[0].Y_Schedule__c;
                crd.y_schd__c = networkRetailYSchedule;
            }else if (pncList.size() == 0 && crd.Override_Retail_Y_Schedule__c == NO){
                        crd.Y_Schd__c = Y4;
                        crd.Pricing_Schedule__c = Y4;
            }   
        }


        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            if (networkJunction.Network_Mail__c == null && networkJunction.Network_Specialty__c == null && networkJunction.Network_Retail__c == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00103);
                ApexPages.addMessage(myMsg);
                return null;
            } else if((networkJunction.Network_Retail__c.equalsIgnoreCase(CUSTOM) && networkJunction.Retail_Custom__c == NULL) || (networkJunction.Network_Mail__c.equalsIgnoreCase(CUSTOM) && networkJunction.Mail_Custom__c == NULL) ||(networkJunction.Network_Specialty__c.equalsIgnoreCase(CUSTOM) && networkJunction.Specialty_Custom__c == NULL)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00104);
                ApexPages.addMessage(myMsg);
                return null;
            }else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getmessage());
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        database.update(crd);
        Pagereference pageRef = new Pagereference(ACCUMPAGE + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        return pageRef;

    }
    /*Method to hide/show fields on Programs screen*/
    public PageReference showPanel() {
        try{
        isNetworkretailSelected = false;
        if (networkJunction.Network_Retail__c != null && CUSTOM.equalsIgnoreCase(networkJunction.Network_Retail__c)) {
            isNetworkretailSelected = true;
        } else {
            networkJunction.Does_client_have_suppression__c = NULL;
        }
        return null;
    }catch(exception e){return null;}
    }
    /*Method to redirect to Programs screen for Next button story*/
    Public Pagereference redirectToPrograms2(){
     try{
            Pagereference pageRef = new Pagereference(PROGRAMSCREEN + crdId);
            pageRef.getParameters().put(EDITMODEPARAM,editMode);
            pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
            return pageRef;
    }catch(exception e){return null;}
    }
    /*Method to redirect to Programs screen*/
    Public PageReference redirectToPrograms() {
        boolean isCriteriaCompleted;
        isCriteriaCompleted = true;
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        if(networkJunction.Network_Retail__c != null && networkJunction.Network_Retail__c != CUSTOM){
            if(networkJunction.Does_client_have_suppression__c!=null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,System.Label.ERR0213);
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        networkRetailValue = string.valueof(networkJunction.Network_Retail__c);
        crdMedicalPlatform = string.valueof(crd.Which_system_will_the_plan_be_installed__c);
        crdSubSegment = string.valueof(crd.Sub_segment__c);
        //Modified by Amit for Request 6938
        
            if(networkJunction.Network_Retail__c != null && (crd.Standard_or_Custom_Plan__c == CREATECONSUMERBUSINESS || crd.Standard_or_Custom_Plan__c == CLONECONSUMERBUSINESS
                    || crd.Standard_or_Custom_Plan__c == CREATEPACKAGEPLAN || crd.Standard_or_Custom_Plan__c == CLONEPACKAGEPLAN
                    || crd.Standard_or_Custom_Plan__c == CREATEHIXPLAN || crd.Standard_or_Custom_Plan__c == CLONEHIXPLAN)
                    ){
                //networkRetailValue = string.valueof(networkJunction.Network_Retail__c);
                for(Pricing_Network__c pnc : pricingNetworkCrosswalkList){
                    if(pnc.Network_Name__c == networkRetailValue && pnc.Medical_Platform__c == crdMedicalPlatform && pnc.Sub_Segment__c == crdSubSegment){
                        pncList.add(pnc);
                        }
                }
                if(pncList.size() > 0 && crd.Override_Retail_Y_Schedule__c == NO){
                    networkRetailYSchedule = pncList[0].Y_Schedule__c;
                    crd.y_schd__c = networkRetailYSchedule;
                    
                }else if (pncList.size() == 0 && crd.Override_Retail_Y_Schedule__c == NO){
                        crd.Y_Schd__c = Y4;
                        crd.Pricing_Schedule__c = Y4;
                } 
            
                 //Added by Nitish Request#06509
                if(((crd.Insured_Type__c != null) && (FULLYINSURED.equalsIgnoreCase(crd.Insured_Type__c)|| SPLITFUNDED.equalsIgnoreCase(crd.Insured_Type__c))) && ((networkJunction.Network_Retail__c != NULL) && (ARX.equalsIgnoreCase(networkJunction.Network_Retail__c)))){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR302);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                 //Added by Nitish Request#06509
                if(((crd.Insured_Type__c != null) && (SELFINSURED.equalsIgnoreCase(crd.Insured_Type__c))) && ((networkJunction.Network_Retail__c != NULL) && ARXFI.equalsIgnoreCase(networkJunction.Network_Retail__c))){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR303);
                    ApexPages.addMessage(myMsg);
                    return null;
                }
            }
    
        /* Commented for Request 05807 by Sushant
        if((networkJunction.Network_Retail__c != CUSTOM && networkJunction.Network_Retail__c != Null && networkJunction.Retail_Custom__c != NULL) 
                        ||(networkJunction.Network_Mail__c !=CUSTOM && networkJunction.Network_Mail__c != Null && networkJunction.Mail_Custom__c != NULL) 
                        ||(networkJunction.Network_Specialty__c !=CUSTOM && networkJunction.Network_Specialty__c != Null && networkJunction.Specialty_Custom__c != NULL)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR0283);
                ApexPages.addMessage(myMsg);
                return null;
        }*/
          try {

            if (crd.Plan_Type_Mail__c == true && networkJunction.Network_Mail__c == NULL) {
                isCriteriaCompleted = false;
            }
            if (crd.Plan_Type_Retail__c == true && networkJunction.Network_Retail__c == NULL) {
                isCriteriaCompleted = false;
            }
            if (crd.Plan_Type_Specialty__c == true && networkJunction.Network_Specialty__c == NULL) {
                isCriteriaCompleted = false;
            }
            
            if (isCriteriaCompleted == false) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00105);
                ApexPages.addMessage(myMsg);
                return null;
            }
            if ((networkJunction.Retail_Custom__c != null) || (networkJunction.Mail_Custom__c != null) || (networkJunction.Specialty_Custom__c != null)) {
                crd.Custom_Network_Flag__c = true;
                
            } else {
                crd.Custom_Network_Flag__c = false;
                
            }
            networkJunction.CRD_ID__c = crdId;
            database.upsert(networkJunction);
        } catch (exception e) {
            // roll everything back in case of error
            Database.rollback(sp);
            if (networkJunction.Network_Mail__c == null && networkJunction.Network_Specialty__c == null && networkJunction.Network_Retail__c == null) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00103);
                ApexPages.addMessage(myMsg);
                return null;
            } else if((networkJunction.Network_Retail__c.equalsIgnoreCase(CUSTOM) && networkJunction.Retail_Custom__c == NULL) || (networkJunction.Network_Mail__c.equalsIgnoreCase(CUSTOM) && networkJunction.Mail_Custom__c == NULL) ||(networkJunction.Network_Specialty__c.equalsIgnoreCase(CUSTOM) && networkJunction.Specialty_Custom__c == NULL)){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, system.label.ERR00104);
                ApexPages.addMessage(myMsg);
                return null;
            }else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info, e.getmessage());
                ApexPages.addMessage(myMsg);
                return null;
            }
        }

        Pagereference pageRef = new Pagereference(PROGRAMSCREEN + crdId);
        pageRef.getParameters().put(EDITMODEPARAM,editMode);
        pageRef.getParameters().put(GROUPMEMBERPARAM,groupMember);
        database.update(crd);
        return pageRef;

    }
    /*Method to clear field on Programs screen*/
    Public Pagereference clearField() {
     try{
        networkJunction.Network_Mail__c = null;
        networkJunction.Network_Retail__c = null;
        networkJunction.Network_Specialty__c = null;
        networkJunction.Mail_Custom__c = null;
        networkJunction.Retail_Custom__c = null;
        networkJunction.Specialty_Custom__c = null;
        return null;
    }catch(exception e){return null;}
    }
}