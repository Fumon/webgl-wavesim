requirejs.config
  paths:
    text: '../libs/text'
    shaders: '../shaders'
    components: 'components'
    jquery: 'https://cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min'
    react: 'https://fb.me/react-0.12.2'
    d3: 'https://cdnjs.cloudflare.com/ajax/libs/d3/3.4.6/d3'

require ['jquery', 'react', 'components/wavegen'], ($, React, Wavegen) ->
  {div, h3, h6, p} = React.DOM


  Ui = React.createFactory React.createClass
    render: ->
      div className: "container", [
        (div className: "section", [
          (h3 className: "section-heading", "Wave simulator"),
          (p className: "section-description",
            "Simple shader to simulate waves in a strip"),
          (Wavegen {})
        ])
      ]
      
  $ ->
    React.render (Ui {}), document.body
