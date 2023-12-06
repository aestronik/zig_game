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
    List.reset(&state.Physics_Container);
}