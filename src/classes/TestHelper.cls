@isTest
public with sharing class TestHelper {

	Event__c event;
	Map<String, Session__c> sessionMap;
	Attendee__c attendee;

	public Event__c createEvent(String name, Boolean toInsert) {
		event = new Event__c(Name = name);
		if (toInsert) insert event;
		return event;
	}

	public Session__c createSession(String name, Datetime sessionStart, Datetime sessionEnd, Boolean toInsert) {
		if (sessionMap == null) sessionMap = new Map<String, Session__c>();

		Session__c sess = new Session__c(
				Name = name,
				Start__c = sessionStart,
				End__c = sessionEnd,
				Event__c = event.Id
			);

		sessionMap.put(name, sess);
		if (toInsert) insert sess;
		return sess;
	}

	public Attendee__c createAttendee(String firstName, Boolean toInsert) {
		attendee = new Attendee__c(
			Event__c = event.Id,
			First_Name__c = firstName
		);
		if (toInsert) insert attendee;
		return attendee;
	}

}