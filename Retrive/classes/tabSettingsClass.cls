/*
 * @author: Accenture
 * @date: 2011-09-21
 */
public with sharing class tabSettingsClass {
    public List<profDelWrapper> tabSettingList{get;set;}
    public Integer numRows{set;get;}
    public static integer index {get; set;}
    
    public tabSettingsClass(ApexPages.StandardController controller) {
         if(index == null) index = 1;
         tabSettingList = new List<profDelWrapper>();
          numRows=1;
    }
    
    public class profDelWrapper{
            public integer count;
            public TabSetting__c profileWrapper;
            public integer getCount(){
                return count;
            }
            public TabSetting__c getProfileWrapper(){
                return profileWrapper;
            }
            public profDelWrapper(){
                this.profileWrapper = new TabSetting__c(Name__c = 'Enter value',Profile__c = ApexPages.currentPage().getParameters().get('CF00N90000002c5Nl_lkid'),
                Object__c = ApexPages.currentPage().getParameters().get('CF00N90000002c5O0_lkid'));
                this.count = index++;
            }
            
    }
    
    public PageReference save(){
    
        List<TabSetting__c> newList = new List<TabSetting__c>();
        for(Integer i=0;i<tabSettingList.size();i++){
            newList.add(tabSettingList[i].getProfileWrapper());
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
            
            for(Integer i=0; i<tabSettingList.size(); ++i)
                if(tabSettingList[i].count == delId) {
                    tabSettingList.remove(i);
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
                   tabSettingList.add(new profDelWrapper());
                }
            }
         }
         catch(Exception e){
             ApexPages.addMessages(e);

         }
    } 
    public void clear() {
          tabSettingList.clear();
        numRows = 1;
    }

}