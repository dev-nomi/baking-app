class HomeController < ApplicationController
    # before_action :check_login
    # authorize_resource
    # def index
    # end
  
    # def about
    # end
  
    # def contact
    # end
  
    # def privacy
    # end
    
    def search
        redirect_back(fallback_location: home_path) if params[:query].blank?
        @query = params[:query]
        @customers = Customer.search(@query)
        @items = Item.search(@query)
        @total_hits = @customers&.size + @items&.size
      end
end
