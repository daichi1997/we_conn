module Wicked::Wizard
  module Controller
    def redirect_to_finish_wizard(options = nil)
      redirect_to finish_wizard_path(options)
    end
  end
end