class PasswordResetsController < ApplicationController
    def new

    end

    def create
        if params[:email].empty?
            flash.now[:alert] = "Please enter email."
            render :new
        else
            @user = User.find_by(email: params[:email])

            if @user.present?
                PasswordMailer.with(user: @user).reset.deliver_later
            end
    
            redirect_to root_path, notice: "If an account with that email was found, we have sent a link to reset your password."
        end
    end

    def edit
        @user = User.find_signed!(params[:token], purpose: "password_reset")
    rescue ActiveSupport::MessageVerifier::InvalidSignature
        redirect_to sign_in_path, alert: "Your token has expired. Please try again."
    end
    def update
        @user = User.find_signed!(params[:token], purpose: "password_reset")
        if password_params[:password].empty? || password_params[:password_confirmation].empty?
            flash.now[:alert] = "Please enter both password and password confirmation."
            render :edit
        else
            if @user.update(password_params)
                redirect_to sign_in_path, notice: "Your password was reset successfully. Please sign in."
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