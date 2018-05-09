({
	onInit : function(cmp, event, helper) {
		helper.getAttendee(cmp);
	},

	onRegisterClick : function(cmp, event, helper) {
		helper.registerToSession(cmp);
	}
})