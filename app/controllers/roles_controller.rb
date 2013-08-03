class RolesController < ApplicationController

    before_filter :login_required
    permit "administrator"
    
    def create
        @user = User.find_by_param(params[:user_id])
        if @user and params[:role] and params[:role][:name]
            @user.has_role params[:role][:name]
            if @user.has_role? params[:role][:name]
                flash[:notice] = "Role added."
            else
                flash[:notice] = "Role was not added"
            end
        else
            flash[:notice] = "Role was not added"
        end
        unless @user.nil?
            redirect_to edit_user_path(@user)
        else
            redirect_to users_path
        end  
    end
    
    def destroy
        @user = User.find_by_param(params[:user_id])
        @role = Role.find(params[:id])
        @user.has_no_role @role.name

        if @user.has_role? @role.name
            flash[:notice] = "Role was not removed"
        else
            flash[:notice] = "Role removed"
        end
        
        redirect_to edit_user_path(@user)
    end
end
