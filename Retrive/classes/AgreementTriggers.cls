public class AgreementTriggers {
	
	/*public static void NDASigned (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request_Invitation__c> pharmMap = new Map<Id, Pharmacy_Network_Request_Invitation__c>([Select Id, Stage__c, Send_Contract__c, NDA_Signed__c FROM Pharmacy_Network_Request_Invitation__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request_Invitation__c> pharmsToUpdate = new List<Pharmacy_Network_Request_Invitation__c>();
        
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='NDA')&&(a.echosign_dev1__Status__c=='Signed')){
                
                Pharmacy_Network_Request_Invitation__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request_Invitation__c);
                
                //jenna
                System.debug('Pharmacy record id: ' + tempPharm.Id);
                System.debug('Before Pharmacy \'Stage\' assignment' + tempPharm.Stage__c);
                System.debug('Before Pharmacy \'Send Contract\' assignment' + tempPharm.Send_Contract__c);
                System.debug('Before Pharmacy \'NDA Signed\' assignment' + tempPharm.NDA_Signed__c);
                
                if(tempPharm != null) {
                    tempPharm.Stage__c = 'Contract Pending';
                    tempPharm.Send_Contract__c = true;
                    tempPharm.NDA_Signed__c = system.today();
                    pharmsToUpdate.add(tempPharm);
                        
                    //jenna
                    System.debug('Pharmacy record id: ' + tempPharm.Id);
                    System.debug('After Pharmacy \'Stage\' assignment' + tempPharm.Stage__c);
                    System.debug('After Pharmacy \'Send Contract\' assignment' + tempPharm.Send_Contract__c);
                	System.debug('After Pharmacy \'NDA Signed\' assignment' + tempPharm.NDA_Signed__c);
                }
                
			}
		}
        update pharmsToUpdate;
	}*/
	
	/*public static void NDADeclined (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request_Invitation__c> pharmMap = new Map<Id, Pharmacy_Network_Request_Invitation__c>([Select Id, Stage__c FROM Pharmacy_Network_Request_Invitation__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request_Invitation__c> pharmsToUpdate = new List<Pharmacy_Network_Request_Invitation__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='NDA')&&(a.echosign_dev1__Status__c=='Cancelled / Declined')){
				
				Pharmacy_Network_Request_Invitation__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request_Invitation__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'NDA Declined';
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}*/
	
	public static void ContractSigned (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request_Invitation__c> pharmMap = new Map<Id, Pharmacy_Network_Request_Invitation__c>([Select Id, Stage__c, Contract_Signed__c FROM Pharmacy_Network_Request_Invitation__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request_Invitation__c> pharmsToUpdate = new List<Pharmacy_Network_Request_Invitation__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='Network Contract')&&(a.echosign_dev1__Status__c=='Signed')){
				
				Pharmacy_Network_Request_Invitation__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request_Invitation__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'Contract Signed';
                    tempPharm.Contract_Signed__c=system.today();
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}
	
	public static void ContractDeclined (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request_Invitation__c> pharmMap = new Map<Id, Pharmacy_Network_Request_Invitation__c>([Select Id, Stage__c FROM Pharmacy_Network_Request_Invitation__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request_Invitation__c> pharmsToUpdate = new List<Pharmacy_Network_Request_Invitation__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='Network Contract')&&(a.echosign_dev1__Status__c=='Cancelled / Declined')){
				
				Pharmacy_Network_Request_Invitation__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request_Invitation__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'Contract Declined';
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}
	
	public static void ContractExpired (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request_Invitation__c> pharmMap = new Map<Id, Pharmacy_Network_Request_Invitation__c>([Select Id, Stage__c FROM Pharmacy_Network_Request_Invitation__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request_Invitation__c> pharmsToUpdate = new List<Pharmacy_Network_Request_Invitation__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='Network Contract')&&(a.echosign_dev1__Status__c=='Expired')){
				
				Pharmacy_Network_Request_Invitation__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request_Invitation__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'Contract Expired';
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}
	
	/*public static void RequestContractSent (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request__c> pharmMap = new Map<Id, Pharmacy_Network_Request__c>([Select Id, Stage__c FROM Pharmacy_Network_Request__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request__c> pharmsToUpdate = new List<Pharmacy_Network_Request__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='Network Contract')&&(a.echosign_dev1__Status__c=='Out for Signature')){
				
				Pharmacy_Network_Request__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'PDA Pending';
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}*/
	
	public static void RequestContractSigned (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request__c> pharmMap = new Map<Id, Pharmacy_Network_Request__c>([Select Id, Stage__c, Contract_Signed_Date__c FROM Pharmacy_Network_Request__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request__c> pharmsToUpdate = new List<Pharmacy_Network_Request__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='Network Contract')&&(a.echosign_dev1__Status__c=='Signed')){
				
				Pharmacy_Network_Request__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'PDA Signature Complete';
                    tempPharm.Contract_Signed_Date__c = system.now();
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}
	
	public static void RequestContractDeclined (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request__c> pharmMap = new Map<Id, Pharmacy_Network_Request__c>([Select Id, Stage__c FROM Pharmacy_Network_Request__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request__c> pharmsToUpdate = new List<Pharmacy_Network_Request__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='Network Contract')&&(a.echosign_dev1__Status__c=='Cancelled / Declined')){
				
				Pharmacy_Network_Request__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'Contract Declined';
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}
	
	public static void RequestContractExpired (List<echosign_dev1__SIGN_Agreement__c> agreements, Set<Id> pharmList) {
		
		Map<Id, Pharmacy_Network_Request__c> pharmMap = new Map<Id, Pharmacy_Network_Request__c>([Select Id, Stage__c FROM Pharmacy_Network_Request__c WHERE Id IN :pharmList]);
		List<Pharmacy_Network_Request__c> pharmsToUpdate = new List<Pharmacy_Network_Request__c>();
		
		for (echosign_dev1__SIGN_Agreement__c a : agreements){
			if((a.Contract_Type__c=='Network Contract')&&(a.echosign_dev1__Status__c=='Expired')){
				
				Pharmacy_Network_Request__c tempPharm = pharmMap.get(a.Pharmacy_Network_Request__c);
				
				if(tempPharm != null) {
                    tempPharm.Stage__c = 'Contract Expired';
                    tempPharm.Closed__c = true;
                    pharmsToUpdate.add(tempPharm);
				}
			}
		}
		update pharmsToUpdate;
	}

}