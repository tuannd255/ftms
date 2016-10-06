var open_select_event_target;

$(document).on("page:change", function () {
  validateFilterRank();
  intSearcher();
  resetOrder();
  show_blank_option();
});

$(document).on("page:load", function(){
  resetOrder();
  show_blank_option();
});

$(window).on("resize", function(){
  updateFilterPosition();
});

$(document).on("click", ".filters .filter_actions a", function () {
  var val = $(this).hasClass("filter_select");
  var filtersWrapper = $(this).parents(".filters");
  filtersWrapper.find("input[type=checkbox]:visible").each(function () {
    if(!$(this).is(":disabled")){
      this.checked = val;
    }
  });

  filtersWrapper.find("input[type=number]").each(function () {
    this.value = "";
  });

  filtersWrapper.find("input[type=text]:not(.search_filter)").each(function () {
    this.value = "";
    intSearcher();
  });

  filtersWrapper.find(".datepicker").each(function () {
    this.value = "";
  });

  show_blank_option();
});

$(document).on('click', '.open-select', function (event) {
  event.preventDefault();
  open_select_event_target = event.target;
  toggleFilterMenu($(this), false);
});

function validateFilterRank() {
  $(".rank_filter_field").change(function() {
    var max = $(this).attr("max");
    var min = $(this).attr("min");
    var current_value = parseFloat($(this).val());
    if(current_value > max)
      current_value = max;
    if(current_value < min)
      current_value = min;
    $(this).val(current_value);
  });
}

function quick_search_manager(inputElement, search_path, loading_path, selector) {
  selector = selector || "label";
  inputElement.quicksearch(search_path, {
    "delay": 100,
    "selector": selector,
    "bind": "keyup",
    "loader": loading_path,
    prepareQuery: function (val) {
      val = val.replace(',', '');
      return val.toLowerCase().split(' ');
    },
    testQuery: function (query, txt, _row) {
      for (var i = 0; i < query.length; i += 1) {
        txt = txt.replace(',', '');
        if (txt.indexOf(query[i]) === -1) {
          return false;
        }
      }
      return true;
    }
  });
}

function toggleFilterMenu(element, resize) {
  var filterName = element.data("name");
  var $filterDom = $("." + filterName);

  if ($filterDom.length == 0) return;

  var _left, _top;
  var windowWidth = $(window).width();
  var filterDomWidth = $filterDom.outerWidth();

  var filterClass = "filters";
  var rightArowClass = "filter-right-arow";

  $("." + filterClass).not($filterDom).hide();

  var fa = element.find(".fa");
  if (fa.offset().left + filterDomWidth > windowWidth) {
    $filterDom.addClass(rightArowClass);
    _left = fa.offset().left - filterDomWidth + 24;
  } else {
    $filterDom.removeClass(rightArowClass);
    _left = fa.offset().left - 12;
  }

  _top = fa.offset().top + fa.outerHeight();

  $filterDom.css({"top": _top, "left": _left});

  if (!resize) {
    $filterDom.toggle();
    loadDataFilter(open_select_event_target);
  }

  if ($("div.filters").is(":visible")) {
    $("input#manager-search").focus();
    $("input.date_input:visible").focus();
    $("input.rank_filter_field:visible").focus();
    $("input.search_filter:visible").focus();
  }
}

function updateFilterPosition() {
  var $filterVisible = $(".filters:visible");
  if ($filterVisible.length > 0) {
    toggleFilterMenu($('.open-select[data-name="f-' + $filterVisible.data("parent") + '"]'), true);
  }
}

function intSearcher(){
  $("div.filters").each(function(){
    var parent_name = $(this).data("parent");
    var month = $(this).data("month") || "";
    if (month != "") {
      parent_name += "_" + month;
    }
    var $inputElement = $("input#manager-search-" + parent_name);
    var search_path = ".f-" + parent_name + " .options .option";
    quick_search_manager($inputElement, search_path, "label.quick-searching");
  });
}

function loadDataFilter(target) {
  var filter_data = $("#filter").attr("data-filter-data");
  var list_select;
  var list_range;
  var list_date;

  data_name = $(target).parent().data('name');
  data_parent = $('.' + data_name).data('column');
  checkbox_type = '.filter :input[type="checkbox"]';

  try {
    if (filter_data != '') {
      data = JSON.parse(filter_data);
    }

    if (data.list_filter_select != undefined) {
      list_select = data.list_filter_select[data_parent];
    }

    if (data.list_filter_range != undefined) {
      list_range = data.list_filter_range[data_parent];
    }

    if (data.list_filter_date != undefined) {
      list_date = data.list_filter_date[data_parent];
    }
  } catch (e) {
    console.log('Parse ------->' + e);
  }



  name_list_resourse = $.map($(checkbox_type), function(item){
    return $(item).val();
  });

  var rows_buffer = Array();
  var list_visible_row = Array();

  $('.filter_table_left_part .trow').each(function(index, element){
    rows_buffer.push({'left_part': $(element)});
  });
  $('.filter_table_right_part .trow').each(function(index, element){
    rows_buffer[index]['right_part'] = $(element);
  });

  rows_buffer.forEach(function(row) {
    var row_is_visible = false;
    var cell_element;
    var cell_value;
    for(var row_child in row){
      cell_element = row[row_child].children("." + data_parent);
      if (cell_element.length != 0){
        if (!row[row_child].hasClass('hide')) {
          cell_value = $.trim(cell_element.text());
          cell_value = cell_value.toLowerCase();
          row_is_visible = true;
        }
        break;
      }
    }

    if(row_is_visible) {
      list_visible_row.push(cell_value);
    }
  });

  if (list_visible_row != undefined) {
    $.each($(checkbox_type), function(index, item) {
      var value = $(item).val().toLowerCase();
      if ($.inArray(value, list_visible_row) != -1){
        $(item).prop('checked', true);
      } else {
        $(item).prop('checked', false);
      }
    });
  }

  if (list_range != undefined) {
    $(".filter #min_value").val(list_range[0]);
    $(".filter #max_value").val(list_range[1]);
  }

  if (list_date != undefined) {
    $(".filter .start_date").val(list_date[0]);
    $(".filter .end_date").val(list_date[1]);
  }
}
