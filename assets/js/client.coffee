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
    day_events = data[current.year][current.month].filter (e) =>
      return e.day == parseInt(day_number)

    # set header to date
    $('#cal-event').find('.header p').text(moment($(@).data('stamp')).format("dddd MMMM DD, YYYY"))

    # display events in popup
    $('#cal-event .body').empty()
    for e in day_events
      $('#cal-event .body').append("<p>#{e.name}</p>")

    if day_events.length < 1
      $('#cal-event .body').append("<p class='empty'>no events today : (</p>")


  $('#cal-event').on 'click', '.close', ->
    $('#cal-event').hide()

  # 
  # event placement
  # 

  # make a request based on the id
  data = {
    '2013': {
      '3': [
         { name: 'test event', day: 2, from: '11:00PM', to: '11:30PM' }
        ,{ name: 'test event 2', day: 4, from: '11:00PM', to: '11:30PM' }
        ,{ name: 'test event 3', day: 2, from: '11:00PM', to: '11:30PM' }
      ]
    }
  }

  colors = ['green', 'blue', 'red', 'purple', 'orange']

  render_events = ->
    current = cal.renderedMonth()

    if data[current.year] && data[current.year][current.month]
      for e in data[current.year][current.month]
        el = $(cal.getDay(e.day))
        color = colors[Math.floor(Math.random()*colors.length)]
        el.find('ul').append("<li class='#{color}'>#{e.name}</li>")

  render_events()