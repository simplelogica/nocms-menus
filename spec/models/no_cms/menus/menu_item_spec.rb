require 'spec_helper'

describe NoCms::Menus::Menu do

  it_behaves_like "model with required attributes", :no_cms_menus_menu, [:name]

end
