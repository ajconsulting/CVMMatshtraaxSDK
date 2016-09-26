precision highp float;

varying vec2 texCoordVarying;
uniform sampler2D source;

void main(void) {
    
    lowp vec4 textureColor = texture2D(source, texCoordVarying);
    
    gl_FragColor.rgb = (1.0 - textureColor.rgb);
}
