import std;
import vec;
import math;
import os;
import gfx;
import ui;

import engine from "./engine";
import shapes from "./shapes";
import render from "./render";

struct ScreenInfo { size: float2, _pad: float2 }

// fn add_line(verts: LineVertex[>..]&, x1: f32, y1: f32, x2: f32, y2: f32, color: u8[4]) {
//     verts.push(LineVertex { pos: float2 { x1, y1 }, color: color });
//     verts.push(LineVertex { pos: float2 { x2, y2 }, color: color });
// }

fn main() {
    guard gfx::open("Goose: a flat grid", 760, 520, gfx::WINDOW_RESIZABLE) else {
        write_stderr(str("gfx: ", gfx::error(), "\n"));
        return;
    }
    defer gfx::close();   // Closed on every way out, the early return below included.

    var backdrop = ui::Colorf { 0.18, 0.24, 0.30, 1.0 };

    // 1. Build a list of line segments (every 2 vertices = 1 line).
    var vertices: Vertex[>..] = [];

    let square0 = create_square(500 + 100, 300 + 20, 40, [240, 90, 70, 255]);
    let square1 = create_square(500 + 200, 300 + 20, 40, [80, 210, 110, 255]);

    square0.add_vertices(vertices);
    square1.add_vertices(vertices);

    vertices.push(
        Vertex { pos: float2 { 10, 20 }, color: [90, 170, 250, 255] },
    );

    vertices.push(
        Vertex { pos: float2 { 110, 120 }, color: [90, 170, 250, 255] },
    );

    vertices.push(
        Vertex { pos: float2 { 10, 120 }, color: [190, 170, 250, 255] },
    );

    vertices.push(
        Vertex { pos: float2 { 110, 220 }, color: [190, 170, 250, 255] },
    );

    // // Diagonal cross
    // add_line(verts, 50.0, 50.0, 350.0, 250.0, [240, 90, 70, 255]);
    // add_line(verts, 350.0, 50.0, 50.0, 250.0, [80, 210, 110, 255]);
    // // Horizontal & vertical lines
    // add_line(verts, 50.0, 320.0, 710.0, 320.0, [90, 170, 250, 255]);
    // add_line(verts, 450.0, 50.0, 450.0, 470.0, [240, 200, 70, 255]);

    let vertex_buffer = gfx::vertex_buffer(bytes_of(vertices));

    let line_vs = create_line_shader();
    let line_fs = create_frag_shader();

    // 3. Configure pipeline for line primitives (double-check field name via autocomplete:
    //    likely `primitive: gfx::LINE` or `topology: gfx::LINE`).

    // var desc = gfx::PipelineDesc { primitive: gfx::LINE_STRIP };
    var desc = gfx::PipelineDesc { primitive: gfx::LINES };

    desc.formats[1] = gfx::VERTEX_UBYTE4_NORM;
    let line_pipeline = gfx::pipeline(line_vs, line_fs, desc);

    while gfx::frame() {
        if gfx::key_pressed("Escape") { break; }

        let size = gfx::screen_size();
        let screen_info = ScreenInfo { size: float2 { size.x, size.y }, .. };

        // The backdrop, then the windows over it.
        gfx::begin_screen(float4 { backdrop.r, backdrop.g, backdrop.b, 1.0 });

        gfx::bind(line_pipeline);
        gfx::bind_vertex_buffer(vertex_buffer);
        gfx::uniforms(gfx::VERTEX, 0, screen_info);
        gfx::draw(vertices.len, 1, 0, 0);

        gfx::end_pass();
    }
}
