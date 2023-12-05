//! This module creates a Memory Arena of sorts that sits on the stack.
//! It's designed for fast iteration and fast allocation and cleanup

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
// Actions to be performed on Lists
pub fn initialize (comptime Generic_Array: type) Container(Generic_Array) {
    var container = Container(Generic_Array) {
        .Data         = undefined,
        .current_size = 0,
        .capacity     = 0,
        .final_index  = 0,
    };
    reset(&container);
    return container;
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
pub fn allocate (container: anytype) !usize {
    if (container.current_size >= container.capacity) { return Error.Full; }
    var index: usize = container.final_index;
    var successful_assignment = true;
    defer { 
        if (successful_assignment) {
            container.Data[index].in_use = true;
            container.current_size += 1;
        } 
    }
    if (index == container.current_size) { 
        container.final_index += 1; 
        return index; 
    }
    // The memory is non-contiguous
    index -= 1;
    while (index > 0) {
        if (!container.Data[index].in_use) { return index; }
        index -= 1;
    }
    // We've reached the bottom of the memory and didn't find
    // a single available space despite the final_index and
    // current_size being different, meaning we messed up!
    successful_assignment = false;
    return Error.NotFound;
}
pub fn deallocate (container: anytype, index: usize) !void {
    if (container.current_size < 1)     { return Error.Empty;    }
    if (index >= container.final_index) { return Error.NotFound; }
    var successful_deallocate = true;
    defer {
        if (successful_deallocate) {
            container.Data[index].in_use = false;
            container.current_size      -= 1;
        }        
    }
    if (index != container.final_index - 1) { return; }  
    // Check for continuity
    if (container.current_size == container.final_index) { container.final_index -= 1; return; }
    var new_final = index;

    while (new_final > 0) {
        if (container.Data[new_final - 1].in_use) { break; }
        new_final -= 1;
    }
    container.final_index = new_final;
}

// Testing suite
const std = @import("std");
test "List: Basic Initialization" {
    const size    = 2;
    var test_list = initialize([size]Entity(u32));
    // Making sure the Metadata is accurate
    try std.testing.expectEqual(test_list.current_size, 0   );
    try std.testing.expectEqual(test_list.final_index,  0   );
    try std.testing.expectEqual(test_list.capacity,     size);
}
test "List: Basic Allocation" {
    const size    = 2;
    var test_list = initialize([size]Entity(u32));

    try std.testing.expectEqual(try allocate(&test_list), 0);
    try std.testing.expectEqual(try allocate(&test_list), 1);
    try std.testing.expectEqual(test_list.current_size,   2);
    try std.testing.expectError(Error.Full, allocate(&test_list));
}
test "List: Basic Deallocation" {
    const size    = 2;
    var test_list = initialize([size]Entity(u32));

    try std.testing.expectError(Error.Empty, deallocate(&test_list, 0));

    _ = try allocate(&test_list);
    try std.testing.expectError(Error.NotFound, deallocate(&test_list, 1));
    try std.testing.expectEqual(test_list.current_size, 1);
    _ = try deallocate(&test_list, 0);
    try std.testing.expectEqual(test_list.current_size, 0);
}
test "List: Suite" {
    const size    = 6;
    var test_list = initialize([size]Entity(u32));

    _ = try allocate(&test_list); // 0 [x, _, _, _, _, _]
    _ = try allocate(&test_list); // 1 [x, x, _, _, _, _]
    _ = try allocate(&test_list); // 2 [x, x, x, _, _, _]
    _ = try allocate(&test_list); // 3 [x, x, x, x, _, _]
    _ = try allocate(&test_list); // 4 [x, x, x, x, x, _]
    _ = try allocate(&test_list); // 5 [x, x, x, x, x, x]

    try std.testing.expectError(Error.Full, allocate(&test_list));

    // Checking that final_index doesn't respond to gaps
    _ = try deallocate(&test_list, 4); // [x, x, x, x, _, x] 6
    try std.testing.expectEqual(test_list.final_index, 6);

    // Checking that final_index collapses properly
    _ = try deallocate(&test_list, 5); // [x, x, x, x, _, _] 4
    try std.testing.expectEqual(test_list.final_index, 4);

    // Checking that final_index handles incrementation
    _ = try deallocate(&test_list, 3); // [x, x, x, _, _, _] 3
    try std.testing.expectEqual(test_list.final_index, 3);

    // Checking that we insert properly with allocate
    _ = try deallocate(&test_list, 1); // [x, _, x, _, _, _] 3
    try std.testing.expectEqual(
        try allocate(&test_list),// [x, x, x, _, _, _]
    1);
    try std.testing.expectEqual(test_list.final_index, 3);

    // Checking that final_index collapses to 0
    _ = try deallocate(&test_list, 1); // [x, _, x, _, _, _] 3
    try std.testing.expectEqual(test_list.final_index, 3);
    _ = try deallocate(&test_list, 0); // [_, _, x, _, _, _] 3
    try std.testing.expectEqual(test_list.final_index, 3);
    _ = try deallocate(&test_list, 2); // [_, _, _, _, _, _] 0
    try std.testing.expectEqual(test_list.final_index, 0);
}