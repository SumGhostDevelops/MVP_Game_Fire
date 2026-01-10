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
	return animationObject.image_index < animationObject.image_number - 1;
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
	
	if(!keyboard_check(vk_shift))
	{	return;
	}
	// Dash Ended.
	if(keyboard_check_released(DashKeyBind))
	{	return;
	}
	
	// Reset dash timer if we ground.
	if(Grounded)
	{	
		dashTimer = DASH_MAX_TIME;
		// Dash Cannot play if we are grounded.
		return;
	}
	
	if(dashTimer > 0)
	{	xMultiplier *= 1.5;
	}
	
	dashTimer -= delta_time;
	
	SetAnimationState(PlayerAnimState.Dashing);
}

function Jump()
{
	var JumpKeyBind = vk_space;
	
	if(!keyboard_check(JumpKeyBind))
	{	return;
	}
	// Jump Ended.	
	if(keyboard_check_released(JumpKeyBind))
	{	return;
	}
	
	if(keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up))
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
	
	SetAnimationState(PlayerAnimState.Jumping);
}

function Handlers()
{
	Dash();
	Crouch();
	Jump();
	
}

function HandleAnimation()
{
	var angle = ComputeCompassAngle(animDirection);
	var sprite = pointer_null;
	var imageIndex = Player.image_index;
	var x1 = Player.x;
	var y1 = Player.y;
	var imageXScale = Player.image_xscale * .05;
	var imageYScale = Player.image_yscale * .05;
	var imageAngle = Player.image_alpha;
	var imageBlend = Player.image_blend;
	var imageAlpha = Player.image_alpha;

	
	switch(animState)
	{
		default:
		case PlayerAnimState.Idle:
			sprite = Sprite4;
			break;
		case PlayerAnimState.Running:
			sprite = SpritePlayerRun;
			
			if(animDirection == Compass.East)
			{	imageXScale = -imageXScale;
			}
			
			break;
		case PlayerAnimState.Crouching:
			sprite = SpritePlayerRun;
			
			if(animDirection == Compass.East)
			{	imageXScale = -imageXScale;
			}
			break;
		case PlayerAnimState.Dashing:
			sprite = SpritePlayerDash;
			
			// Is it in the East Side?
			if(animDirection == Compass.East || animDirection == Compass.NorthEast || animDirection == Compass.SouthEast)
			{	imageXScale = -imageXScale;
			}
			
			// Since dash by default is already tilted x degrees then just adjust.
			var BASE_DASH_ANGLE_OFFSET = 90
			
			imageAngle += angle - BASE_DASH_ANGLE_OFFSET;
			
			break;
		case PlayerAnimState.Jumping:
			sprite = SpritePlayerJump;
			
			if(animDirection == Compass.NorthEast)
			{	imageAngle += angle;
			}
			else if(animDirection == Compass.NorthWest)
			{
				imageXScale = -imageXScale;
				imageAngle += angle;
			}
			
			break;
		case PlayerAnimState.Sliding:
			sprite = SpritePlayerRoll;
			
			if(animDirection == Compass.East)
			{	imageXScale = -imageXScale;
			}
			break;
	}
	
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
	animDirection = Compass.NoDirection;
	xMultiplier = 1;
	yMultiplier = 1;
}

function GameInput()
{	
	PlayerPhysics();
	Handlers();
}

function PlayerPhysics()
{
	rightKey = keyboard_check(vk_right);
	leftKey = keyboard_check(vk_left);
	
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
	
	if (xSpd > 0) 
	{ 
	    if (ySpd > 0)
		{	animDirection = Compass.SouthEast;
	    } 
		else if (ySpd < 0) 
		{	animDirection = Compass.NorthEast;
	    } 
		else 
		{	animDirection = Compass.East;
	    }
	} 
	else if (xSpd < 0) 
	{
	    if (ySpd > 0) 
		{	animDirection = Compass.SouthWest;
	    } 
		else if (ySpd < 0) 
		{	animDirection = Compass.NorthWest;
	    } 
		else 
		{	animDirection = Compass.West;
	    }
	} 
	else 
	{
	    if (ySpd > 0) 
		{	animDirection = Compass.South;
	    } 
		else if (ySpd < 0) 
		{	animDirection = Compass.North;
	    } 
		else 
		{	animDirection = Compass.NoDirection; // idle
	    }
	}
}
