import shaders;

// fn lines_to_vertices(lines: Line[:]) -> Vertex[:] {
//     var vertices = [];
//     for line in lines {
//         vertices.push(line.a);
//         vertices.push(line.b);
//     }
//     return vertices;
// }

fn add_line(vertices: Vertex[>..]&, line: Line) {
    vertices.add_line(line.a, line.b);
}

fn add_line(vertices: Vertex[>..]&, start: Vertex, end: Vertex) {
    vertices.push(start);
    vertices.push(end);
}
