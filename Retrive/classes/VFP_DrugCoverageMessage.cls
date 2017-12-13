/*Purpose: Trigger to implement the validations on Drug Coverage Object                                         
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
1.0 -    	Amit Jain			02 Sep, 2015           The pupose of this class is to show the warning message on Drug Coverage Standard page layout
                                                       using an inline VF page when the Formulary is updated. Request 6014, ST# 233
======================================================================== */
public class VFP_DrugCoverageMessage {
	
	private final Drug_coverage__c dCoverage;

    public VFP_DrugCoverageMessage(ApexPages.StandardController controller) {
		this.dCoverage = (Drug_coverage__c)controller.getRecord();
    }
	
	public pagereference Dismiss(){
		//Reset the Formulary Alert Flag
		dCoverage.Formulary_Change_Alert__c = False;
		update dCoverage;

		//Refresh page
		PageReference pageRef = new Pagereference('/' +dCoverage.id +'?inline=0');
		return pageRef;
		
	}
}