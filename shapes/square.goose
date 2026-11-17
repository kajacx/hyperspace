import engine from "../engine";

/* Formation:
 * AB
 * CD
 */
struct Square {
    a: MovingVertex,
    b: MovingVertex,
    c: MovingVertex,
    d: MovingVertex,
}

fn new_square(x: f32, y: f32, width: f32, color: u8[4]) -> Square {
    return new_moving_square(x, y, 0, 0, width, color);
}

fn new_moving_square(x: f32, y: f32, vx: f32, vy: f32, width: f32, color: u8[4]) -> Square {
    let vel = float2 { vx, vy };
    return Square {
        a: MovingVertex { pos: float2 { x, y }, vel: vel, color: color },
        b: MovingVertex { pos: float2 { x + width, y }, vel: vel, color: color },
        c: MovingVertex { pos: float2 { x, y + width }, vel: vel, color: color },
        d: MovingVertex { pos: float2 { x + width, y + width }, vel: vel, color: color },
    }
}

fn add_vertices(square: Square&, vertices: Vertex[>..]&) {
    vertices.add_line(square.a.to_vertex(), square.b.to_vertex());
    vertices.add_line(square.b.to_vertex(), square.d.to_vertex());
    vertices.add_line(square.d.to_vertex(), square.c.to_vertex());
    vertices.add_line(square.c.to_vertex(), square.a.to_vertex());
}

fn move_by_delta(square: Square&, delta: f32) {
    square.a.move_by_delta(delta);
    square.b.move_by_delta(delta);
    square.c.move_by_delta(delta);
    square.d.move_by_delta(delta);
}
