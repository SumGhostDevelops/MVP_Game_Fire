 getControls();


//Direction 
moveDir = rightKey - leftKey;

//Movement

//X Pos
xSpd = moveDir * moveSpd;


// collision
var _subPixel = .5;

if(place_meeting(x + xSpd, y, Ground))
{
	//precise scoot
	var _pixelCheck = _subPixel * sign(xSpd);
	
	while (!place_meeting(x + _pixelCheck, y, Ground)){
		//moves closer
		x += _pixelCheck;
	}
	
	//if meets at wall, stops moving
	xSpd = 0;
}
// Move 
x+= xSpd;

//Y Pos
// Gravity
if (coyoteHangTimer > 0)
{
coyoteHangTimer--;

}else{


ySpd += GRAV;

setOnGround(false);

}



// terminal velocity
if (ySpd > TERM_VEL){
	
	ySpd = TERM_VEL;
}
if(Grounded){
	
	jumpCount = 0;
	jumpHoldTimer = 0;
	coyoteJumpTimer = coyoteJumpFrames;
	}else{
	if(jumpCount == 0 && coyoteJumpTimer <= 0){ jumpCount = 1;};
	
	}
//jump
	if(jumpKeyBuffered && jumpCount < JUMPMAX)
	{	
		jumpKeyBuffered = false;
		jumpKeyBufferedTimer = 0;
		jumpCount++;
		
		jumpHoldTimer = jumpHoldFrames[jumpCount - 1];
		setOnGround(false);
		
	}
	

	
	if(jumpHoldTimer > 0){
	ySpd = J_SPD[jumpCount - 1];
	jumpHoldTimer--;
	}
		if(!jumpKey){
		jumpHoldTimer = 0;
	}
	
	
	if(place_meeting(x,y + ySpd, Ground)) {
		//scoot
	var _pixelCheckY = _subPixel * sign(ySpd);
	while (!place_meeting(x , y+ _pixelCheckY, Ground)){
		//moves closer
		y += _pixelCheckY;
	}
	//Bonk Code
	if(ySpd < 0){
	jumpHoldTimer = 0;
	}
	ySpd = 0;
	}
	//sets grounded
	if (ySpd >= 0 && place_meeting(x,y+1, Ground)){
		setOnGround(true);
	}
	
	y += ySpd;
