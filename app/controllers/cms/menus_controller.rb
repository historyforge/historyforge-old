module Cms
  class MenusController < ApplicationController

    before_action :authorize_menu
    layout 'application'

    
    def index
      @menus = Cms::Menu.order(:name)
    end
    
    def new
      @menu = Cms::Menu.new
    end
    
    def create
      @menu = Cms::Menu.new resource_params
      if @menu.save
        flash[:notice] = 'The menu was created.'
        redirect_to @menu
      else
        flash[:errors] = 'Unable to create the menu. Please fix the errors and try again.'
        render action: :new
      end
    end
    
    def show
      @menu = Cms::Menu.find params[:id]
      @menu_items = @menu.items.root
    end
    
    def edit
      @menu = Cms::Menu.find params[:id]
    end

    def update
      @menu = Cms::Menu.find params[:id]
      if @menu.update_attributes resource_params
        flash[:notice] = 'The menu was updated.'
        redirect_to @menu
      else
        flash[:errors] = 'Unable to update the menu. Please fix the errors and try again.'
        render action: :edit
      end
    end

    def destroy
      @menu = Cms::Menu.find params[:id]
      if @menu.destroy
        flash[:notice] = 'Menu deleted successfully.'
        redirect_to action: :index
      else
        flash[:errors] = 'Unable to delete the menu.'
        redirect_to action: :show
      end
    end
    
    private
    
    def authorize_menu
      authorize! :manage, Menu
    end
    
    def resource_params
      params.require(:cms_menu).permit(:name, :css_class, :css_id, :access_callback, :theme_callback, :item_theme_callback, items_attributes: [:id, :enabled, :position, :parent_id])
    end
    
  end
end