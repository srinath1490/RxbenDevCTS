@isTest
 private class HistoryDetail_Test {
    
   static testMethod void testGettersAndSetters() {
   HistoryDetail historyDetail = new HistoryDetail();
   historyDetail.getObjectName();
   historyDetail.setObjectName('History');
   historyDetail.getParentId();
   historyDetail.setParentId('001');
   historyDetail.getField();
   historyDetail.setField('Name');
   historyDetail.getCreatedById();
   historyDetail.setCreatedById('Dev');
   historyDetail.getCreatedDate();
   historyDetail.setCreatedDate('01/02/2011');
   historyDetail.getIsDeleted();
   historyDetail.setIsDeleted('True');
   historyDetail.getNewValue();
   historyDetail.setNewValue('NewValue');
   historyDetail.getId();
   historyDetail.setId('001');
   historyDetail.getOldValue();
   historyDetail.setOldValue('oldValue');
   historyDetail.getUserName();
   historyDetail.setUserName('Admin');
   }
}