/// @description Game Constants

window_set_size(1270, 720);
gpu_set_texfilter(false);
controlsSetup();
GRAV = .27;
TERM_VEL = 5;
J_SPD =  [-4, -2.8];
JUMPMAX = array_length(J_SPD);
jumpCount = 0;
jumpHoldTimer = 0;
jumpHoldFrames = [15, 10];
Grounded = true;

xSpd = 0;
ySpd = 0;

moveDir = 0;
moveSpd = 2;

