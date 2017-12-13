/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class CustomButtonLinkclass {

   public static Integer indexGen {get; set;}
    public List<CBLwrapper> CBLlist;
    public Integer numRows {get; set;}
    

     public class CBLwrapper {
    
        private     Custom_Buttons_and_Links__c CBLsetting;
        private Integer index;  

        public CBLwrapper() {
            this.CBLsetting = new   Custom_Buttons_and_Links__c (Custom_Object__c = ApexPages.currentPage().getParameters().get('CF00NR00000011ekq_lkid'));
            this.index = indexGen++;
        }
        
        public  Custom_Buttons_and_Links__c getCBLsetting() {
            return CBLsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
     public CustomButtonLinkclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;

        CBLlist = new List<CBLwrapper>();
        numRows = 1;
    }
    
    public List<CBLwrapper> getCBLlist() {
        return CBLlist;
}
 

public PageReference save() {
        try {
            List<   Custom_Buttons_and_Links__c> tempList = new List< Custom_Buttons_and_Links__c>();
            for(Integer i=0; i<CBLlist.size(); ++i)
                tempList.add(CBLlist[i].getCBLsetting());
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
                    CBLlist.add(new CBLwrapper());
        } 
        catch (Exception ex) {
        ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        CBLlist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<CBLlist.size(); ++i)
                if(CBLlist[i].index == delIndex) {
                    CBLlist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}