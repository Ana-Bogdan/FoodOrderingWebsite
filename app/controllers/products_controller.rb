class ProductsController < ApplicationController
  skip_before_action :require_login, only: %i[ index show ]
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :require_admin, only: %i[ dashboard new create edit update destroy ]

  def index
    @products = Product.all
  end

  def dashboard
    @products = Product.all
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

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

  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to dashboard_path, notice: "Product was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :category, :vegetarian, :price, :image)
    end

    def require_admin
      unless logged_in? && current_user.admin?
        redirect_to root_path, alert: "Access denied. Admin privileges required."
      end
    end
end
