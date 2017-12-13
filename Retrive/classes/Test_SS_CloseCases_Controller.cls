@isTest
private class Test_SS_CloseCases_Controller {
	
	static case toclose;
	static case internalcase;
	static SS_CloseCases_Controller control;

    static testMethod void closeCaseTest() {
    	control=new SS_CloseCases_Controller();
    	//set filecontent=null
    	control.fileContent=NULL;
    	system.assert(control.closeCase()==NULL);
    	//set filename not csv
    	control.fileContent=Blob.valueOf('This is a test');
    	control.filename='InvalidFile.mdx';
    	system.assert(control.closeCase()==NULL);
    	
    	//set filetype to accdb
    	control.fileContent=Blob.valueOf('This is a test');
    	control.filename='validFile.csv';
    	control.fileType='application/accdb';
    	system.assert(control.closeCase()==NULL);
    	
    	//testing maxsize and maxrows is to be implemented.
    	datagenerator();
    	control.fileContent=Blob.valueOf(String.valueOf([select casenumber from case where id=:toclose.Id][0].casenumber));
    	control.filename='validFile.csv';
    	control.fileType='application/csv';
    	control.closeCase();
    	    	//moving on to reading csv and making sure we have the right value returned
    	
    }
    
    static testMethod void closeInternalCaseTest() {
    	control=new SS_CloseCases_Controller();
    	//set filecontent=null
    	control.fileContent=NULL;
    	system.assert(control.closeCase()==NULL);
    	//set filename not csv
    	control.fileContent=Blob.valueOf('This is a test');
    	control.filename='InvalidFile.mdx';
    	system.assert(control.closeCase()==NULL);
    	
    	//set filetype to accdb
    	control.fileContent=Blob.valueOf('This is a test');
    	control.filename='validFile.csv';
    	control.fileType='application/accdb';
    	system.assert(control.closeCase()==NULL);
    	
    	//testing maxsize and maxrows is to be implemented.
    	datagenerator();
    	control.fileContent=Blob.valueOf(String.valueOf([select casenumber from case where id=:toclose.Id][0].casenumber)+','+String.valueOf([select casenumber from case where id=:internalcase.Id][0].casenumber));
    	control.filename='validFile.csv';
    	control.fileType='application/csv';
    	control.closeInternalCase();
    }
    
    static void datagenerator(){
    	//create and insert cases- one normal and one internal
    	toclose=new case(status='New');
    	insert toclose;
    	internalcase=new case();
    	insert internalcase;
    	
    }
}