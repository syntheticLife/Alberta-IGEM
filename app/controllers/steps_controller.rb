class StepsController < ApplicationController
  before_filter :get_event

  def get_event
    @experiment = Experiment.find(params[:experiment_id])
  end

  # GET /steps
  # GET /steps.xml
  def index
    #@steps = @experiment.steps.all( :order => "order" )
    #@steps = @experiment.steps.find( :all )
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
    @step = @experiment.steps.new(params[:step])

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
	#format.js { render :partial => 'experiment/step', :layout => false and return  } 
        format.html { redirect_to([ @experiment, @step ]) }
	#format.html { render :text => @step.description }
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

  require 'fileutils'
  def upload
    @step = @experiment.steps.find(params[:id])
    #@image = ImageFile.new
    @image = ImageFile.save(params[:file])
    @step.image = @image 

#    respond_to do |format|
#        format.js {} 
#    end
#    ImageFile.save(params[:upload])
    render :text => "File has been uploaded succesfully"
  end

  # make a path that will send image data for an image
  def image
    @step = @experiment.steps.find(params[:id])
    if @image = ImageFile.find_by_file_name(@step.image)
      send_data(
        @image.file_data, 
        :type => @image.content_type,
        :filename => @image.file_name,
        :disposition => 'inline'
      )
    else
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
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
