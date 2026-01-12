var gw = display_get_gui_width();
var gh = display_get_gui_height();




draw_set_font(font_btn);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

DrawButtonLabel(btn1, btn1_text, hover == 1);
DrawButtonLabel(btn2, btn2_text, hover == 2);


function DrawButtonLabel(b, text, isHover)
{
    var cx = (b.x1 + b.x2) * 0.5;
    var cy = (b.y1 + b.y2) * 0.5;


    var scale = isHover ? 1.15 : 1.00;
    var col   = isHover ? c_white : c_ltgray;


    if (isHover)
    {
        draw_set_alpha(0.5);
        draw_set_color(c_blue);
        draw_rectangle(b.x1, b.y1, b.x2, b.y2, false);
        draw_set_alpha(1);
    }

    draw_set_color(col);
    draw_text_transformed(cx, cy, text, scale, scale, 0);
}
