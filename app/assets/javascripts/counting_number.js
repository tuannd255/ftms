function totalTraineeValue() {
  if ($('#statistics').length > 0) {
    if ($('#total_trainees').length > 0) {
      $('.fixedTable-header .trainee-by-month').each(function(key, value) {
        var total_trainee_in_month = 0
        var total_trainee_in_month_filter = 0;

        $.each($('.fixedTable-body .total-trainees-month-' + $(value)
          .data('month')), function(index, element) {
          if(!$(element).hasClass('total')){
            total_trainee_in_month += parseInt($(element).data('total-trainees'));
          }
        });

        $.each($('.fixedTable-body .trow:visible .total-trainees-month-' + $(value).data('month')), function(index, element) {
          if(!$(element).hasClass('total')){
            total_trainee_in_month_filter += parseInt($(element).data('total-trainees'));
          }
        });

        percent = total_trainee_in_month_filter / total_trainee_in_month * 100;
        if (percent == 100 || total_trainee_in_month == 0) {
          $('#fixed-bottom-body .total-trainees-month-' + $(value).data('month')).text(total_trainee_in_month_filter.toLocaleString());
        } else {
          $('#fixed-bottom-body .total-trainees-month-' + $(value).data('month'))
            .text(total_trainee_in_month_filter.toLocaleString() + ' - ' +
            Math.round(percent).toFixed(2) + '%');
        }
      });
    };

    if($('#universities').length > 0) {
      var total_trainee_in_university = 0;
      var total_trainee_in_university_filter = 0;
      $('.fixedTable-body .trainee-by-university').each(function(key, value)  {
        total_trainee_in_university += parseInt($(value).data('total-trainees'));
      });
      $('#total-trainees-university').text(total_trainee_in_university
        .toLocaleString());

      $('.fixedTable-body .trow:visible .trainee-by-university')
        .each(function(index, element) {
        if(!$(element).hasClass('total')){
          total_trainee_in_university_filter += parseInt($(element)
            .data('total-trainees'));
        }
      });

      percent = total_trainee_in_university_filter / total_trainee_in_university * 100;
      if (percent == 100 || total_trainee_in_university == 0) {
        $('#fixed-bottom-body #total-trainees-university')
          .text(total_trainee_in_university_filter.toLocaleString());
      } else {
        $('#fixed-bottom-body #total-trainees-university')
          .text(total_trainee_in_university_filter.toLocaleString() + ' - ' +
          Math.round(percent).toFixed(2) + '%');
      }
    }
  }
}
