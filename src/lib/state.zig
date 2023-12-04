const List    = @import("list.zig");
const Physics = @import("physics.zig");
pub const Entity = struct {
    Physics_Container: List.Container([Physics.size]List.Entity(Physics.Entity))
};