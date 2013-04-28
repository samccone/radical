$ ->

  # init calendar
  cal = new Thyme document.getElementById("cal")

  # month pickers
  $('#cal').on 'click', '.next', ->
    cal.nextMonth()
    render_events()
    hidePopupEvent()

  $('#cal').on 'click', '.prev', ->
    cal.prevMonth()
    render_events()
    hidePopupEvent()


  saveConfig = ->
    toReturn = {}
    $('.customize [data-val="true"]').each ->
      if ($(this).val())
        toReturn[$(this).attr('data-name')] = $(this).val()
      else
        toReturn[$(this).attr('data-name')] = $(this).text()

    $.post "/cal/edit/#{window.location.href.split("/")[5]}", toReturn

  #
  # event popup

  hidePopupEvent = ->
    $('#cal-event').hide()
    $('#cal-event input[type="text"]').val('')
    $('#cal').find(".active").removeClass 'active'

  $('#cal td').one 'click', ->
    $('#cal-event').appendTo($('body'))

  $('#cal').on 'click', 'td', ->
    $('#cal').find(".active").removeClass 'active'
    $(this).addClass 'active'
    pos = $(@).offset()
    pos_left = pos.left - 170 + $(@).width()/2
    pos_top = pos.top + $(@).outerHeight()
    $('#cal-event').css(left: pos_left, top: pos_top).show()
    $('#cal-event [name="date"]').val($(this).data('stamp'));

  $('#cal-event .close').on 'click', hidePopupEvent

  $('#cal-event').on "submit", (e) ->
    e.preventDefault()

    toReturn = {}
    $(this.elements).each ->
      if (this.type != "submit")
        toReturn[this.name] = $(this).val();

    $.post '/events/create', toReturn, () ->
      toReturn.date = new Date +toReturn.date
      render_event toReturn
      hidePopupEvent()

  render_event = (e) ->
    colors = ['green', 'blue', 'red', 'purple', 'orange']
    el = $(cal.getDay(new Date(e.date).getDate()))
    color = colors[Math.floor(Math.random()*colors.length)]
    el.find('ul').append("<li class='#{color}'>#{e.name}</li>")

  #
  # event placement
  render_events = ->
    current = cal.renderedMonth()

    $.get "/events/#{window.location.href.split("/")[5]}", (data) ->
      if data[current.year] && data[current.year][current.month]
        for e in data[current.year][current.month]
          render_event(e)

  render_events()

  # 
  # list toggle
  # 

  $('.view-selector li').on 'click', ->
    $('.view-selector li').removeClass 'active'
    $(@).addClass 'active'

  #
  # color pickers
  #

  # RGBA Converter
  componentToHex = (c) ->
    hex = c.toString(16)
    (if hex.length is 1 then "0" + hex else hex)

  rgbToHex = (r, g, b) ->
    "#" + componentToHex(r) + componentToHex(g) + componentToHex(b)

  # Initialize color picker
  colorPicker = new picker
  colorPicker.el.appendTo('.colors')

  # Open/ close color picker
  $('.color-selector').on 'click', ->
    openedColorPicker = $('.color-picker')
    openedColorPicker.toggle()

  colorPicker.on 'change', (color) ->
    $('.color-selector').css('background', color)
    theColor = rgbToHex(color.r, color.g, color.b)
    $('.selected-color-id').text(theColor)
    colorArray = [color.r, color.g, color.b, 1]

  applyColor = (el) ->
    colorPicker.on 'change', (color) ->
      theColor = rgbToHex(color.r, color.g, color.b)
      $(el).css('background', theColor)

      $(el).next().text(theColor)
      colorArray = [color.r, color.g, color.b, 1]
      console.log(colorArray)

  $('.color-selector').on 'click', ->
    applyColor(this)
    console.log(this)
  
  #
  # inject embed code
  #

  embed_id = window.location.toString().match(/.*?edit\/(.*)/)[1]
  embed_code = "<script src='http://jenius-radical.jitsu.com/embed/js/#{embed_id}.js'><script>radical('#cal')</script>"
  $('.embed-code-box').text(embed_code)

  # Hide picker upon click
  $(document).on 'click', (e) ->
    unless ($(e.target)[0].tagName == 'CANVAS' || $(e.target).attr('class') == 'color-selector')
      $('.color-picker').hide()
