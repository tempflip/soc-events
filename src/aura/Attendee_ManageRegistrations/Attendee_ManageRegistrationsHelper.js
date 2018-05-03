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

	setAttendee : function(cmp, att) {
		console.log(att);
		cmp.set('v.attendee', att);
	}
})