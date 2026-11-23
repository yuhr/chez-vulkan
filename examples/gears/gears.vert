#version 450

// Per-vertex diffuse lighting with one directional light, like the
// fixed-function OpenGL lighting the classic gears demo used.

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;

// 128 bytes: the minimum push constant size every device supports.
layout(push_constant) uniform Push {
    mat4 mvp;            // projection * modelview
    mat3 normal_matrix;  // rotation part of modelview (std430: 3 x vec4)
    vec4 color;
} pc;

layout(location = 0) out vec4 frag_color;

const vec3 light_dir = normalize(vec3(5.0, 5.0, 10.0));  // eye space
const float ambient = 0.2;

void main() {
    gl_Position = pc.mvp * vec4(position, 1.0);
    vec3 n = normalize(pc.normal_matrix * normal);
    float diffuse = max(dot(n, light_dir), 0.0);
    frag_color = vec4(pc.color.rgb * (ambient + diffuse), pc.color.a);
}
