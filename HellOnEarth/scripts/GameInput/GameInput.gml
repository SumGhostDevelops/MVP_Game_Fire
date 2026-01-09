





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

function controlsSetup(){
	bufferTime = 5;
	jumpKeyBuffered = 0;
	jumpKeyBufferedTimer = 0;
	
}
function Jump()
{
	if(jumpKeyPressed)
	{	
		jumpKeyBufferedTimer = bufferTime;
	
	
	}
	
	if(jumpKeyBufferedTimer > 0){
		jumpKeyBuffered = 1;
		jumpKeyBufferedTimer--;
	}else{
	jumpKeyBuffered = 0;
	}
}
function getControls()
{
	//Inputs
	rightKey  = keyboard_check(vk_right) + keyboard_check(ord("D"));
		rightKey = clamp(rightKey, 0, 1);
	leftKey = keyboard_check(vk_left)+ keyboard_check(ord("A"));
		leftKey = clamp(leftKey, 0, 1);
	jumpKeyPressed = keyboard_check_pressed(vk_space);
	jumpKey = keyboard_check(vk_space);
	//buffer
Jump();
	// S
	if(keyboard_check_pressed(vk_down))
	{	Crouch();
	}


}
