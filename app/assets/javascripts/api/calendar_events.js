var initialize_calendar;
initialize_calendar = function() {
  $('.calendar').each(function(){
    var calendar = $(this);
    var schedule_id = calendar.attr('schedule_id')
    calendar.fullCalendar({
      header: {
        left: 'prevYear,prev,next,nextYear',
        center: 'title',
        right: 'today,month,agendaWeek,basicDay'
      },
      slotDuration: '00:05:00',
      selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,
      events: {
        url: '/api/calendar_events',
        data: {
            schedule_id: schedule_id
        }
      }
    }); // end of options
  })
};
$(document).on('turbolinks:load', initialize_calendar);