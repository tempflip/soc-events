public with sharing class Attendee_ManageSessionRegistrationsCTRL {

	public Attendee attendee {get; set;}
	public SelectOption[] sessionOptions {get; set;}
	public Id selectedSessionId {get; set;}
	public Boolean saveDisabled {get; set;}
	public String regToDelete {get; set;}

	public Attendee_ManageSessionRegistrationsCTRL(ApexPages.StandardController ctrl) {
		this.attendee = new Attendee(AttendeeSelector.getAttendeeWithSessionRegistrations(new Set<Id>{ctrl.getId()})[0]);
		
		this.sessionOptions = new SelectOption[]{};
		for (Session__c sessRecord : SessionSelector.getSessionsByEvent(new Set<Id>{attendee.eventId})) {
			Session sess = new Session(sessRecord);
			this.sessionOptions.add(new SelectOption(sess.recordId, sess.label));
		}
		this.saveDisabled = true;
	}

	public PageReference registerForSession() {
		try {
			Session sess = new Session(SessionSelector.getSessionsById(new Set<Id>{selectedSessionId})[0]);
			this.attendee.registerForSession(sess);
			this.saveDisabled = false;
		} catch(Attendee.AttendeeException e) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,e.getMessage()));
		}
		return null;
	}

	public PageReference saveRegistrations() {
		AttendeeService.saveAttendee(this.attendee);

		PageReference pr = new PageReference('/' + this.attendee.recordId);
		pr.setRedirect(true);
		return pr;
	}

	public PageReference deleteRegistration() {
		this.attendee.removeSessionRegistrationById(regToDelete);
		this.saveDisabled = false;
		return null;
	}
}