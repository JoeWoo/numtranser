$(function(){

    // tooltip demo
    $('.tooltip-demo').tooltip({
      selector: "a[data-toggle=tooltip]"
    })

    $('.tooltip-test').tooltip()
    $('.popover-test').popover()

    // popover demo
    $("a[data-toggle=popover]")
      .popover()
      .click(function(e) {
        e.preventDefault()
      })

});

function get_transe(){
var string = $("#editor").html()+"\r\n";
var markers = { "text": string};

$.ajax({
    url: "/secure/transe.json",
    data: JSON.stringify(markers),
    type: "POST",
    contentType: "application/json; charset=utf-8",
    dataType : "json",
    success: function( json ) {

        $( "#result" ).html( json.result );
    },
    error: function( xhr, status ) {
        alert( "Sorry, there was a problem!" );
    }
    // complete: function( xhr, status ) {
    //     alert( "The request is complete!" );
    // }
});
};

function clear_editor () {
  $("#editor").html("");
  $("#result").html("");
  // body...
};


function demo (index){
  $("#editor").html("")
  var div="#"+index
  $("#editor").text($(div).html());
  $("#start").click()
}


