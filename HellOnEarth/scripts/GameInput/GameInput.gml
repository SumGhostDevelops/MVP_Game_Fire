enum PlayerAnimState
{
	// ORDER MATTERS.
	// LOWEST PRIORITY.
	Empty,
	Idle,
	Running,
	Jumping,
	Crouching,
	Sliding,
	Dashing,
	// HEIGHTS PRIORITY.
}

enum Compass
{
	NoDirection,
	North,
	NorthEast,
	NorthWest,
	South,
	SouthEast,
	SouthWest,
	East,
	West,
}

function IsAnimationDone(animationObject)
{
	return animationObject.image_index >= animationObject.image_number - 1;
}

function ComputeCompassAngle(c) 
{
    switch(c) 
    {
        case Compass.North:       return 0;
        case Compass.NorthEast:   return 45;
        case Compass.East:        return 90;
        case Compass.SouthEast:   return 135;
        case Compass.South:       return 180;
        case Compass.SouthWest:   return 225;
        case Compass.West:        return 270;
        case Compass.NorthWest:   return 315;
        default:
        case Compass.NoDirection: return 0;
    }
}


function ComputeCompassIsCardinal(c)
{
	switch(c)
	{
		case Compass.North:
		case Compass.East:
		case Compass.South:
		case Compass.West:
			return true;
		default: 
			return false;
	}
}

function SetAnimationState(state)
{
	// If the current state is not high priority enough skip it.
	if(!IsAnimationDone(Player))
	{
		if(state < animState)
		{	return;
		}
	}
	
	// Else just set it to the animation desired.
	animState = state;
}

function AnimationStateOwner()
{	return animState;
}

function EndAnimationState()
{
	animState = PlayerAnimState.Empty;
}

function Crouch()
{
	var CrouchKeyBind = vk_control;
	
	if(!keyboard_check(CrouchKeyBind))
	{	return;	
	}
	
	// Crouch Ended
	if(keyboard_check_released(CrouchKeyBind))
	{	return;
	}
	
	xMultiplier *= .5;
	yMultiplier *= 2;
	
	SetAnimationState(PlayerAnimState.Crouching);
}

function Slide()
{
	SetAnimationState(PlayerAnimState.Sliding);
}

function Dash()
{	
	var DashKeyBind = vk_shift
	
	// Reset dash timer if we ground.
	if(Grounded)
	{	
		dashTimer = DASH_MAX_TIME;
		
		return;
	}
	
	
	if(!keyboard_check(vk_shift))
	{	return;
	}
	
	// Dash Ended.
	if(keyboard_check_released(DashKeyBind))
	{	
		dashTimer = 0;
		
		if(AnimationStateOwner() == PlayerAnimState.Dashing)
		{	EndAnimationState();
		}
		
		return;
	}
	
	if(dashTimer > 0)
	{	
		var angle = ComputeCompassAngle(animDirection);
		var _speed = 10 * (dashTimer / DASH_MAX_TIME);
	
		
		switch(angle)
		{
			case 0:
				yMultiplier /= -.5 * _speed;
				break;
			case 45:
				yMultiplier /= _speed * -.75;
				xMultiplier *= _speed / 1.5;
				break;
			case 90:
				xMultiplier *= _speed;
				break;
			case 135:
				yMultiplier *= _speed / 1.5;
				xMultiplier *= _speed / 1.5;
				break;
			case 180:
				yMultiplier *= _speed;
				break;
			case 225:
				yMultiplier *= _speed / 1.5;
				xMultiplier *= _speed / 1.5;
				break;
			case 270:
				xMultiplier *= _speed;
				break;
			case 315:
				yMultiplier /= _speed * -.75;
				xMultiplier *= _speed / 1.5;
				break;
		}
		SetAnimationState(PlayerAnimState.Dashing);
	}
	
	dashTimer -= delta_time;
}

function Jump()
{
	var JumpKeyBind = vk_space;
	
	// Jump Ended.	
	if(keyboard_check_released(JumpKeyBind))
	{	return;
	}
	
	if(keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up))
	{	
		jumpKeyBufferedTimer = bufferTime;
		SetAnimationState(PlayerAnimState.Jumping);
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

function Handlers()
{
	SetAnimationState(PlayerAnimState.Idle);
	Dash();
	Crouch();
	Jump();
}

function HandleAnimation()
{
	var angle = ComputeCompassAngle(animDirection);
	var sprite = pointer_null;
	
	var imageXScale = 0.04286;
	var imageYScale = 0.04286;
	var imageSpeed = Player.image_speed;
	var imageAngle  = Player.image_angle;
	var imageBlend  = Player.image_blend;
	var imageAlpha  = Player.image_alpha;
	var prevSound = current_sound;

	if(animDirection == Compass.West
			|| animDirection == Compass.NorthWest
			|| animDirection == Compass.SouthWest)
	{	imageXScale = -imageXScale;
	}
	
	
	switch(animState)
	{
		default: 
		case PlayerAnimState.Empty:
			imageAngle = 0;
			sprite = SpritePlayerIdle;
			break;
		case PlayerAnimState.Idle:
			imageAngle = 0;
			sprite = SpritePlayerIdle;
			
			if(current_sound != SoundIdle)
			{	
				current_sound = SoundIdle;
				audio_play_sound(SoundIdle, 0, true);
			}
			
			break;
		case PlayerAnimState.Running:
			sprite = SpritePlayerRun;
			
			if(current_sound != SoundRunning)
			{	
				current_sound = SoundRunning;
				audio_play_sound(SoundRunning, 0, true);
			}
			
			break;

		case PlayerAnimState.Crouching:
			sprite = SpritePlayerCrouch;
			break;

		case PlayerAnimState.Dashing:
			sprite = SpritePlayerDash;
			
			var BASE_ANGLE_OFFSET = 90;
			
			// assume thing is facing down.
			
			switch(angle)
			{
				case 0:
					angle = 180;
					break;
				case 45:
					angle = 135;
					break;
				case 270:
					angle = 90;
					break;
				case 135:
					angle = 45;
					break;
				case 180:
					angle = 0;
					break;
				case 315:
					angle = 45;
					break;
				case 225:
					angle = 135;
					break;
			}
			
			//show_debug_message(angle);
			angle -= BASE_ANGLE_OFFSET;
		
			imageAngle = angle;
			
			if(current_sound != SoundDash)
			{	
				current_sound = SoundDash;
				audio_play_sound(SoundDash, 0, false);
			}

			break;

		case PlayerAnimState.Jumping:
			sprite = SpritePlayerJump;
			// convert to regular angle
			if(angle > 180)
			{	angle -= 360;
			}
			
			if (angle > 90)
			{	angle = 180 - angle;
			}
			else if (angle < -90)
			{	angle = -180 - angle;
			}	
			
			angle = clamp(angle, -45, 45);

			if (imageXScale < 0) 
			{	angle = -angle;
			}
			
			// clamp to nice angles
			angle = clamp(angle, -10, 10);
			
			imageAngle = angle;

			break;

		case PlayerAnimState.Sliding:
			sprite = SpritePlayerRoll;
		
			break;
	}
	
	if(prevSound != current_sound)
	{	
		if(prevSound != pointer_null)
		{	audio_pause_sound(prevSound);
		}
	}
	
	Player.sprite_index = sprite;
	//Player.image_index  = 0;
	
	/*
	show_debug_message(Player.sprite_index);
	show_debug_message(imageSpeed);
	show_debug_message(imageXScale);
	show_debug_message(imageYScale);
	show_debug_message(imageAlpha);
	show_debug_message(Player.image_xscale);
	show_debug_message(Player.image_yscale);
	*/
	
	Player.image_speed = imageSpeed;
	Player.image_xscale = imageXScale;
	Player.image_yscale = imageYScale;
	Player.image_angle = imageAngle;
	Player.image_blend = imageBlend;
	Player.image_alpha = imageAlpha;
}

function GameInputSetup()
{
	bufferTime = 5;
	jumpKeyBuffered = 0;
	jumpKeyBufferedTimer = 0;
	DASH_MAX_TIME = (1_000_000) * .15; // (deltatime thing) x seconds
	dashTimer = 0;
	animState = PlayerAnimState.Idle;
	animDirection = Compass.NoDirection;
	xMultiplier = 1;
	yMultiplier = 1;
	current_sound = pointer_null;
	audio_play_sound(SoundDungeon, 0, true);
}

function GameInput()
{	
	PlayerPhysics();
	Handlers();
	HandleAnimation();
	//show_debug_message("fps: " + string(1_000_000 / delta_time))
}

function PlayerPhysics()
{
	rightKey = keyboard_check(vk_right) || keyboard_check(ord("D"));
	leftKey = keyboard_check(vk_left) || keyboard_check(ord("A"));
	upKey = keyboard_check(vk_space) || keyboard_check(ord("W"));
	downKey = keyboard_check(vk_down) || keyboard_check(ord("S"));
	
	// determine animDirection
	if (rightKey)
	{
	    if (downKey)         animDirection = Compass.SouthEast;
	    else if (upKey)      animDirection = Compass.NorthEast;
	    else                 animDirection = Compass.East;
	}
	else if (leftKey)
	{
	    if (downKey)         animDirection = Compass.SouthWest;
	    else if (upKey)      animDirection = Compass.NorthWest;
	    else                 animDirection = Compass.West;
	}
	else
	{
	    if (downKey)         animDirection = Compass.South;
	    else if (upKey)      animDirection = Compass.North;
	    //else                 animDirection = Compass.NoDirection; // idle
	}
	
	//Direction 
	moveDir = rightKey - leftKey;
	
	if(rightKey || leftKey)
	{	SetAnimationState(PlayerAnimState.Running);
	}
	else if(AnimationStateOwner() == PlayerAnimState.Running)
	{	EndAnimationState();
	}
	//Movement

	//X Pos
	xSpd = moveDir * moveSpd * xMultiplier;

	// collision
	var _subPixel = .01;

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
	{	coyoteHangTimer--;
	}
	else
	{
		ySpd += GRAV * yMultiplier;

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
	
	if(!keyboard_check(vk_space) && !keyboard_check(vk_up))
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
	
	y += ySpd;
	
	xMultiplier = 1;
	yMultiplier = 1;
}

