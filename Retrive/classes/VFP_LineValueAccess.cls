/*Purpose: Trigger handler to give access of the Line value only to the owner/approver of the record 
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Joognu Rao            2/20/2015       give access of the Line value only to the owner/approver of the record  
   2.0 -    Richa                 5/15/2015       Implemented Req 5759 to update the LineValue Name field with new LineValue Number
======================================================================== */

public with sharing class VFP_LineValueAccess{
    
   
    
    public static Map<Id,Id>mapOwner = new Map<Id,Id>();
    public static List<Id>lstQueue = new List<Id>();    
    public static Map<Id,List<Id>> mapQueueToUser = new Map<Id,List<Id>>();
    public static boolean bAccess = true;
    public static Map<Id,decimal> oldLVmap = new Map<Id,decimal>();
    public static Map<Id,LineValue__c> newLVmap = new Map<Id,LineValue__c>();
    
    /**
    * Method :- onBeforeUpdate
    * Description :- Method to give access of the Line value only to the owner/approver of the record 
    **/
    public static void onBeforeUpdate(List<LineValue__c> newRec, List<LineValue__c> oldRec){
        
        
          for(LineValue__c lv : [select id,Line_value__c,Mapping_Request__r.OwnerId,Mapping_Request__r.Approved__c,Provision_ID__r.ProvisionNumber__c from LineValue__c where id IN :newRec AND Mapping_Request__c!=null AND Active__c=false AND Mapping_Request__r.Approved__c = false]){
            mapOwner.put(lv.id,lv.Mapping_Request__r.OwnerId);
            newLVmap.put(lv.id,lv);
          }
          for(LineValue__c oldLvRec : [select id,Line_value__c from LineValue__c where id IN :oldRec AND Mapping_Request__c!=null AND Active__c=false AND Mapping_Request__r.Approved__c = false]){
            oldLVmap.put(oldLvRec.id,oldLvRec.Line_Value__c);
          }          
          
          for(string s : mapOwner.values()){
            if(s.startswith('00G')){
                lstQueue.add(s);
            }
          }
          
          if(!lstQueue.IsEmpty() && lstQueue.size()!=0){
            List<GroupMember> lstGM = [Select id, GroupId, UserOrGroupId From GroupMember Where GroupId In :lstQueue];
            if(!lstGM.IsEmpty() && lstGM.size()!=0){
                for(GroupMember gm : lstGM){
                    if(mapQueueToUser.containsKey(gm.GroupId)){
                        mapQueueToUser.get(gm.GroupId).add(gm.UserOrGroupId);
                    }else{
                        mapQueueToUser.put(gm.GroupId,new list<Id>{gm.UserOrGroupId});
                    }
                    
                }
            }
          }
            if(mapOwner!=null && !mapOwner.IsEmpty()){
              for(LineValue__c lv : newRec){
                if(string.valueOf(mapOwner.get(lv.id)).startswith('00G')){
                    for(id userid : mapQueueToUser.get(mapOwner.get(lv.id))){                   
                        if(userInfo.getUserid()==userid){
                            bAccess = false; 
                            //Implemented Req 5759 to update the LineValue Name field with new LineValue Number 
                            if(lv.Line_value__c != oldLVmap.get(lv.id)){
                                lv.Name = 'P' + newLVmap.get(lv.id).Provision_ID__r.ProvisionNumber__c + 'L' + lv.Line_value__c;
                            }                       
                        }
                    }
                    if(bAccess==true){
                        lv.addError(label.LVMVaccessError);
                    }
                }else{
                    if(userInfo.getUserid()!=mapOwner.get(lv.id)){
                            lv.addError(label.LVMVaccessError);
                        } else {
                                if(lv.Line_value__c != oldLVmap.get(lv.id)){
                                lv.Name = 'P' + newLVmap.get(lv.id).Provision_ID__r.ProvisionNumber__c + 'L' + lv.Line_value__c;
                            }
                            }
                }
              }
          }
          
    }
}