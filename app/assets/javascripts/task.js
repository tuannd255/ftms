$(document).on('turbolinks:load', function(){
  $('body').on('keypress', '.task-pullurl input.link-field', function (e) {
    if (e.which == 13){
      e.preventDefault();
      if ($.trim($(this).val()).length) {
        var new_field = pull_url_input_field();
        $(this).closest('.pull-requestes')
          .find('label.btn-circle.btn-danger')
          .attr('title', I18n.t("user_tasks.label.remove_git_link"));
        $(this).closest('div.pull-rq-field').append(new_field);
        $('input.link-field:last-child').focus();
      }
      return false;
    }
  });

  $('body').on('click', '.update-user-task, .create-user-task', function () {
    var _form = $(this).closest('form'),
        _links = $('input.link-field', _form),
        _git_links = "",
        _pull_url = $('input.pull_urls', _form);
    $(_links).each(function () {
      if ($.trim($(this).val()).length) {
        _git_links += this.value + " ";
      }
    });
    $(_pull_url).val(_git_links);
  });

  $('body').on('click', 'a.task-action', function (e) {
    e.preventDefault();

    var user_task_row = $(this).closest('.task.user-task-row'),
        action = $(this).data('action'),
        task_name = $('strong.task-name', user_task_row).text();
    $('body').on('click', '.pull-rq-field .btn-rm-pull .btn-circle',function () {
      var parent_pull_rq = $(this).closest('div.pull-rq-field');
      if (parent_pull_rq.find('div.pull-requestes').length > 1) {
        $(this).closest('div.pull-requestes').remove();
      }
    });

    $('body').on('click', '.pull-rq-field .btn-submit-pull .btn-circle',function () {
      var pull_rq = $(this).closest('div.pull-requestes').find('input.link-field').val(),
          _that = this,
          _url = $(this).closest('div.task.user-task-row').data('task');
      $.ajax({
        url: _url,
        method: 'PATCH',
        data: {pull_url: pull_rq},
        complete: function (data) {
          $(_that).closest('.modal').modal('hide');
        }
      });
    });

    if (action === "edit") {
      str = user_task_row[0].id;
      str = str.slice(4, str.length);
      $('#user-task-'+ str).modal('show');

    } else if (action === "delete") {
      str = user_task_row[0].id;
      str = str.slice(4, str.length);
      $.ajax({
        url: "http://localhost:3000/en/user_tasks/" + str,
        method: "delete"
      }).done(function() {
        console.log(this);
        $("#row-"+str).remove();
      });
    } else {
      var popup_object = {
        id: user_task_row.attr('id'),
        large_modal: true,
        header_type: "dangerous",
        header_title: I18n.t("notices.attention"),
        body_content: I18n.t("user_tasks.title." + action + "_tasks", {task_name: task_name}),
        footer_btn: [
          {
            id: user_task_row.data('task'),
            class: "btn-danger " + action + "-task",
            title: I18n.t("buttons." + action + "s", {object: "task"}),
            dismiss: false
          },
          {
            class: "btn-secondary",
            title: I18n.t("buttons.cancel"),
            dismiss: true
          }
        ]
      };

      var confirm_modal = popup_html(popup_object);
      user_task_row.append(confirm_modal);
      $(confirm_modal).modal('show');
      $('.' + action + '-task').click(function (e) {
        e.preventDefault();
        var modal = $(this).closest('.modal');
        $.ajax({
          url: this.id,
          method: "PUT",
          data: {status: action},
          complete: function (data) {
            $(modal).modal('hide');
          }
        });
      });
    }
  });
});

function pull_url_input_field(value) {
  var value = value || "";
  return "<div class='pull-requestes'><div class='col-md-11 task-pullurl'>\
    <input type='url' class='form-control link-field' placeholder='"
    + I18n.t("user_tasks.title.git_link") + "' value='" + value + "' pattern='https?://.+'></div>\
    <div class='col-md-1 btn-rm-pull' data-toggle='buttons'>\
    <label class='btn btn-danger btn-circle'>\
    <input type='checkbox' value='false' name='remove'>\
    <i class='fa fa-times' aria-hidden='true'></i></label></div></div></div>";
}

function check_valid_url(str) {
  var regex = /(http|https):\/\/(\w+:{0,1}\w*)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%!\-\/]))?/;
  if(!regex .test(str)) {
    return "";
  } else {
    return str;
  }
}
