public class GMFXmlWriter {
     public XmlStreamWriter w = new XmlStreamWriter();
     string xml;
     
     public String getXml(sObject sourceRecord,List<sObject> childRecords,String rootElement,string childElement,Map<String,String> parentMap,Map<String,String> childMap) {
          if(sourceRecord==NULL){
            return 'Record error, no data found';
            }
          else{
              Set<String> fieldlist=parentMap.keyset();
              w.writeStartDocument(null, '1.0');
                          
              //writing parent elements
                w.writeComment(rootElement+' section');
                w.writeStartElement(null,rootElement, null);
                for(String s : fieldlist){
                  w.writeStartElement(null,s,null);
                  String sname=parentMap.get(s);
                  system.debug(sname);
                  if(sourceRecord.get(sname)!=NULL)
                    w.writeCharacters(String.valueOf(sourceRecord.get(sname)));
                  else
                    w.writeCharacters('');
                  w.writeEndElement();
                }
                //writing child elements
                 for(sObject childRecord:childRecords){
                  writechildElements(childElement+' section',childElement,childMap.keyset(),childMap,childRecord);
                 }
                //end writing child elements
               w.writeEndElement();
              //end writing parent elements
             
              
           
              w.writeEndDocument();
              String xmlOutput = w.getXmlString();
              w.close();
              return xmlOutput;
            }
        }
        
      //function
        private void writechildElements(String secname,String startelem,set<String> fieldlist,Map<String,String> fieldmap,sObject controlobject){
                w.writeComment(secname);
                w.writeStartElement(null,startelem, null);
                for(String s : fieldlist){
                 w.writeStartElement(null,s,null);
                  String sname=fieldmap.get(s);
                  system.debug(sname);
                  if(controlobject.get(sname)!=NULL)
                    w.writeCharacters(String.valueOf(controlobject.get(sname)));
                  else
                    w.writeCharacters('');
                 w.writeEndElement();
                }
                w.writeEndElement();
         }
              //end function
              
   
 }