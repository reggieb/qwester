# This migration comes from qwester (originally 20121019111051)
require 'paperclip'
ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Paperclip::Schema::Statements
class AddButtonImageToQuestionnaires < ActiveRecord::Migration
  def change
    add_attachment :qwester_questionnaires, :button_image
  end
end
