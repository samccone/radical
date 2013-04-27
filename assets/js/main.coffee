$ ->

  # 
  # init calendar
  # 

  cal = new Thyme $("#cal")[0]

  #
  # month pickers
  # 

  $('#cal').on 'click', '.next', ->
    cal.nextMonth()
    render_events()

  $('#cal').on 'click', '.prev', ->
    cal.prevMonth()
    render_events()

  # 
  # event popup
  # 

  $('#cal td').one 'click', ->
    $('.event').appendTo($('body'))

  $('#cal').on 'click', 'td', ->
    pos = $(@).offset()
    pos_left = pos.left - 170 + $(@).width()/2
    pos_top = pos.top + $(@).outerHeight()
    $('.event').css(left: pos_left, top: pos_top).show()

  $('.event').on 'click', '.close', ->
    $('.event').hide()

  # 
  # event placement
  # 

  data = {
    '2013': {
      '3': [
         { name: 'test event', day: 2, from: '11:00PM', to: '11:30PM' }
        ,{ name: 'test event 2', day: 4, from: '11:00PM', to: '11:30PM' }
        ,{ name: 'test event 3', day: 2, from: '11:00PM', to: '11:30PM' }
      ]
    }
  }

  render_events = ->
    current = cal.renderedMonth()

    if data[current.year] && data[current.year][current.month]
      for e in data[current.year][current.month]
        el = $(cal.getDay(e.day))
        el.find('ul').append("<li>#{e.name}</li>")

  render_events()