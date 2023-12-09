const List          = @import("list.zig");
const Physics       = @import("physics.zig");
const Scene         = @import("scene/main.zig");
const Player        = @import("players.zig");
const CONFIG        = @import("../config.zig");
const Sprite        = @import("display/sprite.zig");
const Sprite_Sheet  = @import("display/sprite_sheet.zig");
const Camera        = @import("display/camera.zig");

const std     = @import("std");

const raylib  = @cImport({@cInclude("raylib.h");});

pub const Entity = struct {
    Physics_Container:      List.Container([CONFIG.PHYSICS_MAX]List.Entity(Physics.Entity)),
    Scene_Container:        List.Container([CONFIG.SCENES_MAX]List.Entity(Scene.Name)),
    Player_Container:       List.Container([CONFIG.PLAYER_MAX]List.Entity(Player.Entity)),
    Sprite_Container:       List.Container([CONFIG.SPRITE_MAX]List.Entity(Sprite.Entity)),
    Sprite_Sheet_Container: List.Container([CONFIG.SPRITE_SHEET_MAX]List.Entity(Sprite_Sheet.Entity)),
    RNG:                    std.rand.Xoshiro256,
    Camera:                 Camera.Entity,
    texture:                raylib.Texture,
    last_frame_in_ns:       i64
};