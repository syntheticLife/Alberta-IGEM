# == Schema Information
# Schema version: 20101030224800
#
# Table name: messages
#
#  id         :integer(4)      not null, primary key
#  group_id   :integer(4)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Message < ActiveRecord::Base
	belongs_to :group
end
