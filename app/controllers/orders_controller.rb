class OrdersController < ApplicationController
    before_action :set_order, only: [:show, :edit, :update, :destroy ]
    before_action :check_login
    authorize_resource
  
    # GET /orders or /orders.json
    def index
      # @orders = Order.all
      # if login_admin
      #   @all_orders = Order.all
      # elsif login_customer
      #   @all_orders = Order.find(@order.customer_id)
      # end
      
      # @past_orders = Order.paid
      @orders = Order.all
      if login_admin
        @all_orders = Order.all
      elsif login_customer
        @all_orders = current_user.customer.orders
      end
      
      @past_orders = Order.paid
    end
  
    # GET /orders/1 or /orders/1.json
    def show
      @previous_orders = Order.for_customer(@order.customer)
      #byebug
      @order_items = Order.for_customer(@order.customer)

    end
  
    
    # GET /orders/new
    def new
      #@order = Order.new
    end
  
    # GET /orders/1/edit
    def edit
    end

    def checkout

    end
  
    # POST /orders or /orders.json
    def create
      @order = Order.new(order_params)
        if @order.save
          redirect_to order_url(@order), notice: "Thank you for ordering from GPBO."
        else
         redirect_to checkout_path
        end
    end
  
    # PATCH/PUT /orders/1 or /orders/1.json
    def update
        # if @order.update(order_params)
        #   redirect_to order_url(@order), notice: "Order was successfully updated."
        # else
        #   render :edit, status: :unprocessable_entity
        # end
    end
  
    # DELETE /orders/1 or /orders/1.json
    def destroy
      # @order.destroy
      #   redirect_to orders_url, notice: "Order was successfully destroyed."
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_order
        @order = Order.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def order_params
        params.require(:order).permit(:customer_id, :address_id, :date, :products_total, :shipping, :payment_receipt, :credit_card_number, :expiration_year, :expiration_month)
      end
  end
  