/*
 * @author: Accenture
 * @date: 2011-09-20
 * Controller class for adding multiple 'Design_Setting__c' records through a single page.
 * It provides functionality for dynamically creating new records and saving them all at once.
 */

public class DesignSettingController {

    private static Integer indexGen = 1; //index generator
    
    /*
     * Wrapper class for holding a 'Design_Setting__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class DesignSettingWrapper {
        private Design_Setting__c designSetting;
        private Integer index;
    
        public DesignSettingWrapper() {
            this.designSetting = new Design_Setting__c(Name__c = 'Enter name', Category__c = 'Enter category', Reference_Number__c = 'Enter Refer. #', Development_Environment__c = true);
            this.index = indexGen++;
        }
        
        public Design_Setting__c getDesignSetting() {
            return designSetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    }

    public List<DesignSettingWrapper> dsList;
    public Integer numRows {get; set;}
    
    /*
     * Constructor
     * -----------
     * Initializes 'dsList' and 'numRows'
     */
    public DesignSettingController(ApexPages.StandardController controller) {
        dsList = new List<DesignSettingWrapper>();
        dsList.add(new DesignSettingWrapper());
        
        numRows = 1;
    }
    
    public List<DesignSettingWrapper> getDsList() {
        return dsList;
    }
    
    /*
     * upserts all records currently in the 'dsList'
     */
    public void save() {
        if(dsList.size() == 0) return;
        try {
            List<Design_Setting__c> tempList = new List<Design_Setting__c>();
            for(Integer i=0; i<dsList.size(); ++i)
                tempList.add(dsList[i].getDesignSetting());
            upsert(tempList);
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
        }
    }
    
    /*
     * appends new records to the 'dsList'.
     * The number of records added is determined by the value of 'numRows'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    dsList.add(new DesignSettingWrapper());
        } catch (Exception ex) {}
    }
    
    /*
     * Clears all records from the 'courseList'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void clear() {
        dsList.clear();
        numRows = 1;
    }
    
    /*
     * deletes a record from 'courseList' depending on the 'index' of 'Design_Setting__c' within the 'DesignSettingWrapper' class
     */
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<dsList.size(); ++i)
                if(dsList[i].index == delIndex) {
                    dsList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}