public with sharing class AttendeeSelector {
	public static Attendee__c[] getAttendeeWithSessionRegistrations(Set<Id> idSet) {
		Attendee__c[] attL = [SELECT First_Name__c
									, Last_Name__c
									, (SELECT Session__c
											  , Session__r.Name
											  , Session__r.Start__c
											  , Session__r.End__c
											  , Session__r.Event__c
											  , Session__r.Event__r.Name
										FROM Session_Registrations__r)
								FROM Attendee__c
								WHERE Id IN :idSet];
		return attL;
	}
}