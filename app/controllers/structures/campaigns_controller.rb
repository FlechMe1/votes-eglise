class Structures::CampaignsController < ApplicationController
  before_filter :set_structure

  def index
    @campaigns = @structure.campaigns.order(start_at: :desc).paginate(:page => params[:page])
  end

  def show
    @campaign = @structure.campaigns.find params[:id]
  end

  def new
    @campaign = @structure.campaigns.build
    @members = @structure.members
  end

  def create
    @campaign = @structure.campaigns.build(campaign_params)
    if @campaign.save
      redirect_to [@structure.becomes(Structure), @campaign], notice: "Campagne créée"
    else
      @members = @structure.members
      render :new
    end
  end

  def edit
    @campaign = @structure.campaigns.find params[:id]
    @members = @structure.members
  end

  def update
    @campaign = @structure.campaigns.find params[:id]
    if @campaign.update(campaign_params)
      redirect_to [@structure.becomes(Structure), @campaign], flash:{success: 'Campagne mise à jours.'}
     else
      @members = @structure.members
      render :edit
    end
  end


  def destroy
    @campaign = @structure.campaigns.find params[:id]
    @campaign.destroy
    redirect_to [@structure.becomes(Structure), :campaigns], notice: "Campagne supprimée"
  end

  private
    def set_structure
      @structure = Structure.find params[:structure_id]
    end

    def campaign_params
      params[:campaign].permit(:name, :description, :code, :start_at, :end_at, :is_public, motions_attributes: [:id, :name, :kind, :order, :_destroy], powers_attributes: [:id, :from_id, :from_type, :to_id, :to_type, :_destroy])
    end

end