$(function(){
  $(document).on('ajax:success', '.replaceable', function(e, data){
    $(this).replaceWith(data.replaceable)
  })
  
  var post_id_from = function(object) {
    parseInt(object.parents('article.post:first').data('post-id'))
  }
  
  $('a.bookmark').each(function(i, element){
    var a, title, post_id, url
    a = $(element)
    post_id = post_id_from(a)
    
    if (_.include(window.current_user.bookmarks, post_id)) {
      title = 'Unbookmark'
      url   = ''
    } else {
      title = 'Bookmark'
    }
    a.html(title)
  })
});
