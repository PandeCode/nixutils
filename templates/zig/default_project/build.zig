const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .link_libc = true,
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{ .name = "default_project", .root_module = exe_mod });

    b.installArtifact(exe);

    const run_step = b.step("run", "run");
    const run_exe = b.addRunArtifact(exe);

    run_step.dependOn(&run_exe.step);

    run_exe.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_exe.addArgs(args);
    }

    const exe_check = b.addExecutable(.{
        .name = "check",
        .root_module = exe_mod,
    });
    const check = b.step("check", "Check if project compiles");
    check.dependOn(&exe_check.step);
}
