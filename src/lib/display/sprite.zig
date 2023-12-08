const List    = @import("../list.zig");
const State   = @import("../state.zig");
const raylib  = @cImport({@cInclude("raylib.h");});

const Palette = @import("palette.zig");

const CONFIG  = @import("../../config.zig");

pub const Entity = struct {
    // Visual Info
    Position:   raylib.Vector2,
    rotation:   f32,
    Sheet:      usize,
    // Meta for render
    animation:  u8,
    frame:      f32,
    timer:      u8,
    drawn:      bool
};

pub fn create (state: *State.Entity) !usize {
    const index = try List.allocate(&state.Sprite_Container);
    var  sprite = &state.Sprite_Container.Data[index].data;
    sprite.*.Position.x = 0;
    sprite.*.Position.y = 0;
    sprite.*.rotation   = 0;
    sprite.*.Sheet      = 0;

    sprite.*.animation  = 0;
    sprite.*.frame      = 0;
    sprite.*.timer      = 0;
    sprite.*.drawn      = true;

    return index;
}

pub fn update (state: *State.Entity) void {
    var index: usize = 0;

    while (index < state.Sprite_Container.final_index) {
        defer { index += 1; }
        if (!state.Sprite_Container.Data[index].in_use) { continue; }
        var entity = &state.Sprite_Container.Data[index].data;
        const sprite_sheet = state.Sprite_Sheet_Container.Data[entity.Sheet].data;

        entity.*.timer += 1;
        // Find out if it's time to go to the next frame
        if (entity.timer >= CONFIG.ANIMATION_TIMER) {
            entity.*.timer = 0;
            entity.*.frame += 1;
        }
        // Wrap frames
        if (entity.frame >= sprite_sheet.Animations[entity.animation]) {
            entity.*.frame = 0;
        }
    }
}

pub fn render (state: *State.Entity) void {
    var index: usize = 0;

    while (index < state.Sprite_Container.final_index) {
        defer { index += 1; }
        if (!state.Sprite_Container.Data[index].in_use) { continue; }
        const sprite = state.Sprite_Container.Data[index].data;
        if (!sprite.drawn) { continue; }
        const sprite_sheet = state.Sprite_Sheet_Container.Data[sprite.Sheet].data;

        const anim_source_offset = sprite_sheet.Offset[sprite.animation];

        raylib.DrawTexturePro(
            sprite_sheet.Texture,
            raylib.Rectangle {
                .x =      anim_source_offset + sprite.frame * sprite_sheet.Dimensions.x,
                .y =      0,
                .width =  sprite_sheet.Dimensions.x,
                .height = sprite_sheet.Dimensions.y
            },
            raylib.Rectangle {
                .x =      sprite.Position.x,
                .y =      sprite.Position.y,
                .width =  sprite_sheet.Dimensions.x,
                .height = sprite_sheet.Dimensions.y
            },
            raylib.Vector2 {
                .x = 0,
                .y = 0,
            },
            sprite.rotation,
            Palette.white
        );        
    }
}


