class TraineeProgressPresenter < ActionView::Base
  include Rails.application.routes.url_helpers
  include ApplicationHelper

  def initialize trainee_by_course
    @trainee_by_course = trainee_by_course
  end

  def render
    sidebar = Array.new
    body = Array.new
    @trainee_by_course.each_with_index do |trainee, index|
      sidebar << sidebar_item(trainee, index)
      body << body_item(trainee, index)
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
  def sidebar_item trainee, index
    html = "<div class=\"trow list_#{index}\" id=\"sidebar-row-#{index}\">
      <div class=\"tcell stt\">#</div>
      <div class=\"tcell staff_code\" title=\"#{trainee.profile.staff_code}\">
        #{trainee.profile.staff_code}
      </div>
      <div class=\"tcell trainee_name\" title=\"#{trainee.name}\">
        #{link_to trainee.name, admin_user_path(trainee)}
      </div>
    </div>"
  end

  def body_item trainee, index
    last_course = trainee.trainee_courses.find {|trainee_course| trainee_course.progress?}
    html = "<div class=\"trow #{"list_#{index}"}\" id=\"body-row-#{trainee.id}\">"
    courses_html = ""
    if last_course
      last_course.user_subjects.each do |user_subject|
        if user_subject.init?
          courses_html << "<div class=\"prog-bar-bg-init\">
            #{user_subject.name}(#{I18n.t "user_subjects.statuses.#{user_subject.status}"})
          </div>"
        else
          courses_html << if user_subject.finish?
            "<div class=\"prog-bar-bg-finish\">"
          elsif user_subject.waiting?
            "<div class=\"prog-bar-bg-waiting\">"
          else
            "<div class=\"prog-bar-bg-processing\">"
          end
          courses_html << "#{user_subject.name}(#{percentage_format user_subject.percent_progress} #{I18n.t "user_subjects.statuses.#{user_subject.status}"})
            </div>"
        end
      end
    else
    courses_html << "<div class=\"prog-bar-bg-empty\">
      #{I18n.t "user_subjects.empty"}
    </div>"
    end
    html << "<div class=\"tcell trainee_type\" title=\"#{trainee.profile.trainee_type_name}\">
        #{trainee.profile.trainee_type_name}
      </div>
      <div class=\"tcell location\" title=\"#{trainee.profile.location_name}\">
        #{trainee.profile.location_name}
      </div>
      <div class=\"tcell trainee_status\" title=\"#{trainee.profile.status_name}\">
        #{trainee.profile.status_name}
      </div>
      <div class=\"tcell course_name\" title=\"#{last_course ? last_course.course_name : ""}\">
        #{last_course ? (link_to last_course.course_name, admin_course_path(last_course.course)) :
          "<span></span>"}
      </div>
      <div class=\"tcell course\">
        #{courses_html}
      </div>
    </div>"
  end
end
