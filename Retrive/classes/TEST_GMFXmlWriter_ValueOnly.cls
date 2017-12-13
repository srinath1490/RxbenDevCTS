@isTest
public class TEST_GMFXmlWriter_ValueOnly{
 static testmethod void runtest(){
  GMFXmlWriter_ValueOnly handle=new GMFXmlWriter_ValueOnly();
  Map<String,String> parentMap=new Map<String,String>();
  Map<String,String> child=new Map<String,String>();
  List<Map<String,String>> childMap=new List<Map<String,String>>();
  
  parentMap.put('sampleParent_name1','sampleParent_value1');
  parentMap.put('sampleParent_name2','sampleParent_value2');
  
  child.put('samplechild1_elem1','samplechild1_value1');
  child.put('samplechild1_elem2','samplechild1_value2');
  childMap.add(child);

  child=new Map<String,String>();
  child.put('samplechild2_elem1','samplechild2_value1');
  child.put('samplechild2_elem2','samplechild2_value2');
  childMap.add(child);
  //system.assertEquals(handle.getParentXml('parentroot','childroot',parentMap,childMap),'<?xml version="1.0"?><!--parentroot section--><parentroot><sampleParent_name2>sampleParent_value2</sampleParent_name2><sampleParent_name1>sampleParent_value1</sampleParent_name1><!--childroot section--><childroot><samplechild1_elem1>samplechild1_value1</samplechild1_elem1><samplechild1_elem2>samplechild1_value2</samplechild1_elem2></childroot><!--childroot section--><childroot><samplechild2_elem1>samplechild2_value1</samplechild2_elem1><samplechild2_elem2>samplechild2_value2</samplechild2_elem2></childroot></parentroot>');
 }

}