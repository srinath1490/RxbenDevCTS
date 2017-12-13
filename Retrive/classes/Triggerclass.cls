/*
 * @author : Accenture
 * @date : 2011-09-28
 */
public class Triggerclass {

    public static Integer indexGen {get; set;}
    public List<Triggerwapper> Triggerlist;
    public Integer numRows {get; set;}
    
    public class Triggerwapper {
    
        private Trigger__c Triggersetting;
        private Integer index;
      

         public Triggerwapper() {
            this.Triggersetting = new Trigger__c (Custom_Object__c = ApexPages.currentPage().getParameters().get('CF00N90000002cdFu_lkid'));
           // String coId = ApexPages.currentPage().getParameters().get('CF00N90000002c5mc_lkid');
           // co = [SELECT Enable_History__c FROM CustomObjects__c WHERE Id = :coId];

            this.index = indexGen++;
        }
        
        public Trigger__c getTriggersetting() {
            return Triggersetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
    public Triggerclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        Triggerlist = new List<Triggerwapper>();
        numRows = 1;
    }
    
    public List<Triggerwapper> getTriggerlist() {
        return Triggerlist;
}
 

public PageReference save() {
        try {
            List<Trigger__c> tempList = new List<Trigger__c>();
            for(Integer i=0; i<Triggerlist.size(); ++i) 
                tempList.add(Triggerlist[i].getTriggersetting());
             upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
      public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    Triggerlist.add(new Triggerwapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
    }
    
    
    public void clear() {
        Triggerlist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<Triggerlist.size(); ++i)
                if(Triggerlist[i].index == delIndex) {
                    Triggerlist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}