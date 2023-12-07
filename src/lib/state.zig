const List    = @import("list.zig");
const Physics = @import("physics.zig");
const Scene   = @import("scene/main.zig");
const Player  = @import("players.zig");
const CONFIG  = @import("../config.zig");

const std     = @import("std");


const raylib  = @cImport({@cInclude("raylib.h");});

pub const Entity = struct {
    Physics_Container: List.Container([CONFIG.PHYSICS_MAX]List.Entity(Physics.Entity)),
    Scene_Container:   List.Container([CONFIG.SCENES_MAX]List.Entity(Scene.Name)),
    Player_Container:  List.Container([CONFIG.PLAYER_MAX]List.Entity(Player.Entity)),
    RNG:               std.rand.Xoshiro256,
    texture:           raylib.Texture
};