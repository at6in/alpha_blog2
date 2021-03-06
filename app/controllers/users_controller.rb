class UsersController < ApplicationController
    before_action :set_user, only: [:edit, :update, :show]
    before_action :require_same_user, only: [:edit, :update, :destoy]
    before_action :require_admin, only: [:destory]
    def index
        @user = User.paginate(page: params[:page])
    end
    def new
        @user = User.new
    end
    
    def create
        @user = User.new(user_params)
        if @user.save 
            session[:user_id] = @user.id
            flash[:success] = "Welcome to the Alpha Blog #{@user.username}"
            redirect_to user_path(@user)
        else
            render 'new'
        end
    end
    
    def edit
        
    end
    
    def update
        
        if @user.update(user_params)
            flash[:success] = "your account was updated successfully"
        else
            render 'edit'
        end
    end
    
    def show
        
        @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end
    
    def destory
        @user = User.find(params[:id])
        @user.destroy
        flash[:danger] = "user and all articles have been deleted"
        redirect_to users_path
    end
    
    private 
    
    def user_params
        params.require(:user).permit(:username, :email, :password)
    end
    
    def set_user
        @user = User.find(params[:id])
    end
    
    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:danger] = "You can only edit your own account"
            redirect_to root_path
        end
    end
    
    def require_admin
        if logged_in? && !current_user.admin
            flash[:danger] = "only admin users can perform that action"
            redirect_to root_path
            
        end
    end
end