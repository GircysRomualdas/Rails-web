class PasswordsController < ApplicationController
    before_action :require_user_logged_in!

    def edit

    end
    def update
        if password_params[:password].empty? || password_params[:password_confirmation].empty?
            flash.now[:alert] = "Please enter both password and password confirmation."
            render :edit
        else
            if Current.user.update(password_params)
                redirect_to root_path, notice: "Password updated!"
            else
                render :edit
            end
        end
    end

    private

    def password_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end