
var isPlaying = false;

createjs.Sound.alternateExtensions = ["mp3"];

createjs.Sound.registerSound("sounds/rain/1.mp3", "rain1", 50);
createjs.Sound.registerSound("sounds/rain/2.mp3", "rain2", 50);
createjs.Sound.registerSound("sounds/rain/3.mp3", "rain3", 50);
createjs.Sound.registerSound("sounds/rain/4.mp3", "rain4", 50);
createjs.Sound.registerSound("sounds/rain/5.mp3", "rain5", 50);
createjs.Sound.registerSound("sounds/wind/1.mp3", "wind1", 50);
createjs.Sound.registerSound("sounds/wind/2.mp3", "wind2", 50);
createjs.Sound.registerSound("sounds/wind/3.mp3", "wind3", 50);

function toggle () {

  if(isPlaying){
    for (var i = 0; i < arguments.length; i++) {
          stop(arguments[i]);
    }
    //stop(arguments[0])
  }else{
    for (var i = 0; i < arguments.length; i++) {
          play(arguments[i]);
    }
    //play(arguments[0])
  }

}

function play (sound_id) {
  $(".triangle").css("opacity","0");
  $(".playing").css("opacity","1");
  createjs.Sound.play(sound_id);
  isPlaying = true;
}

function stop (sound_id) {
  $(".triangle").css("opacity","1");
  $(".playing").css("opacity","0");
  createjs.Sound.stop(sound_id);
  isPlaying = false;
}
