chunk_width = 540;
chunk_height = 270;
chunks = ds_list_create();
current_chunk_x = 0;
difficulty_progress = 0;

function generate_chunk(chunk_x) {
    var chunk_start_x = chunk_x * chunk_width;
    var blocks_across = chunk_width / 16;
    
    // Increase difficulty over time
    difficulty_progress = 5 + chunk_x * 0.1; 
    
    var tier_low = room_height - 80;
    var tier_mid = room_height - 160;
    var tier_high = room_height - 240;
    
    //ground 
    for(var i = 0; i < blocks_across; i++) {
        instance_create_layer(chunk_start_x + (i * 16), room_height - 16, "Instances", Ground);
    }
    
    var base_min = 2 + floor(difficulty_progress * 1.0);  
    var base_max = 4 + floor(difficulty_progress * 1.5);  
    base_min = clamp(base_min, 4, 12);
    base_max = clamp(base_max, 8, 16);
    
    var pattern = irandom(6);
    
    switch(pattern) {
        case 0: 
            generate_platforms_at_tier(chunk_start_x, tier_low, base_min, base_max);
            break;
        case 1: 
            generate_platforms_at_tier(chunk_start_x, tier_mid, base_min, base_max);
            break;
        case 2: 
            generate_platforms_at_tier(chunk_start_x, tier_high, base_min - 1, base_max - 1);
            break;
        case 3: 
            generate_platforms_at_tier(chunk_start_x, tier_low, base_min, base_max);
            generate_platforms_at_tier(chunk_start_x, tier_mid, base_min, base_max);
            break;
        case 4: 
            generate_platforms_at_tier(chunk_start_x, tier_mid, base_min, base_max);
            generate_platforms_at_tier(chunk_start_x, tier_high, base_min, base_max);
            break;
        case 5: 
            generate_platforms_at_tier(chunk_start_x, tier_low, base_min, base_max);
            generate_platforms_at_tier(chunk_start_x, tier_high, base_min, base_max);
            break;
        case 6: 
            generate_platforms_at_tier(chunk_start_x, tier_low, base_min - 1, base_max - 1);
            generate_platforms_at_tier(chunk_start_x, tier_mid, base_min, base_max);
            generate_platforms_at_tier(chunk_start_x, tier_high, base_min - 1, base_max - 1);
            break;
    }
    
    // Add vertical walls with safe zone
    var wall_chance = min(0.6 + (difficulty_progress * 0.1), 0.8); 
    if (random(1) < wall_chance) {
        generate_vertical_walls_safe(chunk_start_x, chunk_width / 3); 
    }
    
    ds_list_add(chunks, chunk_x);
}

function generate_platforms_at_tier(chunk_start_x, tier_y, min_platforms, max_platforms) {
    var num_platforms = irandom_range(min_platforms, max_platforms);
    
    for(var i = 0; i < num_platforms; i++) {
        var plat_x = chunk_start_x + irandom(chunk_width - 192);
        var plat_width = irandom_range(6, 12);
        
        for(var j = 0; j < plat_width; j++) {
            instance_create_layer(plat_x + (j * 16), tier_y, "Instances", Ground);
        }
    }
}

function generate_vertical_walls_safe(chunk_start_x, min_gap_size) {
    var num_walls = irandom_range(2, 3);
    var min_spacing = 180; 
    var placed_walls = [];
    

    var safe_zone_start = chunk_start_x + irandom_range(50, chunk_width - min_gap_size - 50);
    var safe_zone_end = safe_zone_start + min_gap_size;
    
    for(var w = 0; w < num_walls; w++) {
        var attempts = 0;
        var valid_position = false;
        var wall_x = 0;
        
        while(!valid_position && attempts < 30) {
            wall_x = chunk_start_x + irandom_range(100, chunk_width - 100);
            valid_position = true;
            
            // Don't place walls in the safe zone
            if(wall_x >= safe_zone_start && wall_x <= safe_zone_end) {
                valid_position = false;
                attempts++;
                continue;
            }
            
            // Check spacing from other walls
            for(var i = 0; i < array_length(placed_walls); i++) {
                if(abs(wall_x - placed_walls[i]) < min_spacing) {
                    valid_position = false;
                    break;
                }
            }
            
            attempts++;
        }
        
        if(valid_position) {
            var wall_bottom = room_height - irandom_range(100, 250);
            var wall_height = irandom_range(4, 8); 
            
            for(var i = 0; i < wall_height; i++) {
                instance_create_layer(wall_x, wall_bottom - (i * 16), "Instances", Ground);
            }
            
            array_push(placed_walls, wall_x);
        }
    }
}