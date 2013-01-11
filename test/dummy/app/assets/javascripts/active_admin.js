//= require active_admin/application

$(function() {
  if (!!$.prototype.tooltip) {
    $( '#questions' ).tooltip();
  }
  
  $(".associated_questions :checkbox").change(function(event) {
    
    var action = event.target.checked ? 'add' : 'delete';
    
    $.ajax({
      type: "PUT",
      url: 'answers/' + event.target.value + '/' + action,

      success: function () {
        //console.log('Successfully retrieved ' + name);
      },
      error: function () {
        //console.log('Error retrieving ' + name);
      }
    })
  });
  
});
