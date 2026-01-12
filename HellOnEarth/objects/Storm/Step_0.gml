
push_speed = min(push_speed + push_accel, push_speed_max);
x += push_speed;


if (instance_exists(Player)) {
 
    if (Player.x < x) {
 
        with(Player) {
            xSpd -= other.push_force;
        }
       
        damage_timer++;
        if (damage_timer >= storm_damage_rate) {
            var dmg = clamp(10 + seconds * 0.2, 10, 40);
			Player.Health -= dmg;
			audio_play_sound(SoundLava,1,false, 5);
            damage_timer = 0;
        }
    } else {
        damage_timer = 0; 
    }
}