var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

hover = 0;

if (mx >= btn1.x1 && mx <= btn1.x2 && my >= btn1.y1 && my <= btn1.y2) hover = 1;
if (mx >= btn2.x1 && mx <= btn2.x2 && my >= btn2.y1 && my <= btn2.y2) hover = 2;

if (mouse_check_button_pressed(mb_left))
{
    if (hover == 1)
    {
        room_goto(Room1);
    }
    else if (hover == 2)
    {
        game_end();
    }
}

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);
draw_set_color(c_white);
draw_text(10, 10, "mx=" + string(mx) + " my=" + string(my));
