$(function() {
  $('#bookings').fullCalendar({
    editable: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'agendaWeek',
    height: 500,
    slotMinutes: 15,
    events: "/events/get_events",
    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5",
    eventClick: function(event, jsEvent, view){
      showEventDetails(event);
    },
  });
});
