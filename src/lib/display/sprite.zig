const List    = @import("../list.zig");
const State   = @import("../state.zig");
const raylib  = @cImport({@cInclude("raylib.h");});

const Sprite_Sheet = @import("sprite_sheet.zig");

const Palette = @import("palette.zig");

const Camera  = @import("camera.zig");

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
    drawn:      bool,
    flipped:    bool
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
    sprite.*.flipped    = false;

    return index;
}
pub fn delete (state: *State.Entity, index: usize) !void {
    _ = try List.deallocate(&state.Sprite_Container, index);
}

pub fn update (state: *State.Entity) void {
    var index: usize = 0;

    while (index < state.Sprite_Container.final_index) {
        defer { index += 1; }
        if (!state.Sprite_Container.Data[index].in_use) { continue; }
        var sprite = &state.Sprite_Container.Data[index].data;
        const sprite_sheet = state.Sprite_Sheet_Container.Data[sprite.Sheet].data;

        // sprite.rotation += 1;

        sprite.*.timer += 1;
        // Find out if it's time to go to the next frame
        if (sprite.timer >= CONFIG.ANIMATION_TIMER) {
            sprite.*.timer = 0;
            sprite.*.frame += 1;
        }
        // Wrap frames
        if (sprite.frame >= sprite_sheet.Animations[sprite.animation]) {
            sprite.*.frame = 0;
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

        draw(state.Camera, sprite, sprite_sheet);
    }
}

pub fn draw (camera: Camera.Entity, sprite: Entity, sprite_sheet: Sprite_Sheet.Entity) void {
    const anim_source_offset = sprite_sheet.Offset[sprite.animation];
    // const camera = state.Display.Camera.Position;
    var flip_source: f32 = 1;
    if (sprite.flipped) { flip_source = -1; }

    raylib.DrawTexturePro(
        sprite_sheet.Texture,
        raylib.Rectangle {
            .x      = anim_source_offset + sprite.frame * sprite_sheet.Dimensions.x,
            .y      = 0,
            .width  = sprite_sheet.Dimensions.x * flip_source,
            .height = sprite_sheet.Dimensions.y
        },
        raylib.Rectangle {
            .x      = Camera.offset_x( camera, sprite.Position.x - sprite_sheet.Dimensions.x / 2),
            .y      = Camera.offset_y( camera, sprite.Position.y - sprite_sheet.Dimensions.y / 2),
            .width  = sprite_sheet.Dimensions.x * camera.zoom, 
            .height = sprite_sheet.Dimensions.y * camera.zoom, 
        },
        raylib.Vector2 {
            .x      = 0,
            .y      = 0,
        },
        sprite.rotation,
        Palette.white
    );
}


