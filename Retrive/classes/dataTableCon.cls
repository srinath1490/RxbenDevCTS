public class dataTableCon {
     
  //constructor for initialization
        public dataTableCon(){
          accounts=new List<Account>();
         }

     //object declaration   
        public List<Account> accounts;
          

       
     //getter and setter methods  
        public List<Account> getAccounts() {
                return accounts;
           }

        public void setAccounts(List<Account> tempList){
             accounts = tempList;
             }
    
 
 
 
   // code providing fuctionality for the action buttons on VF page
    public void save() {
        insert accounts;
        PageReference detailPage=new PageReference('https://na12.salesforce.com/001/o');
        detailPage.setRedirect(true);
                
        }

    public void add() {
          accounts.add(new Account());
          
   }
    
    public void refresh() {
        PageReference pageRef = ApexPages.currentPage();
        pageRef.setRedirect(true);
               
        }
        
    public void clearRecord(){
        Integer sizeOfList= accounts.size();
        accounts.remove(sizeOfList-1);
         }
         
    public void delRecords(){
    
                   }  
              
   }