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

  #
  # event popup

  hidePopupEvent = ->
    $('#cal-event').hide()

  $('#cal td').one 'click', ->
    $('#cal-event').appendTo($('body'))

  $('#cal').on 'click', 'td', ->
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
    $.get "/events", (data) ->
      if data[current.year] && data[current.year][current.month]
        for e in data[current.year][current.month]
          render_event(e)

  render_events()

  #
  # color pickers

  # RGBA Converter
  componentToHex = (c) ->
    hex = c.toString(16)
    (if hex.length is 1 then "0" + hex else hex)
  rgbToHex = (r, g, b) ->
    "#" + componentToHex(r) + componentToHex(g) + componentToHex(b)

  colorPicker = new picker
  colorPicker.el.appendTo('.colors')

  $('.color-selector').on 'click', ->
    openedColorPicker = $('.color-picker')
    openedColorPicker.toggle()

  colorPicker.on 'change', (color) ->
    $('.color-selector').css('background', color)
    theColor = rgbToHex(color.r, color.g, color.b)
    $('.selected-color-id').text(theColor)
    colorArray = [color.r, color.g, color.b, 1]
    console.log(colorArray)
