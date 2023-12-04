/// Error handling
pub const Error = error { Full, Empty, NotFound };
/// Types
pub fn Entity     (comptime Generic_Entity: type) type {
    return struct {
        in_use: bool,
        data: Generic_Entity,
    };
}
pub fn Container  (comptime Generic_Array:  type) type {
    return struct {
        Data:         Generic_Array,
        // Meta Data
        current_size: usize, // 0
        capacity:     usize, // N
        final_index:  usize, // 0
    };
}
/// Actions to be performed on Lists
pub fn initialize (comptime Generic_Array: type) Container(Generic_Array) {
    return Container(Generic_Array) {
        .Data         = undefined,
        .current_size = 0,
        .capacity     = 0,
        .final_index  = 0,
    };
}
pub fn reset (container: anytype) void {
    var index: usize = 0;
    while (index < container.Data.len) {
        container.Data[index].in_use = false;
        index += 1;
    }
    container.current_size = 0;
    container.capacity     = container.Data.len;
    container.final_index  = 0;
}