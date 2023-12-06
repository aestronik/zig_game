const std        = @import("std");

const     CONFIG = @import("../../config.zig");
pub const Scenes = CONFIG.Scenes;
pub const Name   = std.meta.DeclEnum(Scenes);

pub const State  = @import("../state.zig").Entity;

pub const Code = enum {
    Continue,
    Block
};

pub fn enter(scene_name: Name, state: *State) !Code {
    return switch (scene_name) {
        inline else => |tag| @field(Scenes, @tagName(tag)).enter(state),
    };
}

pub fn leave(scene_name: Name, state: *State) !Code {
    return switch (scene_name) {
        inline else => |tag| @field(Scenes, @tagName(tag)).leave(state),
    };
}

pub fn update(scene_name: Name, state: *State) !Code {
    return switch (scene_name) {
        inline else => |tag| @field(Scenes, @tagName(tag)).update(state),
    };
}

pub fn render(scene_name: Name, state: *State) !Code {
    return switch (scene_name) {
        inline else => |tag| @field(Scenes, @tagName(tag)).render(state),
    };
}