const List    = @import("list.zig");
const State   = @import("state.zig");
const raylib  = @cImport({@cInclude("raylib.h");});


const std     = @import("std");
const print   = std.debug.print;


/// Associated type
pub const Entity = struct {
    Physics:        usize,
    Controls:       struct {
        Up:             u8,
        Down:           u8,
        Left:           u8,
        Right:          u8
    },
    Target:         raylib.Vector2
};
/// Setting up the state properly
pub fn initialize (state: *State.Entity) void {
    _ = state;
    return;
}
/// Create a player and return its index!
pub fn create (state: *State.Entity) !usize {
    const player_index   = try List.allocate(&state.Player_Container);
    const player_physics = try List.allocate(&state.Physics_Container);

    var Players = &state.Player_Container.Data;
    // Physics
    var player = &Players[player_index].data;
    player.Physics = player_physics;
    // Controls
    player.Controls.Up    = 87;
    player.Controls.Down  = 83;
    player.Controls.Left  = 65;
    player.Controls.Right = 68;
    // Target
    player.Target.x = 0;
    player.Target.y = 0;

    return player_index;
}
/// Setting up the logic, just Newtonian Physics!
pub fn update (state: *State.Entity) void {
    var index: usize = 0;

    while (index < state.Player_Container.final_index) {
        defer { index += 1; }

        if (!state.Player_Container.Data[index].in_use) { continue; }

        var entity = &state.Player_Container.Data[index].data;
        var entity_physics = &state.Physics_Container.Data[entity.Physics].data;
        // Controls
        entity_physics.*.Velocity.x = 0;
        entity_physics.*.Velocity.y = 0;

        if (raylib.IsKeyDown(entity.Controls.Up))    { entity_physics.*.Velocity.y -= 1.0; }
        if (raylib.IsKeyDown(entity.Controls.Down))  { entity_physics.*.Velocity.y += 1.0; }
        if (raylib.IsKeyDown(entity.Controls.Left))  { entity_physics.*.Velocity.x -= 1.0; }
        if (raylib.IsKeyDown(entity.Controls.Right)) { entity_physics.*.Velocity.x += 1.0; }

    }
}