class ExamPresenter < ActionView::Base
  include Rails.application.routes.url_helpers

  def initialize exams, namespace
    @exams = exams
    @namespace = namespace
  end

  def render
    sidebar = Array.new
    body = Array.new
    @exams.each_with_index do |exam, index|
      sidebar << sidebar_item(exam, index)
      body << body_item(exam, index)
    end
    html = "<aside id=\"parent\" class=\"fixedTable-sidebar\">
      <div id=\"child\">
        <div id=\"table-sidebar\">
          <div class=\"tbody listsort filter_table_left_part\" id=\"list-records\">"
    html += sidebar.join("")
    html += "</div></div></div></aside>"

    html += "<div class=\"fixedTable-body tabel-scroll\">
      <div class=\"tbody listsort filter_table_right_part\">"
    html += body.join("")
    html += "</div></div>"
  end

  private
  def sidebar_item exam, index
    "<div class=\"trow list_#{index}\" id=\"sidebar-row-#{exam.id}\">
      <div class=\"tcell stt\">#</div>
      <div class=\"tcell name trainee_name\" title=\"#{exam.user_name}\">
      #{link_to exam.user_name, eval("#{@namespace}_user_path(exam.trainee)")}
      </div>
    </div>"
  end

  def body_item exam, index
    html = "<div class=\"trow #{"list_#{index}" }\" id=\"body-row-#{exam.id}\">
      <div class=\"tcell subject_name\" title=\"#{exam.user_subject.subject_name}\">
        #{exam.user_subject.subject_name}
      </div>
      <div class=\"tcell course course_name\" title=\"#{exam.user_subject.course_name}\">
        #{link_to exam.user_subject.course_name,
          eval("#{@namespace}_course_path(exam.user_subject.course)")}
      </div>
      <div class=\"tcell created_at text-center\">
        #{l exam.created_at, format: :default}
      </div>
      <div class=\"tcell spent_time text-center\">
        #{exam.spent_time}
      </div>
      <div class=\"tcell score text-center\">
        #{exam.score}
      </div>
      <div class=\"tcell blank\"></div></div>"
  end
end
