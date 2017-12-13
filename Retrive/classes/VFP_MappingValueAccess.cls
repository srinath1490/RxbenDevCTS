/*Purpose: Trigger handler to give access of the Mapping value only to the owner/approver of the record 
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Joognu Rao            2/21/2015       give access of the Mapping value only to the owner/approver of the record  
   
======================================================================== */

public with sharing class VFP_MappingValueAccess{
    
    
    public static Map<Id,Id>mapOwner = new Map<Id,Id>();
    public static List<Id>lstQueue = new List<Id>();    
    public static Map<Id,List<Id>> mapQueueToUser = new Map<Id,List<Id>>();
    public static Map<Id,List<Id>> mapLvToMv = new Map<Id,List<Id>>();
    public static List<Id>lstLV = new List<Id>();
    public static boolean bAccess = true;
    
     /**
    * Method :- onBeforeUpdate
    * Description :- Method to give access of the Mapping value only to the owner/approver of the record 
    **/
    public static void onBeforeUpdate(List<Mapping_Values__c> newRec, List<Mapping_Values__c> oldRec){
            
            for(Mapping_Values__c mv : newRec)
            {
                lstLV.add(mv.Line_ValueID__c);
            }
            
          for(LineValue__c lv : [select id,Mapping_Request__r.OwnerId,Mapping_Request__r.Approved__c from LineValue__c where id IN :lstLV AND Mapping_Request__c!=null AND Active__c=false AND Mapping_Request__r.Approved__c = false]){
            mapOwner.put(lv.id,lv.Mapping_Request__r.OwnerId);
            system.debug('***'+mapOwner);
            system.debug('***'+lv.Mapping_Request__r.OwnerId);
          }
          
          for(string s : mapOwner.values()){
            if(s.startswith('00G')){
                lstQueue.add(s);
            }
          }
          system.debug('***'+lstQueue);
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
          for(Mapping_Values__c lv : newRec){
            if(string.valueOf(mapOwner.get(lv.Line_ValueID__c)).startswith('00G')){
                for(id userid : mapQueueToUser.get(mapOwner.get(lv.Line_ValueID__c))){
                    if(userInfo.getUserid()==userid){
                        bAccess = false;                       
                    }
                }
                if(bAccess==true){
                    lv.addError(label.LVMVaccessError);
                }
            }else{
                if(userInfo.getUserid()!=mapOwner.get(lv.Line_ValueID__c)){
                        lv.addError(label.LVMVaccessError);
                    }
            }
            
          }
        }  
    }
}