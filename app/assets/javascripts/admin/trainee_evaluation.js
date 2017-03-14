$(document).on('turbolinks:load', function() {
  if ($('#trainee_evaluations').length > 0) {
    $('.evaluation-details').on('change', '.evaluation-detail-point', function() {
      build_total_point();
    });
    build_list_selectbox_evaluation($('#list-evaluation li.exist .check-box'));
    if ($('#list-evaluation').data('standard-nonselected')) {
      build_list_nonselectbox_evaluation();
    }

    $('#trainee_evaluation_evaluation_template_id').change(function() {
      var arr_url = document.location.pathname;
      var evaluation_template_id = this.value;
      if (this.value == "") {
        $('#list-evaluation').html($('#list-evaluation .exist'));
        build_list_selectbox_evaluation($('#list-evaluation li.exist .check-box'));
        $('#list-evaluation').prepend($('#list-evaluation .add-new'));
        build_list_selectbox_evaluation($('#list-evaluation li.add-new .check-box'));
      } else {
        $.ajax({
          url: arr_url,
          method: "GET",
          dataType: "json",
          data: {evaluation_template_id: evaluation_template_id},
          success: function(data) {
            var html = "";
            var index = $('#list-evaluation li').length;
            var $list_exist = $('#list-evaluation li.exist');
            var $list_add_new = $('#list-evaluation li.add-new');
            if (data.length > 0) {
              data.forEach(function(evaluation_standard) {
                var $exist = 0;
                $('#list-evaluation li.exist').each(function() {
                  if($(this).data('id') == evaluation_standard.id) {$exist++}
                });
                if ($exist == 0) {
                  html += "<li class='list-group-item row' data-id='" + evaluation_standard.id +
                    "'><div data-color='info' class='col-md-6 check-box render'>" +
                    evaluation_standard.name + "</div>" +
                    '<div class="col-md-6">\
                      <input type="hidden"\
                        name="trainee_evaluation[evaluation_check_lists_attributes][' +
                        index + '][evaluation_standard_id]"\
                        value="' + evaluation_standard.id + '">' +
                      '<input step="0.1" class="evaluation-detail-point form-control\
                        score-evaluation" type="number"\
                        name="trainee_evaluation[evaluation_check_lists_attributes][' +
                        index + '][score]">' + "<a href='#' class='check-list-remove'>\
                      <i class='fa fa-remove'></i></a></div></li>";
                    index++;
                }
              });
            } else {
              html = "<div class='empty'><h2>" + I18n.t("projects.label.empty") +
                "</h2></div>"
            }
            $('#list-evaluation').html($list_exist);
            build_list_selectbox_evaluation($('#list-evaluation li.exist .check-box'));
            $('#list-evaluation').append(html);
            build_list_selectbox_evaluation($('#list-evaluation li .check-box.render'));
            $('#list-evaluation').prepend($list_add_new);
            build_list_selectbox_evaluation($('#list-evaluation li.add-new .check-box'));
          },
          error: function() {
          }
        });
      }
    });
  }

  $('#add-new').click(function (e) {
    e.preventDefault();
    var html = "<li class='list-group-item add-new row' style='margin: 0'>\
      <div class='col-md-6 check-box add-new-name' data-color='info'\
      data-checked='true'><input class='evaluation-detail-name form-control'" +
      "type='text' name='trainee_evaluation[evaluation_check_lists_attributes][" +
      $('#list-evaluation li').length + "][name]'/></div>"
      + "<div class='col-md-6'>"
      + "<input step='0.1' class='evaluation-detail-point form-control score-evaluation'" +
      "type='number' name='trainee_evaluation[evaluation_check_lists_attributes][" +
      $('#list-evaluation li').length + "][score]'>" +
      "<a href='#'' class='check-list-remove'>\
      <i class='fa fa-remove'></i></a></div></li>";
    $('#list-evaluation').append(html);
    build_list_selectbox_evaluation($('#list-evaluation li .check-box.add-new-name'));
  });

  $('#list-evaluation').on('click', 'a.check-list-remove', function (e) {
    e.preventDefault();
    var nearest_li = $(this).closest('li');
    if ($('.check-box', nearest_li).hasClass('render')) {
      nearest_li.remove();
    } else {
      nearest_li.hide();
      nearest_li.find('input._destroy').val(true);
    }
  });
});

function build_list_selectbox_evaluation(lists) {
  var index = $('#list-evaluation li').length - lists.length;
  lists.each(function() {
    // Settings
    var $checkbox = $("<input class='hidden _destroy' type='hidden' value='false'" +
      "name='trainee_evaluation[evaluation_check_lists_attributes][" + index +
      "][_destroy]'>");
    var $use = $("<input class='hidden use' type='hidden' value='false'" +
      "name='trainee_evaluation[evaluation_check_lists_attributes][" + index +
      "][use]'>")
    var $widget = $(this),
      color = ($widget.data('color') ? $widget.data('color') : "primary"),
      style = ($widget.data('style') == "button" ? "btn-" : "list-group-item-"),
      settings = {
        on: {
          icon: 'glyphicon glyphicon-check'
        },
        off: {
          icon: 'glyphicon glyphicon-unchecked'
        }
      };

    $widget.parent().css('margin', '0px');
    if ($('input._destroy', this).length == 0) {
      $widget.append($checkbox);
      $widget.append($use);
    }

    $use.on('change', function () {
      updateDisplay();
    });

    // Actions
    function updateDisplay() {
      var isChecked = $use.val() == 'true';

      // Set the button's state
      $widget.data('state', (isChecked) ? "on" : "off");

      // Set the button's icon
      $widget.find('.state-icon')
        .removeClass()
        .addClass('state-icon ' + settings[$widget.data('state')].icon);

      // Update the button's color
      if (isChecked) {
        $widget.parent().addClass(style + color + ' active');
      } else {
        $widget.parent().removeClass(style + color + ' active');
      }
      $('input.use', $widget).val(isChecked);

      $('.evaluation-detail-name', $widget.parent()).focus();
      build_total_point();
    }

    // Initialization
    function init() {
      if ($widget.data('checked') == true) {
        $use.val(true);
      }

      updateDisplay();

      // Inject the icon if applicable
      if ($widget.find('.state-icon').length == 0) {
        $widget.prepend('<span class="state-icon ' +
          settings[$widget.data('state')].icon + '"></span>');
      }
    }
    init();

    // Event Handlers
    $('.state-icon', $widget).on('click', function () {
      $use.val($use.val() == 'true' ? 'false' : 'true');
      $use.triggerHandler('change');
    });

    index++;
  });
}

function build_list_nonselectbox_evaluation() {
  var data = $('#list-evaluation').data('standard-nonselected');
  html = ''
  for (i = 0; i < data.length; i++) { 
    var standard = data[i];
    var index = Date.now();
    html += "<li class='list-group-item row non-exist' style='margin: 0px;' data-evaluation-standard-id='" + standard.id + "'>" +
      "<div data-checked='false' data-color='info' class='col-md-6 check-box'>" + 
      "<span class='state-icon glyphicon glyphicon-unchecked'></span>" + standard.name + 
      "</div>" +
      "<div class='col-md-6'><input value='" + standard.id + "' type='hidden'" + 
      "name='trainee_evaluation[evaluation_check_lists_attributes][" + index + 
      "][evaluation_standard_id]'><input step='0.1' class='form-control evaluation-detail-point' value=''" +
      "type='number' name='trainee_evaluation[evaluation_check_lists_attributes][" +
      index + "][score]' id='trainee_evaluation_evaluation_check_lists_attributes_" + index + "_score'></div></li>"
  }

  $('#non-exist').html(html);

  $('#list-evaluation li.non-exist .check-box').each(function() {
    // Settings
    var index = Date.now();
    var $checkbox = $("<input class='hidden _destroy' type='hidden' value='false'" +
      "name='trainee_evaluation[evaluation_check_lists_attributes][" + index +
      "][_destroy]'>");
    var $use = $("<input class='hidden use' type='hidden' value='false'" +
      "name='trainee_evaluation[evaluation_check_lists_attributes][" + index +
      "][use]'>")

    var parent_input_score = $(this).parent().find('.evaluation-detail-point').parent();
    $(parent_input_score).html("<input step='0.1' class='form-control evaluation-detail-point'" + 
      "value='' type='number' name='trainee_evaluation[evaluation_check_lists_attributes][" + 
      index + "][score]' id='trainee_evaluation_evaluation_check_lists_attributes_" + 
      index + "_score'>");

    $(parent_input_score).prepend("<input value='" + $(this).parent().data("evaluation-standard-id") + 
      "' type='hidden' name='trainee_evaluation[evaluation_check_lists_attributes][" + 
      index + "][evaluation_standard_id]'>");

    var $widget = $(this),
      color = ($widget.data('color') ? $widget.data('color') : "primary"),
      style = ($widget.data('style') == "button" ? "btn-" : "list-group-item-"),
      settings = {
        on: {
          icon: 'glyphicon glyphicon-check'
        },
        off: {
          icon: 'glyphicon glyphicon-unchecked'
        }
      };

    $widget.parent().css('margin', '0px');
    if ($('input._destroy', this).length == 0) {
      $widget.append($checkbox);
      $widget.append($use);
    }

    $use.on('change', function () {
      updateDisplay();
    });

    // Actions
    function updateDisplay() {
      var isChecked = $use.val() == 'true';

      // Set the button's state
      $widget.data('state', (isChecked) ? "on" : "off");

      // Set the button's icon
      $widget.find('.state-icon')
        .removeClass()
        .addClass('state-icon ' + settings[$widget.data('state')].icon);

      // Update the button's color
      if (isChecked) {
        $widget.parent().addClass(style + color + ' active');
      } else {
        $widget.parent().removeClass(style + color + ' active');
      }
      $('input.use', $widget).val(isChecked);

      $('.evaluation-detail-name', $widget.parent()).focus();
      build_total_point();
    }

    // Initialization
    function init() {
      if ($widget.data('checked') == true) {
        $use.val(true);
      }

      updateDisplay();

      // Inject the icon if applicable
      if ($widget.find('.state-icon').length == 0) {
        $widget.prepend('<span class="state-icon ' +
          settings[$widget.data('state')].icon + '"></span>');
      }
    }
    init();

    // Event Handlers
    $('.state-icon', $widget).on('click', function () {
      $use.val($use.val() == 'true' ? 'false' : 'true');
      $use.triggerHandler('change');
    });
  });
}

function build_total_point() {
  var total_point = 0;
  $('.evaluation-detail-point').each(function() {
    use = $(this).closest('li').find('.use').val() == 'true';
    if($(this).val() !== undefined && $(this).val() !== '' && use) {
      total_point += parseFloat($(this).val());
    }
  });
  document.getElementById('trainee_evaluation_total_point').value = total_point;
}
