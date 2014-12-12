module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, :sort => column, :direction => direction
  end

  def next_page(page = 1, user_id = nil)
    #fill out this helper to navigate pages.
    if user_id.nil?
      link_to "Next", :page => page + 1
    else
      link_to "Next", :page => page + 1, :user_id => user_id
    end
  end

  def previous_page(page = 1, user_id = nil)
    #fill out this helper to navigate pages.
    if user_id.nil?
      link_to "Previous", :page => page - 1
    else
      link_to "Previous", :page => page - 1, :user_id => user_id
    end
  end
end
