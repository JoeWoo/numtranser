var selected_blue_i=1
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
function go(index){
        //$(document).scrollTop(1);
         var ffset= $("#"+index).position().top-83;
         var base_x_flow=$("#result").scrollTop();

            if(ffset > $("#result").height() ){
              $("#result").animate({scrollTop: ffset+base_x_flow-83 }, 1000,function() {
                   titleshow(index);
                });
          }else if(ffset <= 0){
            $("#result").animate({scrollTop: base_x_flow+ffset-83 }, 1000,function() {
                   titleshow(index);
                });
          }
          else{
            titleshow(index);
          }
  };
function highlight (m) {
  dishighlight(selected_blue_i);
  $("#td"+selected_blue_i).css({"background":"#dff0d8","color":"black"})
  selected_blue_i = m;
  $("#td"+selected_blue_i).css({"background":"#08c","color":"white"});
  go(m);
  $("#"+m).css({"background":"blue","color":"white"});
}
function dishighlight (m) {
  titlehide(m);
  $("#"+m).css({"background":"yellow","color":"black"})
}


function titleshow (m) {
  $('#'+m).tooltip('show')
}
function titlehide (m) {
  $('#'+m).tooltip('hide')
}

function render_side_bar () {
  var i=1;
  var table_td="";
  var m= $("#"+i);
  var tb = $("#tb1");

  while(m.length != 0){
    table_td += "<tr id='td"+i+"' onClick='highlight("+i+")' ><td class='minth'>"+i+"</td><td>"+m.text()+"</td><td>"+m.attr("m_value")+"</td><td>"+ m.attr("title")+"</td></tr>";
    i++;
    m=$("#"+i);
  }
  tb.html(table_td);
  titlehide(selected_blue_i);
  dishighlight(selected_blue_i);
}



function get_transe(){
var description = $("#editor").html()+"\r\n";
    description = description.replace(/<br\/>/g, "\n");
    description = description.replace(/<\/?[^>]*>/g, " ");
var markers = { "text": description};

$.ajax({
    url: "/secure/transe.json",
    data: JSON.stringify(markers),
    type: "POST",
    contentType: "application/json; charset=utf-8",
    dataType : "json",
    success: function( json ) {
        $( "#result" ).html(json.result.replace(/\n/g, "<br/>"));
         $('#result-side-bar').hide(100);
          $('#result-side-bar').show(700);
        render_side_bar();
    },
    error: function( xhr, status ) {
        alert( "对不起，由于过去的时间太长，session已失效!\n 请刷新！" );
    }
    // complete: function( xhr, status ) {
    //     alert( "The request is complete!" );
    // }
});
};

function clear_editor () {
  $("#editor").html("");
  $("#result").html("");
  $('#result-side-bar').hide();
  titlehide(selected_blue_i);
  // body...
};

function show_edit () {
  $('#demo').show(700);
  $('input[name="my-checkbox"]').bootstrapSwitch('state', true);
  titlehide(selected_blue_i);
}
function hide_edit () {
  $('#demo').hide(700);
  $('input[name="my-checkbox"]').bootstrapSwitch('state', false);
}

function demo (index){
  if(index=="-1"){
    $("#editor").html("");
    $("#result").html("");
    $("#result-side-bar").hide();
  }else{
    $("#editor").html("")
  var div="#t"+index
  $("#editor").html($(div).html());

  get_transe();

  }
};



