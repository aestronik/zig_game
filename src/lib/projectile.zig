const std     = @import("std");
const print   = std.debug.print;

const Physics = @import("physics.zig");
const Sprite  = @import("display/sprite.zig");
const Sprite_Sheet  = @import("display/sprite_sheet.zig");
const Player  = @import("players.zig");
const List    = @import("list.zig");
const State   = @import("state.zig");
const Vector  = @import("vector.zig");
const raylib  = @cImport({@cInclude("raylib.h");});

const CONFIG = @import("../config.zig");

pub const Team   = enum {
    Good,
    Evil
};

pub const Entity = struct {
    // Visual Info
    Physics:    usize,
    Sprite:     usize,

    target:     Team,

    damage:     i32,
    size:       f32,
    duration:   usize
};

pub fn create (state: *State.Entity) !usize {
    const index = try List.allocate(&state.Projectile_Container);
    var projectile = &state.Projectile_Container.Data[index].data;

    projectile.*.Physics = try Physics.create(state);
    projectile.*.Sprite  = try Sprite.create(state);
    projectile.*.target  = Team.Good;
    projectile.*.damage  = 1;
    projectile.*.duration = 0x0040;

    state.Sprite_Container.Data[
        projectile.Sprite
    ].data.Sheet = try Sprite_Sheet.create(
        state,
        raylib.LoadTexture("assets/visual/missing_texture_8.png"),
        raylib.Vector2 {.x = 8, .y = 8},
        [CONFIG.ANIMATION_SIZE]f32{ 1, 0, 0, 0, 0, 0, 0, 0 }
    );

    return index;
}
pub fn delete (state: *State.Entity, index: usize) !void {
    const projectile = state.Projectile_Container.Data[index].data;
    _ = try Sprite.delete(state, projectile.Sprite);
    _ = try Physics.delete(state, projectile.Physics);
    _ = try List.deallocate(&state.Projectile_Container, index);
}
pub fn update (state: *State.Entity) void {
    var projectile_index: usize = 0;

    projectile_loop: while (projectile_index < state.Projectile_Container.final_index) {
        defer { projectile_index += 1; }
        if (!state.Projectile_Container.Data[projectile_index].in_use) { continue; }
        var projectile = &state.Projectile_Container.Data[projectile_index].data;
        projectile.*.duration -|= 1;
        state.Sprite_Container.Data[
            projectile.Sprite
        ].data.Position = state.Physics_Container.Data[
            projectile.Physics
        ].data.Position;
        if (projectile.duration < 1) { delete(state, projectile_index) catch { print("So apparently this errored!", .{});}; continue; }
        const location = state.Physics_Container.Data[projectile.Physics].data.Position;
        switch (projectile.target) {
            .Good,
            .Evil => {
                var player_index: usize = 0;
                while (player_index < state.Player_Container.final_index) {
                    defer { player_index += 1; }
                    if (!state.Player_Container.Data[player_index].in_use) { continue; }
                    var player          = &state.Player_Container.Data[player_index].data;
                    if (player.health < 1) { continue; }
                    var player_physics  = &state.Physics_Container.Data[player.Physics].data;
                    const distance = Vector.distance(player_physics.Position, location);
                    if (distance > player.size / 2 + projectile.size / 2 ) { continue; }
                    // There has been a collision with this player
                    print("\n\n\nWe've hit the player!\n\n\n", .{});
                    player.health -= projectile.damage;
                    delete(state, projectile_index) catch { print("So apparently this errored!", .{}); };              
                    continue :projectile_loop;
                }
            }
            // Team.Evil => {
            //     var enemy_index: usize = 0;
            //     enemy_loop: while (enemy_index < state.Enemy_Container.final_index) {
            //         defer { enemy_index += 1; }
            //         if (!state.Enemy_Container.Data[enemy_index].in_use) { continue; }
            //         var enemy          = &state.Enemy_Container.Data[enemy_index].data;
            //         var enemy_physics  = &state.Physics_Container.Data[enemy.Physics].data;
            //         if (Vector.distance(enemy_physics.Position, location) > enemy.size / 2 + projectile.size / 2 ) { continue; }
            //         // There has been a collision with this enemy
            //         enemy.health -= projectile.damage;
            //         remove(state, projectile_index);                    
            //         continue :projectile_loop;
            //     }
            // }
        }
    }
}