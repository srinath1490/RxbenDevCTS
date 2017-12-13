/**
 * Interface containing methods Trigger Handlers must implement to enforce best practice
 */
 public with sharing abstract class TriggerHandler{
    
    /*
    */
    void beforeInsert(Map<Id,Sobject> Somap){} 
}