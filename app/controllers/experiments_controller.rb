class ExperimentsController < ApplicationController
  
  before_filter :login_required, :except => [:index, :show]
  before_filter :owns_experiment?, :except => [:index, :show, :clone, :new, :create ]

  # action for displaying print template
  def print
    @experiment = Experiment.find(params[:id])
    @steps = @experiment.steps
    
    # renders the print template without the normal layout
    render :layout => false;
  end
      
  # GET /experiments
  # GET /experiments.xml
    def index
    #TODO only the admin experiments here, the users experiments listed on profile
     @experiments = Experiment.all
   # @experiments = current_user.experiments

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.xml
  def show
    @experiment = Experiment.find(params[:id])
    @steps = @experiment.steps.all(:order => :step_order)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @experiment }
    end
  end 

  # GET /experiments/new
  # GET /experiments/new.xml
  def new
    @experiment = Experiment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @experiment }
    end
  end

  # GET /experiments/1/edit
  def edit
   # @experiment = Experiment.find(params[:id])
  end

  # GET /experiments/add_step/1
  def add_step
   # @experiment = Experiment.find(params[:id])
    @step = Step.create(:experiment_id => @experiment)
    

    render 'steps/edit'

  end


  # POST /experiments
  # POST /experiments.xml
  def create
    # must pass user_id information since session id is not available 
    # in the model
    merged_params = params[:experiment].merge({ :user_id => current_user.id })
    @experiment = Experiment.new( merged_params  )

    respond_to do |format|
      if @experiment.save
        flash[:notice] = 'Experiment was successfully created.'
        format.html { redirect_to(@experiment) }
        format.xml  { render :xml => @experiment, :status => :created, :location => @experiment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def clone 
    old_exp = Experiment.find(params[:id])
    @experiment = old_exp.clone_experiment( current_user )

    respond_to do |format|
      format.html { redirect_to(experiments_url) }
      format.xml  { head :ok }
    end
  end


  # PUT /experiments/1
  # PUT /experiments/1.xml
  def update
    #@experiment = Experiment.find(params[:id])
    respond_to do |format|
      if @experiment.update_attributes(params[:experiment])
	flash[:notice] = 'Experiment was successfully updated.'
	format.html { redirect_to(@experiment) }
	format.xml  { head :ok }
      else
	format.html { render :action => "edit" }
	format.xml  { render :xml => @experiment.errors, :status => :unprocessable_entity }
      end
   

   end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.xml
  def destroy
    #@experiment = Experiment.find(params[:id])
    
    @experiment.destroy

    respond_to do |format|
      format.html { redirect_to(experiments_url) }
      format.xml  { head :ok }
    end

  end

  private
  def owns_experiment? 
    @experiment = Experiment.find(params[:id])
    is_owner_of( @experiment ) || permission_denied
  end
  
  def permission_denied
	flash[:notice] = "You don't have permission to do that!"
	redirect_to :back
  end

end
