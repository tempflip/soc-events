({
	onInit : function(cmp, event, helper) {
	},

	onEventIdChange : function(cmp, event, helper) {
		helper.getSessions(cmp);
	},
})