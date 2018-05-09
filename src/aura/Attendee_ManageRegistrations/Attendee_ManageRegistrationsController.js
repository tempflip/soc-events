({
	onInit : function(cmp, event, helper) {
		helper.getAttendee(cmp);
	},

	onRegisterClick : function(cmp, event, helper) {
		helper.registerToSession(cmp);
	},

	onRegistrationDelete : function(cmp, event, helper) {
		var sessionRegistrationId = event.getParam('sessionRegistrationId');
		var sessionId = event.getParam('sessionId');
		helper.deleteRegistration(cmp, sessionRegistrationId, sessionId);
	},

	onSaveClick	: function(cmp, event, helper) {
		helper.saveAttendee(cmp);
	}
})