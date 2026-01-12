

function rainHurt(){
// Step Event


y += fall_speed;

// Destroy if off-screen or hit ground
if (y > room_height || place_meeting(x, y, Ground)) {
    instance_destroy();
}


 
// Collision with player
if (place_meeting(x, y, Player)) {
    // Damage player
    with(Player) {
		

		audio_play_sound(SoundLava,1,false);
		
		
		 Health -= 1;
		   
    }
    instance_destroy();
	}

}

