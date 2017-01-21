var datetime_options = {
  format: I18n.t("datepicker.time.default"),
  enableOnReadonly: true,
  orientation: "auto",
  forceParse: false,
  daysOfWeekDisabled: "0,6",
  todayHighlight: true,
  showOnFocus: false
};

var btn_group = '<div class="btn-datepk">'
  + '<button class="btn btn-success btn-save">' + I18n.t("buttons.save")
  + '</button>' + '<button class="btn btn-danger btn-cancel" style="float: right;">'
  + I18n.t("buttons.cancel") + '</button></div>';

$(document).on('turbolinks:load ajaxComplete', function() {
  var select_date;
  $('input.datepicker').click(function() {
    var current_date = $(this).val();
    select_date = $(this).datepicker(datetime_options).datepicker('show');
    if($('.user-lists').length > 0){
      showBtnGroup();
      if($('.datepicker-dropdown').hasClass('datepicker-orient-top')) {
        var datepicker_top = $('.datepicker-dropdown').css('top');
        if(datepicker_top > $('.btn-datepk').height()) {
          $('.datepicker-dropdown')
            .css('top', datepicker_top - $('.btn-datepk').height() + 'px');
        } else {
          $('.datepicker-dropdown').css('top',
            $(this).offset().top + $(this).height() + 7 + 'px');
          $('.datepicker-dropdown').removeClass('datepicker-orient-top')
            .addClass('datepicker-orient-bottom');
        }
      }

      $('.btn-save').click(function() {
        select_date.parents('form').submit();
        select_date.datepicker('hide');
      });

      $('.btn-cancel').click(function() {
        select_date.datepicker('hide');
        cleardate(select_date);
      });

      select_date.datepicker().on('hide', function(e) {
        cleardate(this);
      });

      function cleardate(e) {
        $(e).val(current_date);
      }

      select_date.datepicker().on('changeMonth', function(e) {
        showBtnGroup();
      });

      select_date.datepicker().on('changeYear', function(e) {
        showBtnGroup();
      });
    }
  });
});

function showBtnGroup(){
  $('.btn-datepk').remove();
  $('.datepicker-dropdown').append(btn_group);
  $('.btn-datepk').addClass('display_block');
}
