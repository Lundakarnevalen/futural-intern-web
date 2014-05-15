$(function() {
  var $el = $('#bookings'),
      $form = $('#res_form'),
      $status = $('#booking-status');

  $el.fullCalendar({

    header: {
      left: 'prev, next, today',
      center: 'title',
      right: 'month, agendaWeek ,agendaDay'
    },

    defaultView: 'agendaWeek',
    height: 700,
    firstDay: 1,
    slotMinutes: 60,
    minTime: 12,
    maxTime: 22,
    hiddenDays: [6],
    axisFormat: 'H:mm { - H:mm } ',
    slotEventOverlap: false,
    allDaySlot: false,

    eventSources:[{
      url: '/fabriken/reservations.json'
    }],

    unselectAuto: false,
    select: function(start, end, allDay) {
      $('#reservation_start_time').val(start);
      $('#reservation_end_time').val(end);
    },

    selectable: true,
    selectHelper: true,
    timeFormat: 'H:mm { - H:mm } ',
    dragOpacity: "0.5",
    eventClick: function(event, jsEvent, view) {
      showEventDetails(event);
    }
  });

  $form.on('ajax:success', function(e, data, status, xhr) {
    $(this).find('textarea').val("");
    $el.fullCalendar('renderEvent',
    {
      id: data.id,
      title: data.title,
      start: data.start,
      end: data.end,
      allDay: data.allDay,
      url: data.url
    },true);
    $el.fullCalendar('unselect');
    $status
      .text('Din bokning är nu registrerad!')
      .attr('class', 'alert alert-success alert-dismissible')
      .show();

  }).on('ajax:error', function(e, xhr, status, error) {
    var msg = 'Din bokning kunde inte genomföras pga: ' + xhr.responseJSON.errors.join(",");
    $status.text(msg).attr('class', 'alert alert-danger alert-dismissible').show();
  });
});
