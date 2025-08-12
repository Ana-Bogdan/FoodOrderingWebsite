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

    if @product.save
      redirect_to dashboard_path, notice: "Product was successfully created."
    else
      @products = Product.all
      render :dashboard, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      redirect_to dashboard_path, notice: "Product was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy!
    redirect_to dashboard_path, notice: "Product was successfully deleted."
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
