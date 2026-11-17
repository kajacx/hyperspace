import gfx;

struct Vertex { pos: float2, color: u8[4] }

struct MovingVertex { pos: float2, vel: float2, color: u8[4] }

fn move_by_delta(moving: MovingVertex&, delta: f32) {
    moving.pos += moving.vel * delta;
}

fn to_vertex(moving: MovingVertex&) -> Vertex {
    return Vertex { pos: moving.pos, color: moving.color };
}
