class CustomersController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :catch_not_found
  before_action :set_customer, only: %i[ show edit update destroy destroy_with_orders]

  # GET /customers or /customers.json
  def index
    @customers = Customer.all
  end

  # GET /customers/1 or /customers/1.json
  def show
    @customer = Customer.find(params[:id])
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
    @customer = Customer.new(customer_params)
    if @customer.save
      flash.alert = "The customer record was created successfully."
      redirect_to @customer
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

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    if @customer.update(customer_params)
      flash.alert = "The customer record was updated successfully."
      redirect_to @customer
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

  # DELETE /customers/1 or /customers/1.json
  def destroy_with_orders
    if (@customer.orders.exists?)
      @customer.orders.destroy_all
    end
    @customer.destroy
    flash.alert = "The customer record and all related order records were successfully deleted."
    redirect_to customers_url
  end
  def destroy
    begin
      @customer.destroy
      flash.alert = "The customer record was successfully deleted."
    rescue ActiveRecord::InvalidForeignKey
      flash.alert = "That customer record could not be deleted, because the customer has orders."
    end

    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
    #@customer.destroy

    #respond_to do |format|
      #format.html { redirect_to customers_url, notice: "Customer was successfully destroyed." }
      #format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.require(:customer).permit(:first_name, :last_name, :phone, :email)
    end

    def catch_not_found(e)
      Rails.logger.debug("We had a not found exception.")
      flash.alert = e.to_s
      redirect_to customers_path
    end
end
