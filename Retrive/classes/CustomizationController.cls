/*
 * @author: Accenture
 * @date: 2011-09-20
 * Controller class for adding multiple 'Customization__c' records through a single page.
 * It provides functionality for dynamically creating new records and saving them all at once.
 */

public class CustomizationController {

    public static Integer indexGen {get; set;} //index generator
    
    /*
     * Wrapper class for holding a 'Customization__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class CustomizationWrapper {
        public Customization__c customization;
        public Integer index;
    
        public CustomizationWrapper() {
            this.customization = new Customization__c(
                    Name__c = 'Enter value',
                    Label__c = 'Enter value');
            this.index = indexGen++;
        }
        
        public Customization__c getCustomization() {
            return customization;
        }
        
        public Integer getIndex() {
            return index;
        }
    }

    public List<CustomizationWrapper> customizationList;
    public Integer numRows {get; set;}
    
    /*
     * Constructor
     * -----------
     * Initializes 'customizationList' and 'numRows'
     */
    public CustomizationController(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        
        customizationList = new List<CustomizationWrapper>();
        numRows = 1;
    }
    
    public List<CustomizationWrapper> getCustomizationList() {
        return customizationList;
    }
    
    /*
     * upserts all records currently in the 'customizationList'
     */
    public PageReference save() {
        if(customizationList.size() == 0)
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        try {
            List<Customization__c> tempList = new List<Customization__c>();
            for(Integer i=0; i<customizationList.size(); ++i)
                tempList.add(customizationList[i].getCustomization());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    /*
     * appends new records to the 'customizationList'.
     * The number of records added is determined by the value of 'numRows'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    customizationList.add(new CustomizationWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
    }
    
    /*
     * Clears all records from the 'courseList'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void clear() {
        customizationList.clear();
        numRows = 1;
    }
    
    /*
     * deletes a record from 'courseList' depending on the 'index' of 'Customization__c' within the 'CustomizationWrapper' class
     */
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<customizationList.size(); ++i)
                if(customizationList[i].index == delIndex) {
                    customizationList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}