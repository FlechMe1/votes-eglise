class Structures::IsMembershipsController < ApplicationController
  before_filter :set_structure

  def index
    @is_members = @structure.memberships.paginate(:page => params[:page])
  end


  private
    def set_structure
      @structure = Structure.find params[:structure_id]
    end

end