$(document).ready(function(){
	$("#preview").click(function(){
		if($(this).attr('status') == 'edit'){
			// hide all button
			$(this).attr('status', 'preview');
			$(this).text('Edit');
			$("img.upload-image").each(function(){
				$(this).hide();
			});
			$("img.upload-code").each(function(){
				$(this).hide();
			});
			
			$("div.content-pic-wrapper").each(function(){
				$(this).hide();
			});
		}else if( $(this).attr('status') == 'preview'){
			$(this).attr('status', 'edit');
			$(this).text('Preview');
			$("img.upload-image").each(function(){
				$(this).show();
			});
			$("img.upload-code").each(function(){
				$(this).show();
			});	
		}
	});

	$("#add_step").click(function(){
		// code to add step
	
		var $step = $('#step-n').clone().attr('id', '').show();
		var stepCounter  = $('div.step').length;
		
		$step.attr('id', "step-" + (stepCounter ) ); 
		$step.appendTo("ul#steps-container");
		
		
		var authenticity_token = "";
		$("input[type='hidden']", $("form.new_step_title").first() ).each(function(){
			if($(this).attr('name') == 'authenticity_token'){
				authenticity_token = $(this).attr('value');
				return false;
			}
		});
		
		var loading_bar = "loading-bar-" + (stepCounter ) ;
		$("div.loading-bar", $step ).attr('id', loading_bar );
		// console.log( loading_bar );
		// set the input.uploadify
		var input_uploadify = "uploadify-" + stepCounter; 
		$("input.uploadify", $step ).attr('id', input_uploadify );
		// set the ul.uploaded_pic_wrapper 
		var pic_wrapper = "pic-wrapper_" + stepCounter;
		$("ul.uploaded_pic_wrapper", $step ).attr('id', pic_wrapper );
		// set the input.order 
		$("input.order", $step).each(function(){
			$(this).attr('value', stepCounter);
		});
		
		
		// added auth_token
		$("form.add_detail_code input.auth_tok" , $step).attr('value', authenticity_token);
		
		//textarea id
		var textarea_id = 'codify-' + stepCounter;
		$("form.add_detail_code textarea.codify", $step).attr('id', textarea_id);
		
		// post owner-- no.. it is correct
		// secret key -- from the server
		//order done
		// $("form.add_detail_code input.order").attr('value', textarea_id);
		// loading codify
		var loading_codify = "loading-codify-" + stepCounter;
		$("div.loading-codify", $step).attr('id', loading_codify);
		
		
		
		return false;
	});
	
	$("#main").keypress(function(e){
		if(e.keyCode == '13'){
			var classValue = $(e.target).parent().attr('class');
			if( classValue=="new_step_title" || classValue=="new_step_description" || 
				classValue=="post_title" ){
					return false;
			}
		}
	});
	
	$("#main").submit(function(e){
		var $target= $(e.target);
		var $target_parent = $target.parent();
		if( $target.hasClass("add_detail_code") ){
			// console.log("Yeah");
		}
		// console.log("boom boom");
		$("textarea", $target).hide();
		$("input[type='submit']", $target).hide();
		$("h2", $target.parent()).hide();
		$("div.loading-codify", $target).show();
		var dataSend = $target.serialize();
		var destination = $target.attr('action');
		$.ajax({
			type: "POST",
			url: destination,
			data: dataSend,
			dataType : 'script',
			success: function(response){
				// $("form.post_title", $target.parent() ).replaceWith(new_form);
				// console.log("response received");
				// alert(content);
				if( $("img.upload-code", $target_parent.parent()).hasClass('no-show') ){
					// nothing
				}else{
					$("img.upload-code", $target_parent.parent()).addClass('no-show');
				}
	
				$("div.uploaded_code_container", $target.parent().parent()).html("");
				$("div.uploaded_code_container", $target.parent().parent()).append(new_content);
	
				$("div.uploaded_code_container pre", $target.parent().parent()).syntaxHighlight({showGutter: false, showControls: false, firstLine: 1});  

			
				$target= $target.replaceWith(new_form);
				$target_parent.hide();
				// $target.hide();
			}
		});
		return false;
	});
	
	$("#main").click(function(e){
		var $target = $(e.target);
		
		// for pic upload
		
		if($target.hasClass('upload-code')){
			if($target.hasClass('no-show')){
				$("div.content-code-wrapper", $target.parent()).show();
				$target.removeClass('no-show');
			}else{
				$("div.content-code-wrapper", $target.parent()).hide();
				$target.addClass('no-show');
			}
			
		}
		
		
		if( $target.hasClass("upload-image")){			
			var destination = $("form.add_detail_pic", $target.parent() ).attr('action');
			var session_key_name = $("#session_key_name").attr('value');
			var session_key_value = $("#session_key_value").attr('value');
			var auth_token  = $("#uploadify_auth_token").attr('value');
			var step_order = $("form.new_step_description input.order", $target.parent().parent()).attr('value');
			var uuid   = $("form.new_step_description input.secret_key", $target.parent().parent()).attr('value');
			var post_owner = $("form.new_step_description input.post_owner", $target.parent().parent()).attr('value');
			
			var loading_bar = $("div.loading-bar", $target.parent() ).attr('id');
			var uploadify_object_id = "#" + $("input.uploadify", $target.parent()).attr('id');
			var dataSend = {};
			dataSend['from_uploadify'] = "yes";
			dataSend[session_key_name] = session_key_value;
			dataSend['authenticity_token'] = encodeURIComponent(auth_token);
			dataSend['step_order'] = step_order;
			dataSend['uuid']  = uuid;
			dataSend['post_owner']  = post_owner;
			
			if( $(uploadify_object_id + "Uploader").length == 0){
				$( uploadify_object_id, $target.parent() ).uploadify({
					'uploader'       : '/swf/uploadify.swf',
					'script'         : destination,
					'cancelImg'      : '/images/cancel.png',
					'fileDataName'    : 'detail[photo]',
					'folder'         : 'uploads',
					'queueID'        : loading_bar, 
					'auto'           : true,
					'multi'          : true,
					'scriptAccess'   : 'always',
					onComplete : function(event, queueID, fileObj, response, data ){
						// console.log("ZOMG... ");
						
						var obj= $.parseJSON( response );
						// console.log(response);
						// var $image = $("<img src='" + obj.img_source + "' />");
						//  
						// $image.appendTo( $("ul.uploaded_pic_wrapper", $target.parent()));
						// $image.wrap("<li />");
						// console.log("appended");
						// alert(obj.id);
						var destination_container_id = "#" + $("ul.uploaded_pic_wrapper", $target.parent()).attr('id');
						var $new_loader = $("#loader").clone().attr('id', '').show();
						$new_loader.appendTo( destination_container_id );
						$new_loader.wrap("<li id='detail-image-" + obj.id +"' />");
						getImageReady(obj.id, obj.destination);
					},
					'scriptData' 		 : dataSend
				});
			}else{
				
			}
			$("div.content-pic-wrapper", $target.parent()).show();
		}
		
		
		if(  $target.attr('id') == "post-title" ) {
			if($target.hasClass("loading")){
				return false;
			}
			$target.hide();
			$("form.post_title", $target.parent() ).show();
			$("form.post_title input[type='text']", $target.parent() ).focus();
			$("form.post_title input[type='text']", $target.parent() ).blur( function(){
				if(this.value == this.defaultValue){
					$target.show();
					$("form.post_title", $target.parent() ).hide();
				}else{
					$("form.post_title input[type='text']", $target.parent() ).unbind('blur');
					var formdata = $("form.post_title", $target.parent() ).serialize();
					var destination = $("form.post_title", $target.parent() ).attr('action');
					
					
					var new_text = $("form.post_title input[type='text']", $target.parent() ).attr('value');
					$target.text( new_text );
					
					$("form.post_title", $target.parent() ).hide();
					$target.show();
					$.ajax({
						type: "POST",
						url: destination,
						data: formdata,
						dataType : 'script',
						success: function(response){
							$("form.post_title", $target.parent() ).replaceWith(new_form);
						}
					});
				}
			});
		}
		
		if( $target.parent().hasClass('step') ){
			if($target.hasClass("loading")){
				return false;
			}
			if( $target.is('h2') ){
				$target.hide();
				$("form.new_step_title input[type='text']", $target.parent() ).show();
				$("form.new_step_title input[type='text']", $target.parent() ).focus();
				$("form.new_step_title input[type='text']", $target.parent() ).blur( function(){
					if(this.value == this.defaultValue){
						$target.show();
						$("form.new_step_title input[type='text']", $target.parent() ).hide();
					}else{
						var new_text = $("form.new_step_title input[type='text']", $target.parent() ).attr('value');
						$("form.new_step_title input[type='text']", $target.parent() ).unbind('blur');
						$target.text( new_text );
						$target.show();
						$target.addClass("loading");
						$("form.new_step_title", $target.parent() ).hide();
						
						var formdata = $("form.new_step_title", $target.parent() ).serialize();
						var destination = $("form.new_step_title", $target.parent() ).attr('action');
						$.ajax({
							type: "POST",
							url: destination,
							data: formdata,
							datatype : 'script',
							success: function(response){
								// alert("a title has just been added");
								$("form.new_step_title", $target.parent() ).replaceWith(new_form);
								// it seems that we have to wait the DOM replacement to finish
								$target.removeClass("loading");
							}
						});
					}

				});
			} 
			
			if( $target.is('p') ){
				
				$target.hide();
				$("form.new_step_description textarea", $target.parent() ).show();
				$("form.new_step_description textarea", $target.parent() ).focus();

				$("form.new_step_description textarea", $target.parent() ).blur( function(){
					if(this.value == this.defaultValue){
						$target.show();
						$("form.new_step_description textarea", $target.parent() ).hide();
					}else{
						var new_text = $("form.new_step_description textarea", $target.parent() ).attr('value');
						$("form.new_step_description textarea", $target.parent() ).unbind('blur');
						$target.text( new_text );
						$target.show();
						$target.addClass("loading");
						$("form.new_step_description", $target.parent() ).hide();
						
						var formdata = $("form.new_step_description", $target.parent() ).serialize();
						var destination = $("form.new_step_description", $target.parent() ).attr('action');
						$.ajax({
							type: "POST",
							url: destination,
							data: formdata,
							datatype : 'script',
							success: function(response){
								// $target.text( title );
								$("form.new_step_description", $target.parent() ).replaceWith(new_form);
								$target.removeClass("loading");
							}
						});
					}
				});
			}
		}	
	});
	

	$("#main").focus(function(e){
		var $target_focus = $(e.target);
		if( $target_focus.is("input[type='text']") || $target_focus.is('textarea')){
			e.target.select();
		}
	});
});



function getImageReady( detail_id, destination ){
	var dest = "'" + destination + "'"; 
	var funct =  "getStatus(" +  detail_id + ","   +    dest  +")"; 
	setTimeout( funct , 3000);
}

function getStatus( detail_id, destination){
	var data = {
		'detail_id' : detail_id
	};
	
	// alert( "The interval id inside is " + intervalID);
	$.ajax({
	  url: destination,
	  dataType: 'json',
	  data: data,
	  success: function(response){
			if(response.status == 'OK'){
				replaceImage(detail_id, response.image_location);
				// alert("The status is " + response.status) ;
				// console.log("ok " + response.image_location);
				// alert("the interval id is " + response.interval_id )
				
			}
			else{
				// alert("not ok yet");
				// console.log("not ok yet");
				getImageReady( detail_id, destination )
			}
		}
	});
}

function replaceImage(detail_id, image_location){
	$("#detail-image-" + detail_id + " img").attr('src',image_location );
}




