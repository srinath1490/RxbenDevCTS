/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class timeTriggerController{
    
 
   public static Integer indexGen {get; set;} //index generator
    
    /*
     * Wrapper class for holding a 'Time_Trigger__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class TimeTriggerWrapper {
        private Time_Trigger__c timeTriggerObj;
        private Integer index;
     
     
     public TimeTriggerWrapper() {
            this.timeTriggerObj = new Time_Trigger__c(Action_Name__c = 'Enter value',
            Workflows_Approval__c = ApexPages.currentPage().getParameters().get('CF00NU0000001YrCt_lkid'));
            this.index = indexGen++;
        }
        
        public Time_Trigger__c getTimeTriggerObj() {
            return timeTriggerObj;
        }
        
        public Integer getIndex() {
            return index;
        }
    }
    
    public List<TimeTriggerWrapper> ttList;
    public Integer numRows {get; set;}
    
     /*
     * Constructor
     * -----------
     * Initializes 'qList' and 'numRows'
     */
    public timeTriggerController(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        ttList = new List<TimeTriggerWrapper>();
        numRows = 1;
    }
    public List<TimeTriggerWrapper> getTTList() {
        return ttList;
            }

    

     
    /*
     * upserts all records currently in the 'dsList'
     */
     public  PageReference save() {
            try {
            List<Time_Trigger__c> tempList = new List<Time_Trigger__c>();
            for(Integer i=0; i<ttList.size(); i++){
                
                Time_Trigger__c tt = ttList[i].getTimeTriggerObj();
                tt.Action_Name__c = tt.Action_Name__c.replace(' ', '_');
                tt.Action_Name__c = tt.Action_Name__c.replace('__', '_');
                if(tt.Email_Templates__c!=NULL)
                { tt.Email_Templates__c = tt.Email_Templates__c.replace(' ', '');
                  tt.Email_Templates__c = 'unfiled$public/' + tt.Email_Templates__c;
                  }
                if(tt.Recipient_Type__c!=NULL)
                tt.Recipient_Type__c = tt.Recipient_Type__c.replace(' ', '');
                if(tt.Sender_Type__c!=NULL)
                tt.Sender_Type__c = tt.Sender_Type__c.replace(' ', '');
                tempList.add(ttList[i].getTimeTriggerObj());
                }
                if(tempList.size()!=0)
                upsert(tempList);
                return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
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
                    ttList.add(new TimeTriggerWrapper());
        } 
        catch (Exception ex) {
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
     * deletes a record from 'ttList' depending on the 'index' of 'Time_Trigger__c' within the 'TimeTriggerWrapper' class
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