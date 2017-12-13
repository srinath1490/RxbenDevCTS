/*
 * @author: Accenture
 * @date: 2011-09-21
 */
public with sharing class profileClass {

    public static integer index {get; set;}
    public List<profDelWrapper> profileList;
    public Integer numRows {set;get;}
    
    public class profDelWrapper {
        public integer count;
        public Profile__c profileWrapper;        
        
        public profDelWrapper() {
            this.profileWrapper = new Profile__c(Profile_Name__c = 'Enter value');
            this.count = index++;
        }
        public Profile__c getProfileWrapper(){
            return profileWrapper;
        }
        public integer getCount(){
            return count;
        }
    }
    
    public profileClass(ApexPages.StandardController controller) {
        if(index == null) index = 1;
        
        profileList = new List<profDelWrapper>();
        numRows=1;
    }
    
    public List<profDelWrapper> getProfileList() {
        return profileList;
    }

    public PageReference save(){
    
        List<Profile__c> newList = new List<Profile__c>();
        for(Integer i=0;i<profileList.size();i++){
            newList.add(profileList[i].getProfileWrapper());
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
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
    }
    
    public void add(){
        try {
            if(numRows>0) {
                for(integer i=0;i<numRows;i++) {
                    profileList.add(new profDelWrapper());
                }
            }
        }
        catch(Exception e) {
            ApexPages.addMessages(e);
        }
    } 
    
    public void clear() {
        profileList.clear();
        numRows = 1;
    }
    
    public void del(){
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delId'));
            
            for(Integer i=0; i<profileList.size(); i++)
                if(profileList[i].count == delIndex) {
                    profileList.remove(i);
                    break;
                }
        } catch (Exception e) {
            ApexPages.addMessages(e);
        }
    }
    
    
    
   

}