function Jump()
{
}

function Crouch()
{
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