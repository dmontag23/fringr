var initialize_calendar;
initialize_calendar = function() {
  $('.calendar').each(function(){
    var calendar = $(this);
    calendar.fullCalendar({
      header: {
        left: 'prevYear,prev,next,nextYear',
        center: 'title',
        right: 'today,month,agendaWeek,basicDay'
      },
      selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,
      events: [
        {
            title  : 'event1',
            start  : '2017-03-25'
        },
        {
            title  : 'event2',
            start  : '2017-03-26',
            end    : '2017-03-28'
        },
        {
            title  : 'event3',
            start  : '2017-03-28T12:30:00',
            allDay : false // will make the time show
        }
    ]
    }); // end of options
  })
};
$(document).on('turbolinks:load', initialize_calendar);