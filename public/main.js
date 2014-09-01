
//$.getScript("./infoview.js");

//var view = new infoview();

var lock_chiba = false;
var lock_hiroshima = false;
var lock_hokkaido = false;

$(document).ready(function(){

    $("#chiba").hover(function () {
        if(!(lock_chiba)){
            lock_chiba = true;
            $('#info-chiba').transition({ opacity: 1 });
            $('.info-name-chiba').shuffleLetters();
            $('.rainfall-chiba').shuffleLetters();
            $('.temperature-chiba').shuffleLetters();
            $('.windspeed-chiba').shuffleLetters();
            setTimeout(function(){
                $('#line-to-info').transition({ opacity: 1 });
            },600);
        }
    }, function(){
        setTimeout(function(){
            $('#info-chiba').transition({ opacity: 0 });
            $('#line-to-info').transition({ opacity: 0 });
            lock_chiba = false;
        },3000);
    });

    $("#hiroshima").hover(function () {
        if(!(lock_hiroshima)){
            lock_hiroshima = true;
            $('#info-hiroshima').transition({ opacity: 1 });
            $('.info-name-hiroshima').shuffleLetters();
            $('.rainfall-hiroshima').shuffleLetters();
            $('.temperature-hiroshima').shuffleLetters();
            $('.windspeed-hiroshima').shuffleLetters();
            setTimeout(function(){
                $('#line2-to-info').transition({ opacity: 1 });
            },600);
        }
    }, function(){
        setTimeout(function(){
            $('#info-hiroshima').transition({ opacity: 0 });
            $('#line2-to-info').transition({ opacity: 0 });
            lock_hiroshima = false;
        },3000);
    });

    $("#nayori").hover(function () {
        if(!(lock_hokkaido)){
            lock_hokkaido = true;
            $('#info-hokkaido').transition({ opacity: 1 });
            $('.info-name-hokkaido').shuffleLetters();
            $('.rainfall-hokkaido').shuffleLetters();
            $('.temperature-hokkaido').shuffleLetters();
            $('.windspeed-hokkaido').shuffleLetters();
            setTimeout(function(){
                $('#line3-to-info').transition({ opacity: 1 });
            },600);
        }
    }, function(){
        setTimeout(function(){
            $('#info-hokkaido').transition({ opacity: 0 });
            $('#line3-to-info').transition({ opacity: 0 });
            lock_hokkaido = false;
        },3000);
    });

});

