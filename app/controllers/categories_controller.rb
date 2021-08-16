# Description/Explanation of CategoriesController
class CategoriesController < ApplicationController
  # GET /categories or /categories.json
  def index
    @tree = Category.tree

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tree }
    end
  end

  # GET /categories/1 or /categories/1.json
  def show
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError, 'Not found'
    end

    @children = @category.children

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  def new
    @category = Category.new
    @parent = Category.by_alias params[:alias]

    if params[:alias] && @parent.nil?
      raise ActionController::RoutingError, 'Not found'
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError, 'Not found'
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new
    @parent = Category.by_alias params[:alias]

    if params[:alias] && @parent.nil?
      raise ActionController::RoutingError, 'Not found'
    end

    @parent ||= Category.new

    @category.title = params[:category][:title]
    @category.alias = params[:category][:alias]
    @category.text = params[:category][:text]
    @category.parent = @parent

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category.url, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: 'new' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError, 'Not found'
    end

    @category.title = params[:category][:title]
    @category.alias = params[:category][:alias]
    @category.text = params[:category][:text]

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category.url, notice: 'Category was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: 'edit' }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    @category = Category.by_alias params[:alias]
    if @category.nil?
      raise ActionController::RoutingError, 'Not found'
    end

    parent_url = @category.parent_url
    @category.destroy_tree

    respond_to do |format|
      format.html { redirect_to parent_url }
      format.json { head :ok }
    end
  end
end
