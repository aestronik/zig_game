const std     = @import("std");
const print   = std.debug.print;

pub const List = struct {
    pub const Default = struct {
        pub fn enter (number: u8) !void {
            print("Entered Default and got {}!\n", .{number});
        }
    };
    pub const Another = struct {
        pub fn enter (number: u8) !void {
            print("Entered Another and got {}!\n", .{number});
        }
    };
};

pub const Name = std.meta.DeclEnum(List);