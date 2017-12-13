/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class DocumentControlController {

    private static Integer indexGen = 1; //index generator

    public class DocumentControlWrapper {
        private DocumentControl__c documentControl;
        private Integer index;
    
        public DocumentControlWrapper() {
            this.documentControl = new DocumentControl__c(Name__c = 'Enter name', Details_Of_Change__c = 'Enter details', Reason__c = 'Enter reason',Refrence_No__c='Enter Refer. #' ,Release__c= 0,Version__c = 0);
            this.index = indexGen++;
        }
        
        public DocumentControl__c getDocumentControl() {
            return documentControl;
        }
        
        public Integer getIndex() {
            return index;
        }
    }

    public List<DocumentControlWrapper> documentControlList;
    public Integer numRows {get; set;}
    

    public DocumentControlController(ApexPages.StandardController controller) {
        documentControlList = new List<DocumentControlWrapper>();
        
        numRows = 1;
    }
    
    public List<DocumentControlWrapper> getDocumentControlList() {
        return documentControlList;
    }
    

    public void save() {
        if(documentControlList.size() == 0) return;
        try {
            List<DocumentControl__c> tempList = new List<DocumentControl__c>();
            for(Integer i=0; i<documentControlList.size(); ++i)
                tempList.add(documentControlList[i].getDocumentControl());
            upsert(tempList);
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
        }
    }
    
    public void addRecord() {
        try {
        system.debug('\n --Value of No Of Row Element--'+numRows);
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    documentControlList.add(new DocumentControlWrapper());
        } catch (Exception ex) {}
    }
    
    public void clear() {
        documentControlList.clear();
        numRows = 1;
    }
    
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<documentControlList.size(); ++i)
                if(documentControlList[i].index == delIndex) {
                    documentControlList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}