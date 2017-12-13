public with sharing class Generic_CSVReader {
   //*****************************
   // Member variabels   
   //*****************************
   Private	Blob					     fileContent	{get;set;}
   Private	String					     fileName		{get;set;}
   Private	String					     fileType		{get;set;}
   Private	Integer					     fileSize 		{get;set;}
   Private	String					     fileString		{get;set;}
   Private	List<String>			     fileLines;
   Private	Integer					     fileLinesSize;
  
   private  final static Integer MAXFILESIZE=2097152; // 2MB
  
   //*****************************
   // Member Methods  
   //*****************************
   
   //---Method Name: Submit
   // Arguments
   //	-None
   // Return: pageReference
   // Description: call this method on submit button click to upload file and read from CSV file and handle it.
   
   
  public List<string> readCVSList(Blob fileContent){

   	   	    if(fileContent!=NULL&fileContent.size()<MAXFILESIZE){
   	   	    	    List<sObject> returnList=new List<sObject>();
	   	   	    	fileString=fileContent.toString();
	   				fileLines=fileString.split('\n');
	   	     		fileLinesSize=fileLines.size();	
	   				return fileLines;
			   			   		
   	   	    }
   	   else	
   	    	return NULL;
  }// end readCVSList
   /* will be included in v2- needs more testing.
   public List<sObject> readCSVRecords(Blob fileContent,List<String> fieldNames){
   	       List<sObject> returnList=new List<sObject>();	
   	   	    if(fileContent!=NULL&fileContent.size()<MAXFILESIZE){ //currently limited to 2MB
   	   	   
   	   	    	    returnList=new List<sObject>();
	   	   	    	fileString=fileContent.toString();
	   				fileLines=fileString.split('\n');
	   				fileLinesSize=fileLines.size();	
			   		for(Integer i=1;i<fileLinesSize;i++){ //leave out headings
			   			String[] inputvalues = new String[]{};
			            inputvalues = filelines[i].split(',');
			            for(String s:fieldNames){
			            	Integer y=0;
			            	returnList[i-1].put(s,inputvalues[y]);
			            	y++;
			            }
			            
			   		}	
			   return returnList;
			   			   		
   	   	    }  
   	   	 else
   	   	    return NULL; 	   
   }// end readCSVRecords 
   */
   
}// end class