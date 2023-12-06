const     CONFIG = @import("../../config.zig");
pub const Name   = CONFIG.Scenes.Name;
pub const List   = CONFIG.Scenes.List;

pub const Code = enum {
    Continue
};

pub fn enter(scene_name: Name, number: u8) !void {
    try switch (scene_name) {
        inline else => |tag| @field(List, @tagName(tag)).enter(number),
    };
}