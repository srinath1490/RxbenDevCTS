/*
 * @author : Accenture
 * @date : 2011-09-28
 */
public class SearchLayoutclass {

   public static Integer indexGen {get; set;}
    public List<SLwrapper> SLlist;
    public Integer numRows {get; set;}
    

     public class SLwrapper {
    
        private Search_Layout__c SLsetting;
        private Integer index;  

        public SLwrapper() {
            this.SLsetting = new   Search_Layout__c (Custom_Object__c = ApexPages.currentPage().getParameters().get('CF00N90000002cdGh_lkid'));
            this.index = indexGen++;
        }
        
        public  Search_Layout__c getSLsetting() {
            return SLsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
     public SearchLayoutclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;

        SLlist = new List<SLwrapper>();
        numRows = 1;
    }
    
    public List<SLwrapper> getSLlist() {
        return SLlist;
}
 

public PageReference save() {
        try {
            List<   Search_Layout__c> tempList = new List< Search_Layout__c>();
            for(Integer i=0; i<SLlist.size(); ++i)
                tempList.add(SLlist[i].getSLsetting());
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
                    SLlist.add(new SLwrapper());
        } 
        catch (Exception ex) {
        ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        SLlist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<SLlist.size(); ++i)
                if(SLlist[i].index == delIndex) {
                    SLlist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}