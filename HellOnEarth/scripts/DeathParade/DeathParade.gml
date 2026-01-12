function DeathParade(){
spawn_timer--;
if (spawn_timer <= 0) {
    // Spawn rain near player view
    var spawn_x = Player.x + irandom_range(-400, 400);
    var spawn_y = Player.y - 300; // Above screen
    instance_create_layer(spawn_x, spawn_y, "Instances", RainDrop);
    spawn_timer = spawn_rate;
}
}