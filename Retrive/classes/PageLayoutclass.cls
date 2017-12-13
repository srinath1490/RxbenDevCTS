/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class PageLayoutclass {

   public static Integer indexGen {get; set;}
    public List<PLwrapper> PLlist;
    public Integer numRows {get; set;}
    

     public class PLwrapper {
    
        private     Page_Layout__c PLsetting;
        private Integer index;  

        public PLwrapper() {
            this.PLsetting = new   Page_Layout__c (Custom_Object__c = ApexPages.currentPage().getParameters().get('CF00NR00000011eks_lkid'));
            this.index = indexGen++;
        }
        
        public  Page_Layout__c getPLsetting() {
            return PLsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
     public PageLayoutclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;

        PLlist = new List<PLwrapper>();
        numRows = 1;
    }
    
    public List<PLwrapper> getPLlist() {
        return PLlist;
}
 

public PageReference save() {
        try {
            List<   Page_Layout__c> tempList = new List< Page_Layout__c>();
            for(Integer i=0; i<PLlist.size(); ++i)
                tempList.add(PLlist[i].getPLsetting());
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
                    PLlist.add(new PLwrapper());
        } 
        catch (Exception ex) {
        ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        PLlist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<PLlist.size(); ++i)
                if(PLlist[i].index == delIndex) {
                    PLlist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}