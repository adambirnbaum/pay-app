class RegistrationsController < Devise::RegistrationsController
	def update
		# required for settings form to submit when password is left blank
	    #if params[:user][:current_password].blank? && params[:user][:not_registered] == 1
	    #  params[:user].delete("current_password")
	      #params[:user].delete("password")
	      #params[:user].delete("password_confirmation")
	    #end

	    @user  = User.find(current_user.id)


	    successfully_updated = if needs_password?( @user , params)
        	@user .update_with_password(params[:user])
    	else
    		# remove the virtual current_password attribute update_without_password
      		# doesn't know how to ignore it
      		params[:user].delete(:current_password)
      		
      		if params[:user][:not_registered] == "1"
      			params[:user][:not_registered] = "0"
      		end

       		@user .update_without_password(params[:user])
    	end

	    if successfully_updated
	      set_flash_message :notice, :updated
	      # Sign in the user bypassing validation in case his password changed
	      sign_in  @user , :bypass => true
	      redirect_to after_update_path_for( @user )
	    else
	      render "edit"
	    end
	end


	def new
		super
	end 

	def create
		super
	end 

	def edit
		super
	end 

	def cancel
		super
	end 

	def destroy
		super
	end 

	private

	  # check if we need password to update user data
	  # ie if password or email was changed
	  # extend this as needed
	  def needs_password?(user, params)
	  	if params[:user][:not_registered] == "0"
	    	return user.email != params[:user][:email] || !params[:user][:password].blank?
	    else
			return false
	    end 
	  end
	
end
