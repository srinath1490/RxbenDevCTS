public class GMFXmlWriter_ValueOnly{

     public XmlStreamWriter w = new XmlStreamWriter();
     string xml;
     
     public String getParentXml(String version,String rootElement,String childElement,Map<String,String> parentMap,List<Map<String,String>> childMaps) {
    
              Set<String> fieldlist=parentMap.keyset();
              w.writeStartDocument(null, '1.0');
                          
              //writing parent elements
                w.writeComment(rootElement+' section');
                w.writeStartElement(null,rootElement, null);
				
				w.writeStartElement(null,rootElement+'-XMLVersion',null);       
              	w.writeCharacters(version);        
              	w.writeEndElement();
              	                
                for(String s : fieldlist){
                  w.writeStartElement(null,s,null);
                  String sname=parentMap.get(s);
                  system.debug(sname);
                  if(sname!=NULL)
                    w.writeCharacters(sname);
                  else
                    w.writeCharacters('');
                  w.writeEndElement();
                }
                
                //write child elements
                  for(Map<string,string> m:childMaps){
                     //Write elements for each child
                    w.writeComment(childElement+' section');
                    w.writeStartElement(null,childElement, null);
                    set<String> childfieldList=m.keyset();
                for(String s : childfieldlist){
                  w.writeStartElement(null,s,null);
                  String sname=m.get(s);
                  system.debug(sname);
                  if(sname!=NULL)
                    w.writeCharacters(sname);
                  else
                    w.writeCharacters('');
                  w.writeEndElement();
                }
                w.writeEndElement();
                  }
                //end of child elements
                
               w.writeEndElement();
              //end writing parent elements
             
              
           
               w.writeEndDocument();
              String xmlOutput = w.getXmlString();
              w.close();
              return xmlOutput;
            
     }
     public String getParentXml(String rootElement,String childElement,Map<String,String> parentMap,List<Map<String,String>> childMaps) {
         
              Set<String> fieldlist=parentMap.keyset();
              w.writeStartDocument(null, '1.0');
              w.writeStartElement(null,'GMF-XMLVersion',null);       
              w.writeCharacters('1.0');        
              w.writeEndElement();            
              //writing parent elements
                w.writeComment(rootElement+' section');
                w.writeStartElement(null,rootElement, null);
                for(String s : fieldlist){
                  w.writeStartElement(null,s,null);
                  String sname=parentMap.get(s);
                  system.debug(sname);
                  if(sname!=NULL)
                    w.writeCharacters(sname);
                  else
                    w.writeCharacters('');
                  w.writeEndElement();
                }
                
                //write child elements
                  for(Map<string,string> m:childMaps){
                     //Write elements for each child
                    w.writeComment(childElement+' section');
                    w.writeStartElement(null,childElement, null);
                    set<String> childfieldList=m.keyset();
                for(String s : childfieldlist){
                  w.writeStartElement(null,s,null);
                  String sname=m.get(s);
                  system.debug(sname);
                  if(sname!=NULL)
                    w.writeCharacters(sname);
                  else
                    w.writeCharacters('');
                  w.writeEndElement();
                }
                w.writeEndElement();
                  }
                //end of child elements
                
               w.writeEndElement();
              //end writing parent elements
             
              
           
               w.writeEndDocument();
              String xmlOutput = w.getXmlString();
              w.close();
              return xmlOutput;
            
        }
        
       //end function
       
       /**	
		* =====================================================================
		* 						   TEST CASE(S)
		* =====================================================================
		**/
		static testMethod void testXMLGeneration(){
			Map<String,String> parentMap = new Map<String,String>();
			List<Map<String,String>> childMaps = new List<Map<String,String>>();
			
			parentMap.put('first', 'first');			
		    for(Integer i = 0; i < 5 ; i++){
		    	 Map<String, String> tempMap = new Map<String,String>();
		         tempMap.put(String.valueOf(i),String.valueOf(i));
		         childMaps.add(tempMap);
		    }
		    
			GMFXmlWriter_ValueOnly xmlGeneration = new GMFXmlWriter_ValueOnly();
			xmlGeneration.getParentXml('FirstElement','SecondElement',parentMap,childMaps);
		}
}