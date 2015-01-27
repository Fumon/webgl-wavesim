precision mediump float;

const float pi = 3.14159;
uniform float time;
uniform int numWaves;
uniform float amplitude[8];
uniform float wavelength[8];
uniform float speed[8];
uniform vec2 direction[8];

void main() {
    mediump float xpos = gl_PointCoord.x;
    mediump float height = 0.0;
    for (int i = 0; i < 8; ++i) {
      if(i < numWaves) {
        float frequency = 2.0*pi/wavelength[i];
        float phase = speed[i] * frequency;
        float theta = dot(direction[i], vec2(xpos, 0));
        height += amplitude[i] * sin(theta * frequency + time * phase);
      }
    }
    gl_FragColor = vec4(0,0,height,1);  // Blue
}
