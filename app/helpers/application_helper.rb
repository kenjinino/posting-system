module ApplicationHelper

  def highlight_keyword(hit, field)
    highlight = hit.highlight(field)
    if highlight
      highlight.format { |fragment| content_tag(:strong, fragment) }
    else
      hit.result.try(field)
    end
  end

end
