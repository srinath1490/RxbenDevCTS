/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class queueController{



 public static Integer indexGen {get; set;} //index generator
    
    /*
     * Wrapper class for holding a 'Queue__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class QueueWrapper {
        private Queue__c queue;
        private Integer index;
     
     
        public QueueWrapper() {
            this.queue = new Queue__c(Queue_Name__c= 'Enter value');
            this.index = indexGen++;
        }
        
        public Queue__c getQueue() {
            return queue;
        }
        
        public Integer getIndex() {
            return index;
        }
    }
    
    public List<QueueWrapper> qList;
    public Integer numRows {get; set;}
    
    /*
     * Constructor
     * -----------
     * Initializes 'qList' and 'numRows'
     */
    public queueController(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
            
        qList = new List<QueueWrapper>();
        numRows = 1;
    }
    public List<QueueWrapper> getQList() {
        return qList;
    }

    
  /*
     * upserts all records currently in the 'qList'
     */
    public PageReference save() {
        if(qList.size()==0)
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        try {
            List<Queue__c> tempList = new List<Queue__c>();
            for(Integer i=0; i<qList.size(); ++i)
                tempList.add(qList[i].getQueue());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    
    
     /*
     * appends new records to the 'qList'.
     * The number of records added is determined by the value of 'numRows'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void add() {
          try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    qList.add(new QueueWrapper());
        } 
        catch (Exception ex) {
           ApexPages.addMessages(ex);
        }
   }
    
    
    /*
     * Clears all records from the 'qList'
     * Issues with the method: Not working if mandatory fields are left empty
     */        
    public void clear(){
        qList.clear();
        numRows = 1;
         }
     

    /*
     * deletes a record from 'qList' depending on the 'index' of 'Queue__c' within the 'QueueWrapper' class
     */
     public void delRecords(){
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<qList.size(); ++i)
                if(qList[i].index == delIndex) {
                    qList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
    
       
             
   }