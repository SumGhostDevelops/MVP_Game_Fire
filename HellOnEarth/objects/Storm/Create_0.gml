push_force = 0.5; 
storm_width = 400; 
storm_damage_rate = 60; 
damage_timer = 0;
push_speed = 1.5;     
seconds = 0;
if (instance_exists(Player))
{
    seconds = Player.ticks / 1_000_000;
}else{
push_accel = .02;
}
push_accel = lerp(0.01, 0.05, clamp(seconds / 120, 0, 1));      
push_speed_max = 6;      

// Get the background layer
var bg_layer = layer_get_id("Background");

// Make it scroll automatically
layer_hspeed(bg_layer, 1);
layer_vspeed(bg_layer, 0);


var bg_layer = layer_get_id("Background");
layer_x(bg_layer, -x * 0.3); 