shader_type canvas_item;

void fragment() {
    // Pega a cor original da textura do sprite
    vec4 cor_original = texture(TEXTURE, UV);
    
    // Inverte apenas os canais RGB (mantendo o canal ALPHA totalmente intacto para não ficar transparente)
    COLOR.rgb = vec3(1.0) - cor_original.rgb;
    COLOR.a = cor_original.a;
}