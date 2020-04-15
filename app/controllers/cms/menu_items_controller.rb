module Cms
  class MenuItemsController < ApplicationController
    
    before_action :authorize_menu
    layout 'application'

    
    def new
      @menu_item = Cms::MenuItem.new
    end
    
    def create
      @menu_item = @menu.items.build resource_params
      if @menu_item.save
        flash[:notice] = 'The menu item was created.'
        redirect_to @menu
      else
        flash[:errors] = 'Unable to create the menu item. Please fix the errors and try again.'
        render action: :new
      end
    end
    
    def edit
      @menu_item = @menu.items.find params[:id]
    end

    def update
      @menu_item = @menu.items.find params[:id]
      if @menu_item.update_attributes resource_params
        flash[:notice] = 'The menu item was updated.'
        redirect_to @menu
      else
        flash[:errors] = 'Unable to update the menu item. Please fix the errors and try again.'
        render action: :edit
      end
    end

    def destroy
      @menu_item = @menu.items.find params[:id]
      if @menu_item.destroy
        flash[:notice] = 'Menu deleted successfully.'
        redirect_to cms_menu_path(@menu)
      else
        flash[:errors] = 'Unable to delete the menu.'
        redirect_to action: :show
      end
    end
    
    private
    
    def authorize_menu
      @menu = Cms::Menu.find params[:menu_id]
      authorize! :manage, Menu
    end
    
    def resource_params
      params.require(:cms_menu_item).permit(:title, :url, :is_external, :enabled, :show_as_expanded, :position, :css_class, :css_id, :access_callback, :active_callback, :theme_callback)
    end
    
  end
end