LevelGeneration();

function cleanup_chunk(chunk_x) {
    var chunk_start_x = chunk_x * chunk_width;
    var chunk_end_x = chunk_start_x + chunk_width;
    
    // Destroy all ground blocks in this chunk
    with(Ground) {
        if (x >= chunk_start_x && x < chunk_end_x) {
            instance_destroy();
        }
    }
}