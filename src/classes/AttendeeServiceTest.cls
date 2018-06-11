@isTest
public with sharing class AttendeeServiceTest {

	@isTest
	public static void registerAttendeeForSessionHappy1() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 10, 0, 0), Datetime.newInstance(2018, 6, 1, 11, 0, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);

		AttendeeService.registerAttendeeForSession(new Map<Id, Id[]>{att.Id => new Id[]{s1.Id, s2.Id}});

		Session_Registration__c[] rl = [SELECT Session__c
											, Attendee__c
										FROM Session_Registration__c];

		system.assertEquals(2, rl.size());
		system.assertEquals(att.Id, rl[0].Attendee__c);
		system.assertEquals(att.Id, rl[1].Attendee__c);
		system.assertEquals(s1.Id, rl[0].Session__c);
		system.assertEquals(s2.Id, rl[1].Session__c);

	}

	@isTest
	public static void registerAttendeeForSessionSad1() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 9, 30, 0), Datetime.newInstance(2018, 6, 1, 10, 30, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);

		Boolean errorCatched = false;

		try {
			AttendeeService.registerAttendeeForSession(new Map<Id, Id[]>{att.Id => new Id[]{s1.Id, s2.Id}});
		} catch(Attendee.AttendeeException err) {
			errorCatched = true;
		}
		system.assert(errorCatched);
	}

	@isTest
	public static void registerAttendeeForSessionSad2() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 9, 30, 0), Datetime.newInstance(2018, 6, 1, 10, 30, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);

		AttendeeService.registerAttendeeForSession(new Map<Id, Id[]>{att.Id => new Id[]{s1.Id}});


		Boolean errorCatched = false;
		try {
			AttendeeService.registerAttendeeForSession(new Map<Id, Id[]>{att.Id => new Id[]{s2.Id}});
		} catch(Attendee.AttendeeException err) {
			errorCatched = true;
		}
		system.assert(errorCatched);
	}

	@isTest
	public static void validateSessionRegistrationHappy1() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 10, 0, 0), Datetime.newInstance(2018, 6, 1, 11, 0, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);

		Session_Registration__c se1 = new Session_Registration__c(Attendee__c = att.Id,
																Session__c = s1.Id);

		Session_Registration__c se2 = new Session_Registration__c(Attendee__c = att.Id,
																Session__c = s2.Id);

		insert new Session_Registration__c[]{se1, se2};

		Session_Registration__c[] rl = [SELECT Session__c
											, Attendee__c
										FROM Session_Registration__c];

		system.assertEquals(2, rl.size());
		system.assertEquals(att.Id, rl[0].Attendee__c);
		system.assertEquals(att.Id, rl[1].Attendee__c);
		system.assertEquals(s1.Id, rl[0].Session__c);
		system.assertEquals(s2.Id, rl[1].Session__c);		
	}

	@isTest
	public static void validateSessionRegistrationSad2() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 9, 30, 0), Datetime.newInstance(2018, 6, 1, 10, 30, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);

		Session_Registration__c se1 = new Session_Registration__c(Attendee__c = att.Id,
																Session__c = s1.Id);

		Session_Registration__c se2 = new Session_Registration__c(Attendee__c = att.Id,
																Session__c = s2.Id);

		insert se1;
		Boolean errorCatched = false;
		try {		
			insert se2;
		} catch(Exception err) {
			errorCatched = true;
		}
		system.assert(errorCatched);
	}	

	@isTest
	public static void registerAttendeeVFHappy1() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 9, 30, 0), Datetime.newInstance(2018, 6, 1, 10, 30, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);

		Test.startTest();
			Attendee_ManageSessionRegistrationsCTRL vf = new Attendee_ManageSessionRegistrationsCTRL(new ApexPages.StandardController(att));
			vf.selectedSessionId = vf.sessionOptions[0].getValue();
			vf.registerForSession();
			vf.saveRegistrations();
		Test.stopTest();


		Session_Registration__c[] rl = [SELECT Session__c
											, Attendee__c
										FROM Session_Registration__c];

		system.assertEquals(1, rl.size());
		system.assertEquals(att.Id, rl[0].Attendee__c);
		system.assertEquals(s1.Id, rl[0].Session__c);
	}



	@isTest
	public static void registerAttendeeVFSad1() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 9, 30, 0), Datetime.newInstance(2018, 6, 1, 10, 30, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);

		Test.startTest();
			Attendee_ManageSessionRegistrationsCTRL vf = new Attendee_ManageSessionRegistrationsCTRL(new ApexPages.StandardController(att));
			vf.selectedSessionId = vf.sessionOptions[0].getValue();
			vf.registerForSession();
			system.assertEquals(0, ApexPages.getMessages().size() );
			vf.registerForSession();
			system.assertEquals(1, ApexPages.getMessages().size() );
			vf.saveRegistrations();

		Test.stopTest();
		Session_Registration__c[] rl = [SELECT Session__c
											, Attendee__c
										FROM Session_Registration__c];

		system.assertEquals(1, rl.size());
		system.assertEquals(att.Id, rl[0].Attendee__c);
		system.assertEquals(s1.Id, rl[0].Session__c);
	}	

	@isTest
	public static void deleteAttendeeVFHappy1() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 10, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 30, 0), true);
		Attendee__c att = th.createAttendee('Peter', true);
		Session_Registration__c se1 = new Session_Registration__c(Attendee__c = att.Id,
																Session__c = s1.Id);

		Session_Registration__c se2 = new Session_Registration__c(Attendee__c = att.Id,
																Session__c = s2.Id);

		insert se1;
		insert se2;

		Test.startTest();
			Attendee_ManageSessionRegistrationsCTRL vf = new Attendee_ManageSessionRegistrationsCTRL(new ApexPages.StandardController(att));
			vf.regToDelete = vf.attendee.sessionRegistrationList[0].sessionId;
			vf.deleteRegistration();
			vf.saveRegistrations();
		Test.stopTest();


		Session_Registration__c[] rl = [SELECT Session__c
											, Attendee__c
										FROM Session_Registration__c];

		system.assertEquals(1, rl.size());
		system.assertEquals(att.Id, rl[0].Attendee__c);
		system.assertEquals(s2.Id, rl[0].Session__c);
	}


	@isTest
	public static void regAttendeeAuraHappy1() {
		TestHelper th = new TestHelper();
		Event__c e = th.createEvent('My Event', true);
		Session__c s1 = th.createSession('s1', Datetime.newInstance(2018, 6, 1, 9, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 0, 0), true);
		Session__c s2 = th.createSession('s2', Datetime.newInstance(2018, 6, 1, 10, 0, 0), Datetime.newInstance(2018, 6, 1, 10, 30, 0), true);
		Attendee__c attRecord = th.createAttendee('Peter', true);
		Session_Registration__c se1 = new Session_Registration__c(Attendee__c = attRecord.Id,
																Session__c = s1.Id);	

		insert se1;

		Attendee att = Attendee_ManageRegistrationsController.getAttendee(attRecord.Id);
		system.assertEquals(1, att.sessionRegistrationList.size());
		Session[] sessList = Attendee_ManageRegistrationsController.getSessions(e.Id);
		system.assertEquals(2, sessList.size());

		att = Attendee_ManageRegistrationsController.registerAttendeeToSession(JSON.serialize(att), s2.Id);
		system.assertEquals(2, att.sessionRegistrationList.size());

		//Attendee_ManageRegistrationsController.saveAttendee(JSON.serialize(att));

		//Session_Registration__c[] rl = [SELECT Session__c
		//									, Attendee__c
		//								FROM Session_Registration__c];

		//system.assertEquals(2, rl.size());
		//system.assertEquals(attRecord.Id, rl[0].Attendee__c);
		//system.assertEquals(s1.Id, rl[0].Session__c);
		//system.assertEquals(attRecord.Id, rl[1].Attendee__c);
		//system.assertEquals(s2.Id, rl[1].Session__c);
	}


}