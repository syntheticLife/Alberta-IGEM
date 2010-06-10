// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


$(document).ready(function() {
	// options for editing steps with ajax form
	var step_options = {
		//target:       '', 
                //beforeSubmit: showRequest,
		//success:      showResponse,
		success:      processStep,
		dataType:     'json',
		//resetForm:  true

	}

	// submit the edits for steps with ajaX
	$('.inplace_edit_step').submit( function() {
		$(this).ajaxForm(step_options);
		$(this).parent().prev().show( "slow" );
		$(this).parent().hide( "slow" );	
		return false;
	});

	// replace step with edit form on click
	$(".step_view").click( function() {
		$(this).next().slideDown( "slow" );
	   	$(this).slideUp( "slow" );	
	});

  // $('#uploadForm input').change(function(){
  //  $(this).parent().ajaxSubmit({
  //   beforeSubmit: function(a,f,o) {
  //   o.dataType = 'json';
  //  },
  //  complete: function(XMLHttpRequest, textStatus) {
   // XMLHttpRequest.responseText will contain the URL of the uploaded image.
   // Put it in an image element you create, or do with it what you will.
   // For example, if you have an image elemtn with id "my_image", then
   //  $('#my_image').attr('src', XMLHttpRequest.responseText);
   // Will set that image tag to display the uploaded image.
   // },
   //});
//});

});	

	
// process the JSON data returned after submitting a step
function processStep(data){
   //var stepId = '.step'+ data.id.toString();

   //var whatDidIFind = $(stepId).html(); 
	   
    // 'data' is the json object returned from the server 
    alert(whatDidIFind);
}

// pre-submit callback 
function showRequest(formData, jqForm, options) { 
    // formData is an array; here we use $.param to convert it to a string to display it 
    // but the form plugin does this for you automatically when it submits the data 
    var queryString = $.param(formData); 
 
    // jqForm is a jQuery object encapsulating the form element.  To access the 
    // DOM element for the form do this: 
    // var formElement = jqForm[0]; 
 
    alert('About to submit: \n\n' + queryString); 
 
    // here we could return false to prevent the form from being submitted; 
    // returning anything other than false will allow the form submit to continue 
    return true; 
} 
 
// post-submit callback 
function showResponse(responseText, statusText, xhr, $form)  { 
    // for normal html responses, the first argument to the success callback 
    // is the XMLHttpRequest object's responseText property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'xml' then the first argument to the success callback 
    // is the XMLHttpRequest object's responseXML property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'json' then the first argument to the success callback 
    // is the json data object returned by the server 
 
    alert('status: ' + statusText + '\n\nresponseText: \n' + responseText + 
        '\n\nThe output div should have already been updated with the responseText.'); 
} 
