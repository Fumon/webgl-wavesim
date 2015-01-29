precision highp float;

const vec4 OCEAN = vec4(0, 0.435, 0.475, 1.0);
const vec4 OCEANSPRAY = vec4(0.831, 0.996, 0.988, 1.0);

const float pi = 3.14159;
uniform float time;
uniform int numWaves;
uniform float amplitude[8];
uniform float wavelength[8];
uniform float speed[8];
uniform vec2 direction[8];

varying vec2 pos;

void main() {
    float height = 0.0;
    for (int i = 0; i < 8; ++i) {
      if(i < numWaves) {
        float frequency = 2.0*pi/wavelength[i];
        float phase = speed[i] * frequency;
        float theta = dot(direction[i], pos);
        height += amplitude[i] * sin(theta * frequency + time * phase);
      }
    }
    height = clamp(height, 0.0, 1.0);
    gl_FragColor = mix(OCEAN, OCEANSPRAY, height);  // Blue
}
