component
extends="taffy.core.resource"
taffy_uri="/{streamId}"
{
	
	function get(streamId, sinceId)
	{
		var local = {};
		local.queryService = new query();
		
		local.sql = "
			select * 
			from tblStreamEvent
			where streamId = :streamId and 1=1
		";
		
		if (structKeyExists(arguments, "sinceId")){
			local.sql &= "
				and eventId > :sinceId and 1=1
			";
			local.queryService.addParam(name="sinceId", cfsqltype="cf_sql_numeric", value=arguments.sinceId);
		}
		
		local.sql &= "
			order by eventTimestamp desc, eventId desc
		";

		local.queryService.setSql(sql);
		local.queryService.addParam(name="streamId", cfsqltype="cf_sql_varchar", value=arguments.streamId);
		
		local.result = local.queryService.execute().getResult();
		
		if (local.result.recordCount eq 0)
		{
			return noData().withStatus(304, "Not Modified");
		}
		
		local.data = QueryToArrayOfStructures(local.result);

		return representationOf(local.data);
	}
	
	private function QueryToArrayOfStructures(theQuery){
		var theArray = arraynew(1);
		var cols = ListtoArray(theQuery.columnlist);
		var row = 1;
		var thisRow = "";
		var col = 1;
		for(row = 1; row LTE theQuery.recordcount; row = row + 1){
			thisRow = structnew();
			for(col = 1; col LTE arraylen(cols); col = col + 1){
				thisRow[lcase(cols[col])] = theQuery[cols[col]][row];
			}
			arrayAppend(theArray,duplicate(thisRow));
		}
		return(theArray);
	}

}