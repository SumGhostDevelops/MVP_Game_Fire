/// @description Movement

	yPos += .1;
	xPos = 0;
	// A
	if keyboard_check(vk_left)
	{
		xPos -= 15
	}
	// D
	if keyboard_check(vk_right)
	{
		xPos += 15
	}
	

	
	if(place_meeting(x,y+Ground.sprite_height,Ground)){
		
		yPos = 0;
		
		if(keyboard_check(vk_up)){
			yPos =-( Ground.sprite_height/15);
		}
	}
	
		move_and_collide(xPos, yPos, Ground);
	