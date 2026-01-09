function Crouch()
{
	tmp = 10
	MIN_SPEED_SLIDE = 15
	
	if(tmp > MIN_SPEED_SLIDE)
	{	
		Slide();
		return;
	}
}

function Slide()
{
}

function Dash()
{	
	if(keyboard_check_pressed(vk_shift))
	{	
		dashing = true;
		dashTimer = DASH_MAX_TIME;
	}
	
	if(keyboard_check_released(vk_shift))
	{	dashing = false;
	}
	
	if(Grounded)
	{	dashing = false;
	}
	
	if(dashTimer <= 0)
	{	dashing = false;
	}
	
	if(!dashing)
	{	//dashTimer = 0;
	}
	
	if(dashing)
	{	dashTimer -= (delta_time / 100000);
	}
	
	show_debug_message(dashTimer);
}

function MouseInput()
{
}

function Jump()
{
	if(keyboard_check_pressed(vk_space))
	{	jumpKeyBufferedTimer = bufferTime;
	}
	
	if(jumpKeyBufferedTimer > 0)
	{
		jumpKeyBuffered = 1;
		jumpKeyBufferedTimer--;
	}
	else
	{
		jumpKeyBuffered = 0;
	}
}

function GameInputSetup()
{
	bufferTime = 5;
	jumpKeyBuffered = 0;
	jumpKeyBufferedTimer = 0;
	dashing = false;
	DASH_MAX_TIME = (delta_time / 100000) * .5; // (deltatime thing) x seconds
	dashTimer = 0;
}

function GameInput()
{
	//Inputs
	rightKey = keyboard_check(vk_right) || keyboard_check(ord("D"));
	leftKey = keyboard_check(vk_left) || keyboard_check(ord("A"));
	
	if(keyboard_check(vk_space))
	{	Jump();
	}
	
	if(keyboard_check(vk_down))
	{	Crouch();
	}
	
	Dash();
	
	
	//Direction 
	moveDir = rightKey - leftKey;

	//Movement

	//X Pos
	xSpd = moveDir * moveSpd;

	if(dashing)
	{	xSpd *= 2
	}

	// collision
	var _subPixel = .5;

	if(place_meeting(x + xSpd, y, Ground))
	{
		//precise scoot
		var _pixelCheck = _subPixel * sign(xSpd);
	
		while (!place_meeting(x + _pixelCheck, y, Ground))
		{
			//moves closer
			x += _pixelCheck;
		}
	
		//if meets at wall, stops moving
		xSpd = 0;
	}
	
	// Move 
	x += xSpd;

	//Y Pos
	// Gravity
	if (coyoteHangTimer > 0)
	{
		coyoteHangTimer--;
	}
	else
	{
		ySpd += GRAV;
		

		setOnGround(false);
	}

	// terminal velocity
	if (ySpd > TERM_VEL)
	{	ySpd = TERM_VEL;
	}
	
	if(Grounded)
	{
		jumpCount = 0;
		jumpHoldTimer = 0;
		coyoteJumpTimer = coyoteJumpFrames;
	}
	else
	{
		if(jumpCount == 0 && coyoteJumpTimer <= 0)
		{	jumpCount = 1;
		};
	
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
	
	if(jumpHoldTimer > 0)
	{
		ySpd = J_SPD[jumpCount - 1];
		jumpHoldTimer--;
	}
	
	if(!keyboard_check(vk_space))
	{	jumpHoldTimer = 0;
	}
	
	
	if(place_meeting(x,y + ySpd, Ground)) 
	{
		//scoot
		var _pixelCheckY = _subPixel * sign(ySpd);
		while (!place_meeting(x , y+ _pixelCheckY, Ground))
		{
			//moves closer
			y += _pixelCheckY;
		}
		//Bonk Code
		if(ySpd < 0)
		{	jumpHoldTimer = 0;
		}	ySpd = 0;
	}
	
	//sets grounded
	if (ySpd >= 0 && place_meeting(x,y+1, Ground))
	{	setOnGround(true);
	}
	
	if(!dashing)
	{	y += ySpd;
	}
}
