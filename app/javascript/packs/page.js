import $ from 'jquery'
window.$ = $

$(document).ready(function() {
  $('.wiki-content').click(function() {
    var content = $(this.children).data('meta-content');
    var wiki_name = $(this.children).text();

    if(content['message'] === "No matching data found") {
      $('#meta-content').html(content['message']);
    } else {
      $('#meta-content').html(get_content(content, wiki_name));
    }
  });
});

function get_content(content, name) {
  var metadata = "<p>Wikipedia pages for "+ name +"</p>"
  $.each( content, function( key, value ) {
    metadata = metadata +
    "<div class='row'>"+
    "<div class='col-md-12 border meta-content'>"+
    "Language: "+key+"  <a href='"+value['link']+"'>link</a>"+
    " |  Word count: "+ value['word_count']+
    "</div>"+
    "</div>"
  });

  return metadata;
}
