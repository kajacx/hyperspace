import std;
import vec;
import math;
import os;
import gfx;

import engine from "./engine";
import shapes from "./shapes";
import render from "./render";

struct ScreenInfo { size: float2, _pad: float2 }

fn main() {
    guard gfx::open("Goose: a flat grid", 760, 520, gfx::WINDOW_RESIZABLE) else {
        write_stderr(str("gfx: ", gfx::error(), "\n"));
        return;
    }
    defer gfx::close();   // Closed on every way out, the early return below included.

    // 1. Build a list of line segments (every 2 vertices = 1 line).
    var vertices: Vertex[>..] = [];

    let square0 = new_moving_square(100, 20, 30, 20, 40, [240, 90, 70, 255]);
    let square1 = new_moving_square(200, 20, 30, 20, 40, [80, 210, 110, 255]);

    square0.move_by_delta(5);
    square1.move_by_delta(10);

    square0.add_vertices(vertices);
    square1.add_vertices(vertices);

    // vertices.push(
    //     Vertex { pos: float2 { 10, 20 }, color: [90, 170, 250, 255] },
    // );
    // vertices.push(
    //     Vertex { pos: float2 { 110, 120 }, color: [90, 170, 250, 255] },
    // );

    // vertices.push(
    //     Vertex { pos: float2 { 10, 120 }, color: [190, 170, 250, 255] },
    // );
    // vertices.push(
    //     Vertex { pos: float2 { 110, 220 }, color: [190, 170, 250, 255] },
    // );

    let vertex_buffer = gfx::vertex_buffer(bytes_of(vertices));

    let line_vs = create_line_shader();
    let line_fs = create_frag_shader();

    var desc = gfx::PipelineDesc { primitive: gfx::LINES };

    desc.formats[1] = gfx::VERTEX_UBYTE4_NORM;
    let line_pipeline = gfx::pipeline(line_vs, line_fs, desc);

    while gfx::frame() {
        if gfx::key_pressed("Escape") { break; }

        let size = gfx::screen_size();
        let screen_info = ScreenInfo { size: float2 { size.x, size.y }, .. };

        let delta = gfx::delta_time() as f32;
        square0.move_by_delta(delta);
        square1.move_by_delta(delta);

        vertices.clear();
        square0.add_vertices(vertices);
        square1.add_vertices(vertices);

        gfx::update_buffer(vertex_buffer, bytes_of(vertices));

        // The backdrop, then the windows over it.
        gfx::begin_screen(float4 { 0.18, 0.24, 0.30, 1.0 });

        gfx::bind(line_pipeline);
        gfx::bind_vertex_buffer(vertex_buffer);
        gfx::uniforms(gfx::VERTEX, 0, screen_info);
        gfx::draw(vertices.len, 1, 0, 0);

        gfx::end_pass();
    }
}
