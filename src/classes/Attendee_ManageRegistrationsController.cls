public with sharing class Attendee_ManageRegistrationsController {

	@AuraEnabled
	public static Attendee getAttendee(Id attendeeId) {
		Attendee__c a = AttendeeSelector.getAttendeeWithSessionRegistrations(new Set<Id>{attendeeId})[0];
		Attendee att = new Attendee(a);
		return att;
	}

	@AuraEnabled
	public static Session[] getSessions() {
		Session__c[] sl = SessionSelector.getSessionsByEvent(new Set<Id>{'a015C000001hDcG'});
		Session[] sessionList = new Session[]{};
		for (Session__c s : sl) {
			sessionList.add(new Session(s));
		}
		return sessionList;
	}

	@AuraEnabled
	public static void registerAttendeeForSession(Id attendeeId
												, Id sessionId) {
		AttendeeService.registerAttendeeForSession(new Map<Id, Id[]>
												{
													attendeeId => new Id[]{sessionId}
												});
	}


}