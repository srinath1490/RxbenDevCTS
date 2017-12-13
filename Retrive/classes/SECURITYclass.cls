/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class SECURITYclass {

    public static Integer indexGen {get; set;}
    
     public class Securitywrapper {
    
        public security__c securitysetting;
        public Integer index;  

         public Securitywrapper() {
            this.securitysetting = new security__c (
                Security_Name__c = 'Enter value',
                Object__c = ApexPages.currentPage().getParameters().get('CF00NU0000001YrCq_lkid'));
            this.index = indexGen++;
        }
        
        public security__c getsecuritySetting() {
            return securitysetting;
        }
        
        public Integer getIndex() {
            return index;
        }
    } 

    public List<Securitywrapper> Securitylist;
    public Integer numRows {get; set;}
    
     
     public SECURITYclass(ApexPages.StandardController controller) {
        if(indexGen == null) indexGen = 1;
        Securitylist = new List<Securitywrapper>();
        numRows = 1;
    }
    
    public List<Securitywrapper> getSecuritylist() {
        return Securitylist;
}
 

public Pagereference save() {
        try {
            List<security__c> tempList = new List<security__c>();
            for(Integer i=0; i<Securitylist.size(); ++i)
                tempList.add(Securitylist[i].getsecuritySetting());
            upsert(tempList);
            return new pagereference('/' + ApexPages.currentPage().getParameters().get('retURL') );
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }


        


    public void addNewRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    Securitylist.add(new Securitywrapper());
        } catch (Exception ex) {
             ApexPages.addMessages(ex);
        
        }
    }
    
    
    public void clear() {
        Securitylist.clear();
        numRows = 1;
    }
    
  
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<Securitylist.size(); ++i)
                if(Securitylist[i].index == delIndex) {
                    Securitylist.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}