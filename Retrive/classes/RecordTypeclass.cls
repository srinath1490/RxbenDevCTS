/*
 * @author : Accenture
 * @date : 2011-09-28
 */
public class RecordTypeclass {

   public static Integer indexGen {get; set;}
    public List<RTwrapper> RTlist;
    public Integer numRows {get; set;}
    

     public class RTwrapper {
    
        private     Record_Type__c RTsetting;
        private Integer index;  

        public RTwrapper() {
            this.RTsetting = new   Record_Type__c (Custom_Object__c = ApexPages.currentPage().getParameters().get('CF00NR00000011eku_lkid'));
            this.index = indexGen++;
        }
        
        public  Record_Type__c getRTsetting() {
            return RTsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
     public RecordTypeclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;

        RTlist = new List<RTwrapper>();
        numRows = 1;
    }
    
    public List<RTwrapper> getRTlist() {
        return RTlist;
}
 

public PageReference save() {
        try {
            List<   Record_Type__c> tempList = new List< Record_Type__c>();
            for(Integer i=0; i<RTlist.size(); ++i)
                tempList.add(RTlist[i].getRTsetting());
            upsert(tempList);
            return new PageReference ('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }


        


    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    RTlist.add(new RTwrapper());
        } 
        catch (Exception ex) {
        ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        RTlist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<RTlist.size(); ++i)
                if(RTlist[i].index == delIndex) {
                    RTlist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}