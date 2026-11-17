// map pixel coordinates (0..width, 0..height) to GPU clip space (-1..1).
fn create_line_shader() {
    return embed_shader("vert", """
    layout(location = 0) in vec2 a_pos;
    layout(location = 1) in vec4 a_color;
    layout(set = 1, binding = 0) uniform ScreenInfo {
        vec2 u_screen_size;
    };
    layout(location = 0) out vec4 v_color;
    void main() {
        vec2 ndc = (a_pos / u_screen_size) * 2.0 - 1.0;
        // Flip Y so (+-1???, 0) is top-left instead of bottom-left
        gl_Position = vec4(ndc.x, -ndc.y, 0.0, 1.0);
        v_color = a_color;
    }
    """);
}

fn create_frag_shader() {
    return embed_shader("frag", """
    layout(location = 0) in vec4 v_color;
    layout(location = 0) out vec4 result;
    void main() {
        result = v_color;
    }
    """);
}
