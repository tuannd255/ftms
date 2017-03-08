$(document).on("turbolinks:load", function() {
  setTimeout(function() {
    $('.list-project li:first-child').trigger('click');
  },10);

  var clone_project;
  var li_tag_name;
  var clone_requirement;
  $('body').on('click', 'li.project-item', function() {

    if (!$(this).hasClass('active')) {
      var project_id = $(this).data("prj");
      $.ajax({
        url: "projects/" + project_id + "/project_requirements",
        method: "GET",
        dataType: "json",
        success: function(data) {
          var html = "";
          var j = 0;
          if (data.requirement.length > 0) {
            data.requirement.forEach(function(requirement){
              j++;
              html += "<li type='1' class='list-group-item requirement-item' data-rqm="
                + requirement.id + " data-parent-prj="+ project_id + ">" 
                + "<span class='index'>" + j + '</span>'
                + ".&nbsp;&nbsp;<span>" + requirement.name
                + "</span><div class='action'><a href='#' class='rqm-edit' title='"
                + I18n.t("buttons.edit") + "'><i class='fa fa-pencil'></i></a>\
                <a href='#' class='rqm-delete' title='"
                + I18n.t("buttons.edit") + "'><i class='fa fa-remove'></i></a>\
                </div></li>";
            });
          } else {
            html = "<div class='empty'><h2>" + I18n.t("projects.label.empty") + "</h2></div>"
          }

          $('#list-rqms').html(html);

          $('.list-requirement ul').append("<li class='list-group-item requirement-item'>\
            <input type='text' class='edit-name-field'\
            name='requirement-name' maxlength='255'><a href='#' class='new-rqm-save' title='"
            + I18n.t("buttons.create") + "'><i class='fa fa-check'></i></a>\
            <a href='#' class='new-rqm-cancel' title='"
            + I18n.t("buttons.cancel") + "'><i class='fa fa-remove'></i></a></li>");
          $('#sumRequirement b').html(j);
        },
        error: function() {
        }
      });
    }
    active_li($(this));
  });

  $('body').on('click', 'a.prj-edit', function(e) {
    var nearest_active_input = $(this).closest('ul').find('input.edit-name-field');

    if (nearest_active_input.length > 0){
      temp_li = nearest_active_input.closest('li');
      if (temp_li.data('prj')) {
        temp_li.replaceWith(clone_project);
      } else {
        temp_li.remove();
      }
    }
    li_tag_name = $(this).closest('li');
    active_li(li_tag_name);
    clone_project = li_tag_name.clone();
    var name = li_tag_name.find('span').text();
    name_field_html = "<input type='text' class='edit-name-field' name='project-name'\
      value='"+ name +"' maxlength='255'><a href='#' class='edit-prj-save' title='"
      + I18n.t("buttons.save") + "'><i class='fa fa-check'></i></a>\
      <a href='#' class='edit-prj-cancel' title='"
      + I18n.t("buttons.cancel") + "'><i class='fa fa-remove'></i></a>";
    li_tag_name.html(name_field_html);
    $('.list-project input.edit-name-field:first-child').focus();
    e.preventDefault();
  });

  $('body').on('click', 'a.prj-delete', function(e) {
    li_tag_name = $(this).closest('li');
    $.ajax({
      url: "projects/" + li_tag_name.data("prj"),
      method: "POST",
      dataType: "json",
      data: {"_method": "delete"},
      complete: function(data) {
        if (data.status == 200) {
          li_tag_name.remove();
          $('#list-rqms').html("<div class='empty'><h2>" + I18n.t("projects.label.empty") + "</h2></div>");
        } else {
          li_tag_name.replaceWith(clone_project);
          active_li(li_tag_name);
        }
        update_index_project();
      }
    });
    e.preventDefault();
  });

  $('body').on('click', 'a.edit-prj-cancel', function(e) {
    li_tag_name = $(this).closest('li');
    li_tag_name.replaceWith(clone_project);
    active_li(li_tag_name);
    e.preventDefault();
  });

  $('body').on('click', 'a.edit-prj-save', function(e) {
    li_tag_name = $(this).closest('li');
    var new_name = li_tag_name.find('input').val();

    $.ajax({
      url: "projects/" + li_tag_name.data("prj"),
      method: "PATCH",
      dataType: "json",
      data: {project: {name: new_name}},
      complete: function(data) {
        if (data.status == 200) {
          clone_project.find('span').html(new_name);
        }
        li_tag_name.replaceWith(clone_project);
        active_li(li_tag_name);
      }
    });
    e.preventDefault();
  });

  $('body').on('click', 'a.rqm-edit', function(e) {
    var nearest_active_input = $(this).closest('ul').find('input.edit-name-field');
    if (nearest_active_input.length > 0){
      temp_li = nearest_active_input.closest('li');
      temp_li.replaceWith(clone_requirement);
    }
    li_tag_name = $(this).closest('li');
    clone_requirement = li_tag_name.clone();
    var name = li_tag_name.find('span').text();
    name_field_html = "<input type='text' class='edit-name-field' name='requirement-name'\
      value='"+ name +"'><a href='#' class='edit-rqm-save' title='"
      + I18n.t("buttons.save") + "'><i class='fa fa-check'></i></a>\
      <a href='#' class='edit-rqm-cancel' title='"
      + I18n.t("buttons.cancel") + "'><i class='fa fa-remove'></i></a>";
    li_tag_name.html(name_field_html);

    $('#list-rqms input.edit-name-field:first-child').focus();
    e.preventDefault();
  });

  $('body').on('click', 'a.rqm-delete', function(e) {
    li_tag_name = $(this).closest('li');
    var _url = "projects/" + li_tag_name.data("parent-prj")
      + "/project_requirements/" + li_tag_name.data("rqm");
    $.ajax({
      url: _url,
      method: "POST",
      dataType: "json",
      data: {"_method": "delete"},
      complete: function(data) {
        if (data.status == 200) {
          li_tag_name.remove();
        } else {
          li_tag_name.replaceWith(clone_requirement);
        }
        update_index_requirement()
      }
    });
    e.preventDefault();
  });

  $('body').on('click', 'a.edit-rqm-save', function(e) {
    li_tag_name = $(this).closest('li');
    var new_name = li_tag_name.find('input').val();
    var _url = "projects/" + li_tag_name.data("parent-prj")
      + "/project_requirements/" + li_tag_name.data("rqm");
    $.ajax({
      url: _url,
      method: "PATCH",
      dataType: "json",
      data: {project_requirement: {name: new_name}},
      complete: function(data) {
        if (data.status == 200) {
          clone_requirement.find('span').html(new_name);
        }
        li_tag_name.replaceWith(clone_requirement);
      }
    });
    e.preventDefault();
  });

  $('body').on('click', 'a.edit-rqm-cancel', function(e) {
    li_tag_name = $(this).closest('li');
    li_tag_name.replaceWith(clone_requirement);
    e.preventDefault();
  });

  $('#new-prj').click(function () {
    $('#list-rqms').html("<div class='empty'><h2>" + I18n.t("projects.label.empty") + "</h2></div>");
    var nearest_active_input = $('.list-project input.edit-name-field');

    if (nearest_active_input.data('prj')){
      temp_li = nearest_active_input.closest('li');
      temp_li.replaceWith(clone_project);
    }
    if ($('#new-prj-nf').length == 0) {

      $('.list-project ul').append("<li class='list-group-item project-item' id='new-prj-nf'>\
        <input type='text' id='project-name-field' class='edit-name-field' name='project-name'>\
        <a href='#' class='new-prj-save' title='"
        + I18n.t("buttons.create") + "'><i class='fa fa-check'></i></a>\
        <a href='#' class='new-prj-cancel' title='"
        + I18n.t("buttons.cancel") + "'><i class='fa fa-remove'></i></a></li>");
      active_li($('.list-project li:last-child'));
    } else {
      $('#new-prj-nf').fadeTo('quick', 0.3).fadeTo('slow', 1.0);
    }
    $('#project-name-field').focus();
  });

  $('#new-rqm').click(function () {
    if ($('.list-requirement .empty').length > 0) {
      $('.list-requirement .empty').remove();
    }
    if ($('li.project-item.active').data('prj')) {
      $('.list-requirement ul').append("<li class='list-group-item requirement-item'>\
        <input type='text' class='edit-name-field'\
        name='requirement-name'><a href='#' class='new-rqm-save' title='"
        + I18n.t("buttons.create") + "'><i class='fa fa-check'></i></a>\
        <a href='#' class='new-rqm-cancel' title='"
        + I18n.t("buttons.cancel") + "'><i class='fa fa-remove'></i></a></li>");
    } else {
      $('.list-requirement ul').append("<li class='list-group-item requirement-item'>\
        <input type='text' class='edit-name-field' name='requirement-name'>\
        <a href='#' class='new-rqm-cancel' title='"
        + I18n.t("buttons.cancel") + "'><i class='fa fa-remove'></i></a></li>");
    }
    $('#list-rqms input.edit-name-field:first-child').focus();
  });

  $('body').on('click', '.new-rqm-cancel, .new-prj-cancel', function (e) {
    $(this).closest('li').remove();
    if (!$.trim($('.list-requirement ul').html()).length || !$('.list-project li.active').length) {
      $('.list-requirement ul').html("<div class='empty'><h2>"
        + I18n.t("projects.label.empty") + "</h2></div>");
    }
    e.preventDefault();
  });

  $('body').on('click', '.new-prj-save', function (e) {
    var prj_name = $(this).closest('li').find('input.edit-name-field').val();
    var rqms = {};
    $('#list-rqms input[name="requirement-name"]').each(function(i, v){
      rqms[i] = {name: $(v).val()};
    });
    var alert_type = "";
    var prj_li = $(this).closest('li');
    $.ajax({
      url: "projects",
      method: "POST",
      dataType: "json",
      data: {project: {name: prj_name, project_requirements_attributes: rqms}},
      success: function(data) {
        flash_now('alert-success', I18n.t("projects.create_project.success"));

        prj_li.replaceWith("<li class='list-group-item project-item' data-prj="
          + data.project.id + ">" + "<span class='index'>" 
          + $('.list-project li').length + '</span>.'
          + "&nbsp;&nbsp;<span>" + data.project.name + "</span><div class='action'>\
          <a href='#' class='prj-edit' title=" + I18n.t("buttons.edit")
          + "><i class='fa fa-pencil'></i></a><a href='#' class='prj-delete'\
          title='" + I18n.t("buttons.delete") + "'><i class='fa fa-remove'></i></a>\
          </div></li>");
        $('#list-rqms li').each(function (i, v) {
          var j = i+1;
          var html = $.parseHTML("<li type='1' class='list-group-item requirement-item' data-rqm='"
            + data.requirements[i].id + "' data-parent-prj='"+ data.project.id + "'>"
            + "<span class='index'>" + j + "</span>.&nbsp;&nbsp;<span>" + data.requirements[i].name
            + "</span><div class='action'><a href='#' class='rqm-edit' title='"
            + I18n.t("buttons.edit") + "'><i class='fa fa-pencil'></i></a>\
            <a href='#' class='rqm-delete' title='"
            + I18n.t("buttons.edit") + "'><i class='fa fa-remove'></i></a></div></li>");
          $(v).replaceWith(html);
        });
        update_index_project();
      },
      error: function(data) {
        flash_now('alert-error', I18n.t("projects.create_project.fail"));
      }
    });
    e.preventDefault();
  });

  $('body').on('click', '.new-rqm-save', function (e) {
    var pqm_name = $('.list-requirement input.edit-name-field').val();
    var prj_id = $('li.project-item.active').data('prj');
    var rqm_li = $(this).closest('li');
    $.ajax({
      url: "projects/" + prj_id + "/project_requirements",
      method: "POST",
      dataType: "json",
      data: {project_requirement: {name: pqm_name, project_id: prj_id}},
      success: function(data) {
        flash_now('alert-success', I18n.t("projects.create_requirement.success"));
        rqm_li.replaceWith("<li type='1' class='list-group-item requirement-item' data-rqm="
          + data.requirement.id + " data-parent-prj="+ prj_id + ">"
          + "<span class='index'>"
          + $('#list-rqms li').length + ".</span>.&nbsp;&nbsp;<span>" + data.requirement.name
          + "</span><div class='action'><a href='#' class='rqm-edit' title='"
          + I18n.t("buttons.edit") + "'><i class='fa fa-pencil'></i></a>\
          <a href='#' class='rqm-delete' title='"
          + I18n.t("buttons.edit") + "'><i class='fa fa-remove'></i></a>\
          </div></li>");
        update_index_requirement()
      },
      error: function(data) {
        flash_now('alert-error', I18n.t("projects.create_requirement.fail"));
      }
    });
    e.preventDefault();
  });

  $('.list-requirement').on('keypress', '.requirement-item input', function (e) {
    if (e.which == 13) {
      if ($(this).closest('ul').find('li:first-child').data('parent-prj')) {
        $('.new-rqm-save').click();
      }
      $('#new-rqm').click();
      return false;
    }
  });

});

function active_li(li_tag) {
  $that = li_tag;
  $that.parent().find('li').removeClass('active');
  $that.addClass('active');
  $('#new-rqm').prop('disabled', !$('.list-project li.active').length);
}

function flash_now(type, message) {
  var flash = "<div class='alert " + type + " fade in hide-flash'>\
    <a class='close' data-dismiss='alert' href='#' aria-hidden='true'>&times;</a>"
    + message + "</div>";
  $('.flash').html(flash);
}

function update_index_project() {
  $.each($('.list-project .list-group-item.project-item'), function(index, value) {
    $(value).find('.index').html(index + 1);
  });
  size = $('.list-project .list-group-item.project-item').length;
  $('#sumProject b').text(size);
}

function update_index_requirement() {
  $.each($('#list-rqms .list-group-item.requirement-item[type]'), function(index, value) {
    $(value).find('.index').html(index + 1);
  });
  size = $('#list-rqms .list-group-item.requirement-item[type]').length;
  $('#sumRequirement b').text(size);
}
