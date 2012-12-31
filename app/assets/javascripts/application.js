//= require_tree .

$(function() {

  var container = $('#container');
  container.isotope({
    itemSelector : '.item',
    layoutMode : 'fitRows'
  });

  $('#fbtab').hover(function() {
    this.src = 'images/Like_hover.png';
  }, function() {
    this.src = 'images/Like.png';
  });
  $('#twtab').hover(function() {
    this.src = 'images/Follow_hover.png';
  }, function() {
    this.src = 'images/Follow.png';
  });
  $('#footer_fb').mouseover(function(){
    $(this).attr("src",'/images/footer_fb_hover.png');
  })
  .mouseout(function(){
    $(this).attr("src",'/images/footer_fb.png');
  });
  
  $('#footer_twitter').mouseover(function(){
    $(this).attr("src",'/images/footer_twitter_hover.png');
  })
  .mouseout(function(){
    $(this).attr("src",'/images/footer_twitter.png');
  });
  // Login Form

$(function() {
    var button = $('#loginButton');
    var box = $('#loginBox');
    var form = $('#loginForm');
    button.removeAttr('href');
    button.mouseup(function(login) {
        box.toggle();
        button.toggleClass('active');
    });
    form.mouseup(function() { 
        return false;
    });
    $(this).mouseup(function(login) {
        if(!($(login.target).parent('#loginButton').length > 0)) {
            button.removeClass('active');
            box.hide();
        }
    });
});


});

function open_in_new_tab(url)
{
  window.open(url, '_blank');
  window.focus();
}
