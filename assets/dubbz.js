//TODO: 
// - list of arrived people

var dubbz = (function(){
	var apilocation = '/dubbz/api/index.cfm';
	var lastEventId = 0, streamId = 'default';
	
	return {

		sendCommand: function(handle, command, callback){
			var that = this,
				slashCmd = command.split(' ');
			if (slashCmd[0] == '/roll'){
				//do roll
				var
					diceCount = /(\d+)d\d+/.exec(slashCmd[1]),
					diceSize = /\d+d(\d+)/.exec(slashCmd[1]);
				
				slashCmd.shift(); //drops /roll
				slashCmd.shift(); //drops 1d20
				var rollGroup = slashCmd.join(' ');
				
				$.ajax({
					type: 'post',
					url: this.apiUrl('/' + streamId + '/roll'),
					dataType: 'json',
					data: {
						diceSize: diceSize[1],
						diceCount: diceCount[1], 
						rollGroup: rollGroup,
						chatHandle: handle
					},
					success: function(data){
						if (typeof callback != 'undefined') callback();
					},
					error: function(xhr, status, err){
						that.showError(err);
					}
				});
			}else{
				//do chat
				$.ajax({
					type: 'post',
					url: this.apiUrl('/' + streamId + '/chat'),
					dataType: 'json',
					data: {
						chatText: command,
						chatHandle: handle
					},
					success: function(data){
						if (typeof callback != 'undefined') callback();
					},
					error: function(xhr, status, err){
						that.showError(err);
					}
				});
			}
		},
		
		updateStream: function(callback){
			var that = this;
			$.ajax({
				type: 'get',
				url: that.apiUrl('/' + streamId + '?sinceId=' + lastEventId),
				dataType: 'json',
				success: function(data){
					if (typeof data != 'undefined') lastEventId = data[0].eventid;
					if (typeof callback != 'undefined') callback(data);
				},
				error: function(xhr, status, err){
					that.showError(err);
				}
			});
		},
		
		showError: function(msg,seconds){
			var s = seconds || 4;
			var d = new Date();
			var id = 'msg' + d.getHours() + d.getMinutes() + d.getSeconds() + d.getMilliseconds();
			var newMsg = $("<div id='" + id + "' class='alert-message error'><a class='close'>x</a><p><strong>ERROR!</strong> " + msg + "</p></div>");
			newMsg.appendTo("#messages");
			setTimeout("$('#" +  id + "').addClass('fade').alert('close');",s*1000);//remove after specified delay
		},
		
		showSuccess: function(msg,seconds){
			var s = seconds || 4;
			var d = new Date();
			var id = 'msg' + d.getHours() + d.getMinutes() + d.getSeconds() + d.getMilliseconds();
			var newMsg = $("<div id='" + id + "' class='alert-message success'><a class='close'>x</a><p><strong>Success!</strong> " + msg + "</p></div>");
			newMsg.appendTo("#messages");
			setTimeout("$('#" +  id + "').addClass('fade').alert('close');",s*1000);//remove after specified delay
		},
		
		apiUrl: function(uri){
			return apilocation + uri;
		}

	};
})();

var dubbzui = (function(){
	var refresherHandle, lastRollGroup = '', lastRollHandle = '';
	
	return {
		
		startRefresher: function(){
			this.refreshChatlog();//do it once before we start the timer so we don't have to wait on initial page load
			refresherHandle = setInterval(this.refreshChatlog, 4000);
		},
		
		stopRefresher: function(){
			clearInterval(refresherHandle);
		},
		
		refreshChatlog: function(){
			dubbz.updateStream(function(data){
				if (typeof data == 'undefined') return;
				data.reverse();
				var handle, group;
				for (var i=0; i<data.length; i++){
					handle = data[i].chathandle;
					group = data[i].rollgroup;
					if (group == '-chit-chat-'){
						$("<li class='chat'><strong>" + data[i].chathandle + "</strong>: " + data[i].chattext + "</li>").appendTo("#chatlog ul");
					}else{
						if (group != lastRollGroup || handle != lastRollHandle){
							$("<li class='roll'><h3>" + handle + " <span class='dice'>&#9861;</span> " + group + "</h3></li>").appendTo("#chatlog ul");
							lastRollGroup = group;
							lastRollHandle = handle;
						}
						$("<li class='roll'>Rolled an <strong>" + data[i].rollvalue + "</strong></li>").appendTo("#chatlog ul");
					}
				}
				
				//scroll to bottom
				$("#chatlog").scrollTop($("#chatlog")[0].scrollHeight);
			});
		}
		
	};
})();

//bind stuff on page load
$(function(){
	$("#cmdForm").submit(function(e){
		e.preventDefault();
		var handle = $("#handle").val(),
			command = $("#command").val();

		if (handle.length == 0){
			dubbz.showError('Enter your handle, idiot!');
			return;
		}
		if (command.length == 0){
			dubbz.showError('What exactly do you want me to submit, genius?');
			return;
		}

		dubbz.sendCommand(handle, command, function(){
			dubbzui.refreshChatlog();
		});
		
		$("#command").focus();
		
		//prevent form from actually submitting
		return false;
	});

	$("#refresh").click(function(e){
		e.preventDefault();
		dubbzui.refreshChatlog();
	});
	
	//don't allow double-submit of any forms
	$("form").preventDoubleSubmit();
	
	dubbzui.startRefresher();
	
	$("#autoRefresh").click(function(){
		var checked = $(this).attr("checked") == "checked";
		console.log("checked?",checked);
		if (checked) dubbzui.startRefresher();
		else dubbzui.stopRefresher();
	});
	
});
