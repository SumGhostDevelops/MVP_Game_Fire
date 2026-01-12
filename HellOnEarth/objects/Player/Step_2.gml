
var CameraWidth = camera_get_view_width(view_camera[0]) / 2;
var CameraHeight = camera_get_view_height(view_camera[0]) / 1.5;

CameraWidth = clamp(0,CameraWidth,   camera_get_view_width(view_camera[0]));


camera_set_view_pos(view_camera[0], x - CameraWidth,0);
