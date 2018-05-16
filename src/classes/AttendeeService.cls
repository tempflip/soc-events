public with sharing class AttendeeService {

	/*
	* Registers Attendees to a list of Sessions
	* Params:
	* Session Id lists mapped to Attendee id's
	*/
	//public static void registerAttendeeForSession(Map<Id, Id[]> sessionsByAttendee) {
		
	//	// getting the data from the database
	//	//////////////////////////
	//	Attendee__c[] attList = AttendeeSelector.getAttendeeWithSessionRegistrations(sessionsByAttendee.keySet());
	//	Set<Id> sessionIdSet = new Set<Id>();

	//	for (Attendee__c attRecord : attList) {
	//		for (Session_Registration__c sr : attRecord.Session_Registrations__r) {
	//			sessionIdSet.add(sr.Session__c);
	//		}
	//	}
	//	for (Id attId : sessionsByAttendee.keySet()) {
	//		sessionIdSet.addAll(sessionsByAttendee.get(attId));
	//	}

	//	Map<Id, Session__c> sessionMap = new Map<Id, Session__c>(SessionSelector.getSessionsById(sessionIdSet));

	//	// making the operations on domain layer instances
	//	//////////////////////
	//	SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[]{Session_Registration__c.SObjectType});

	//	for (Attendee__c attRecord : attList) {
	//		Attendee att = new Attendee(attRecord);
	//		att.uow = uow;
	//		for (Id sessionId : sessionsByAttendee.get(attRecord.Id)) {
	//			Session sess = new Session(sessionMap.get(sessionId));
	//			att.registerForSession(sess);
	//		}
	//		att.upsertSessionRegistrationRecords();
	//	}

	//	// database commit
	//	//////////////////
	//	uow.commitWork();
	//}

	/*
	* Validates if a Session Registration record is valid.
	* Call on before insert and on before update
	*/
	public static void validateSessionRegistration(Session_Registration__c[] srList) {
		// getting the data from the database
		//////////////////////////
		Set<Id> attIdSet = Helpers.getIdSet(srList, Session_Registration__c.Attendee__c);
		Set<Id> sessIdSet = Helpers.getIdSet(srList, Session_Registration__c.Session__c);

		Map<Id, Session__c> sessionMap = new Map<Id, Session__c>(SessionSelector.getSessionsById(sessIdSet));
		Map<Id, Attendee__c> attendeeMap = new Map<Id, Attendee__c>(AttendeeSelector.getAttendeeWithSessionRegistrations(attIdSet));

		// making the operations on domain layer instances
		//////////////////////
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

	/*
	* Saves the passed Attendee in JSON form;
	* Deletes the Session Registrations from the db which are not passed
	*/
	public static Attendee saveAttendee(String attendeeJSON) {

		SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[]{Session_Registration__c.SObjectType});		
		
		Attendee att = (Attendee) JSON.deserialize(attendeeJSON, Attendee.class);
		att.uow = uow;
		att.upsertSessionRegistrationRecords();
		uow.commitWork();
		
		Session_Registration__c[] srToDelete = diffSessionRegistrations(att, att.recordId);
		delete srToDelete;

		return att;
	}

	/*
	* Saves the passed Attendee instrance to the database
	*/
	public static void saveAttendee(Attendee attendee) {

		SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[]{Session_Registration__c.SObjectType});				
		attendee.uow = uow;
		attendee.upsertSessionRegistrationRecords();
		uow.commitWork();

		Session_Registration__c[] srToDelete = diffSessionRegistrations(attendee, attendee.recordId);
		delete srToDelete;		
	}

	/*
	* Returns the Session Registrations from the Database which you don't have on the passed Attendee
	* Handy when you want to delete registrations
	*/
	private static Session_Registration__c[] diffSessionRegistrations(Attendee att, Id attId) {
		Attendee__c[] attList = AttendeeSelector.getAttendeeWithSessionRegistrations(new Set<Id>{attId});
		Attendee attInDatabase = new Attendee(attList[0]);

		Session_Registration__c[] srNotExisting = new Session_Registration__c[]{};

		for (SessionRegistration srDb : attInDatabase.sessionRegistrationList) {
			Boolean found = false;
			for (SessionRegistration srAtt : att.sessionRegistrationList) {
				if (srDb.sessionId == srAtt.sessionId) found = true;
			}

			if (found == false) {
				srNotExisting.add(srDb.record);
			}
		}

		return srNotExisting;
	}


}