/*Purpose: Apex Class for VFP_CRDStep1a Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -    Abhay                 8/19/2011       Apex Class for class VFP_CRDStep1a Page.
     2.0 -    Amit                  4/3/2013        Removed ApexPages.Message from redirectToStep2() for Pera Mass Change
     2.1 -    Sushant               09/10/2013      Code added for Req 1063    
     3.0 -    Amit                  15 Nov 2013     Added Y schedule for HIX plans
     4.0 -    Nikita Bansal         07/29/2015      Implemented Request 05947      
======================================================================== 
*/
public with sharing class VFP_CRDStep1aController {
    Public CRD__c crd {
        get;
        set;
    }
    public string crdId {
        get;
        set;
    }

    public string existingStandardPlan {
        get;
        set;
    }
    public string pageName {
        get;
        set;
    }
    public list < String > errorMessages {
        get;
        set;
    }
    public string userId{get;set;} //Added for next button story
    public string editMode{get;set;} //Added for next button story
    public string PUBLICGROUP {get;set;} //Added for next button story
    public string groupID{get;set;}   //Added for next button story
    public list<group> groupCheck{get;set;}  //Added for next button story
    public list<GroupMember> groupMemberCheck{get;set;}  //Added for next button story
    public string groupMember{get;set;}  //Added for next button story
    private static final string EDITTRUE = 'BCTME';
    private static final string EDITFALSE = 'BCTNR';
    private static final string GRPMEMTRUE = 'RUME';
    private static final string GRPMEMFLASE = 'RUNR';
    private static final string PARAMEDITMODE = 'p1';
    private static final string PARAMGRPMEMBER = 'p2';
    private static final string SECONDSCREEN = '/apex/VF_NewCRDPlan_Step1?id=';
    private static final string YSCH = 'Y6';
    private static final string HOME = 'home';
    private static final string YES = 'Yes';
    public string previousPageMode{get;set;}
    public boolean showMessage {get;set;}
    public boolean readOnlyMode{get;set;}
    public list<string> groupUserIds = new list<string>();  //Added for next button story
    public static final List < Schema.PicklistEntry > Plan = CRD__c.Standard_or_Custom_Plan__c.getDescribe().getPicklistValues();

    /*Class Constructor*/
    public VFP_CRDStep1aController(ApexPages.StandardController controller) {
        try{
        PUBLICGROUP = System.Label.PublicGroupCRDEditMode;
        checkPublicGroup();
        if(System.currentPagereference().getParameters().get(PARAMEDITMODE)==EDITTRUE){
                                previousPageMode=EDITTRUE;
                                editMode = EDITTRUE;                 
        }else{
                                previousPageMode=EDITFALSE; 
                                editMode = EDITFALSE;                 
             }
        this.crd = (CRD__c) Controller.getRecord();
        crdId = ApexPages.CurrentPage().getParameters().get('id');
        errorMessages = new list < String > ();
        if (crdId != null) {

            crd = [Select Name,Y_Schd__c,Clone_from_which_CRD__r.name,Cloned_CRD_Plan_Effective_Date__c,Cloned_CRD_RxPlan_ID__c, Clone_TPID__c, Clone_Insured_Type__c,LastSent__c,Clone_from_which_CRD__c, Funding_Type_New_Value__c, Clone_Owner_PPID__c, Clone_Ben_ID__c, Clone_Migration_Run_Number__c, Clone_RxPlan_ID__c, Clone_BPERxPlan_ID__c, Clone_File_ID__c,Clone_Retail_Y_Schedule__c, Clone_Account__c, TPID_New_Value__c, Owner_PPID_New_Value__c, Ben_ID_New_Value__c, Migration_Run_Number_New_Value__c, RxPlan_ID_New_Value__c, Old_RxPlan_ID_New_Value__c, BPERxPlan_ID_New_Value__c, File_ID_New_Value__c, Account_New_Value__c, Insured_Type__c, Integrate_with_Medical__c, Are_you_creating_a_Package_Plan__c, RxPlan_ID_Status__c, Standard_or_Custom_Plan__c, Standard_Plan_Selection__c, Plan_Type_Paper__c,Status__c, Clone_Old_RxPlan_ID__c From CRD__c Where id = : this.crd.id LIMIT 80000];
            crdId = crd.id;           
            readOnlyMode = True;
        }else{
                readOnlyMode = False;
                }
        existingStandardPlan = crd.Clone_from_which_CRD__c;
        pageName = HOME;
    }catch(exception e){
        ApexPages.addMessages(e);
    }
    }
    /*Select options list populator method*/
    Public List < SelectOption > getPlanType() {
        try{
        List < SelectOption > options = new List < SelectOption > ();
        options.add(new Selectoption('', '-None-'));
        for (Schema.PicklistEntry P: Plan) {
            if (crd.Are_you_creating_a_Package_Plan__c != null && crd.Are_you_creating_a_Package_Plan__c == YES) {
                options.add(new Selectoption(p.getValue(), p.getLabel()));
            } else if (p.getLabel() != 'Build a Package Plan') {
                options.add(new Selectoption(p.getValue(), p.getLabel()));
            }
        }
        return options;
    }catch(exception e){
        ApexPages.addMessages(e);
        return null;
    }
    }
    /*Method for Next Button Story*/
    Public Pagereference redirectToStep22(){
        Pagereference pageRef = new Pagereference(SECONDSCREEN + crd.Id);
        
        //condition to pass previous screen parameter
        if(previousPageMode == EDITTRUE){
            pageRef.getParameters().put(PARAMEDITMODE,EDITTRUE);
        }else if(previousPageMode == EDITFALSE){
            pageRef.getParameters().put(PARAMEDITMODE,EDITFALSE);
        }
        pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
            return pageRef;
    }
    /*Method for Next Button Story*/
    Public PageReference redirectToStep2() {
    boolean hasError = false;
    errormessages.clear();
    Savepoint sp;
    //if (groupMember == GRPMEMTRUE) {
        try {
             
              sp = Database.setSavepoint();
                    
                    //Added by Amit on 15th Nov 2013
                    /*
                    if(crd.Standard_or_Custom_Plan__c == 'Cloning a HIX plan from existing CRD' || crd.Standard_or_Custom_Plan__c == 'Creating a HIX plan'){
                        crd.Y_Schd__c = 'Y4';
                    }
                    //ends
                    */
                    crd.Pricing_Schedule__c = crd.Y_Schd__c;
                    crd.Mail_Y_Schedule__c = YSCH;
                    database.upsert(crd);

        
            if (crd.Standard_or_Custom_Plan__c != null) {
              if(crd.Standard_or_Custom_Plan__c== 'Cloning a custom plan from existing CRD' || crd.Standard_or_Custom_Plan__c== 'Cloning a package plan from existing CRD' || crd.Standard_or_Custom_Plan__c== 'Cloning a packaged consumer business plan from an existing CRD' || crd.Standard_or_Custom_Plan__c== 'Cloning a HIX plan from existing CRD'){
                    if(crd.clone_from_which_crd__c ==  NULL){
                        errorMessages.add(system.Label.ERR0211);
                        hasError = true;
                        return null;
                        
                 }
            }                 
                 
                if(crd.Standard_or_Custom_Plan__c == 'Cloning a custom plan from existing CRD'  || crd.Standard_or_Custom_Plan__c == 'Cloning a package plan from existing CRD' || crd.Standard_or_Custom_Plan__c== 'Cloning a packaged consumer business plan from an existing CRD' || crd.Standard_or_Custom_Plan__c == 'Cloning a HIX plan from existing CRD'){
                
                        if(crd.Clone_TPID__c == NULL || crd.Clone_Owner_PPID__c == NULL || crd.Clone_Ben_ID__c == NULL || crd.Clone_Account__c == NULL){
                    errorMessages.add(system.Label.ERR00227);
                        hasError = true;
                        return null;
                        
                }
                 if (crd.Clone_from_which_CRD__c !=null) 
                {
                    if (existingStandardPlan == null ) {
                         database.update(crd);
                        VFP_CloneCRD clsCloneCrd = new VFP_CloneCRD();
                            clsCloneCrd.cloneCrdWithItems(crd.Clone_from_which_CRD__c, crd,FALSE);
                             //crd.LastSent__c = system.now(); 
                    }
                }
                
               }
            }
           if (hasError) return null;         
            database.update(crd);
        } catch (exception e) {
                   
            Database.rollback(sp);
           errorMessages.add(e.getMessage()); 
           return null;
        } /*}
        else {
        //No updates to be done if the user is not in the permission list
        } */
        Pagereference pageRef = new Pagereference(SECONDSCREEN + crd.Id);
        
        //condition to pass previous screen parameter
        if(previousPageMode == EDITTRUE){
            pageRef.getParameters().put(PARAMEDITMODE,EDITTRUE);
        }else if(previousPageMode == EDITFALSE){
            pageRef.getParameters().put(PARAMEDITMODE,EDITFALSE);
        }
        pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
            return pageRef;
            
    }
    /*Method for Next Button Story*/
    Public PageReference redirectToStep1() {
        try {
            database.update(crd);
        } catch (exception e) {
            return null;
        }
        Pagereference pageRef = new Pagereference(SECONDSCREEN + crd.Id);
        if(previousPageMode == EDITTRUE){
            pageRef.getParameters().put(PARAMEDITMODE,EDITTRUE);
        }else if(previousPageMode == EDITFALSE){
            pageRef.getParameters().put(PARAMEDITMODE,EDITFALSE);
        }
        pageRef.getParameters().put(PARAMGRPMEMBER,groupMember);
        return pageRef;
    }
    /*Method for displaying fields on First screen*/
    public PageReference showPanel() {
        try{
        if (crd.Standard_or_Custom_Plan__c == 'Creating a custom plan' || crd.Standard_or_Custom_Plan__c == 'Creating a package plan' || crd.Standard_or_Custom_Plan__c == 'Creating a packaged consumer business plan' || crd.Standard_or_Custom_Plan__c == 'Creating a HIX plan') {
            crd.Clone_TPID__c = null;
            crd.Clone_Owner_PPID__c = null;
            crd.Clone_Ben_ID__c = null;
            crd.Clone_RxPlan_ID__c = null;
            crd.Clone_Old_RxPlan_ID__c = null;
            crd.Clone_Account__c = null;
            crd.TPID_New_Value__c = null;
            crd.Owner_PPID_New_Value__c = null;
            crd.Ben_ID_New_Value__c = null;
            crd.RxPlan_ID_New_Value__c = null;
            crd.Old_RxPlan_ID_New_Value__c = null;
            crd.Account_New_Value__c = null;
            crd.Clone_Insured_Type__c = null;
            crd.Funding_Type_New_Value__c = null;
            crd.Standard_Plan_Selection__c = null;
        }
        return null;

    } catch(exception e){
        ApexPages.addMessages(e);
        return null;
    }
    }
    /*Method for Next Button Story*/
    public pageReference checkPublicGroup(){
        try{
        userId = UserInfo.getUserId();
        if(System.currentPagereference().getParameters().get(PARAMGRPMEMBER)==GRPMEMTRUE)
            groupMember=GRPMEMTRUE;
        else {    
            groupMember=GRPMEMFLASE;
        groupCheck = [Select g.Id,g.Name from Group g where Name =: PUBLICGROUP LIMIT 80000];
        groupId = groupcheck[0].id;
        groupMemberCheck = [Select g.UserOrGroupId, g.Id, g.GroupId From GroupMember g where GroupId =: groupId LIMIT 80000];
        
        for(GroupMember gm : groupMemberCheck){
             groupUserIds.add(string.valueof(gm.UserOrGroupId));
        }  
        
        for(string s : groupUserIds){
            if(s.contains(userId)){
            groupMember = GRPMEMTRUE;
        }
        }}
        return null;
    }catch(exception e){
        ApexPages.addMessages(e);
        return null;
    }
    }
}