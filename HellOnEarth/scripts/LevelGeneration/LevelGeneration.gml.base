function LevelGeneration(){
	// at bottom of the screen for right now, generate an instance of the ground'
// Create Event
chunk_width = 1024;
chunk_height = 1024;
chunks = ds_list_create();
current_chunk_x = 0;

// Generate initial chunks
repeat(3) {
    generate_chunk(current_chunk_x);
    current_chunk_x++;
	}
	
}


function generate_chunk(chunk_x) {
    var chunk_start_x = chunk_x * chunk_width;
    
    // Calculate how many 16x16 blocks fit across the chunk width
    var blocks_across = chunk_width / Ground.sprite_width;
    
    // Spawn ground blocks at the bottom
    for(var i = 0; i < blocks_across; i++) {
        var block_x = chunk_start_x + (i *  Ground.sprite_width);
        var block_y = room_height -  Ground.sprite_height; 
        instance_create_layer(block_x, block_y, "Instances", Ground);
    }
    
    ds_list_add(chunks, chunk_x);
}