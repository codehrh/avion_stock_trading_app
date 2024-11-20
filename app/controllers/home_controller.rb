class HomeController < ApplicationController

def index
    @users = User.all  # This fetches all users from the database
end

end