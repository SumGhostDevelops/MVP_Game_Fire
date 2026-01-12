var t = global.final_ticks;

var totalSeconds = floor(t / 1_000_000);
var minutes = totalSeconds div 60;
var seconds = totalSeconds mod 60;

var timeText = string(minutes) + ":" + string_format(seconds, 2, 0);

draw_set_alpha(1);
draw_set_color(c_red);


draw_text_transformed(100, 100, "Final Time: " + timeText, 4, 4, 0);
