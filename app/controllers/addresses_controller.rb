class AddressesController < ApplicationController
    before_action :set_address, only: [:show, :edit, :update, :destroy]
    before_action :check_login
    authorize_resource
  
    # GET /addresses or /addresses.json
    def index
      @addresses = Address.all
      @active_addresses = Address.active.paginate(page: params[:page]).per_page(10)
      @inactive_addresses = Address.inactive.paginate(page: params[:page]).per_page(10)
    end
  
    # GET /addresses/1 or /addresses/1.json
    def show
    end
  
    # GET /addresses/new
    def new
      @address = Address.new
    end
  
    # GET /addresses/1/edit
    def edit
    end
  
    # POST /addresses or /addresses.json
    def create
      @address = Address.new(address_params)
  
      respond_to do |format|
        if @address.save
          format.html { redirect_to customer_url(@address.customer_id), notice: "The address was added to #{@address.customer.proper_name}." }
          format.json { render :show, status: :created, location: @address }
        else
          format.html { render :new, status: :unprocessable_entity } 
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /addresses/1 or /addresses/1.json
    def update
      respond_to do |format|
        if @address.update(address_params)
          format.html { redirect_to addresses_url, notice: "Address was successfully updated." }
          format.json { render :show, status: :ok, location: @address }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /addresses/1 or /addresses/1.json
    def destroy
      # @address.destroy
  
      # respond_to do |format|
      #   format.html { redirect_to addresses_url, notice: "Address was successfully destroyed." }
      #   format.json { head :no_content }
      # end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_address
        @address = Address.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def address_params
        params.require(:address).permit(:customer_id, :is_billing, :recipient, :street_1, :street_2, :city, :state, :zip, :active)
      end
  end
  