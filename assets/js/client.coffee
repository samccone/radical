window.radical = (div, id) ->

  # 
  # load css
  # 

  css = document.createElement 'link'
  css.rel = 'stylesheet'
  css.href = '/css/main.css'
  document.head.appendChild(css)

  # 
  # load js dependencies
  # 

  append_script = (name, cb) ->
    script = document.createElement('script')
    script.src = name
    document.head.appendChild(script)
    script.onreadystatechange = script.onload = ->
      cb() if !loaded
      loaded = true

  append_script '/js/deps.js', ->

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

    event_popup = '<form method="post" enctype="multipart/form-data" action="/events/create" class="event"><div class="header"><p>New Event Title</p><div class="close">×</div></div><div class="body"></div></form>'

    $(event_popup).appendTo($('body'))

    $("#{div} td").one 'click', ->
      $('.events').appendTo($('body'))

    $(div).on 'click', 'td', ->
      pos = $(@).offset()
      pos_left = pos.left - 170 + $(@).width()/2
      pos_top = pos.top + $(@).outerHeight()
      $('.event').css(left: pos_left, top: pos_top).show()

      # get events on current day
      day_number = $(@).find('span').text()
      current = cal.renderedMonth()
      day_events = data[current.year][current.month].filter (e) =>
        return e.day == parseInt(day_number)

      # set header to date
      $('.event').find('.header p').text(moment($(@).data('stamp')).format("dddd MMMM DD, YYYY"))

      # display events in popup
      $('.event .body').empty()
      for e in day_events
        console.log e
        $('.event .body').append("<p>#{e.name}</p>")

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