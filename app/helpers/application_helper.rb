module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def next_page(title = nil)
    #fill out this helper to navigate pages.
    link_name = "Next"
    if title.nil?
      link_to link_name, :page => params[:page].to_i + 1
    elsif title == "games"
      link_to link_name, :page => params[:page].to_i + 1, :user_id => params[:user_id].to_i
    elsif title == "topics"
      link_to link_name, :page => params[:page].to_i + 1, :forum_id => params[:forum_id].to_i
    elsif title == "comments"
      link_to link_name, :page => params[:page].to_i + 1
    elsif title == "users"
      "user"
    else
      "Next"
    end
  end

  def previous_page(title = nil)
    link_name = "Previous"
    if title.nil?
      link_to link_name, :page => params[:page].to_i - 1
    elsif title == "games"
      link_to link_name, :page => params[:page].to_i - 1, :user_id => params[:user_id].to_i
    elsif title == "topics"
      link_to link_name, :page => params[:page].to_i - 1, :forum_id => params[:forum_id].to_i
    elsif title == "comments"
      link_to link_name, :page => params[:page].to_i - 1
    elsif title == "users"
      "user"
    else
      "Previous"
    end
  end
end
