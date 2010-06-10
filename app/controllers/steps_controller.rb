class StepsController < ApplicationController
  before_filter :get_event


  def get_event
    @experiment = Experiment.find(params[:experiment_id])
  end

  # GET /steps
  # GET /steps.xml
  def index
    @steps = @experiment.steps.all( :order => "step_order" )

   
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.xml
  def show
    @step = @experiment.steps.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.xml
  def new
    @step = @experiment.steps.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = @experiment.steps.find(params[:id])
  end

  # POST /steps
  # POST /steps.xml
  def create
    # check to see if this experiment has any steps already
    i = 1  # if it doen't this is step one
    unless @experiment.steps.empty? 
      # if it does, this increment the step by one
      i = @experiment.steps.last( :order => 'step_order' ).step_order + 1
    end

    @step = @experiment.steps.new(params[:step])
    @step.step_order = i 
    
    respond_to do |format|
      if @step.save
        flash[:notice] = 'Step was successfully created.'
        format.html { redirect_to([ @experiment, @step ]) }
        format.xml  { render :xml => @step, :status => :created, :location =>[ @experiment, @step ]}
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.xml
  def update
    @step = @experiment.steps.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        flash[:notice] = 'Step was successfully updated.'
        format.html { redirect_to([ @experiment, @step ]) }
        #format.xml  { head :ok }
	format.xml  { render :xml => @step }
	ActiveRecord::Base.include_root_in_json = false
	format.js { render :json => @step }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @step.errors, :status => :unprocessable_entity }
      end
   end
  end
  
  # action for reordering steps
  def up
    #move up the list	  
    @step = @experiment.steps.find(params[:id])
    
    #get current order of step
    i = @step.step_order
    save = false

    unless i == 1 
      # increment the order of the previous step
      other_step = @experiment.steps.find_by_step_order(i - 1)    
      other_step.step_order = i
      @step.step_order = i - 1
      save = true
     
    end
    respond_to do |format|
         if save && other_step.save && @step.save
	     flash[:notice] = 'Order updated'
	     format.html { redirect_to experiment_steps_path(@experiment) }
         else
	     flash[:notice] = 'The step could not be reordered'
             format.html { redirect_to experiment_steps_path(@experiment) }

         end
       end  
  end

  def down
    # move step down the list	  
    @step = @experiment.steps.find(params[:id])
    
    # get current order of step
    i = @step.step_order
    save = false
    unless i == @experiment.steps.length 
      # decrement the order of the following step
      other_step = @experiment.steps.find_by_step_order(i + 1)
      other_step.step_order = i
      @step.step_order = i + 1
      save = true
    end
    respond_to do |format|
      if save && other_step.save && @step.save
         flash[:notice] = 'Order updated'
         format.html { redirect_to experiment_steps_path(@experiment) }
      else
         flash[:notice] = 'The step could not be reordered'
         format.html { redirect_to experiment_steps_path(@experiment) }
       end
    end 
  end

  # action for uploading images to a step
  require 'fileutils'
  def upload
    @step = @experiment.steps.find(params[:id])
    
    unless @step.image.blank?
	 @step.image.destroy
    end
    @image = Image.create(:step_id => @step, :image_file => params[:file])

    
    if @image.save 
	#params[:file].original_filename
    	@step.image = @image 
    	redirect_to([@experiment,@step])
    else
	    flash[:notice] = 'your photo did not save!'
	    render :action => 'new'
    end
  end
  
  
  
  # DELETE /steps/1
  # DELETE /steps/1.xml
  def destroy
    @step = @experiment.steps.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to(experiment_steps_url( @experiment )) }
      format.xml  { head :ok }
    end
  end
end
