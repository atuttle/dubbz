component
extends="taffy.core.resource"
taffy_uri="/{streamId}/chat"
{
	
	function post(streamId, chatText, chatHandle)
	{
		var local = {};
		
		local.queryService = new query();
		local.queryService.setSql("
			insert into tblStreamEvent(streamId, chatHandle, chatText, rollGroup)
			values (:streamId, :chatHandle, :chatText, :rollGroup)
		");
		local.queryService.addParam(name="streamId", cfsqltype="cf_sql_varchar", value=arguments.streamId);
		local.queryService.addParam(name="chatHandle", cfsqltype="cf_sql_varchar", value=arguments.chatHandle);
		local.queryService.addParam(name="chatText", cfsqltype="cf_sql_varchar", value=arguments.chatText);
		local.queryService.addParam(name="rollGroup", cfsqltype="cf_sql_varchar", value="-chit-chat-");
		local.queryService.execute();

		return noData().withStatus(201,"WHERE'S THE MOUNTAIN DEW?");
		
	}
	
}
