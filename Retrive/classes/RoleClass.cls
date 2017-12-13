/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class RoleClass {

    public static Integer indexGen {get; set;}
    public List<RoleWrapper> RoleList;
    public Integer numRows {get; set;}
    
    public class RoleWrapper {
    
        private Role_Heirarchy__c Role;
        private Integer index;  

         public RoleWrapper() {
            this.Role = new Role_Heirarchy__c (Name__c = 'Enter name'); 
            this.index = indexGen++;
        }
        
        public Role_Heirarchy__c getRole() {
            return Role;
                    }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
    public RoleClass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        RoleList = new List<RoleWrapper>();
        numRows = 1;
    }
    
    public List<RoleWrapper> getRoleList() {
        return RoleList;
}
 

public PageReference save() {
        try {
            if(!checkHistoryTracking())
                return null;
        
            List<Role_Heirarchy__c> tempList = new List<Role_Heirarchy__c>();
            for(Integer i=0; i<RoleList.size(); ++i)
                tempList.add(RoleList[i].getRole());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }

    private boolean checkHistoryTracking() {
        return true;
    }
        


    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    RoleList.add(new RoleWrapper());
        } 
        catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
    
    
    public void clear() {
        RoleList.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<RoleList.size(); ++i)
                if(RoleList[i].index == delIndex) {
                    RoleList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}