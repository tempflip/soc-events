public with sharing class SessionRegistration {
	public Session_Registration__c record;
	@AuraEnabled public String sessionName;
	@AuraEnabled public DateTime sessionStart;
	@AuraEnabled public DateTime sessionEnd;

	public SessionRegistration(Session_Registration__c sr) {
		this.buildFromRecord(sr);
	}

	public void buildFromRecord(Session_Registration__c sr) {
		this.record = sr;
		this.sessionName = sr.Session__r.Name;
		this.sessionStart = sr.Session__r.Start__c;
		this.sessionEnd = sr.Session__r.End__c;
	}
}