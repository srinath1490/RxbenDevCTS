/*
 * @author: Accenture
 * @date: 2011-09-21
 * Controller class for adding multiple 'Workflow_Field_Update__c' records through a single page.
 * It provides functionality for dynamically creating new records and saving them all at once.
 */

public class WorkflowFieldUpdateController {

    public static Integer indexGen {get; set;} //index generator
    public List<WorkflowFieldUpdateWrapper> wfuList;
    public Integer numRows {get; set;}
    
    /*
     * Wrapper class for holding a 'Workflow_Field_Update__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class WorkflowFieldUpdateWrapper {
        private Workflow_Field_Update__c wfUpdate;
        private Integer index;
    
        public WorkflowFieldUpdateWrapper() {
            this.wfUpdate = new Workflow_Field_Update__c(Workflow_Field_Update_Name__c = 'Enter name', 
                    Field_To_Update__c = ApexPages.currentPage().getParameters().get('CF00N90000002c53C_lkid'),
                    Workflow_Approval_Object__c = ApexPages.currentPage().getParameters().get('CF00N90000002c5KE_lkid'));
            this.index = indexGen++;
        }
        
        public Workflow_Field_Update__c getWfUpdate() {
            return wfUpdate;
        }
        
        public Integer getIndex() {
            return index;
        }
    }
    
    /*
     * Constructor
     * -----------
     * Initializes 'wfuList' and 'numRows'
     */
    public WorkflowFieldUpdateController(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        
        wfuList = new List<WorkflowFieldUpdateWrapper>();
        numRows = 1;
    }
    
    public List<WorkflowFieldUpdateWrapper> getWfuList() {
        return wfuList;
    }
    
    /*
     * upserts all records currently in the 'wfuList'
     */
    public PageReference save() {
        if(wfuList.size() == 0) return null;
        try {
            List<Workflow_Field_Update__c> tempList = new List<Workflow_Field_Update__c>();
            for(Integer i=0; i<wfuList.size(); ++i)
                tempList.add(wfuList[i].getWfUpdate());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    /*
     * appends new records to the 'wfuList'.
     * The number of records added is determined by the value of 'numRows'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    wfuList.add(new WorkflowFieldUpdateWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
         }
    }
    
    /*
     * Clears all records from the 'courseList'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void clear() {
        wfuList.clear();
        numRows = 1;
    }
    
    /*
     * deletes a record from 'courseList' depending on the 'index' of 'Workflow_Field_Update__c' within the 'WorkflowFieldUpdateWrapper' class
     */
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<wfuList.size(); ++i)
                if(wfuList[i].index == delIndex) {
                    wfuList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}