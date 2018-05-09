({
	onInit : function(cmp, event, helper) {
		helper.getAttendee(cmp);
	},

	onRegisterClick : function(cmp, event, helper) {
		helper.registerToSession(cmp);
	},

	onRegistrationDelete : function(cmp, event, helper) {
		var sessionRegistrationId = event.getParam('sessionRegistrationId');
		helper.deleteRegistration(cmp, sessionRegistrationId);
	}
})