/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class DataLoaderController {

    private static Integer indexGen = 1; //index generator

    public class DataLoaderWrapper {
        private DataLoader__c dataLoader;
        private Integer index;
    
        public DataLoaderWrapper() {
            this.dataLoader = new DataLoader__c(Name__c = 'Enter name',Custom_Objects__c = ApexPages.currentPage().getParameters().get('CF00N90000002c503_lkid'));
            this.index = indexGen++;
        }
        
        public DataLoader__c getDataLoader() {
            return dataLoader;
        }
        
        public Integer getIndex() {
            return index;
        }
    }

    public List<DataLoaderWrapper> dataLoaderList;
    public Integer numRows {get; set;}
    

    public DataLoaderController(ApexPages.StandardController controller) {
        dataLoaderList = new List<DataLoaderWrapper>();
        dataLoaderList.add(new DataLoaderWrapper());
        numRows = 1;
    }
    
    public List<DataLoaderWrapper> getDataLoaderList() {
        return dataLoaderList;
    }
    

    public PageReference save() {
        
        try {
            List<DataLoader__c> tempList = new List<DataLoader__c>();
            for(Integer i=0; i<dataLoaderList.size(); ++i)
                tempList.add(dataLoaderList[i].getDataLoader());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('CF00N90000002c503_lkid'));

        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    public void addRecord() {
        try {
        
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    dataLoaderList.add(new DataLoaderWrapper());
        } catch (Exception ex) {}
    }
    
    public void clear() {
        dataLoaderList.clear();
        numRows = 1;
    }
    
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<dataLoaderList.size(); ++i)
                if(dataLoaderList[i].index == delIndex) {
                    dataLoaderList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
    }