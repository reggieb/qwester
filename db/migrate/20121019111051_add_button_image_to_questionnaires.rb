require 'paperclip'
ActiveRecord::ConnectionAdapters::AbstractAdapter.send :include, Paperclip::Schema::Statements
class AddButtonImageToQuestionnaires < ActiveRecord::Migration
  def change
    add_attachment :qwester_questionnaires, :button_image
  end
end
