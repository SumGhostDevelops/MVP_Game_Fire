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
		//show_debug_message("Grounded");
		dashTimer = DASH_MAX_TIME;
		// Dash Cannot play if we are grounded.
		return;
	}
	
	if(!keyboard_check(vk_shift))
	{	return;
	}
	
	// Dash Ended.
	if(keyboard_check_released(DashKeyBind))
	{	
		dashTimer = 0;
		return;
	}
	
	if(dashTimer > 0)
	{	
		var angle = ComputeCompassAngle(animDirection);
		var _speed = 5 * (dashTimer / DASH_MAX_TIME);
	
		
		switch(angle)
		{
			case 0:
				yMultiplier /= _speed;
				break;
			case 45:
				yMultiplier /= _speed / 1.5;
				xMultiplier *= _speed / 1.5;
				break;
			case 90:
				xMultiplier *= _speed;
				break;
			case 135:
				yMultiplier /= _speed / 1.5;
				xMultiplier *= _speed / 1.5;
				break;
			case 180:
				yMultiplier *= _speed;
				break;
			case 225:
				yMultiplier /= _speed / 1.5;
				xMultiplier *= _speed / 1.5;
				break;
			case 270:
				xMultiplier *= _speed;
				break;
			case 315:
				yMultiplier /= _speed / 1.5;
				xMultiplier *= _speed / 1.5;
				break;
		}
	}
	
	dashTimer -= delta_time;
	
	SetAnimationState(PlayerAnimState.Dashing);
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
	
	if(keyboard_check(vk_right) || keyboard_check(vk_left))
	{	SetAnimationState(PlayerAnimState.Running);
	}
	
	Dash();
	Crouch();
	Jump();
}

function HandleAnimation()
{
	var angle = ComputeCompassAngle(animDirection);
	var sprite = pointer_null;
	
	var imageXScale = .035;
	var imageYScale = .035;
	var imageAngle  = Player.image_angle;
	var imageBlend  = Player.image_blend;
	var imageAlpha  = Player.image_alpha;

	if(animDirection == Compass.West
			|| animDirection == Compass.NorthWest
			|| animDirection == Compass.SouthWest)
	{	imageXScale = -imageXScale;
	}
	
	switch(animState)
	{
		default:
		case PlayerAnimState.Idle:
			sprite = SpritePlayerRoll;
			break;

		case PlayerAnimState.Running:
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
	
	// ONLY change sprite + reset index
	if (Player.sprite_index != sprite)
	{
		Player.visible = true;
		Player.sprite_index = sprite;
		Player.image_index  = 0;
	}
	
	show_debug_message(Player.sprite_index);
	show_debug_message(Player.image_xscale);
	show_debug_message(Player.image_yscale);
	
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
	DASH_MAX_TIME = (1_000_000) * .75; // (deltatime thing) x seconds
	dashTimer = 0;
	animState = PlayerAnimState.Idle;
	animDirection = Compass.NoDirection;
	xMultiplier = 1;
	yMultiplier = 1;
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
	
	//Movement

	//X Pos
	xSpd = moveDir * moveSpd * xMultiplier;

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

