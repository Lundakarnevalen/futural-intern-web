$(function() {
  var $el = $('#pickup-calendar'),
      location = window.location.pathname.replace(/^\/([^\/]*).*$/, '$1'),
      defaultView = location === 'snaxeriet' ? 'agendaDay' : 'month'
  $el.fullCalendar({

    header: {
      left: 'prev, next, today',
      center: 'title',
      right: 'month, agendaWeek ,agendaDay'
    },
    defaultView: defaultView,
    height: 700,
    slotMinutes: 60,
    axisFormat: 'H:mm { - H:mm } ',
    slotEventOverlap: false,
    allDaySlot: false,

    eventSources:[{
      url: '/' + location + '/orders/calendar.json'
    }],
    selectable: false,
    selectHelper: false,
    timeFormat: 'H:mm { - H:mm } ',
  });
});
