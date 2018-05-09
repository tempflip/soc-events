trigger SessionRegistration on Session_Registration__c (before insert) {
	AttendeeService.validateSessionRegistration(trigger.new);
}