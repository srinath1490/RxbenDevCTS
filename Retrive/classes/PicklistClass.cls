/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class PicklistClass {

    public static Integer indexGen {get; set;}
    public List<PicklistWrapper> PLList;
    public Integer numRows {get; set;}
    
    public class PicklistWrapper {
    
        private Picklist_Details__c Picklist;
        private Integer index;  

         public PicklistWrapper() {
            this.Picklist = new Picklist_Details__c (Name__c = 'Enter name');
            this.index = indexGen++;
        }
        
        public Picklist_Details__c getPicklist() {
            return Picklist;
                    }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
    public PicklistClass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        PLList = new List<PicklistWrapper>();
        numRows = 1;
    }
    
    public List<PicklistWrapper> getPLList() {
        return PLList;
}
 

public PageReference save() {
        try {
            if(!checkHistoryTracking())
                return null;
        
            List<Picklist_Details__c> tempList = new List<Picklist_Details__c>();
            for(Integer i=0; i<PLList.size(); ++i)
                tempList.add(PLList[i].getPicklist());
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
                    PLList.add(new PicklistWrapper());
        } 
        catch (Exception ex) {
            ApexPages.addMessages(ex);
          }
    }
    
    
    public void clear() {
        PLList.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<PLList.size(); ++i)
                if(PLList[i].index == delIndex) {
                    PLList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}