
spr_bg = Title_2;


btn1_text = "START";
btn2_text = "QUIT";


btn1 = { x1: 800, y1: 240, x2: 1200, y2: 370 }; 
btn2 = { x1: 800, y1: 430, x2: 1200, y2: 570 };

// fonts (optional)
font_title =-1;
font_btn   = -1;

hover = 0; 

audio_play_sound(BGM, 1, true);
if (layer_exists("UILayer"))
{
    layer_set_visible("UILayer", false);
}
