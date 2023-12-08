const List    = @import("../list.zig");
const State   = @import("../state.zig");
const raylib  = @cImport({@cInclude("raylib.h");});

const CONFIG  = @import("../../config.zig");

pub const Entity  = struct {
    Texture:    raylib.Texture,
    Dimensions: raylib.Vector2,
    Animations: [CONFIG.ANIMATION_SIZE]f32,
    Offset:     [CONFIG.ANIMATION_SIZE]f32,
};

pub fn create (state: *State.Entity, texture: raylib.Texture, dimensions: raylib.Vector2, animations: [8]f32 ) !usize {
    const index = try List.allocate(&state.Sprite_Sheet_Container);
    var  sprite_sheet = &state.Sprite_Sheet_Container.Data[index].data;
    sprite_sheet.*.Dimensions   = dimensions;
    sprite_sheet.*.Animations   = animations;
    sprite_sheet.*.Texture      = texture;

    var counter: usize = 0;
    var offset : f32   = 0;

    while (counter < CONFIG.ANIMATION_SIZE) {
        const frames = sprite_sheet.*.Animations[counter];
        defer { 
            counter += 1; 
            offset += frames * sprite_sheet.Dimensions.x; 
        }
        if (frames == 0) { 
            sprite_sheet.*.Offset[counter] = 0; 
            continue; 
        }
        sprite_sheet.*.Offset[counter] = offset;
    }

    return index;
}