/*
 * @author: Accenture
 * @date: 2011-09-21
 */
public class recordTypeSettingClass {

    public static Integer indexGen {get; set;}
    
     public class settingwrapper {
    
        private RecordTypeSetting__c recordsetting;
        private Integer index;  

         public settingwrapper() {
            this.recordsetting = new RecordTypeSetting__c(Name__c = 'Enter value', Profile__c = ApexPages.currentPage().getParameters().get('CF00N90000002c5Md_lkid'),
            Object__c = ApexPages.currentPage().getParameters().get('CF00N90000002c5MY_lkid'));
            this.index = indexGen++;
        }
        
        public RecordTypeSetting__c getrecordsetting() {
            return recordsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 

    public List<settingwrapper> settinglist;
    public Integer numRows {get; set;}
    
     
     public recordTypeSettingClass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        
        settinglist = new List<settingwrapper>();
        numRows = 1;
    }
    
    public List<settingwrapper> getsettinglist() {
        return settinglist;
}
 

public PageReference save() {
        try {
            List<RecordTypeSetting__c> tempList = new List<RecordTypeSetting__c>();
            for(Integer i=0; i<settinglist.size(); ++i)
                tempList.add(settinglist[i].getrecordsetting());
            upsert(tempList);
            
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
        }
        PageReference requestPage = new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        requestPage.setRedirect(false);
        return requestPage;
    }


        


    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    settinglist.add(new settingwrapper());
        } catch (Exception ex) {
        ApexPages.addMessages(ex);}
    }
    
    
    public void clear() {
        settinglist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<settinglist.size(); ++i)
                if(settinglist[i].index == delIndex) {
                    settinglist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}