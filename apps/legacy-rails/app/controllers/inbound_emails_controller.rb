class InboundEmailsController < ApplicationController
    skip_before_action :authenticate_user!
    def index
        f = File.new("public/out.json", "w")
        f.write(params.to_json)     #=> 10
        f.close                   #=> nil
        
        render :json => { "message" => "RIGHT" }, :status => 200
    end
end
