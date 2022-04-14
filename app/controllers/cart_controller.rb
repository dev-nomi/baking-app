class CartController < ApplicationController
  #byebug
  include AppHelpers::Cart
  include AppHelpers::Shipping
  before_action :set_cart, only: [:edit, :update, :destroy]
  before_action :check_login
  #authorize_resource

  
  # GET /order_items/1 or /order_items/1.json
  def show
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total = @subtotal + @shipping_cost
  end

  def set_cart
  end

  # # GET /order_items/new
   def new
     @cart = create_cart
     flash[:notice] = "GPBO Baking Sheet was added to cart."
     redirect_to home_path
   end

   # GET /order_items/1/edit
   def edit
    # item_id = Item.find(param[:id])
    # add_item_to_cart(item_id)
   end

   def checkout
    @items_in_cart = get_list_of_items_in_cart
    @subtotal = calculate_cart_items_cost
    @shipping_cost = calculate_cart_shipping
    @total = @subtotal + @shipping_cost
    customer = Customer.find_by(user_id: session[:user_id])
    @addresses = customer.addresses
    @order = Order.find_by(customer_id: customer.id).to_a
    #redirect_to view_cart_path
    end

  # # POST /order_items or /order_items.json
   def create
    # @addresses = order.addresses
    # save_each_item_in_cart(order)
  end

  # # PATCH/PUT /order_items/1 or /order_items/1.json
  def update
   # add_item_to_cart(item_id)
  end

  # # DELETE /order_items/1 or /order_items/1.json
  def destroy
    remove_item_from_cart(params[:id])
    redirect_to view_cart_path, notice: "GPBO Baking Sheet was removed from cart."
  end

  def empty
    clear_cart
    redirect_to view_cart_path, notice: "Cart is emptied."
  end

private

def set_cart
   @cart = session[:cart]
end

# Only allow a list of trusted parameters through.
 def cart_params
   #params.require(:cart).permit(:order_id, :item_id, :quantity, :shipped_on)
 end
# # def current_cart
#   if session[:cart_id]
#     cart = Cart.find_by(:id => session[:cart_id])
#     if cart.present?
#       @current_cart = cart
#     else
#       session[:cart_id] = nil
#     end
#   end

#   if session[:cart_id] == nil
#     @current_cart = Cart.create
#     session[:cart_id] = @current_cart.id
#   end
# end

end


