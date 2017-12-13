/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class customObjectController{


    public static Integer indexGen {get; set;} //index generator
    public List<CustomObjectWrapper> coList;
    public Integer numRows {get; set;}

    
    /*
     * Wrapper class for holding a 'CustomObjects__c' record and its row index together.
     * The row index is used to delete the row using commandLink
     */
    public class CustomObjectWrapper {
        private CustomObjects__c customObject;
        private Integer index;
     
     
     public CustomObjectWrapper() {
            this.customObject = new CustomObjects__c(
                    Label__c = 'Enter value',
                    Plural_Label__c = 'Enter value',
                    Object_Name__c = 'Enter value',
                    Record_Name__c = 'Enter value',
                    Name_Type__c = 'Text',
                    Auto_Number_Format__c='A-{0000}',
                    Deployment_Status__c='Deployed');
            this.index = indexGen++;
        }
        
        public CustomObjects__c getCustomObject() {
            return customObject;
        }
        
        public Integer getIndex() {
            return index;
        }
    }
        
    /*
     * Constructor
     * -----------
     * Initializes 'coList' and 'numRows'
     */
    public customObjectController(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        coList = new List<CustomObjectWrapper>();
        numRows = 1;
    }
    public List<CustomObjectWrapper> getCoList() {
        return coList;
    }


     
    /*
     * upserts all records currently in the 'coList'
     */
    public PageReference save() {
        if(coList.size()==0)
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        try {
            
            List<CustomObjects__c> tempList = new List<CustomObjects__c>();
           
            for(Integer i=0; i<coList.size(); ++i){
           
            CustomObjects__c co=coList[i].getCustomObject();
            co.Object_Name__c = co.Object_Name__c.replace(' ', '_');
                co.Object_Name__c = co.Object_Name__c.replace('__', '_');
            if ((co.Object_Name__c!='Account')&&(co.Object_Name__c!='Contact')&&(co.Object_Name__c!='Opportunity')&&(co.Object_Name__c!='Case')&&(co.Object_Name__c!='Lead')&&(co.Object_Name__c!='Contract')&&(co.Object_Name__c!='Campaign')&&(co.Object_Name__c!='Solution')&&(co.Object_Name__c!='Event')&&(co.Object_Name__c!='Task')&&(co.Object_Name__c!='Asset')){
                co.Object_Name__c += '__c';
            }
                tempList.add(co);
                }
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    
    
     /*
     * appends new records to the 'coList'.
     * The number of records added is determined by the value of 'numRows'
     * Issues with the method: Not working if mandatory fields are left empty
     */
    public void add() {
          try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    coList.add(new CustomObjectWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
   }
    
    
    /*
     * Clears all records from the 'coList'
     * Issues with the method: Not working if mandatory fields are left empty
     */        
    public void clear(){
        coList.clear();
        numRows = 1;
         }
     

    /*
     * deletes a record from 'coList' depending on the 'index' of 'CustomObjects__c' within the 'CustomObjectWrapper' class
     */
     public void delRecords(){
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<coList.size(); ++i)
                if(coList[i].index == delIndex) {
                    coList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
    
       
             
   }