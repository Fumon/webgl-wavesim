
define ['react', 'jquery', 'text!shaders/frag.glsl', 'text!shaders/vert.glsl'], (react, $, fsh, vsh) ->

  rnd = () ->
    Math.random() * 0.3 + 0.5
  rndPI = () ->
    Math.random() * (4*Math.PI)

  react.createFactory react.createClass
    # Constants
    w:
      numWaves:
        v: 5
        f: 'uniform1i'
      amplitude:
        f: 'uniform1fv'
      wavelength:
        f: 'uniform1fv'
      speed:
        f: 'uniform1fv'
      direction:
        f: 'uniform2fv'
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
        time: null
        numWaves: null
        amplitude: null
        wavelength: null
        speed: null
        direction: null

      for key of @uniforms
        @uniforms[key] = @gl.getUniformLocation @glprog, key
      console.log @uniforms

      # Randomize constants
      num = @w.numWaves.v
      for key of @w
        if key != 'numWaves'
          arr = null
          if key == 'direction'
            arr = new Float32Array(Array(num*2))
          else
            arr = new Float32Array(Array(num))
          i = 0
          while i < num
            if key == 'direction'
              arr[i*2]=Math.cos rndPI()
              arr[i*2+1] = Math.sin rndPI()
            else if key == 'wavelength'
              arr[i]=1.0/rnd()
            else
              arr[i]=rnd()
            ++i
          @w[key].v = arr
      console.log @w


      # Create buffer
      @buf = @createBuffer()

      @time = 0.0

      @draw()
    draw: () ->
      # Clear
      @gl.clear @gl.COLOR_BUFFER_BIT

      # Use program
      @gl.useProgram @glprog

      # Seed constants
      for key, data of @w
        @gl[data.f](@uniforms[key], data.v)

      #@gl[@w.numWaves.f](@uniforms.numWaves, @w.numWaves.v)
      #@gl[@w.amplitude.f](@uniforms.amplitude, @w.amplitude.v)


      # Set time
      @gl.uniform1f(@uniforms.time, @time)

      # Bind Buffer and point vertex shader at the points
      @gl.bindBuffer @gl.ARRAY_BUFFER, @buf
      @gl.vertexAttribPointer @posattr, 2, @gl.FLOAT, false, 0, 0
      @gl.drawArrays @gl.TRIANGLE_STRIP, 0, 4

      @time += 0.01
      window.requestAnimationFrame @draw
    render: () ->
      react.createElement 'canvas', className: 'glRender'

