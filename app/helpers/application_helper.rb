module ApplicationHelper
  # Allows for setting the background-color on the given tag in a view/layout.
  #
  # @param [Symbol] tag
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
