/*Purpose: Apex Class for VF_CRDSearch Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 02/10/2013              Apex Class for VF_CRDSearch Page..
======================================================================== 
*/

public with sharing class VFP_CRDSearchController {
    public list < CRD__c > lstCRD4Account {
        get;
        set;
    }
    public crd__c currentCrd {
        get;
        set;
    }
    public list < CSAP_CGLP_Junction__c > lstCSAPJunction {
        get;
        set;
    }
    public list < CSAP_CGLP_Junction__c > CSAPList {
        get;
        set;
    }
    public String selectedCrdId {
        get;
        set;
    }
    public String CRDName {
        get;
        set;
    }
    public String FCGName {
    get;
    set;
    }
    public String AccountName{
    get;
    set;
    } 
    public list < String > errorMessages {
        get;
        set;
    }
     
    public VFP_CRDSearchController(ApexPages.StandardController controller) {
        lstCRD4Account = new list < CRD__c > ();
        lstCSAPJunction = new list < CSAP_CGLP_Junction__c > ();
        errorMessages = new list < String > (); 
        currentCrd = (crd__c) controller.getRecord();
    }
    

    
    //Display the CRD's based on the Account Name
    public pagereference ShowSearchresults() {
    lstCSAPJunction.clear();
    lstCRD4Account.clear();
    errorMessages.clear();
    set<id> CrdIds = new set<id>();
    String whereClause = '';
    if ( FCGName != NULL && FCGName != ''){
            CSAPList = [select id, CRD__c,CSAP_CGLP_Junction__c.Name, Full_Control_Group__c, GLP_Group_Number__c, GLP_Plan_ID__c, Partial_Control_Group__c, CSAP_Control_ID__c, CSAP_Plan_ID__c from CSAP_CGLP_Junction__c where CSAP_Control_ID__c = :FCGName and RecordType.Name = 'CRD to Partial CG'];
            for(CSAP_CGLP_Junction__c CsapTemp :  CSAPList )
                if( !CrdIds.contains(CsapTemp .CRD__c))
                    CrdIds.add(CsapTemp.CRD__c);
                    
            if(whereClause != null && whereClause != ''){
                whereClause = whereClause + ' and id in :CrdIds ';
                System.debug('Step##' + whereClause );    
                }
            else{
                whereClause = 'id in :CrdIds ';   
                System.debug('Step@@' + whereClause );    
                }     
            
            
    }
    
    if ( CRDName != NULL && CRDName != ''){
            if(whereClause != null && whereClause != ''){
                whereClause = whereClause + ' and name = :CRDName '; 
                System.debug('Step0' + whereClause );  }  
            else{
                whereClause = 'name = :CRDName ';    
                System.debug('Step1' + whereClause );   
                }    
    }
    if ( currentCrd.Account__c != NULL){
            if(whereClause != null && whereClause != ''){
                whereClause = whereClause + ' and Account__c =  \'' +currentCrd.account__c + '\'';  
                System.debug('Step2' + whereClause );
                }    
            else{
                whereClause = 'Account__c = \'' +currentCrd.account__c + '\'';
                System.debug('Step3' + whereClause );   
                } 
    }
    
    system.debug(whereClause);   
    
        string whereClausequery = 'select id, name, status__c, Effective_Start_Date__c, Plan_Platform__c, RxPlanID__c, Insured_Type__c, Are_you_creating_a_Package_Plan__c from crd__c where ' +whereClause;
        system.debug(whereClausequery);
        if(whereClause != NULL && whereClause != ''){
         lstCRD4Account = Database.query(whereClausequery);
              }
    else{
        //ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.Error, 'Solar Access % must be between 0 and 100 for Roof 1.') );

       ApexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,system.label.ERR0229));
         }
         
       return null; 
    }
    //Display the CSAP/CLGP Junction data
    public void showCSAPListData() {
        lstCSAPJunction = [select id, CSAP_CGLP_Junction__c.Name, Full_Control_Group__c, GLP_Group_Number__c, GLP_Plan_ID__c, Partial_Control_Group__c, CSAP_Control_ID__c, CSAP_Plan_ID__c from CSAP_CGLP_Junction__c where CRD__c = : selectedCrdId and RecordType.Name = 'CRD to Partial CG'];
    }

}