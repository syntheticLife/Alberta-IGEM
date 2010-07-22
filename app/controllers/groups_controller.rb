class GroupsController < ApplicationController
  before_filter :set_nav
  def index
	@groups = Group.all
  end

  def show
	@group = get_group_by_id_or_name
	@members = @group.users
	@messages = @group.messages.all
  end

  def new
	  @group = Group.new
  end

  def destroy
	  @group = Group.find(params[:id])
	  @group.destroy

	  redirect_to( groups_path )
  end

  def create
	  @group = Group.new( params[:group] )
	  if  @group.save
	  
		  # assign creater to admin_role of group
		  current_user.group = @group
		  current_user.role = @group.admin_role
		  
		  if current_user.save
			flash[:notice] = 'The group was succesfully created.'
			#redirect_to pretty_group_path( @group.name )
			redirect_to group_path( @group )
		  else
			flash[:error] = 'There was an error creating the group.'
		  end
	  else
		  flash[:error] = 'The group could not be created!'
		  redirect_to groups_path
	  end

  end

  def edit
	  @group = get_group_by_id_or_name
  end

  def update 
	  @group = Group.find(params[:id])
	  if @group.update_attributes( params[:group] )
	  	flash[:notice] = 'Group updated'
	  else
		flash[:error] = 'The changes were not saved'
	  end
	  redirect_to @group
  end

  def join
	  @group = Group.find(params[:id])
	  
	  respond_to do |format|
	    if @group.join_with_key( current_user, params[:key] )
		format.html {
		       	flash[:notice] =  "Succesfully joined #{@group.name}."
			redirect_to group_path(@group)
		}
		format.js { head :ok }
	    else
		fomat.html {
			flash[:notice] = "Incorrect key, could not joini #{@group.name}"
			redirect_to groups_path

		}
		format.js { head 'incorrect key'}
	    end
	  end
  end
  def new_key 
	@group = Group.find(params[:id])
	
	key = @group.generate_new_key
	if key
		render :text=>key
	else
		head :error
	end

  end

  def upload
	  @group = Group.find(params[:id])
  end
  
  private
  def set_nav
	  @navbar_selected = :groups
  end
  def  get_group_by_id_or_name
	 params[:name] ? Group.find_by_name(params[:name]) : Group.find(params[:id])
  end

end