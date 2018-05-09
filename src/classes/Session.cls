public with sharing class Session {
	@AuraEnabled public Session__c record;
	@AuraEnabled public String name;
	@AuraEnabled public DateTime startTime;
	@AuraEnabled public DateTime endTime;

	public Session(Session__c sess) {
		this.buildFromRecord(sess);
	}

	private void buildFromRecord(Session__c sess) {
		this.record = sess;
		this.name = sess.Name;
		this.startTime = sess.Start__c;
		this.endTime = sess.End__c;
	}
}