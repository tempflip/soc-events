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
				this.showError(cmp, res.getError()[0].message);
				return;
			}
			this.setSynced(cmp, false);
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
			this.setSynced(cmp, true);
			this.setAttendee(cmp, res.getReturnValue());
		});

		$A.enqueueAction(action);
	},


	deleteRegistration : function(cmp, sessionRegistrationId, sessionId) {
		var attendee = cmp.get('v.attendee');
		attendee.sessionRegistrationList = attendee.sessionRegistrationList.filter(function(sr) {
			return sr.sessionId != sessionId;
		});

		cmp.set('v.attendee', attendee);
		this.setSynced(cmp, false);

	},

	showError : function(cmp, message) {
		alert(message);
	},

	setAttendee : function(cmp, att) {
		console.log('## im the current state: ', att);
		cmp.set('v.attendee', att);
	},

	deleteRegistrationSuccess : function(cmp) {
		this.getAttendee(cmp);
	},

	setSynced : function(cmp, synced) {
		cmp.set('v.synced', synced);
	}
})