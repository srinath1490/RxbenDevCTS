/*
 * @author : Accenture
 * @date : 2011-09-28
 */

public class ReviewerController {

    private static Integer indexGen = 1; //index generator

    public class ReviewerWrapper {
        private Reviewer__c review;
        private Integer index;
    
        public ReviewerWrapper() {
            this.review = new Reviewer__c(Name__c = 'Enter name', ReviewedBy__c = 'Enter reviewer', Reviewed_On__c = Date.today(), Role__c='Enter role',Sign_off_sheet__c = ApexPages.currentPage().getParameters().get('CF00N90000002c52n_lkid'));
            this.index = indexGen++;
        }
        
        public Reviewer__c getReview() {
            return review;
        }
        
        public Integer getIndex() {
            return index;
        }
    }

    public List<ReviewerWrapper> reviewList;
    public Integer numRows {get; set;}
    

    public ReviewerController(ApexPages.StandardController controller) {
        reviewList = new List<ReviewerWrapper>();
        numRows = 1;
    }
    
    public List<ReviewerWrapper> getReviewList() {
        return reviewList;
    }
    

    public PageReference saveRecords() {
        try {
            List<Reviewer__c> tempList = new List<Reviewer__c>();
            for(Integer i=0; i<reviewList.size(); ++i)
                tempList.add(reviewList[i].getReview());
            upsert(tempList);
            return new PageReference('/' + ApexPages.currentPage().getParameters().get('CF00N90000002c52n_lkid'));
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
    
    public void addRecord() {
        try {
            if(numRows > 0)
                for(Integer i=0; i<numRows; ++i)
                    reviewList.add(new ReviewerWrapper());
        } catch (Exception ex) {}
    }
    
    public void clear() {
        reviewList.clear();
        numRows = 1;
    }
    
    public void deleteRow() {
        try {
            Integer delIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('delRow'));
            
            for(Integer i=0; i<reviewList.size(); ++i)
                if(reviewList[i].index == delIndex) {
                    reviewList.remove(i);
                    break;
                }
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
        }
    }
}