/* Apex Class for Redirecting to User to CRD Screens depending upon CRD Edit Mode Public Group */
public class VFP_CRDFirstPageRedirection {
    public string crdid{get;set;}
    public crd__c crd{get;set;}
    public string userId{get;set;} 
    public string editMode{get;set;} 
    public string PUBLICGROUP {get;set;} 
    public string groupID{get;set;}   
    public list<group> groupCheck{get;set;}  
    public list<GroupMember> groupMemberCheck{get;set;}  
    public string groupMember{get;set;}  
    private static final string EDITTRUE = 'BCTME';
    private static final string EDITFALSE = 'BCTNR';
    private static final string GRPMEMTRUE = 'RUME';
    private static final string GRPMEMFLASE = 'RUNR';
    private static final string FIRSTSCREEN = '/apex/VF_CRDFirstScreen?id=';
    PRIVATE STATIC FINAL STRING FIRSTSCREENNEW = '/apex/VF_CRDFirstScreen';
    PRIVATE STATIC FINAL STRING ERRORSCREEN = '/apex/VF_CRDErrorScreen';
    PRIVATE STATIC FINAL STRING PARAMEDITMODE = 'p1';
    private static final string PARAMGRPMEMBER ='p2';
    
    Pagereference pageRef ;
    public list<string> groupUserIds = new list<string>();  
    
    /*Class Constructor*/
    public VFP_CRDFirstPageRedirection(ApexPages.StandardController controller) {
        
    }
/* Method :checkPublicGroup(): Performs redirecton of user to CRD Screens depending upon CRD Edit Group on Page Load */
    public pageReference checkPublicGroup(){
        crdId = ApexPages.CurrentPage().getParameters().get('id'); //Collect CRDID
        
        PUBLICGROUP = System.Label.PublicGroupCRDEditMode;
        userId = UserInfo.getUserId();
        
        //Check whether the user is present in the Public Group
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
        }
        
        //Below Scenario Considers whether the user is trying to reach the CRD from New button or Clicking on View of Existing CRD
        // New CRD will not have a CRDID but an existing CRD will have a CRDID
        
        //Below Case for NEW CRD Creation
        if(crdid == null){
            // If User is part of Edit group, User should reach first screen in Edit Mode
            if(groupmember == GRPMEMTRUE){
                    pageRef = new Pagereference(FIRSTSCREENNEW);       
                    pageRef.getParameters().put(PARAMEDITMODE,EDITTRUE);
                    pageRef.getParameters().put(PARAMGRPMEMBER,GRPMEMTRUE);
            }
                //If user is not a part of Edit Group, User should be redirected to an Error Screen
                else {
                    pageRef = new Pagereference(ERRORSCREEN);
                }
        }
        //Below Case for Viewing an EXISTING CRD
            else if(crdid != null){
                //If User is part of Edit group, User should reach first screen in Read Only Mode 
                if(groupmember == GRPMEMTRUE){
                    pageRef = new Pagereference(FIRSTSCREEN + crdId);
                    pageRef.getParameters().put(PARAMEDITMODE,EDITFALSE);
                    pageRef.getParameters().put(PARAMGRPMEMBER,GRPMEMTRUE);
                }
                  //If user is not a part of Edit Group, User should be redirected to Second Screen of CRD in Read Only Mode
                    else {
                    pageRef = new Pagereference(FIRSTSCREEN + crdId);
                    pageRef.getParameters().put(PARAMEDITMODE,EDITFALSE);
                    pageRef.getParameters().put(PARAMGRPMEMBER,GRPMEMFLASE);
                }
            }
        
        return pageRef;
    }
    
    
}