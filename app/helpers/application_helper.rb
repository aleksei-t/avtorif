# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def pages
    controllers = Dir.new("#{RAILS_ROOT}/app/controllers").entries.sort
    cont = Array.[]
      controllers.each do |controller|
      if controller =~ /_controller/ && !(controller =~ /application/)
        cont << link_to(controller.camelize.gsub("Controller.rb",""), :controller => controller.camelize.gsub("Controller.rb","").tableize) + " " 
      end
    end
    return cont
  end

end