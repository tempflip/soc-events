public with sharing class Helpers {
	public static Set<Id> getIdSet(SObject[] sobjectList, Schema.SObjectField f) {
		Set<Id> idSet = new Set<Id>();
		for (SObject so : sobjectList) {
			idSet.add((Id) so.get(f.getDescribe().getName()));
		}
		return idSet;
	}
}