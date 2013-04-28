$ ->

  # init calendar
  cal = new Thyme $("#cal")[0]

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


  #
  # event placement
  render_events = ->
    colors = ['green', 'blue', 'red', 'purple', 'orange']

    $.get "/events", (data) ->
      current = cal.renderedMonth()
      if data[current.year] && data[current.year][current.month]
        for e in data[current.year][current.month]
          el = $(cal.getDay(new Date(e.date).getDate()))
          color = colors[Math.floor(Math.random()*colors.length)]
          el.find('ul').append("<li class='#{color}'>#{e.name}</li>")

  render_events()
