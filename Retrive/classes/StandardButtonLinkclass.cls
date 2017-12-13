/* Author:Rishabh Rawat
*/

public class StandardButtonLinkclass {

   public static Integer indexGen {get; set;}
    public List<SBLwrapper> SBLlist;
    public Integer numRows {get; set;}
    

     public class SBLwrapper {
    
        private     Standard_Buttons_and_Links__c SBLsetting;
        private Integer index;  

        public SBLwrapper() {
            this.SBLsetting = new   Standard_Buttons_and_Links__c (Custom_Object__c = ApexPages.currentPage().getParameters().get('CF00N90000002cdFv_lkid'));
            //String coId = ApexPages.currentPage().getParameters().get('CF00N90000002c5mc_lkid');
            //co = [SELECT Enable_History__c FROM CustomObjects__c WHERE Id = :coId];);
            this.index = indexGen++;
        }
        
        public  Standard_Buttons_and_Links__c getSBLsetting() {
            return SBLsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
     public StandardButtonLinkclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;

        SBLlist = new List<SBLwrapper>();
        numRows = 1;
    }
    
    public List<SBLwrapper> getSBLlist() {
        return SBLlist;
}
 

public PageReference save() {
        try {
            List<   Standard_Buttons_and_Links__c> tempList = new List< Standard_Buttons_and_Links__c>();
            for(Integer i=0; i<SBLlist.size(); ++i)
                tempList.add(SBLlist[i].getSBLsetting());
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
                    SBLlist.add(new SBLwrapper());
        } 
        catch (Exception ex) {
        ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        SBLlist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<SBLlist.size(); ++i)
                if(SBLlist[i].index == delIndex) {
                    SBLlist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}