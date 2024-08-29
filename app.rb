require "bundler/setup"
Bundler.require
require "sinatra/reloader" if development?
require "./models.rb"
require_relative "utils/date.rb"

enable :sessions

def logged_in?
    user_id = session[:user_id]
    if user_id
        return true
    else
        return false
    end
end

get '/' do
    if logged_in? 
        erb :index
    else 
        redirect "/login"
    end
end

get "/login" do 
    erb :login
end

post "/login" do
    user = Users.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect "/"
    else
        puts "Error: fail to login..."
        redirect "/login"
    end
end

get "/signup" do
    erb :signup
end

post "/signup" do
    user = Users.create(name: params[:name], email: params[:email], user_id: params[:user_id], password: params[:password])
    if user.persist?
        session[:user_id] = user.id
        redirect "/"
    else
        puts "Error: fail to signup..."
        redirect "/signup"
    end
end