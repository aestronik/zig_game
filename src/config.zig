pub const FPS: u64 = 60;
pub const Scenes   = @import("lib/scene/demo_scenes.zig");

pub const PHYSICS_MAX       = 0x4000;       // 16,384
pub const SCENES_MAX        = 0x0010;       // 00,016
pub const PLAYER_MAX        = 0x0020;       // 00,032
pub const SPRITE_SHEET_MAX  = 0x0010;       // 00,016
pub const SPRITE_MAX        = PHYSICS_MAX;  // Makes sense right?

pub const DISPLAY_WIDTH         = 0x0280; // 640
pub const DISPLAY_HEIGHT        = 0x01B0; // 432
pub const DISPLAY_MAGNIFICATION = 0x0001;

pub const GAME_NAME = "Zig Game";

pub const CAMERA_MIN_ZOOM = 0.1;

pub const ANIMATION_SIZE  = 8; // IDLE, MOVE, ATK, DEF, WIN, DIE, MISC 1, MISC 2
pub const ANIMATION_TIMER = 6; // 100ms