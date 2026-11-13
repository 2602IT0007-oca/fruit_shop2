class CustomersController < ApplicationController
  before_action :set_customer, only: %i[ show edit update destroy ]

  # GET /customers or /customers.json
  def index
    return @customers = Customer.all if params[:name].blank? && params[:age].blank?

    # 条件が2つとも指定されている場合
    if params[:name].present? && params[:age].present?
      @customers = Customer.where(["name like ? and age = ?", "%#{params[:name]}%", "#{params[:age]}"]);
    else
      # nameの条件だけ指定されている場合
      if params[:name].present?
        @customers = Customer.where(["name like ?", "%#{params[:name]}%"]);
      # ageの条件だけ指定されている場合
      else
        @customers = Customer.where(["age = ?", "#{params[:age]}"]);
      end
    end
  end

  # GET /customers/1 or /customers/1.json
  def show
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

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: "Customer was successfully created." }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @customer.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /customers/1 or /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: "Customer was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @customer.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /customers/1 or /customers/1.json
  def destroy
    @customer.destroy!

    respond_to do |format|
      format.html { redirect_to customers_path, notice: "Customer was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def customer_params
      params.expect(customer: [ :employee_id, :name, :age ])
    end
end