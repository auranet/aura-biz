# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  # For PDF output.
  def pdf_image_tag(image, options = {})
    options[:src] = File.expand_path(RAILS_ROOT) + '/public/images/' + image 
    tag(:img, options)
  end


end
