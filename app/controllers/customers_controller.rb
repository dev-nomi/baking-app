class CustomersController < ApplicationController
  
  before_action :set_customer, only: [:show, :edit, :update]
  before_action :check_login, except: [:new ,:create]

  #authorize_resource
  load_and_authorize_resource

  # GET /customers or /customers.json
  def index
    logged_in?
    @customers = Customer.all
    @active_customers = Customer.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    #@previous_orders = @customers.orders.get
    #@addresses = @customers.addresses.get

  end

  # GET /customers/1 or /customers/1.json
  def show
    @previous_orders = Order.for_customer(@customer).to_a
    @addresses = @customer.billing_address.to_a
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit

  end

  # POST /customers or /customers.json
  def create
    @user = User.new(user_params)
    @customer = Customer.new(customer_params)
    #byebug
    @user.role = "customer"
    @user.active = true
    if !@user.save
      @customer.valid?
      render action: 'new'
    else 
      @customer.user_id = @user.id
      if @customer.save
        redirect_to customer_url(@customer), notice: "#{@customer.first_name} #{@customer.last_name} was added to the system."
      else
        render action: 'new'
      end
    end

      # # if @customer.save
      # #   #byebug
      # #   redirect_to customer_url(@customer), notice: "#{@customer.first_name} #{@customer.last_name} was added to the system."
      # # else
      # #   render :new, status: :unprocessable_entity 
      # # end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
      if @customer.update(customer_params)
         redirect_to customer_url(@customer), notice: "Customer was successfully updated."
      else
        render :edit, status: :unprocessable_entity 
    end
  end

  # DELETE /customers/1 or /customers/1.json
  # def destroy
  #   @customer.destroy
  #   redirect_to customers_url, notice: "Customer was successfully destroyed." 
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active)
    end
    def user_params      
      params.require(:customer).permit(:username, :password, :password_confirmation, :role, :greeting)
    end
end