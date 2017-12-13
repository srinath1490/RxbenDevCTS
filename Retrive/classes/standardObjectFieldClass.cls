/*Author:Rishabh Rawat
 */

public class standardObjectFieldClass {

    public static Integer indexGen {get; set;}
    public class StandardObjectFieldWrapper { 
        public StandardObjectField__c stdField;
        public Integer index;
    
        public StandardObjectFieldWrapper() {
            this.stdField = new StandardObjectField__c(Field_Name__c = 'Enter name');
            this.index = indexGen++;
        }
        
        public StandardObjectField__c getStdField() {
            return stdField;
        }
        public void setStdField(StandardObjectField__c s) {
            stdField = s;
        }
        
        public Integer getIndex() {
            return index;
        }
    }

    public List<StandardObjectFieldWrapper> stdFieldList;
    public Integer numRows {get; set;}

    public standardObjectFieldClass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
            
        stdFieldList = new List<StandardObjectFieldWrapper>();
        numRows = 1;
    }
    
    public List<StandardObjectFieldWrapper> getStdFieldList() {
        return stdFieldList;
    }
    
    public PageReference save() {
        if(stdFieldList.size() == 0)
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        try {
            List<StandardObjectField__c> tempList = new List<StandardObjectField__c>();
            for(Integer i=0; i<stdFieldList.size(); ++i)
                tempList.add(stdFieldList[i].getStdField());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    public void add() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    stdFieldList.add(new StandardObjectFieldWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
    }
    
    public void clear() {
        stdFieldList.clear();
        numRows = 1;
    }
    
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<stdFieldList.size(); ++i)
                if(stdFieldList[i].index == delIndex) {
                    stdFieldList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }

}