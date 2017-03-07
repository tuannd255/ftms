class EvaluationTemplatePresenter < ActionView::Base
  include Rails.application.routes.url_helpers

  def initialize args
    @evaluation_templates = args[:evaluation_templates]
    @namespace = args[:namespace]
  end

  def render
    sidebar = Array.new
    body = Array.new
    @evaluation_templates.each_with_index do |evaluation_template, index|
      sidebar << sidebar_item(evaluation_template, index)
      body << body_item(evaluation_template, index)
    end
    html = "<aside id=\"parent\" class=\"fixedTable-sidebar\">
      <div id=\"child\">
        <div id=\"table-sidebar\">
          <div class=\"tbody listsort filter_table_left_part\" id=\"list-records\">
    "
    html += sidebar.join("")
    html += "</div></div></div></aside>"

    html += "<div class=\"fixedTable-body tabel-scroll\">
      <div class=\"tbody listsort filter_table_right_part\">"
    html += body.join("")
    html += "</div></div>"
  end

  private
  def sidebar_item evaluation_template, index
    "<div class=\"trow list_#{index}\" id=\"sidebar-row-#{evaluation_template.id}\">
      <div class=\"tcell stt\">#</div>
      <div class=\"tcell evaluation_template_name\" title=\"
        #{evaluation_template.name}\">
        #{evaluation_template.name}
      </div>
    </div>
    "
  end

  def body_item evaluation_template, index
    html = "
    <div class=\"trow #{"list_#{index}" }\" id=\"body-row-#{evaluation_template.id}\">
      <div class=\"tcell action-edit\">
        #{link_to t("buttons.edit"),
          eval("edit_#{@namespace}_evaluation_template_path(evaluation_template)")}
      </div>
      <div class=\"tcell blank\"></div>
    </div>"
  end
end
