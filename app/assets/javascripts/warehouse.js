$(function() {
  $('#bookings').fullCalendar({
    editable: true,
    header: {
      left: 'prev, next, today',
      center: 'title',
      right: 'month, agendaWeek ,agendaDay'
    },
    defaultView: 'month',
    height: 600,
    slotMinutes: 15,
    eventSources:[{
      url: '/fabriken/reservations.json'
    }],
    timeFormat: 'h:mm t{ - h:mm t} ',
    dragOpacity: "0.5",
    eventClick: function(event, jsEvent, view){
      showEventDetails(event);
    },
  });
});
