const List    = @import("list.zig");
const State   = @import("state.zig");
const raylib  = @cImport({@cInclude("raylib.h");});
/// Array size
pub const size   = 0x4000;
/// Associated type
pub const Entity = struct {
    Position: raylib.Vector2,
    Velocity: raylib.Vector2,
    size:     f64
};
/// Setting up the state properly
pub fn initialize (state: *State.Entity) void {
    List.reset(&state.Physics_Container);
}