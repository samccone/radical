$ ->
  cal = new Thyme $("#cal")[0]

  $('#cal').on 'click', '.next', ->
    cal.nextMonth()

  $('#cal').on 'click', '.prev', ->
    cal.prevMonth()

  $('#cal td').one 'click', ->
    $('.event').appendTo($('body'))

  $('#cal td').on 'click', ->
    pos = $(@).offset()
    pos_left = pos.left - 170 + $(@).width()/2
    pos_top = pos.top + $(@).outerHeight()
    $('.event').css(left: pos_left, top: pos_top).show()

  $('.event').on 'click', '.close', ->
    $('.event').hide()
