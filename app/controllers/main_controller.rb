class MainController < ApplicationController
    def index
        response = HTTParty.get("https://api.publicapis.org/categories")
        @response = JSON.parse(response.body)
    end
end