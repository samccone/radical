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
        toReturn[$(this).attr('data-name')] = JSON.stringify(hexToRgb($(this).text()));

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
    $('#cal-event .current-time').html moment($(this).data('stamp')).format("ddd MMM D")
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
  componentToHex = (c) ->
    hex = c.toString(16);
    if hex.length == 1 then "0" + hex else hex

  rgbToHex = (r, g, b) ->
    "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);

  hexToRgb = (hex) ->
    result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
    [parseInt(result[1], 16), parseInt(result[2], 16), parseInt(result[3], 16)]

  # Initialize color picker

  colorPicker = new picker
  colorPicker.el.appendTo('.colors')
  opened = null
  openedColorPicker = null
  # Open/ close color picker

  $('.color-selector').on 'click', (e) ->
    opened = $(e.currentTarget)
    $('.header-box.selected').removeClass("selected")
    opened.parent().addClass("selected")

    openedColorPicker = $('.color-picker')
    $('.color-picker').show()
    colorPicker.hue("rgb("+hexToRgb(opened.next().text()).join(",")+")")
    colorPicker.render();

  colorPicker.on 'change', (color) ->
    opened.css('background', color)
    theColor = rgbToHex(color.r, color.g, color.b)
    opened.next().text(theColor)
    colorArray = [color.r, color.g, color.b, 1]
    opened.data("custom-color", colorArray)

  #
  # inject embed code
  #

  embed_id = window.location.toString().match(/.*?edit\/(.*)/)[1]
  embed_code = "<script src='http://jenius-radical.jitsu.com/embed/js/#{embed_id}.js'><script>radical('#cal')</script>"
  $('.embed-code-box').text(embed_code)

  # Hide picker upon click
  $('.font-selector').on 'change', ->
      saveConfig()

  $(document).on 'click', (e) ->
    unless ($(e.target)[0].tagName == 'CANVAS' || $(e.target).attr('class') == 'color-selector')
      saveConfig()
      $('.header-box.selected').removeClass("selected")
      $('.color-picker').hide()

  $('.title').zclip({
    path:'/ZeroClipboard.swf',
    copy:$('.embed-code-box').text()
    })
