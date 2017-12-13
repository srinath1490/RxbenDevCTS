global class DailyChangeHistoryMailer implements Schedulable {
    global void execute(SchedulableContext SC) {
        Database.executeBatch(new ChangeHistoryMailer()); 
    }
}