/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class ruleCriteriaController{


    public static Integer indexGen {get; set;} //index generator
    public List<ruleCriteriaWrapper> ttList;
    public Integer numRows {get; set;}

    
    /*
     * Wrapper class for holding a 'Rule_Criteria__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class ruleCriteriaWrapper {
        private Rule_Criteria__c ruleCriteriaObj;
        private Integer index;
     
     
     public ruleCriteriaWrapper() {
            this.ruleCriteriaObj = new Rule_Criteria__c(
                    Name__c = 'Enter value',
                    Trigger_Type__c = 'on Create Or Triggering Update',
                    Workflows_Approval__c = (id)ApexPages.currentPage().getParameters().get('CF00NU0000001YrCo_lkid'),
                    Use_Rule_When__c = 'Criteria are met');
//            Field__c = ApexPages.currentPage().getParameters().get('CF00NU0000001YrCo_lkid'));
            this.index = indexGen++;
        }
        
        public Rule_Criteria__c getruleCriteriaObj() {
            return ruleCriteriaObj;
        }
        
        public Integer getIndex() {
            return index;
        }
    }
        
    /*
     * Constructor
     * -----------
     * Initializes 'ttList' and 'numRows'
     */
    public ruleCriteriaController(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
            
        ttList = new List<ruleCriteriaWrapper>();
        numRows = 1;
    }
    public List<ruleCriteriaWrapper> getttList() {
        return ttList;
    }


     
    /*
     * upserts all records currently in the 'ttList'
     */
    public PageReference save() {
        if(ttList.size()==0)
            return null;
            try {
            system.debug('\n CF00NU0000001YrCo_lkid value here '+ttList);
            List<Rule_Criteria__c> tempList = new List<Rule_Criteria__c>();
            for(Integer i=0; i<ttList.size(); ++i){
             Rule_Criteria__c rc = ttList[i].getruleCriteriaObj();
                rc.Name__c = rc.Name__c.replace(' ', '_');
                rc.Name__c = rc.Name__c.replace('__', '_');
                tempList.add(rc);
                }
                upsert(tempList);
                           return new PageReference ('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    
     /*
     * appends new records to the 'ttList'.
     * The number of records added is determined by the value of 'numRows'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void add() {
          try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    ttList.add(new ruleCriteriaWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
   }
    
    
    /*
     * Clears all records from the 'ttList'
     * Issues with the method: Not working if mandatory fields are left empty
     */        
    public void clearRecord(){
        ttList.clear();
        numRows = 1;
         }
     

    /*
     * deletes a record from 'ttList' depending on the 'index' of 'ruleCriterias__c' within the 'ruleCriteriaWrapper' class
     */
     public void delRecords(){
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<ttList.size(); ++i)
                if(ttList[i].index == delIndex) {
                    ttList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
    
       
             
   }