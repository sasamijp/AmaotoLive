
var lock_chiba = false;
var lock_akuseki = false;
var lock_hokkaido = false;

$(document).ready(function(){

    $("#chiba").hover(function () {
        if(!(lock_chiba)){
            lock_chiba = true;
            $('#west').find('#info').transition({ opacity: 1 });
            $('#west').find("#info .info-name").shuffleLetters();
            $('#west').find("#info .rainfall").shuffleLetters();
            $('#west').find("#info .temperature").shuffleLetters();
            $('#west').find("#info .windspeed").shuffleLetters();
            setTimeout(function(){
                $('#west').find('#line').transition({ opacity: 1 });
            },600);
        }
    }, function(){
        setTimeout(function(){
            $('#west').find('#info').transition({ opacity: 0 });
            $('#west').find('#line').transition({ opacity: 0 });
            lock_chiba = false;
        },3000);
    });

  /*  $("#hiroshima").hover(function () {
        if(!(lock_hiroshima)){
            lock_hiroshima = true;
            $('#east').find('#info').transition({ opacity: 1 });
            $('#east').find('#info .info-name').shuffleLetters();
            $('#east').find("#info .rainfall").shuffleLetters();
            $('#east').find("#info .temperature").shuffleLetters();
            $('#east').find("#info .windspeed").shuffleLetters();
            setTimeout(function(){
                $('#east').find('#line').transition({ opacity: 1 });
            },600);
        }
    }, function(){
        setTimeout(function(){
            $('#east').find('#info').transition({ opacity: 0 });
            $('#east').find('#line').transition({ opacity: 0 });
            lock_hiroshima = false;
        },3000);
    });
    */
    $("#akuseki").hover(function () {
        if(!(lock_akuseki)){
            lock_akuseki = true;
            $("#kyushu").find('#info').transition({ opacity: 1 });
            $("#kyushu").find('#info .info-name').shuffleLetters();
            $("#kyushu").find("#info .rainfall").shuffleLetters();
            $("#kyushu").find("#info .temperature").shuffleLetters();
            $("#kyushu").find("#info .windspeed").shuffleLetters();
            setTimeout(function(){
                $('#kyushu').find('#line').transition({ opacity: 1 });
            },600);
        }
    }, function(){
        setTimeout(function(){
            $('#kyushu').find('#info').transition({ opacity: 0 });
            $('#kyushu').find('#line').transition({ opacity: 0 });
            lock_akuseki = false;
        },3000);
    });

    $("#nayoro").hover(function () {
        if(!(lock_hokkaido)){
            lock_hokkaido = true;
            $('#tohoku').find('#info').transition({ opacity: 1 });
            $('#tohoku').find("#info .info-name").shuffleLetters();
            $('#tohoku').find("#info .rainfall").shuffleLetters();
            $('#tohoku').find("#info .temperature").shuffleLetters();
            $('#tohoku').find("#info .windspeed").shuffleLetters();
            setTimeout(function(){
                $('#tohoku').find('#line').transition({ opacity: 1 });
            },600);
        }
    }, function(){
        setTimeout(function(){
            $('#tohoku').find('#info').transition({ opacity: 0 });
            $('#tohoku').find('#line').transition({ opacity: 0 });
            lock_hokkaido = false;
        },3000);
    });

});

