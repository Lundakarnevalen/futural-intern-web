$(function() {
  var $el = $('#bookings');
  $el.fullCalendar({
    editable: true,

    header: {
      left: 'prev, next, today',
      center: 'title',
      right: 'month, agendaWeek ,agendaDay'
    },

    defaultView: 'month',
    height: 700,
    slotMinutes: 30,
    minTime: 7,
    maxTime: 22,
    hiddenDays: [6],

    slotEventOverlap: false,

    eventSources:[{
      url: '/fabriken/reservations.json'
    }],

    select: function(start, end, allDay) {
      $el.fullCalendar('unselect');
    },

    eventRender: function(event, element) {
    },

    selectable: true,
    selectHelper: true,

    timeFormat: 'H:mm { - H:mm } ',
    dragOpacity: "0.5",
    eventClick: function(event, jsEvent, view) {
      showEventDetails(event);
    }
  });
});
