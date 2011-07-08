class AuthenticationsController < ApplicationController
  def index
    @authentications = current_user.authentications if current_user
  end

  def create
    auth = request.env["rack.auth"]
    authentication = Authentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    if authentication
      flash[:notice] = auth['user_info']['email']
      @user_session = UserSession.new(authentication.user, true)
      if @user_session.save
        #flash[:notice] = "Signed in successfully."
        redirect_to root_path
      else
        render 'user_sessions/new'
      end
    elsif current_user
      current_user.authentications.create!(:provider => auth['provider'], :uid => auth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to root_path
    else
      user = User.new
      user.apply_omniauth(auth)
      user.reset_persistence_token!
      if user.save(false)
        flash[:notice] = "Signed in successfully."
        @user_session = UserSession.new(user, true)
        if @user_session.save
          redirect_to root_path
        else
          render 'user_sessions/new'
        end
      else
        session[:omniauth] = auth.except('extra')
        redirect_to signup_path
      end
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

end
