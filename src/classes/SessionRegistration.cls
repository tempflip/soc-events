public with sharing class SessionRegistration {
	
	public SObjectUnitOfWork uow;
	public Session_Registration__c record;
	@AuraEnabled public String sessionName;
	@AuraEnabled public DateTime sessionStart;
	@AuraEnabled public DateTime sessionEnd;
	public Session sess;
	public Attendee att;

	public SessionRegistration(Session_Registration__c sr) {
		this.buildFromRecord(sr);
	}

	public SessionRegistration(Session sess, Attendee att) {
		this.sess = sess;
		this.att = att;
	}

	public void buildFromRecord(Session_Registration__c sr) {
		this.record = sr;
		this.sessionName = sr.Session__r.Name;
		this.sessionStart = sr.Session__r.Start__c;
		this.sessionEnd = sr.Session__r.End__c;
	}

	public void upsertRecord() {
		if (this.record == null) this.record = new Session_Registration__c();
		
		this.record.Attendee__c = this.att.record.Id;
		this.record.Session__c = this.sess.record.Id;
		this.uow.registerDirty(this.record);
	}

}