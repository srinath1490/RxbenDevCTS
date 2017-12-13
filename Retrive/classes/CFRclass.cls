/*
 * @author : Accenture
 * @date : 2011-09-28
 */
public class CFRclass {

    public static Integer indexGen {get; set;}
    public List<Customfieldwrapper> FieldList;
    public Integer numRows {get; set;}
    
    public class Customfieldwrapper {
    
        private CustomFields__c customSetting;
        private Integer index;
        public CustomObjects__c co;

         public Customfieldwrapper() {
            this.customSetting = new CustomFields__c (Field_Label__c = 'Enter Field Label', Field_Name__c = 'Enter name', Custom_Objects__c = ApexPages.currentPage().getParameters().get('CF00NR00000011ekp_lkid'));
            String coId = ApexPages.currentPage().getParameters().get('CF00NR00000011ekp_lkid');
            try{
            co = [SELECT Enable_History__c FROM CustomObjects__c WHERE Id = :coId]; 
            }catch(Exception e){}

            this.index = indexGen++;
        }
        
        public CustomFields__c getcustomSetting() {
            return customSetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
    public CFRclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        FieldList = new List<Customfieldwrapper>();
        numRows = 1;
    }
    
    public List<Customfieldwrapper> getFieldList() {
        return FieldList;
}
 

public PageReference save() {
        try {
            if(!checkHistoryTracking())
                return null;
       
      
            List<CustomFields__c> tempList = new List<CustomFields__c>();
            for(Integer i=0; i<FieldList.size(); ++i) {
                CustomFields__c cc = FieldList[i].getcustomSetting();
                cc.Field_name__c = cc.Field_Name__c.replace(' ', '_');
                cc.Field_name__c = cc.Field_Name__c.replace('__', '_');
                
                if(!cc.Field_name__c.endsWith('__c'))
                    cc.Field_name__c += '__c';
                if ((cc.Custom_Objects__r.Object_Name__c!='Account')||(cc.Custom_Objects__r.Object_Name__c!='Contact')||(cc.Custom_Objects__r.Object_Name__c!='Opportunity')||(cc.Custom_Objects__r.Object_Name__c!='Case')||(cc.Custom_Objects__r.Object_Name__c!='Lead')||(cc.Custom_Objects__r.Object_Name__c!='Contract')||(cc.Custom_Objects__r.Object_Name__c!='Campaign')||(cc.Custom_Objects__r.Object_Name__c!='Solution')||(cc.Custom_Objects__r.Object_Name__c!='Event')||(cc.Custom_Objects__r.Object_Name__c!='Task')||(cc.Custom_Objects__r.Object_Name__c!='Asset'))
                    cc.Enable_History__c= false;
                if (cc.Data_Type__c=='Name'){
                    cc.Field_name__c='Name';
                    }
                if (FieldList[i].co.Enable_History__c==false && cc.Enable_History__c==true){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: History tracking not enabled in parent object.');
                    ApexPages.addMessage(myMsg);
                    return null;
                }
                tempList.add(cc);
            }
            try{
            upsert(tempList);
            }catch(Exception e){}
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('retURL'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }

    private boolean checkHistoryTracking() {
        return true;
    }
        


    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    FieldList.add(new CustomfieldWrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        }
    }
    
    
    public void clear() {
        FieldList.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<FieldList.size(); ++i)
                if(FieldList[i].index == delIndex) {
                    FieldList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}