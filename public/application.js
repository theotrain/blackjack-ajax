$(document).ready(function(){
  //animate_cards();
  player_hit();
  player_stay();
  prevent_enter();
  //player_action();
  //dealer_hit();
});

function animate_cards() {
  $(document).ready(function(){
    //alert('animate');
    $("#throw_dealer").css({left:-300, top:-400});
    $("#throw_dealer").rotate(-200);
    $("#throw_dealer").rotate({duration:800, animateTo:0,
      callback: function(){
        $.ajax({
        type: 'POST',
        url: '/game/player/stay'
        }).done(function(msg){
          $("div#game").replaceWith(msg);
        });
        return false;
      }
    })
    $('#throw_dealer').animate({ left: "0px",
      top:  "0px",
      }, 600);

    $("#throw_player").css({left:-400, top:-700});
    $("#throw_player").rotate(-200);
    $("#throw_player").rotate({duration:800, animateTo:0})
    $("#throw_player").animate({
     left: 0,
     top:  0,
     }, 600);
    // $( "#throw_player" ).animate({
    // left: 0,
    // top: 0,
    // }, 600, function() {
    // //alert("finished animation");
    // });
    return false;
  });
}

function prevent_enter () {
  $(window).keydown(function(event){
    if(event.keyCode == 13) {
      event.preventDefault();
      return false;
    }
    });
}

// function player_action() {
//   $(document).on("click", "form#hit_form input", function() {
//     alert("player hits!");
//     $.ajax({
//       type: 'POST',
//       url: '/game/player_action'
//     }).done(function(msg){
//       $("div#game").replaceWith(msg);
//     });
//     return false;
//   });
// }

function player_hit() {
  $(document).on("click", "form#hit_form input", function() {
    //alert("player hits!");
    $.ajax({
      type: 'POST',
      url: '/game/player/hit'
    }).done(function(msg){
      $("div#game").replaceWith(msg);
    });
    return false;
  });
}

function player_stay() {
  $(document).on("click", "form#stay_form input", function() {
    $.ajax({
      type: 'POST',
      url: '/game/player/stay'
    }).done(function(msg){
      $("div#game").replaceWith(msg);
    });
    return false;
  });
}
