module ApplicationHelper
  def tag_with_color(tag)
    capture_haml do
      if @background_color.nil?
        haml_tag tag do
          yield
        end
      else
        haml_tag tag, { style: "background-color: #{@background_color}" } do
          yield
        end
      end
    end
  end
end
