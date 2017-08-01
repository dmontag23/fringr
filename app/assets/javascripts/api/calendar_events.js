var initialize_calendar;
initialize_calendar = function() {
  $('.calendar').each(function(){
    var calendar = $(this);
    var schedule_id = calendar.attr('schedule_id')
    var default_start_day = calendar.attr('default_start_day')
    calendar.fullCalendar({
      header: {
        left: 'prevYear,prev,next,nextYear',
        center: 'title',
        right: 'today,month,agendaWeek,basicDay'
      },
      defaultView: 'agendaWeek',
      slotDuration: '00:05:00',
      firstDay: 4,
      defaultDate: moment(default_start_day),
      editable: true,
      // do not allow resize event to alter duration
      eventDurationEditable: false,
      eventLimit: true,
      events: {
        url: '/api/calendar_events',
        data: {
            schedule_id: schedule_id
        }
      },
      eventDrop: function(event, delta, revertFunc, jsEvent, ui, view) { 
        
        checkForConflicts(event, revertFunc);

      }
    }); // end of options
  })
};
$(document).on('turbolinks:load', initialize_calendar);
$('#calendar').fullCalendar('gotoDate', currentDate);

function checkForConflicts(event, revertFunc){
// Ajax call passes event's JSON to application in a query
// parameter. Uses JSON.stringify to generate an URL friendly
// JSON string.
  $.ajax({
    data: { schedule_id: $('.calendar').attr('schedule_id'), event_json: JSON.stringify(event) },
    url: '/api/calendar_events/check_piece',
    dataType: "json",
    success: function(data){
      saveEvent(event, revertFunc);
    },
    error: function(xhr){
      var errors = $.parseJSON(xhr.responseText).errors;
      alert(errors);
      if (confirm("Override")) {
        saveEvent(event, revertFunc);
      } else {
        revertFunc();
      }
    }
  })
};

function saveEvent(event, revertFunc){
// Ajax call passes event's JSON to application in a query
// parameter. Uses JSON.stringify to generate an URL friendly
// JSON string.
  $.ajax({
    type: "POST",
    data: { schedule_id: $('.calendar').attr('schedule_id'), event_json: JSON.stringify(event) },
    url: '/api/calendar_events/',
    dataType: "json",
    success: function(data){
      alert("Saved");
    },
    error: function(xhr){
      var errors = $.parseJSON(xhr.responseText).errors;
      alert(errors);
      revertFunc();
    }
  })
};