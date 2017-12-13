public class signOffSheetController {

    private static Integer indexGen = 1; //index generator

    public class SignOffSheetWrapper {
        private Sign_off_sheet__c soSheet;
        private Integer index;
    
        public SignOffSheetWrapper() {
            this.soSheet = new Sign_off_sheet__c(Name__c = 'Enter name', Approval_Comments__c = 'Enter Comments', Document_Id__c = 0, Document_Owner__c = 'Enter Owner', Document_Title__c= 'Enter title',Version__c = 0);
            this.index = indexGen++;
        }
        
        public Sign_off_sheet__c getSoSheet() {
            return soSheet;
        }
        
        public Integer getIndex() {
            return index;
        }
    }

    public List<SignOffSheetWrapper> soSheetList;
    public Integer numRows {get; set;}
    

    public signOffSheetController(ApexPages.StandardController controller) {
        soSheetList = new List<SignOffSheetWrapper>();
        
        numRows = 1;
    }
    
    public List<SignOffSheetWrapper> getSoSheetList() {
        return soSheetList;
    }
    

    public void saveRecords() {
        if(soSheetList.size() == 0) return;
        try {
            List<Sign_off_sheet__c> tempList = new List<Sign_off_sheet__c>();
            for(Integer i=0; i<soSheetList.size(); ++i)
                tempList.add(soSheetList[i].getSoSheet());
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
                    soSheetList.add(new SignOffSheetWrapper());
        } catch (Exception ex) {}
    }
    
    public void clear() {
        soSheetList.clear();
        numRows = 1;
    }
    
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<soSheetList.size(); ++i)
                if(soSheetList[i].index == delIndex) {
                    soSheetList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}