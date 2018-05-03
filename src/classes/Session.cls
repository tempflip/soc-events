public with sharing class Session {
	public Session__c record;
	public String name;
	public DateTime startTime;
	public DateTime endTime;

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