#version 450

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec2 uv;

// 112 bytes, within the 128-byte minimum every device supports.
layout(push_constant) uniform Push {
    mat4 mvp;            // projection * modelview
    mat3 normal_matrix;  // rotation part of modelview (std430: 3 x vec4)
} pc;

layout(location = 0) out vec2 frag_uv;
layout(location = 1) out float frag_light;

const vec3 light_dir = normalize(vec3(0.3, 0.5, 1.0));  // eye space

void main() {
    gl_Position = pc.mvp * vec4(position, 1.0);
    vec3 n = normalize(pc.normal_matrix * normal);
    frag_light = 0.35 + 0.65 * max(dot(n, light_dir), 0.0);
    frag_uv = uv;
}
