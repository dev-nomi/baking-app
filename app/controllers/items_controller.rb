class ItemsController < ApplicationController
    before_action :set_item, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
    # GET /items or /items.json
    def index
      #byebug
      @items = Item.all
      @categories = Category.all
      @featured_items = Item.featured
      @other_items = Item.alphabetical 

    end

    # GET /items/1 or /items/1.json
    def show
      @prices = @item.current_retail_price.to_a
      @similar_items = Item.search(@item.name)
    end

    def toggle_active
      @item = Item.find(params[:id])
      if @item.active
       @item.active = false
       @item.save!
       redirect_to item_url(@item), notice: "#{@item.name} was made inactive"
      else 
        @item.active = true
        @item.save!
        redirect_to item_url(@item), notice: "#{@item.name} was made active"
      end
    end

    def toggle_feature
      @item = Item.find(params[:id])
     if @item.is_featured
      @item.is_featured = false
      @item.save!
      redirect_to item_url(@item), notice: "#{@item.name} is no longer featured"
     else 
      @item.is_featured = true
      @item.save!
      redirect_to item_url(@item), notice: "#{@item.name} is now featured"
     end
    end
  
    # GET /items/new
    def new
      @item = Item.new
    end
  
    # GET /items/1/edit
    def edit
    end
  
    # POST /items or /items.json
    def create
      @item = Item.new(item_params)
  
        if @item.save
          redirect_to item_url(@item), notice: "#{@item.name} was added to the system." 
       else
          render :new, status: :unprocessable_entity 
        end
    end
  
    # PATCH/PUT /items/1 or /items/1.json
    def update
       if @item.update(item_params)
          redirect_to item_url(@item), notice: "Item was successfully updated."
         else
          render :edit, status: :unprocessable_entity 
         end
     end
  
    # DELETE /items/1 or /items/1.json
    def destroy

      if @item.destroy
         redirect_to items_url, notice: "Item was successfully destroyed." 
      else
        redirect_to item_url(@item), notice: "Item can not destroyed."  
      end
     end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_item
        @item = Item.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def item_params
        params.require(:item).permit(:category_id, :name, :description, :color, :inventory_level, :reorder_level, :weight, :is_featured)
      end
  end
  