const List    = @import("list.zig");
const State   = @import("state.zig");
const raylib  = @cImport({@cInclude("raylib.h");});
/// Associated type
pub const Entity = struct {
    Position: raylib.Vector2,
    Velocity: raylib.Vector2,
    size:     f32
};
/// Setting up the state properly
pub fn initialize (state: *State.Entity) void {
    _ = state;
    return;
}
pub fn create (state: *State.Entity) !usize {
    const index = try List.allocate(&state.Physics_Container);
    // TODO: Initialize these to zero
    return index;
}
pub fn delete (state: *State.Entity, index: usize) !void {
    // Here's the thing, we might actually have multiple things
    // linked to the same address so this will occasionally error
    _ = try List.deallocate(&state.Physics_Container, index);
}
/// Setting up the logic, just Newtonian Physics!
pub fn update (state: *State.Entity) void {
    var index: usize = 0;

    while (index < state.Physics_Container.final_index) {
        defer { index += 1; }

        if (!state.Physics_Container.Data[index].in_use) { continue; }

        var entity = &state.Physics_Container.Data[index].data;

        entity.*.Position.x += entity.Velocity.x;
        entity.*.Position.y += entity.Velocity.y;
    }
}