// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require turbolinks
//= require datatables
//= require_tree .

$(document).on("ready page:change", function(){
  $('#query').focus();
  $('.sidebar-tooltip').tooltip({container: 'body', html: true});
  $('.sidebar-popover').popover({container: 'body', html: true});

  $('#card-number-input').focus(); 
  $('#card-number-input').bind("change", function() {
    $.ajax({
      url: "/participants/lookup.json",
      type: "POST",
      data: {
        card_number: $('#card-number-input').val()
      }      
    }).done( function(data) {
      console.log(data['name']);
      console.log($(this));
      $('#card-number-input').parent().children().first().val(data['id']);
      $('#card-number-input').parent().children().last().html("</br><div class=\"panel panel-success\"><div class=\"panel-heading\">Participant Info</div><div class=\"panel-body\">" + data["name"] + "</div>");
    }).error( function(data) {
      $('#card-number-input').parent().children().first().val("");
      $('#card-number-input').parent().children().last().html("</br><div class=\"panel panel-danger\"><div class=\"panel-heading\">Participant Not Found</div><div class=\"panel-body\">If this message persists please try entering their AndrewID instead.</div>")
    });
  });
  
  $('#card-number-input').bind("keydown", function() {
    if (window.event && window.event.keyCode == 13) {
      event.preventDefault();
      $('#main-content-div :submit').focus()
    }
  });
  
  $( ".pending-member" ).click(function() {
    $("#" + this.id).remove();
  });
  
});

function _toggleText(el, opt1, opt2){
  var $el = $(el);
  if($el.html().trim() == opt1.trim()) $el.html(opt2);
  else if($el.html().trim() == opt2.trim()) $el.html(opt1);
}

$(document).ready(function () {
  $('#tasks').DataTable();
});

