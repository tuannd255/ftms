$(document).on("turbolinks:load", function() {
  $("#tbl-role-allocate").DataTable({
    "dom": "<'row'<'col-sm-12'f>>" + "<'row'<'col-sm-12'tr>>",
    retrieve: true,
    "scrollY": "300px",
    "scrollCollapse": true,
    "paging": false,
    order: [1, "asc"],
    "columnDefs": [{"orderable": false, "targets": 0}],
    language: {
      search: "_INPUT_",
      searchPlaceholder: I18n.t("datatables.search_controller")
    }
  });
});
