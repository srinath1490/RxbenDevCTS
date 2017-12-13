/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class ValidationRuleclass {

   public static Integer indexGen {get; set;}
    public List<VLwrapper> VLlist;
    public Integer numRows {get; set;}
    

     public class VLwrapper {
    
        private Validation_Rule__c VLsetting;
        private Integer index;  

        public VLwrapper() {
            this.VLsetting = new Validation_Rule__c (
                    Rule_Name__c = 'Enter value',
                    Error_Condition_Formula__c = 'Enter value',
                    Error_Message__c = 'Enter value',
                    Error_Location__c = 'Top of Page',
                    Custom_Object__c = ApexPages.currentPage().getParameters().get('CF00NR00000011el3_lkid'));
            this.index = indexGen++;
        }
        
        public Validation_Rule__c getVLsetting() {
            return VLsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
     public ValidationRuleclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;

        VLlist = new List<VLwrapper>();
        numRows = 1;
    }
    
    public List<VLwrapper> getVLlist() {
        return VLlist;
}
 

public PageReference save() {
        if(VLlist.size()==0){
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));}
        try {
            List<Validation_Rule__c> tempList = new List<Validation_Rule__c>();
              for(Integer i=0; i<VLlist.size(); ++i){
              Validation_Rule__c VR=VLlist[i].getVLsetting();
              VR.Rule_Name__c = VR.Rule_Name__c.replace(' ', '_');
              VR.Rule_Name__c = VR.Rule_Name__c.replace('__', '_');
              tempList.add(VLlist[i].getVLsetting());
              }
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
                    VLlist.add(new VLwrapper());
        } 
        catch (Exception ex) {
        ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        VLlist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<VLlist.size(); ++i)
                if(VLlist[i].index == delIndex) {
                    VLlist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}