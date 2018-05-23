public with sharing class Session {
	public Session__c record;
	@AuraEnabled public Id recordId;
	@AuraEnabled public String name;
	@AuraEnabled public DateTime startTime;
	@AuraEnabled public DateTime endTime;
	@AuraEnabled public String label { 
		get {
			return this.name 
				+ ' ' 
				+ this.startTime.format('MM/dd hh:mm') 
				+ ' - ' 
				+ this.endTime.format('hh:mm');
		} set;
	}

	public Session(Session__c sess) {
		this.buildFromRecord(sess);
	}

	private void buildFromRecord(Session__c sess) {
		this.record = sess;
		this.recordId = sess.Id;
		this.name = sess.Name;
		this.startTime = sess.Start__c;
		this.endTime = sess.End__c;
	}

}