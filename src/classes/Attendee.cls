public with sharing class Attendee {

	public class AttendeeException extends Exception {}

	public SObjectUnitOfWork uow;
	public Attendee__c record;
	@AuraEnabled public Id recordId;
	@AuraEnabled public SessionRegistration[] sessionRegistrationList {get; set;}
	@AuraEnabled public String firstName {get; set;}
	@AuraEnabled public String lastName {get; set;}
	@AuraEnabled public Id eventId;

	public Attendee(Attendee__c att) {
		this.buildFromRecord(att);
	}

	/*
	* Registers the Attendee to a given session;
	* so creates a new sessionRegistration in the list
	*/
	public void registerForSession(Session sess) {
		this.validateSessionRegistration(sess);
		this.sessionRegistrationList.add(new SessionRegistration(sess, this));
	}

	/*
	* Validates if an Attendee can be registered to a given session
	*/
	public void validateSessionRegistration(Session sess) {
		if (ifSessionAlreadyRegistered(sess) == true) {
			throw new AttendeeException(
				'This Attendee is already registered for the Session: ' 
				+ sess.name
			);
		}
		if (ifSessionOverlaps(sess) != null) {
			throw new AttendeeException(
				'This session overlaps with another: ' 
				+ ifSessionOverlaps(sess).sessionName
			);
		}			
	}

	/*
	* Removes a SessionRegistration (de-registers the Attendee)
	*/
	public void removeSessionRegistrationById(Id sessionId) {
		SessionRegistration[] sessionRegistrationListFiltered = new SessionRegistration[]{};
		for (SessionRegistration sr : this.sessionRegistrationList) {
			if (sr.sessionId != sessionId) sessionRegistrationListFiltered.add(sr);
		}
		this.sessionRegistrationList = sessionRegistrationListFiltered;
	}

	/*
	* Saves the SessionRegistration to the UOW
	*/
	public void upsertSessionRegistrationRecords() {
		for (SessionRegistration sr : this.sessionRegistrationList) {
			sr.uow = this.uow;
			if (sr.att == null) sr.att = this;
			sr.upsertRecord();
		}
	}



	// Private helpers
	////////////////////
	////////////////////
	
	private void buildFromRecord(Attendee__c att) {
		this.record = att;
		this.recordId = att.Id;
		this.firstName = att.First_Name__c;
		this.lastName = att.Last_Name__c;
		this.eventId = att.Event__c;
		
		this.sessionRegistrationList = new SessionRegistration[]{};
		for (Session_Registration__c sr : att.Session_Registrations__r) {
			this.sessionRegistrationList.add(new SessionRegistration(sr));
		}
	}	


	private Boolean ifSessionAlreadyRegistered(Session sess) {
		for (SessionRegistration sr : this.sessionRegistrationList) {
			if (sr.sessionId == sess.recordId) return true;
		}
		return false;
	}

	private SessionRegistration ifSessionOverlaps(Session sess) {
		for (SessionRegistration sr : this.sessionRegistrationList) {

			if ((sess.startTime >= sr.sessionStart && sess.startTime < sr.sessionEnd)
				|| (sess.endTime > sr.sessionStart && sess.endTime <= sr.sessionEnd)
			) 
			{
				return sr;
			}
		}
		return null;
	}

}