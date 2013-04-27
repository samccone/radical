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

  $('#cal').on 'click', '.prev', ->
    cal.prevMonth()

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
