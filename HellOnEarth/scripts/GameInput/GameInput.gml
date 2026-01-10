enum PlayerAnimState
{
	Idle,
	Running,
	Jumping,
	Crouching,
	Sliding,
	Dashing,
}

enum Compass
{
	North,
	South,
	East,
	West,
}


function Crouch()
{
	Slide();
		
	animState = PlayerAnimState.Crouching;
	return;

}

function Slide()
{
	animState = PlayerAnimState.Sliding;
}

function Dash()
{	
	if(keyboard_check_pressed(vk_shift) && (!Grounded || coyoteHangTimer > 0))
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
	{	
		dashTimer -= (delta_time);
		animState = PlayerAnimState.Dashing;
	}
	
}

function MouseInput()
{
}

function Jump()
{
	animState = PlayerAnimState.Jumping;
	
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

function HandleAnimation()
{
	sprite = pointer_null;
	imageIndex = Player.image_index;
	x1 = Player.x;
	y1 = Player.y;
	imageXScale = Player.image_xscale * .05;
	imageYScale = Player.image_yscale * .05;
	imageAngle = Player.image_alpha;
	imageBlend = Player.image_blend;
	imageAlpha = Player.image_alpha;
	
	
	switch(animDirection)
	{
		case Compass.North:
			break;
		case Compass.South:
			break;
		case Compass.East:
			break;
		case Compass.West:
			break;
	}
	
	switch(animState)
	{
		default:
		case PlayerAnimState.Idle:
		case PlayerAnimState.Running:
			if(animDirection == Compass.West)
			{	imageXScale = -imageXScale;
			}
			sprite = SpritePlayerRun;
			break;
		case PlayerAnimState.Crouching:
			sprite = SpritePlayerRun;
			break;
		case PlayerAnimState.Dashing:
			sprite = SpritePlayerDash;
			break;
		case PlayerAnimState.Jumping:
			sprite = SpritePlayerJump;
			break;
		case PlayerAnimState.Sliding:
			sprite = SpritePlayerRoll;
			break;
	}
	
	show_debug_message(sprite);
	show_debug_message(animDirection);
	
	draw_sprite_ext(sprite, imageIndex, x1, y1, imageXScale, imageYScale, imageAngle, imageBlend, imageAlpha);
}

function GameInputSetup()
{
	bufferTime = 5;
	jumpKeyBuffered = 0;
	jumpKeyBufferedTimer = 0;
	dashing = false;
	DASH_MAX_TIME = (1_000_000) * .30; // (deltatime thing) x seconds
	dashTimer = 0;
	animState = PlayerAnimState.Idle;
	animDirection = Compass.West;
}

function GameInput()
{
	//Inputs
	rightKey = keyboard_check(vk_right) || keyboard_check(ord("D"));
	leftKey = keyboard_check(vk_left) || keyboard_check(ord("A"));
	upKey = keyboard_check(vk_up) || keyboard_check(ord("W"))
	downKey = keyboard_check(vk_down) || keyboard_check(ord("S"))
	
	animState = PlayerAnimState.Idle;
	
	if(keyboard_check(vk_space))
	{	Jump();
	}
	
	if(keyboard_check(vk_down))
	{	Crouch();
	}
	
	Dash();
	
	
	//Direction 
	moveDir = rightKey - leftKey;

	if(moveDir)
	{
		if(leftKey)
		{	animDirection = Compass.West;
		}
		else
		{	animDirection = Compass.East;
		}
	}
	else
	{
		if(upKey && downKey)
		{
		}
		else if(upKey)
		{	animDirection = Compass.North;
		}
		else if(downKey)
		{	animDirection = Compass.South;
		}
		
	}
	
	//Movement

	//X Pos
	xSpd = moveDir * moveSpd;

	if(moveDir && animState == PlayerAnimState.Idle)
	{	animState = PlayerAnimState.Running;
	}
	
	if(dashing)
	{	xSpd *= (4 * (dashTimer / DASH_MAX_TIME))
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
