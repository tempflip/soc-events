public with sharing class SessionRegistration {
	
	public SObjectUnitOfWork uow;
	public Session_Registration__c record;
	@AuraEnabled public Id recordId {get; set;}
	@AuraEnabled public String sessionName {get; set;}
	@AuraEnabled public Id sessionId {get; set;}
	@AuraEnabled public DateTime sessionStart {get; set;}
	@AuraEnabled public DateTime sessionEnd {get; set;}
	@AuraEnabled public String label {get {
			return this.sessionStart.format('MM/dd hh:mm') + ' - ' + this.sessionEnd.format('hh:mm');
		} set;
	}

	@AuraEnabled public String sessionStartLabel {
		get {
			return this.sessionStart.format('MM/dd hh:mm');
		} set;}
	@AuraEnabled public String sessionEndLabel {
		get {
			return this.sessionEnd.format('MM/dd hh:mm');
		} set;}

	public Session sess;
	public Attendee att;

	public SessionRegistration(Session_Registration__c sr) {
		this.buildFromRecord(sr);
	}

	public SessionRegistration(Session sess, Attendee att) {
		this.sess = sess;
		this.att = att;
		this.sessionId = sess.recordId;
		this.sessionName = sess.name;
		this.sessionStart = sess.startTime;
		this.sessionEnd = sess.endTime;
	}

	public void buildFromRecord(Session_Registration__c sr) {
		this.record = sr;
		this.recordId = sr.Id;
		this.sessionName = sr.Session__r.Name;
		this.sessionId = sr.Session__c;		
		this.sessionStart = sr.Session__r.Start__c;
		this.sessionEnd = sr.Session__r.End__c;
	}

	public void upsertRecord() {
		if (this.record == null) this.record = new Session_Registration__c(Id = this.recordId);
		
		if (this.recordId == null) {
			// master lookups writeable only when creating a new record
			if (this.att != null) this.record.Attendee__c = this.att.recordId;
			if (this.sess != null) {
				this.record.Session__c = this.sess.recordId;
			} else if (this.sessionId != null) {
				this.record.Session__c = this.sessionId;
			}
		}

		this.uow.registerDirty(this.record);
	}

}