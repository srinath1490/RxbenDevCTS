/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class WFAclass {

    public static Integer indexGen {get; set;}
    public List<approvalwrapper> approvallist;
    public Integer numRows {get; set;}
    

     public class approvalwrapper {
    
        private Workflows_Approval__c approvalsetting;
        private Integer index;  

        public approvalwrapper() {
            this.approvalsetting = new Workflows_Approval__c (Rule_Name__c = 'Entername',WorkFlow_Approval_Object__c = ApexPages.currentPage().getParameters().get('CF00N90000002c5KD_lkid'));
            this.index = indexGen++;
        }
        
        public Workflows_Approval__c getapprovalsetting() {
            return approvalsetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 
     
     public WFAclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;

        approvallist = new List<approvalwrapper>();
        numRows = 1;
    }
    
    public List<approvalwrapper> getapprovallist() {
        return approvallist;
}
 

public PageReference save() {
        try {
            List<Workflows_Approval__c> tempList = new List<Workflows_Approval__c>();
            for(Integer i=0; i<approvallist.size(); ++i){
            Workflows_Approval__c wfa = approvallist[i].getapprovalsetting();
            // wfa.Rule_Name__c = wfa.Rule_Name__c.replace(' ', '_');
            //  wfa.Rule_Name__c = wfa.Rule_Name__c.replace('__', '_');
               tempList.add(wfa);
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
                    approvallist.add(new approvalwrapper());
        } 
        catch (Exception ex) {
        ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        approvallist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<approvallist.size(); ++i)
                if(approvallist[i].index == delIndex) {
                    approvallist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}