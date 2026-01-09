if!(instance_exists(Player)){ exit; }
var _camWidth = camera_get_view_width(view_camera[0]);
var _camHeight = camera_get_view_height(view_camera[0]);



var _camX = Player.x - _camWidth/2;
var _camY = Player.y - _camHeight/2;



_camX = clamp(_camX, 0, room_width - _camWidth);
_camY = clamp(_camY, 0, room_height - _camHeight);


finalCamX += (_camX - finalCamX) * camTrailSpeed;
finalCamY += (_camY - finalCamY) * camTrailSpeed;

scrollSpeed+= logn(scrollSpeed, scrollSpeed);

show_debug_message(scrollSpeed);
camera_set_view_pos(view_camera[0], scrollSpeed, finalCamY);

