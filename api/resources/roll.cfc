component
extends="taffy.core.resource"
taffy_uri="/{streamId}/roll"
{
	
	function post(streamId, diceSize, diceCount, rollGroup, chatHandle)
	{
		var local = {};
		
		//ROLL ALL THE DICE!
		local.rolls = [];
		for (local.d = 1; local.d <= arguments.diceCount; local.d++)
		{
			arrayAppend(local.rolls, randRange(1,arguments.diceSize));
		}
		
		local.queryService = new query();
		for (local.d = 1; local.d <= diceCount; local.d++)
		{
			local.queryService.setSql("
				insert into tblStreamEvent(streamId, diceSize, rollValue, rollGroup, chatHandle)
				values (:streamId, :diceSize, :rollValue, :rollGroup, :chatHandle)
			");
			local.queryService.addParam(name="streamId", cfsqltype="cf_sql_varchar", value=arguments.streamId);
			local.queryService.addParam(name="diceSize", cfsqltype="cf_sql_numeric", value=arguments.diceSize);
			local.queryService.addParam(name="rollValue", cfsqltype="cf_sql_numeric", value=local.rolls[d]);
			local.queryService.addParam(name="rollGroup", cfsqltype="cf_sql_varchar", value="[#arguments.diceCount#d#arguments.diceSize#] #arguments.rollGroup#");
			local.queryService.addParam(name="chatHandle", cfsqltype="cf_sql_varchar", value=arguments.chatHandle);
			local.queryService.execute();
		}

		return noData().withStatus(201,"Critical POST!");
		
	}
	
}
