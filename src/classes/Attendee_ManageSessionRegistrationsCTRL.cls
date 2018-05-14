public with sharing class Attendee_ManageSessionRegistrationsCTRL {

	public Attendee attendee {get; set;}
	public SelectOption[] sessionOptions {get; set;}
	public Id selectedSessionId {get; set;}

	public Attendee_ManageSessionRegistrationsCTRL(ApexPages.StandardController ctrl) {
		this.attendee = new Attendee(AttendeeSelector.getAttendeeWithSessionRegistrations(new Set<Id>{ctrl.getId()})[0]);
		
		this.sessionOptions = new SelectOption[]{};
		for (Session__c sess : SessionSelector.getSessionsByEvent(new Set<Id>{attendee.eventId})) {
			this.sessionOptions.add(new SelectOption(sess.Id, sess.Name));
		}
	}

	public PageReference registerForSession() {
		Session sess = new Session(SessionSelector.getSessionsById(new Set<Id>{selectedSessionId})[0]);
		this.attendee.registerForSession(sess);
		return null;
	}

	public PageReference saveRegistrations() {

		SObjectUnitOfWork uow = new SObjectUnitOfWork(new Schema.SObjectType[]{Session_Registration__c.SObjectType});				
		this.attendee.uow = uow;
		this.attendee.upsertSessionRegistrationRecords();
		uow.commitWork();

		PageReference pr = new PageReference('/' + this.attendee.recordId);
		pr.setRedirect(true);
		return pr;
	}
}