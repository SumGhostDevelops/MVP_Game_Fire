
if (Player.x > current_chunk_x * chunk_width - chunk_width) {
    generate_chunk(current_chunk_x);
    current_chunk_x++;
    
    // Delete old chunks
    if (ds_list_size(chunks) > 4) {
		
        cleanup_chunk(chunks[| 0]);
		
        ds_list_delete(chunks, 0);
    }
}