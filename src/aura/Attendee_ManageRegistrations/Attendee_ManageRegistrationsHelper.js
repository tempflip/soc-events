({
	getAttendee : function(cmp) {
		var action = cmp.get('c.getAttendee');
		action.setParams({
			'attendeeId' : cmp.get('v.recordId')
		});

		action.setCallback(this, function(res) {
			if (res.getState() != 'SUCCESS') {
				console.log('### error: ',res.getError());
				return;
			}
			this.setAttendee(cmp, res.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	registerToSession: function(cmp) {
		var action = cmp.get('c.registerAttendeeToSession');

		action.setParams({
			'sessionId' : cmp.get('v.sessionId'),
			'attendeeJSON' : JSON.stringify(cmp.get('v.attendee'))
		});

		action.setCallback(this, function(res) {
			if (res.getState() != 'SUCCESS') {
				console.log('### error: ',res.getError());
				return;
			}
			this.setAttendee(cmp, res.getReturnValue());
		});

		$A.enqueueAction(action);
	},

	saveAttendee : function(cmp) {
		var action = cmp.get('c.saveAttendee');
		action.setParams({
			'attendeeJSON' : JSON.stringify(cmp.get('v.attendee'))
		});

		action.setCallback(this, function(res) {
			if (res.getState() != 'SUCCESS') {
				console.log('### error: ',res.getError());
				return;
			}
			
			this.setAttendee(cmp, res.getReturnValue());
		});

		$A.enqueueAction(action);
	},


	deleteRegistration : function(cmp, sessionRegistrationId) {
		// var action = cmp.get('c.deleteRegistration');

		// action.setParams({
		// 	'sessionRegistrationId' : sessionRegistrationId
		// });

		// action.setCallback(this, function(res) {
		// 	if (res.getState() != 'SUCCESS') {
		// 		console.log('### error: ',res.getError());
		// 		return;
		// 	}
		// 	this.deleteRegistrationSuccess(cmp);
		// });

		// $A.enqueueAction(action);
	},

	setAttendee : function(cmp, att) {
		console.log('## im the current state: ', att);
		cmp.set('v.attendee', att);
	},

	deleteRegistrationSuccess : function(cmp) {
		this.getAttendee(cmp);
	}
})