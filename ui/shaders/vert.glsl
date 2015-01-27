attribute vec2 aVertPos;

void main() {
    gl_Position = vec4(aVertPos, 0, 1);
}
