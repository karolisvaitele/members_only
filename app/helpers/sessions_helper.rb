module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def remember(user)
        user.remember
        cookies.permanent[:remember_token] = user.remember_token
        cookies.permanent.signed[:user_id] = user.id
    end

    def forget(user)
        cookies.delete(:remember_token)
        cookies.delete(:user_id)
    end

    def current_user
        if session[:user_id]
            @current_user ||= User.find_by(id: session[:user_id])
        elsif cookies.signed[:user_id]
            @current_user = User.find_by(id: cookies.signed[:user_id])
            if @current_user && @current_user.authenticated?(cookies[:remember_token])
                log_in @current_user
                @current_user
            end
        end
    end

    def log_out
        session.delete(:user_id)
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
        @current_user = nil
    end

    def logged_in?
        !current_user.nil?
    end
end
