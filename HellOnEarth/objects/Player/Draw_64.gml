var totalSeconds = floor(ticks / 1_000_000);
var minutes = totalSeconds / 60;
var seconds = totalSeconds % 60;

// format 00:00
var timeText = string(minutes) + ":" + string_format(seconds, 2, 0);

// style
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// position (top-left)
draw_text(100, 16, "Time: " + timeText);