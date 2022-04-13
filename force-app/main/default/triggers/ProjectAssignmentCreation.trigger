trigger ProjectAssignmentCreation on Project__c (after insert, after update) {
    if(Trigger.isAfter && Trigger.isInsert){
        ProjectAssignmentRecordCreation.createProAssRecord(Trigger.new);
        
    }
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        ProjectAssignmentRecordCreation.updatedata(Trigger.new);
    }
}