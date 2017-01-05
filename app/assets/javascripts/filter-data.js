var check_content;
var rows_buffer = Array();
$(document).on("ready, turbolinks:load", function(){
  loading_filter_row();
  filter_function();
});
var loading_filter_row = function(){
  rows_buffer = [];
  $(".filter_table_left_part .trow").each(function(index, element){
    rows_buffer.push({"left_part": $(element)});
  });
  $(".filter_table_right_part .trow").each(function(index, element){
    rows_buffer[index]["right_part"] = $(element);
  });
}

var reset_position_list = function(){
  $(".fixedTable-body").scrollLeft($(".fixedTable-header").scrollLeft());
}

var filter_function = function(){
  var list_filter_select = Object();
  var list_filter_range = Object();
  var list_filter_date = Object();
  var select = ".filter :input[type='checkbox']";
  var range = ".filter :input[type='number']";
  var date = ":input.date_input";

  var caretdownClass = "ic-filter";
  var filterClass = "ic-filtered";
  var filtersWrapper = $("#filter");

  if (filtersWrapper.length > 0) {
    var filter_type = filtersWrapper.data("type");
    var user_id = filtersWrapper.data("id");
    var target_id = filtersWrapper.data("target-id");
    var target_params = filtersWrapper.data("target-params");
    var filter_data = filtersWrapper.attr("data-filter-data");
    var data = Object();

    try {
      if (filter_data != "")
        data = JSON.parse(filter_data);

      if (data.list_filter_select != undefined) {
        list_filter_select = data.list_filter_select
      }

      if (data.list_filter_range != undefined) {
        list_filter_range = data.list_filter_range;
      }

      if (data.list_filter_date != undefined) {
        list_filter_date = data.list_filter_date;
      }
    } catch (e) {
      console.log('Parse ------->' + e);
    }
  }

  var btnFilterOnOff = $("#btn-filter-on-off");
  var isFilterTurnOn = filtersWrapper.data("is-turn-on");
  var $trow = $(".trow");

  var update_ui_range_date = function(type, list_filter) {
    var check;
    $(type).each(function() {
      $(this).val("");
      var name = $(this).attr("name").toLowerCase();
      var nameFilter = Object.keys(list_filter).indexOf(name);

      if(nameFilter !== -1) {
        if(check !== name) {
          $(this).val(list_filter[name][0]);
        }else{
          $(this).val(list_filter[name][1]);
        }
        check = name;
      }
    });
  };

  var applyFilter = function() {
    var elems = [list_filter_select, list_filter_range, list_filter_date];

    var filter_columns_data = [];

    for(var column_name in list_filter_select) {
      var data = list_filter_select[column_name];
      var column_filter = {"columnName": column_name, "params": {"select": data}};
      filter_columns_data.push(column_filter);
    }

    for(var column_name in list_filter_range) {
      var data = list_filter_range[column_name];
      var column_filter = {"columnName": column_name, "params": {"range": {start: data[0], end: data[1] }}};
      filter_columns_data.push(column_filter);
    }

    console.log("Fillter on columns");
    console.log(filter_columns_data);

    rows_buffer.forEach(function(row) {
      var hide_condition = false;

      for(var index in filter_columns_data) {
        var column = filter_columns_data[index]
        var cell_element;

        for(var row_child in row){
         cell_element = row[row_child].children("." + column.columnName);
         if (cell_element.length != 0) break;
        }

        var not_found_column = (cell_element.length == 0);
        if (not_found_column) continue;

        var cell_value = $.trim(cell_element.text());
        cell_value = cell_value.toLowerCase();

        if (column.params.hasOwnProperty('select')) {
          if (column.columnName == 'program') {
            var cell_parent = cell_element.data('parent_program');
            var list = column.params.select;
            var hide_program = [];

            if (list.length > 0) {
              for(var i = 0; i < list.length; i++) {
                hide_program += cell_parent.indexOf(list[i]) == -1;
              }
              hide_condition = hide_program.indexOf('false') == -1;
            }
          }
          if (hide_condition) {break;};
        }

        if (column.params.hasOwnProperty('select')) {
          var list = column.params.select;

          if (column.columnName == 'course_trainers') {
            hide_condition = ($(list).filter(cell_value.split(", ")).length == 0);
          } else if (column.columnName != 'program') {
            hide_condition = (list.indexOf(cell_value) == -1);
          }
          if (hide_condition) {break;};
        }

        if (column.params.hasOwnProperty('range')) {
          var range_values = column.params.range;
          var start_parse = parseFloat( range_values.start );
          var end_parse = parseFloat( range_values.end );

          if ( isNaN(start_parse) || isNaN(end_parse) ) {

          } else {
            var start = Math.min(start_parse, end_parse);
            var end = Math.max(start_parse, end_parse);

            cell_value = cell_value.replace(',', '');
            hide_condition = (parseFloat(cell_value) < start || parseFloat(cell_value) > end);
            if (hide_condition) {break;};
          }
        }

        if (column.params.hasOwnProperty('blank')) {
          var blank_condition = column.params.blank;
          hide_condition = !(blank_condition == (cell_value == ""))
          if (hide_condition) {break;};
        }
      };
      for(var row_child in row){
        if (hide_condition) {
          row[row_child].addClass('hide');
        } else {
          row[row_child].removeClass('hide');
        }
      }
    });
  };


  var after_filter = function() {
    update_number_row_records();
    load_tables();

    if($("#projects").find(".list-employee").length > 0) {
      reload_sum_assignee();
    }
    resetOrder();
    totalTraineeValue();
    changeIconFilter();
  };


  var hide_filters = function() {
    $(".ic-filter, .ic-filtered").addClass("ic-filter-off");
  };

  var show_filters = function() {
    $(".ic-filter, .ic-filtered").removeClass("ic-filter-off");
  };

  var reload_filter = function() {
    if (data == undefined) return;
    applyFilter();

    update_ui_select(select, list_filter_select);
    update_ui_range_date(range, list_filter_range);
    update_ui_range_date(date, list_filter_date);

    after_filter();
  };

  var remove_filter_and_reload_order = function() {
    $trow.removeClass('hide');
    after_filter();
    hide_filters();
  };

  function changeIconFilter() {
    var columns = [];

    if (list_filter_select != undefined) {
      $.each(list_filter_select, function(key, value) {
        if (key != undefined) {
          columns.push(key);
        }
      });
    }

    $(".ic-filter, .ic-filtered").each(function() {
      var filter_icon = $( this );
      var found_class = false;
      for ( var i in columns )
      {
        if (filter_icon.hasClass(columns[i]))
        {
          found_class = true;
          break;
        }
      }

      if (found_class) {
        filter_icon.removeClass("ic-filter").addClass("ic-filtered");
      } else {
        filter_icon.removeClass("ic-filtered").addClass("ic-filter");
      }
    });
  }

  if(filtersWrapper.length > 0 && data !== null && data !== "") {
    reload_filter();
  } else {
    if(!isFilterTurnOn){
      hide_filters();
    }
  }

  if(typeof isFilterTurnOn !== "undefined"){
    $("#change-color").prop("disabled", !isFilterTurnOn);
    if (isFilterTurnOn) {
      btnFilterOnOff.addClass("btn-filter-on");
    } else {
      btnFilterOnOff.addClass("btn-filter-off");
      remove_filter_and_reload_order();
    }
  } else {
    show_filters();
  }
  $(document).off("click", "#btn-filter-on-off");
  $(document).on("click", "#btn-filter-on-off", function(event) {
    var filterLoading = $("#filter-loading");
    event.preventDefault();
    if(isFilterTurnOn) {
      filterLoading.text(I18n.t("filters.loading"));
      btnFilterOnOff.toggleClass("btn-filter-off btn-filter-on");
      remove_filter_and_reload_order();
      btnFilterOnOff.attr("title", I18n.t("filters.btn_on"));
      filterLoading.text("");
    } else {
      btnFilterOnOff.toggleClass("btn-filter-on btn-filter-off");
      if (data !== ""){
        filterLoading.text(I18n.t("filters.loading"));
        reload_filter();
        show_filters();
        resetOrder();
        btnFilterOnOff.attr("title", I18n.t("filters.btn_off"));
        filterLoading.text("");
      } else {
        location.reload();
      }
    }

    $("#change-color").prop("disabled", isFilterTurnOn);

    isFilterTurnOn = !isFilterTurnOn;
    $.ajax({
      type: "POST",
      url: "/filter_datas",
      data: ({filter: {filter_type: filter_type, user_id: user_id, is_turn_on: isFilterTurnOn,
        target_id: target_id, target_params: JSON.stringify(target_params) }}),
      dataType: "json",
      success: function(msg) {
      },
      error: function(msg) {
      }
    });
  });

  $(".filter-form").off("click", ".button-filters");
  $(".filter-form").on("click", ".button-filters", function(event) {
    event.preventDefault();
    filterClickListener(event);
    reset_position_list();
  });

  var filterClickListener = function(event) {
    var statisticsContent = $('#statistics-content');

    var saveFilterData = function() {
      var content = Object();
      content["list_filter_select"] = list_filter_select;
      content["list_filter_range"] = list_filter_range;
      content["list_filter_date"] = list_filter_date;
      data = content;
      content = JSON.stringify(content);

      filtersWrapper.attr("data-filter-data", content);

      if(check_content !== content) {
        check_content = content;
        $.ajax({
          type: "POST",
          url: "/filter_datas",
          data: ({filter: {filter_type: filter_type, content: content, user_id: user_id,
            target_id: target_id, is_turn_on: isFilterTurnOn,
            target_params: JSON.stringify(target_params)}}),
          dataType: "json",
          success: function(msg) {
          },
          error: function(msg) {
          }
        });
      }
    };

    function extend(obj, src) {
        Object.keys(src).forEach(function(key) { obj[key] = src[key]; });
        return obj;
    }

    list_filter_select = extend(list_filter_select, getParamsFilter(select));

    for (var key in list_filter_select) {
      if (list_filter_select[key] == 'ALL'){
        delete list_filter_select[key];
      }
    }

    applyFilter();
    after_filter();
    if (statisticsContent.length == 0) {
      saveFilterData();
    }
    show_blank_option();
  };

  $(document).on('click', '.button-cancel', function() {
    $("div.filters:visible").hide('fast', function() {
      $(this).parents('.filters').find('.search_filter').each(function () {
        this.value = '';
        intSearcher();

        update_ui_select(select, list_filter_select);
        update_ui_range_date(range, list_filter_range);
        update_ui_range_date(date, list_filter_date);
      });
    });
  });

  $(document).on("click", ".sortable", function(event) {
    event.preventDefault();
    var name = $(this).data("name");
    var type = $(this).data("value");
    var listsWrapper = $(".listsort");
    var listitems =  listsWrapper.find("." + name + ":visible");
    var parent_list = listitems.first().parent().parent();
    var lastRow = $(".sum-assignee-value");
    lastRow.remove();

    listitems.sort(function (a, b) {
      var valA = $(a).text().toUpperCase().replace(/,/g, "").trim();
      var valB = $(b).text().toUpperCase().replace(/,/g, "").trim();

      var sort_type = (type ==="asc") ? 1 : -1;
      var value_compare = $.isNumeric(valA) && $.isNumeric(valB) ? valA - valB : valA.localeCompare(valB);
      value_compare *= sort_type;
      if (value_compare == 0) {
        var index_compare = a.offsetTop - b.offsetTop;
        return index_compare;
      } else {
        return value_compare;
      }
    });

    $.each(listitems, function(index, item) {
      $(this).parent().parent().append($(item).parent("div"));
    });

    var sort_index_list = jQuery.makeArray();
    $.each(parent_list.children("div"), function(index, value ) {
      sort_index_list.push($(value).attr("class").split(" ")[1]);
    });

    $.each(listsWrapper, function(index, list) {
      var temp = list;
      $.each(sort_index_list, function(index, item) {
        var test = $(temp).children("." + item)[0];
        $(list).append(test);
      });
    });
    resetOrder();
    loadSalaryHistory();
    listsWrapper.append(lastRow);
  });
}

var update_number_row_records = function(){
  $("#number-records").text($(".filter_table_left_part").find(".trow:visible").not('.sum-assignee-value').length + " records");
};

var getParamsFilter = function(type) {
  var list_params_filter = Object();
  var name;
  var select_all = true;
  $(type).each(function() {
    name = $(this).attr('name').toLowerCase();
    var value = $(this).val().toLowerCase();

    if ($(this).is(':checked')) {
      if(Object.keys(list_params_filter).indexOf(name) === -1) {
        list_params_filter[name] = [value];
      } else {
        list_params_filter[name].push(value);
      }
    } else {
      select_all = false;
    }
  });

  if (!list_params_filter.hasOwnProperty(name) ) {
    list_params_filter[name]= [];
  }
  if (select_all && name != undefined) {
    list_params_filter[name]= 'ALL';
  }
  return list_params_filter
};

var update_ui_select = function(select, list_filter_select) {
  $(select).each(function() {
    $(this).prop("checked", false);
    var value = $(this).val().toLowerCase();
    var name = $(this).attr("name").toLowerCase();
    if(Object.keys(list_filter_select).indexOf(name) !== -1 &&
      $.inArray(value, list_filter_select[name]) !== -1) {
      $(this).prop("checked", true);
    }
  });
};

var reload_sum_assignee = function() {
  var column = ["price", "billing", "discount", "accounting"]
  for(var i = 0; i < column.length; i++) {
    var sum = 0;
    list_record = $(".listsort").find("." + column[i] + ":visible");

    $.each(list_record, function(){
      sum += parseInt($(this).text().replace(/,/g, ""));
    });
    $(".sum-" + column[i]).html($.number(sum));
  }
  $(".list-employee .assigned_employees .listsort").append($(".sum-assignee-value"));
};

var reload_filter_project_assignee = function() {
  var select = ".filter :input[type='checkbox']";
  var column = ["uid", "name", "category"];
  var list_filter_select = getParamsFilter(".filter input:checked");
  var element;
  var $listEmployeeOption = $(".list-employee .add-option .option");

  for(var i = 0; i < column.length; i++) {
    var list = [];
    var options = $(".f-" + column[i] + " .options").empty();
    list_record = $(".listsort").find("." + column[i]);
    $.each(list_record, function(){
      element = $.trim($(this).text());
      if($.inArray(element, list) == -1) {
        list.push(element);
      }
    });

    $.each(list, function(key, value){
      var option = $listEmployeeOption.clone();
      option.find("input").attr({name: column[i], id: "filter_" + column[i] + "_" + key, value: value});
      if (value == ""){
        option.find("label").html(I18n.t("employees.show.blank")).attr({for: "filter_" + column[i] + "_" + key})
      } else {
        option.find("label").html(value).attr({for: "filter_" + column[i] + "_" + key})
      }
      options.append(option);
    });
  }
  update_ui_select(select, list_filter_select);
};

$(document).keyup(function(e) {
  if (e.keyCode == 27) {
    $(".filters").hide();
    $(".datepicker-orient-top").hide();
  }
});
