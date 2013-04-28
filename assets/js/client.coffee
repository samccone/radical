#= require "jquery.js"
#= require "moment.js"
#= require "thyme.js"

window.radical = (div, id) ->

  # 
  # init calendar
  # 

  cal = new Thyme $(div)[0]

  #
  # month pickers
  # 

  $(div).on 'click', '.next', ->
    cal.nextMonth()
    render_events()

  $(div).on 'click', '.prev', ->
    cal.prevMonth()
    render_events()

  # 
  # event popup
  # 

  event_popup = '<form method="post" enctype="multipart/form-data" action="/events/create" id="cal-event"><div class="header"><p>New Event Title</p><div class="close">×</div></div><div class="body"></div></form>'

  $(event_popup).appendTo($('body'))

  $(div).on 'click', 'td', ->
    pos = $(@).offset()
    pos_left = pos.left - 170 + $(@).width()/2
    pos_top = pos.top + $(@).outerHeight()
    $('#cal-event').css(left: pos_left, top: pos_top).show()

    # get events on current day
    day_number = $(@).find('span').text()
    current = cal.renderedMonth()
    day_events = events[current.year][current.month].filter (e) =>
      return new Date(e.date).getDate() == parseInt(day_number)

    # set header to date
    $('#cal-event').find('.header p').text(moment($(@).data('stamp')).format("dddd MMMM DD, YYYY"))

    # display events in popup
    $('#cal-event .body').empty()
    for e in day_events
      $('#cal-event .body').append("<div class='evnt'><time>#{e.from}</time><div class='middle'><p>#{e.name}</p><small>#{e.location}</small></div><div class='add-to-calendar'></div></div>")

    if day_events.length < 1
      $('#cal-event .body').append("<p class='empty'>no events today : (</p>")


  $('#cal-event').on 'click', '.close', ->
    $('#cal-event').hide()

  # 
  # event placement
  # 

  colors = ['green', 'blue', 'red', 'purple', 'orange']

  render_events = ->
    current = cal.renderedMonth()

    # events is injected
    if events[current.year] && events[current.year][current.month]
      for e in events[current.year][current.month]
        date = new Date(e.date).getDate()
        console.log date
        el = $(cal.getDay(date))
        color = colors[Math.floor(Math.random()*colors.length)]
        el.find('ul').append("<li class='#{color}'>#{e.name}</li>")

  render_events()