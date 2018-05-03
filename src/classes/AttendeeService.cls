public with sharing class AttendeeService {

	public static void registerAttendeeForSession(Map<Id, Id[]> sessionsByAttendee) {
		Attendee__c[] attList = AttendeeSelector.getAttendeeWithSessionRegistrations(sessionsByAttendee.keySet());
		Set<Id> sessionIdSet = new Set<Id>();

		for (Attendee__c attRecord : attList) {
			for (Session_Registration__c sr : attRecord.Session_Registrations__r) {
				sessionIdSet.add(sr.Session__c);
			}
		}
		for (Id attId : sessionsByAttendee.keySet()) {
			sessionIdSet.addAll(sessionsByAttendee.get(attId));
		}

		Map<Id, Session__c> sessionMap = new Map<Id, Session__c>(SessionSelector.getSessionsById(sessionIdSet));

		for (Attendee__c attRecord : attList) {
			Attendee att = new Attendee(attRecord);
			for (Id sessionId : sessionsByAttendee.get(attRecord.Id)) {
				Session sess = new Session(sessionMap.get(sessionId));
				att.registerForSession(sess);
			}
		}
	}

	public static void validateSessionRegistration(Session_Registration__c[] srList) {
		Set<Id> attIdSet = new Set<Id>();
		Set<Id> sessIdSet = new Set<Id>();

		for (Session_Registration__c sr : srList) {
			if (sr.Attendee__c != null) {
				attIdSet.add(sr.Attendee__c);
			}
			if (sr.Session__c != null) {
				sessIdSet.add(sr.Session__c);
			}		
		}

		Map<Id, Session__c> sessionMap = new Map<Id, Session__c>(SessionSelector.getSessionsById(sessIdSet));
		Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>(AttendeeSelector.getAttendeeWithSessionRegistrations(attIdSet));

		for (Session_Registration__c sr : srList) {
			if (sr.Attendee__c == null || sr.Session__c == null) continue;
			Attendee att = new Attendee(attendeeMap.get(sr.Attendee__c));
			Session sess = new Session(sessionMap.get(sr.Session__c));
			try {
				att.validateSessionRegistration(sess);
			} catch(Attendee.AttendeeException e) {
				sr.addError(e.getMessage());
			}
		}

	}
}