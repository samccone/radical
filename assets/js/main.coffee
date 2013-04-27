$ ->
  cal = new Thyme $("#cal")[0]

  $('#cal').on 'click', '.next', ->
    cal.nextMonth()

  $('#cal').on 'click', '.prev', ->
    cal.prevMonth()