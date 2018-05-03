public with sharing class Attendee {

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
}