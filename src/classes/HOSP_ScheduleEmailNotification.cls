global class HOSP_ScheduleEmailNotification implements Schedulable {
    global void execute(SchedulableContext sc) {
        HOSP_EmailNotification en = new HOSP_EmailNotification();
        Database.executeBatch(en);
    }
}