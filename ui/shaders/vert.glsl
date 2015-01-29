attribute vec2 aVertPos;

varying vec2 pos;

void main() {
  gl_Position = vec4(aVertPos, 0, 1);
  pos = aVertPos;
}
