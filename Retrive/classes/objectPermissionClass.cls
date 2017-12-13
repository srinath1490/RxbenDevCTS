/*
 * @author: Accenture
 * @date: 2011-09-21
 */
public with sharing class objectPermissionClass {

    public List<profDelWrapper> objectPermissionList{get;set;}
    public Integer numRows{set;get;}
    public static integer index {get; set;}
    
    
    public class profDelWrapper{
            public integer count;
            public ObjectPermission__c profileWrapper; 
            public integer getCount(){
                return count;
            }
            public ObjectPermission__c getProfileWrapper(){
                return profileWrapper;
            }
            public profDelWrapper(){
                this.profileWrapper = new ObjectPermission__c(Name__c = 'Enter value', Profile__c = ApexPages.currentPage().getParameters().get('CF00N90000002c5LV_lkid'),
                        Custom_Objects__c=ApexPages.currentPage().getParameters().get('CF00N90000002c5LL_lkid'));
                this.count = index++;
            }
    }
    
    public objectPermissionClass(ApexPages.StandardController controller){
        if(index == null) index = 1;
        
        objectPermissionList = new List<profDelWrapper>();
        numRows=1;
    }
    
    public PageReference save(){
    
        List<ObjectPermission__c> newList = new List<ObjectPermission__c>();
        for(Integer i=0;i<objectPermissionList.size();i++){
            newList.add(objectPermissionList[i].getProfileWrapper());
        }
        try{
            if(newList!=null){
                upsert(newList);
            }
         } 
        catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
        PageReference requestPage = new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        requestPage.setRedirect(false);
        return requestPage;
    }
    
    public void del(){
     try {
            Integer delId = Integer.valueOf(ApexPages.currentPage().getParameters().get('delId'));
            
            for(Integer i=0; i<objectPermissionList.size(); ++i)
                if(objectPermissionList[i].count == delId) {
                    objectPermissionList.remove(i);
                    break;
                }
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
  
    }

    public void add(){
      try{
            if(numRows>0)
            {
                for(integer i=0;i<numRows;i++)
                {
                    objectPermissionList.add(new profDelWrapper());
                }
            }
         }
         catch(Exception e){
             ApexPages.addMessages(e);

         }
    } 
 public void clear() {
          objectPermissionList.clear();
        numRows = 1;
    }

}