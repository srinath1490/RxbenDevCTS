/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class AssignmentClass {

    public static Integer indexGen {get; set;}
    public List<AssignmentWrapper> AssignmentList;
    public Integer numRows {get; set;}
    
    public class AssignmentWrapper {
    
        public Assignment_Rule__c AssignmentRule;
        public Integer index;  

         public AssignmentWrapper() {
            this.AssignmentRule = new Assignment_Rule__c (Rule_Name__c= 'Enter name');
            this.index = indexGen++;
        }
        
        public Assignment_Rule__c getAssignmentRule() {
            return AssignmentRule;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
    public AssignmentClass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        AssignmentList = new List<AssignmentWrapper>();
        numRows = 1;
    }
    
    public List<AssignmentWrapper> getAssignmentList() {
        return AssignmentList;
}
 

public PageReference save() {
        try {
            if(!checkHistoryTracking())
                return null;
        
            List<Assignment_Rule__c> tempList = new List<Assignment_Rule__c>();
            for(Integer i=0; i<AssignmentList.size(); ++i)
                tempList.add(AssignmentList[i].getAssignmentRule());
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
                    AssignmentList.add(new AssignmentWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
    }
    
    
    public void clear() {
        AssignmentList.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<AssignmentList.size(); ++i)
                if(AssignmentList[i].index == delIndex) {
                    AssignmentList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}