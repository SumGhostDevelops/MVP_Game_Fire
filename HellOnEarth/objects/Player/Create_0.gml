/// @description Game Constants

window_set_size(1270, 720);
gpu_set_texfilter(false);
controlsSetup();

// Functions
function setOnGround(_val = true){

	if _val == true{
	Grounded = true;
	coyoteHangTimer = coyoteHangFrames;
	
	}else{
	Grounded = false;
	coyoteHangTimer = 0;
	
	}
}


// Constants and Variables
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

// Coyote Time
coyoteHangFrames = 2;
coyoteHangTimer = 0;
// buffer
coyoteJumpFrames = 5;
coyoteJumpTimer = 0;