# == Schema Information
# Schema version: 20100608222653
#
# Table name: experiments
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  authour     :string(255)
#  description :text
#  published   :boolean(1)
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Experiment < ActiveRecord::Base
  attr_accessible :title, :authour, :description, :published
  has_many :steps  
end
