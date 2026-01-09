function Jump()
{
}

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

function MouseInput()
{
}

function WASD()
{
	// W
	if(keyboard_check_pressed(vk_up))
	{	Jump();
	}
	// S
	if(keyboard_check_pressed(vk_down))
	{	Crouch()
	}
	// A
	if(keyboard_check_pressed(vk_left))
	{
	}
	// D
	if(keyboard_check_pressed(vk_right))
	{
	}
}


function Special()
{
	// Space Bar
	if(keyboard_check_pressed(vk_space))
	{	Jump();
	}
}

function GameInput()
{
	MouseInput();
	WASD();
	Special();
}