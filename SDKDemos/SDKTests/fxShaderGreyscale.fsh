precision highp float;

varying vec2 texCoordVarying;
uniform sampler2D source;
uniform float iGlobalTime;

const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

void main(void) {
    
    lowp vec4 textureColor = texture2D(source, texCoordVarying);
    float luminance = dot(textureColor.rgb, W);
    
    gl_FragColor.rgb = vec3(luminance);
}
