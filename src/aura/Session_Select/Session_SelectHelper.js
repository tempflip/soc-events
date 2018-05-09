({
	getSessions : function(cmp) {
		var action = cmp.get('c.getSessions');
		action.setParams({
			'eventId' : cmp.get('v.eventId')
		});

		action.setCallback(this, function(res) {
			if (res.getState() != 'SUCCESS') {
				console.log('### error: ',res.getError());
				return;
			}
			this.setSessions(cmp, res.getReturnValue());
		});
		$A.enqueueAction(action);
	},

	setSessions : function(cmp, sessions) {
		cmp.set('v.sessions', sessions);
		console.log(sessions);
	}
})