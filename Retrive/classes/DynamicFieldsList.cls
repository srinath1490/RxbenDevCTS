public class DynamicFieldsList{
    private ApexPages.StandardSetController controller;
    public DynamicFieldsList(ApexPages.StandardController controller) {
    }
    public boolean status;
    public List<String> FieldList {get;set;}
        public List<String> sampleFieldList {
        get {
        if (sampleFieldList == null) {
            sampleFieldList = new List<String>();
            sampleFieldList.add('Name');
            sampleFieldList.add('AccountNumber');
            sampleFieldList.add('BillingAddress');
            sampleFieldList.add('A_c_Email__c');
            sampleFieldList.add('Active__c');

        }
        return sampleFieldList;
        }
       
        private set;
    }
    
        public PageReference add(){
         status = true;
        If(status==true)
        {
           
            FieldList = getFieldList();
        }
        return null;
    
    }
public List<String> getFieldList() {
        FieldList = sampleFieldList;
              return FieldList;
      }

    
      
   }