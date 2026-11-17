import engine from "../engine";

/* Formation:
 * AB
 * CD
 */
struct Square {
    a: Vertex,
    b: Vertex,
    c: Vertex,
    d: Vertex,
}

fn create_square(x: f32, y: f32, width: f32, color: u8[4]) -> Square {
    return Square {
        a: Vertex { pos: float2 { x, y }, color: color },
        b: Vertex { pos: float2 { x + width, y }, color: color },
        c: Vertex { pos: float2 { x, y + width }, color: color },
        d: Vertex { pos: float2 { x + width, y + width }, color: color },
    }
}

// fn add_lines(square: Square&, lines: Line[>..]&) {
//     lines.push(Line { a: square.a, b: square.b });
//     lines.push(Line { a: square.b, b: square.d });
//     lines.push(Line { a: square.d, b: square.c });
//     lines.push(Line { a: square.c, b: square.a });
// }

fn add_vertices(square: Square&, vertices: Vertex[>..]&) {
    vertices.push(square.a);
    vertices.push(square.b);

    vertices.push(square.b);
    vertices.push(square.d);

    vertices.push(square.d);
    vertices.push(square.c);

    vertices.push(square.c);
    vertices.push(square.a);
}
