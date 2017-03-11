class PostPresenter < ActionView::Base
  include Rails.application.routes.url_helpers

  def initialize args = {}
    @posts = args[:posts]
    @namespace = args[:namespace]
  end

  def render
    sidebar = Array.new
    body = Array.new
    @posts.each_with_index do |post, index|
      sidebar << sidebar_item(post, index)
      body << body_item(post, index)
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
  def sidebar_item post, index
    "<div class=\"trow list_#{index}\" id=\"sidebar-row-#{index}\">
      <div class=\"tcell stt\">#</div>
      <div class=\"tcell trainee_name \">
        #{link_to post.user.name, eval("#{@namespace}_user_path(post.user)")}
      </div>
      <div class=\"tcell post_title \">
        #{link_to post.title, eval("#{@namespace}_post_path(post)")}
      </div>
    </div>"
  end

  def body_item post, index
    html = "<div class=\"trow #{"list_#{index}"}\" id=\"body-row-#{post.id}\">
      <div class=\"tcell post_content \"title=\"#{strip_tags post.content}\">
        #{strip_tags post.content}
      </div>
      <div class=\"tcell post_date \"title=\"#{post.created_at}\">
        #{l post.created_at, format: :default if post.created_at}
      </div>
      <div class=\"tcell tag \"title=\"#{post.created_at}\">"
    tags = ""
    post.tag_list.each do |tag|
      tags << "#{link_to tag, eval("#{@namespace}_tag_path(tag)"), class: "tag"}, "
    end
    html << tags.chomp(", ")
    html << "</div></div>"
  end
end
