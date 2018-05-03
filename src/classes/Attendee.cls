public with sharing class Attendee {

	public class AttendeeException extends Exception {}

	public Attendee__c record;
	@AuraEnabled public SessionRegistration[] sessionRegistrationList;
	@AuraEnabled public String firstName;
	@AuraEnabled public String lastName;

	public Attendee(Attendee__c att) {
		this.buildFromRecord(att);
	}

	private void buildFromRecord(Attendee__c att) {
		this.record = att;
		this.firstName = att.First_Name__c;
		this.lastName = att.Last_Name__c;

		this.sessionRegistrationList = new SessionRegistration[]{};
		for (Session_Registration__c sr : att.Session_Registrations__r) {
			this.sessionRegistrationList.add(new SessionRegistration(sr));
		}
	}

	public void registerForSession(Session sess) {
		this.validateSessionRegistration(sess);
	}

	public void validateSessionRegistration(Session sess) {
		if (ifSessionAlreadyRegistered(sess) == true) {
			throw new AttendeeException('This Attendee already registered for the Session.');
		}
		if (ifSessionOverlaps(sess) == true) {
			throw new AttendeeException('This session overlaps with another.');
		}			
	}

	public Boolean ifSessionAlreadyRegistered(Session sess) {
		for (SessionRegistration sr : this.sessionRegistrationList) {
			if (sr.record.Session__c == sess.record.Id) return true;
		}
		return false;
	}

	public Boolean ifSessionOverlaps(Session sess) {
		for (SessionRegistration sr : this.sessionRegistrationList) {
			if (	(sess.startTime <= sr.sessionStart && sess.endTime > sr.sessionStart) 
				|| (sess.startTime < sr.sessionEnd && sess.endTime >= sr.sessionEnd)
			) 
			{
				return true;
			}
		}
		return false;
	}	
}