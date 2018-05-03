public with sharing class Attendee_ManageRegistrationsController {

	@AuraEnabled
	public static Attendee getAttendee(Id attendeeId) {
		Attendee__c a = AttendeeSelector.getAttendeeWithSessionRegistrations(new Set<Id>{'a04J000000SgErw'})[0];
		Attendee att = new Attendee(a);
		return att;
	}
}