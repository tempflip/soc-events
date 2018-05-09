trigger SessionRegistration on Session_Registration__c (before insert, before update) {
	//AttendeeService.validateSessionRegistration(trigger.new);
}