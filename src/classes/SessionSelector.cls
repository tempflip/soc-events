public with sharing class SessionSelector {

	public static Session__c[] getSessionsById(Set<Id> idSet) {
		Session__c[] sessList = [SELECT Name
									, Start__c
									, End__c
								FROM Session__c
								WHERE Id IN :idSet];
		return sessList;
	}

	public static Session__c[] getSessionsByEvent(Set<Id> idSet) {
		Session__c[] sessList = [SELECT Name
									, Start__c
									, End__c
								FROM Session__c
								WHERE Event__c IN :idSet];
		return sessList;
	}

}