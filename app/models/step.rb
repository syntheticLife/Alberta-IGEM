# == Schema Information
# Schema version: 20100609172527
#
# Table name: steps
#
#  id            :integer(4)      not null, primary key
#  description   :text
#  title         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  experiment_id :integer(4)
#  step_order    :integer(4)
#  autogenerated :boolean(1)
#

class Step < ActiveRecord::Base
  attr_accessible :title, :description, :image, :experiment_id,
                  :step_order, :autogenerated
  belongs_to :experiment
  has_one :image

  before_destroy :decrement_following_steps 
  after_create :set_step_order

  # move_up step in list (switch with preceding step)
  def move_up
    #get current order of step
    i = self.step_order
    saved = false
    experiment = self.experiment

    unless i == 1 
      # increment the order of the previous step
      other_step = experiment.steps.find_by_step_order(i - 1)    
      other_step.step_order = i
      self.step_order = i - 1
    
      saved = self.save && other_step.save
    end
    return saved
  end

  # move_down step in list (switch with following step)
   def move_down
    #get current order of step
    i = self.step_order
    saved = false
    experiment = self.experiment

    unless i == 1 
      # increment the order of the previous step
      other_step = experiment.steps.find_by_step_order(i + 1)    
      other_step.step_order = i
      self.step_order = i + 1
    
      saved = self.save && other_step.save
    end
    return saved
  end 
  
  # insert step
  def insert_new(position)
    experiment = self.experiment
    i = self.step_order
    if position == 'after'
      i = i + 1
    end
    
    # make new step
    new_step = experiment.steps.create
    
    
    n = experiment.steps.length
    unless n  == 1 
       # increment all the steps after
       
       steps_after = experiment.steps.find_all_by_step_order( i..n )
       steps_after.each do |s|
         s.step_order = s.step_order + 1
	 s.save
       end
    end
    new_step.title = "inserted step"    
    new_step.step_order = i
    new_step.save

  end  
  

  private
 

  def decrement_following_steps
    experiment = self.experiment
    # check for other steps in the experiment
    n = experiment.steps.length
    unless n  == 1 
       # decrement all the steps after
       i = self.step_order + 1
       steps_after = experiment.steps.find_all_by_step_order( i..n )
       steps_after.each do |s|
         s.step_order = s.step_order - 1
	 s.save
       end
    end    
  end
  
  def set_step_order
    # sets the step_order to be the last in the list 
    self.step_order = self.experiment.steps.length 
    self.save
  end
end

