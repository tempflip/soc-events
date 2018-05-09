public with sharing class Attendee_ManageRegistrationsController {

	@AuraEnabled
	public static Attendee getAttendee(Id attendeeId) {
		Attendee__c a = AttendeeSelector.getAttendeeWithSessionRegistrations(new Set<Id>{attendeeId})[0];
		Attendee att = new Attendee(a);
		return att;
	}

	@AuraEnabled
	public static Session[] getSessions(Id eventId) {
		Session__c[] sl = SessionSelector.getSessionsByEvent(new Set<Id>{eventId});
		Session[] sessionList = new Session[]{};
		for (Session__c s : sl) {
			sessionList.add(new Session(s));
		}
		return sessionList;
	}

	@AuraEnabled
	public static Attendee registerAttendeeToSession(String attendeeJSON
												, Id sessionId) {

		Attendee att = (Attendee) JSON.deserialize(attendeeJSON, Attendee.class);

		Session__c sessRecord = SessionSelector.getSessionsById(new Set<Id>{sessionId})[0];
		Session sess = new Session(sessRecord);
		att.registerForSession(sess);
		return att;
	}

	@AuraEnabled
	public static Attendee saveAttendee(String attendeeJSON) {

		SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[]{Session_Registration__c.SObjectType});		
		Attendee att = (Attendee) JSON.deserialize(attendeeJSON, Attendee.class);

		//system.assert(false, att) ;	

		att.uow = uow;
		att.upsertSessionRegistrationRecords();
		uow.commitWork();
		
		return getAttendee(att.recordId);
	}

	@AuraEnabled
	public static void deleteRegistration(Id sessionRegistrationId) {
		delete new Session_Registration__c(Id = sessionRegistrationId);
	}

}