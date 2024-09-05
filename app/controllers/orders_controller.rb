class OrdersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_order, only: %i[ show edit update destroy ]

  # GET /orders or /orders.json
  #displaying a list of all orders
  def index
    @orders = Order.all
  end

  # GET /orders/1 or /orders/1.json
  #displaying spesific order
  def show
    @order = Order.find(params[:id])
  end

  # GET /orders/new
  #creating a new order
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  #editing an order
  def edit
  end

  # POST /orders or /orders.json
  #define method for creating new order
  def create
    @order = Order.new(order_params)
    if @order.save
      flash.alert = "The order record was created successfully."
      redirect_to @order
    else
      render :new, status: :unprocessable_entity
    end
    
    #@customer = Customer.new(customer_params)
    #respond_to do |format|
      #if @customer.save
        #format.html { redirect_to customer_url(@customer), notice: "Customer was successfully created." }
        #format.json { render :show, status: :created, location: @customer }
      #else
        #format.html { render :new, status: :unprocessable_entity }
        #format.json { render json: @customer.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  #defining method for updating order
  def update
    if @order.update(order_params)
      flash.alert = "The order record was updated successfully."
      redirect_to @order
    else
      render :edit, status: :unprocessable_entity
    end
    
    #respond_to do |format|
      #if @customer.update(customer_params)
        #format.html { redirect_to customer_url(@customer), notice: "Customer was successfully updated." }
        #format.json { render :show, status: :ok, location: @customer }
      #else
        #format.html { render :edit, status: :unprocessable_entity }
        #format.json { render json: @customer.errors, status: :unprocessable_entity }
      #end
    #end
  end

  # DELETE /orders/1 or /orders/1.json
  #defining method for deleting an order
  def destroy
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: "Order was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    #define private method for setting order parameters
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:product_name, :product_count, :customer_id)
    end

    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to customers_path
    end
end
