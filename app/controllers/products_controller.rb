class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products
  def index
    @products = Product.all
  end

  # GET /dashboard
  def dashboard
    @products = Product.all
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to dashboard_path, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        @products = Product.all
        format.html { render :dashboard, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to dashboard_path, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: "Product was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

    # Callback to set @product by ID
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow trusted parameters
    def product_params
      params.require(:product).permit(:name, :category, :vegetarian, :price, :image)
    end
end
