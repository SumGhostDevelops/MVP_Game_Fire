/// @description Game Constants

window_set_max_width(display_get_width());
window_set_max_height(display_get_height());
window_set_min_width(display_get_width() / 5);
window_set_min_height(display_get_height() / 5);
window_set_size(display_get_width() / 1.5, display_get_height() / 1.5);
window_center();
audio_pause_sound(BGM);

gpu_set_texfilter(false);
GameInputSetup();

// Functions
function setOnGround(_val = true){

	if (_val)
	{
		Grounded = true;
		coyoteHangTimer = coyoteHangFrames;
	}
	else
	{
		Grounded = false;
		coyoteHangTimer = 0;
	}
}


if (layer_exists("UILayer"))
{
    layer_set_visible("UILayer", true);
}

if (!variable_global_exists("final_ticks")) global.final_ticks = 0;

// Constants and Variables
GRAV = .27;
TERM_VEL = 5;
J_SPD =  [-4, -2.8];
JUMPMAX = array_length(J_SPD);
jumpCount = 0;
jumpHoldTimer = 0;
jumpHoldFrames = [15, 10];
Grounded = true;
scrollSpeed = 0;
camTrailSpeed = .04;
Health = 50;
ticks = 0;
Dead = false;

var totalSeconds = floor(ticks / 1_000_000);
var minutes = totalSeconds / 60;
var seconds = totalSeconds % 60;


xSpd = 0;
ySpd = 0;

moveDir = 0;
moveSpd = 4;

// Coyote Time
coyoteHangFrames = 2;
coyoteHangTimer = 0;
// buffer
coyoteJumpFrames = 5;
coyoteJumpTimer = 0;

