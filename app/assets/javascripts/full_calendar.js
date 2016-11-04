$(document).on('turbolinks:load', function() {
  $('#calendar').fullCalendar({
    theme: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay,listMonth'
    },
    navLinks: true,
    editable: true,
    eventLimit: true,
    businessHours: {
      dow: [1, 2, 3, 4, 5]
    },
    events: {
      url: '',
      error: function() {
        $('#script-warning').show();
      }
    },
    loading: function(bool) {
      $('#loading').toggle(bool);
    }
  });
});
