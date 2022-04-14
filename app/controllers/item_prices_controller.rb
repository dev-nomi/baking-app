class ItemPricesController < ApplicationController
    before_action :set_item_price, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
    
  
    # GET /item_prices/new
    def new
      @item_price = ItemPrice.new
      @item = Item.find(params[:item_id])
    end
  
   
  
    # POST /item_prices or /item_prices.json
    def create
      @item_price = ItemPrice.new(item_price_params)
  
      respond_to do |format|
        if @item_price.save
          format.html { redirect_to item_url(@item_price), notice: "Successfully updated the price." }
          format.json { render :show, status: :created, location: @item_price }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @item_price.errors, status: :unprocessable_entity }
        end
      end
    end
  
  
    private
      # Use callbacks to share common setup or constraints between actions.
      # def set_item_price
      #   @item_price = ItemPrice.find(params[:id])
      # end
  
      # Only allow a list of trusted parameters through.
      def item_price_params
        params.require(:item_price).permit(:item_id, :price, :start_date, :end_date)
      end
  end
  