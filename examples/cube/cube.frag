#version 450

layout(set = 0, binding = 0) uniform sampler2D tex;

layout(location = 0) in vec2 frag_uv;
layout(location = 1) in float frag_light;
layout(location = 0) out vec4 out_color;

void main() {
    vec4 color = texture(tex, frag_uv);
    out_color = vec4(color.rgb * frag_light, color.a);
}
