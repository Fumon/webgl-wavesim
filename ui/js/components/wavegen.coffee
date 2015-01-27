
define ['react', 'jquery', 'text!shaders/frag.glsl', 'text!shaders/vert.glsl'], (react, $, fsh, vsh) ->
  # Constants
  w:
    numWaves:
      v: 1
      f: 'uniform1i'
    amplitude:
      v: new Float32Array([
        0.8
      ])
      f: 'uniform1fv'
    wavelength:
      v: new Float32Array([
        0.1
      ])
      f: 'uniform1fv'
    speed:
      v: new Float32Array([
        0.5
      ])
      f: 'uniform1fv'
    direction:
      v: new Float32Array([
        0.0, 1.0
      ])
      f: 'uniform2fv'



  react.createFactory react.createClass
    displayName: 'gl'
    getgl: () ->
      # Grab the gl context
      gl = null
      try
        gl = @getDOMNode().getContext('webgl') || @getDOMNode().getContext('experimental-webgl')
      catch e

      if !gl
        console.error 'Problem grabbing webgl context'
        gl = null

      gl
    resizeGL: (e) ->
      el = $ this
      @gl.viewport 0, 0, el.width, el.height
    createBuffer: () ->
      buf = @gl.createBuffer()
      @gl.bindBuffer @gl.ARRAY_BUFFER, buf

      verts = new Float32Array([
        1.0, 1.0,
        -1.0, 1.0,
        1.0, -1.0,
        -1.0, -1.0
      ])
      @gl.bufferData @gl.ARRAY_BUFFER, verts, @gl.STATIC_DRAW
      buf
    componentDidMount: () ->
      el = @getDOMNode()
      @gl = @getgl()
      if @gl == null
        return

      # Hook resize
      $(el).resize @resizeGL

      # Clear the render
      @gl.clearColor 0.0, 0.0, 0.0, 1.0
      @gl.clear @gl.COLOR_BUFFER_BIT

      # Compile program
      fragsh = @gl.createShader @gl.FRAGMENT_SHADER
      vertsh = @gl.createShader @gl.VERTEX_SHADER
      @gl.shaderSource fragsh, fsh
      @gl.shaderSource vertsh, vsh

      # Compile and check for errors
      for sh in [fragsh, vertsh]
        @gl.compileShader sh
        if !@gl.getShaderParameter sh, @gl.COMPILE_STATUS
          console.error "Error compiling shader: #{@gl.getShaderInfoLog sh}"
          return
      
      # Create Program and attach shaders
      @glprog = @gl.createProgram()
      @gl.attachShader @glprog, fragsh
      @gl.attachShader @glprog, vertsh
      @gl.linkProgram @glprog

      if !@gl.getProgramParameter @glprog, @gl.LINK_STATUS
       console.error "Unable to link the program"
       return

      # Grab vert shader attrs
      @posattr = @gl.getAttribLocation @glprog, "aVertPos"
      @gl.enableVertexAttribArray @posattr

      # Grab Uniforms
      @uniforms =
        time: @gl.getUniformLocation @glprog, 'time'
        numWaves: @gl.getUniformLocation @glprog, 'numWaves'
        amplitude: @gl.getUniformLocation @glprog, 'amplitude'
        wavelength: @gl.getUniformLocation @glprog, 'wavelength'
        speed: @gl.getUniformLocation @glprog, 'speed'
        direction: @gl.getUniformLocation @glprog, 'direction'


      # Create buffer
      @buf = @createBuffer()
      @draw()
    draw: () ->
      # Clear
      @gl.clear @gl.COLOR_BUFFER_BIT

      # Use program
      @gl.useProgram @glprog

      # Seed constants
      for key, data of @w
        @gl[data.f](@uniforms[key], data.v)

      # Set time
      @gl.uniform1f(@uniforms.time, 0.3)

      # Bind Buffer and point vertex shader at the points
      @gl.bindBuffer @gl.ARRAY_BUFFER, @buf
      @gl.vertexAttribPointer @posattr, 2, @gl.FLOAT, false, 0, 0
      @gl.drawArrays @gl.TRIANGLE_STRIP, 0, 4
    render: () ->
      react.createElement 'canvas', className: 'glRender'

