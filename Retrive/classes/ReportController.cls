/*
 * @author: Accenture
 * @date: 2011-09-20
 * Controller class for adding multiple 'Report__c' records through a single page.
 * It provides functionality for dynamically creating new records and saving them all at once.
 */

public class ReportController {

    public static Integer indexGen {get; set;} //index generator
    public List<ReportWrapper> reportList;
    public Integer numRows {get; set;}
    
    /*
     * Wrapper class for holding a 'Report__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class ReportWrapper {
        private Report__c report;
        private Integer index;
    
        public ReportWrapper() {
            this.report = new Report__c(
                    Report_Name__c = 'Enter value',
                    Fields__c = 'Enter value',
                    Development_Environment__c = true);
            this.index = indexGen++;
        }
        
        public Report__c getReport() {
            return report;
        }
        
        public Integer getIndex() {
            return index;
        }
    }
    
    /*
     * Constructor
     * -----------
     * Initializes 'reportList' and 'numRows'
     */
    public ReportController(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
            
        reportList = new List<ReportWrapper>();
        numRows = 1;
    }
    
    public List<ReportWrapper> getReportList() {
        return reportList;
    }
    
    /*
     * upserts all records currently in the 'reportList'
     */
    public PageReference save() {
        if(reportList.size() == 0)
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        try {
            List<Report__c> tempList = new List<Report__c>();
            for(Integer i=0; i<reportList.size(); ++i)
                tempList.add(reportList[i].getReport());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    /*
     * appends new records to the 'reportList'.
     * The number of records added is determined by the value of 'numRows'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    reportList.add(new ReportWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
    }
    
    /*
     * Clears all records from the 'courseList'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void clear() {
        reportList.clear();
        numRows = 1;
    }
    
    /*
     * deletes a record from 'courseList' depending on the 'index' of 'Report__c' within the 'ReportWrapper' class
     */
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<reportList.size(); ++i)
                if(reportList[i].index == delIndex) {
                    reportList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}