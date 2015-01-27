precision mediump float;

void main() {
    mediump float xpos = gl_PointCoord.x;
    gl_FragColor = vec4(0,0,sin(xpos),1);  // Blue
}
