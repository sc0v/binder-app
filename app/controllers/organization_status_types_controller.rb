# ## Schema Information
#
# Table name: `organization_status_types`
#
# ### Columns
#
# Name            | Type               | Attributes
# --------------- | ------------------ | ---------------------------
# **`active`**    | `boolean`          | `default(TRUE)`
# **`category`**  | `string(255)`      |
# **`display`**   | `boolean`          |
# **`id`**        | `integer`          | `not null, primary key`
# **`name`**      | `string(255)`      |
#

class OrganizationStatusTypesController < ApplicationController
  load_and_authorize_resource

  # GET /organization_status_types
  # GET /organization_status_types.json
  def index
  end

  # GET /organization_status_types/new
  def new
  end

  # GET /organization_status_types/1/edit
  def edit
  end

  # POST /organization_status_types
  # POST /organization_status_types.json
  def create
    @organization_status_type.save
    if params[:from_organization_status].present?
      redirect_to new_organization_status_path
      return
    end
    redirect_to organization_status_types_path
  end

  # PATCH/PUT /organization_status_types/1
  # PATCH/PUT /organization_status_types/1.json
  def update
    @organization_status_type.update_attributes(organization_status_type_params)
    redirect_to organization_status_types_path
  end

  # DELETE /organization_status_types/1
  # DELETE /organization_status_types/1.json
  def destroy
    if(@organization_status_type.organization_statuses.count > 0)
      flash[:error] = 'Cannot delete a status type until all organizations of that type are deleted.'
      redirect_to organization_status_types_url
      return
    end
    @organization_status_type.destroy
    respond_with(@organization_status_type)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_status_type_params
      params.require(:organization_status_type).permit(:name, :display)
    end
end
