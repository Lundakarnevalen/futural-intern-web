class Api::ClustersController < Api::ApiController
  before_filter :authenticate_user_from_token!
  before_filter :check_inclusion, only: [:update, :create]
  MINIMUM_CLUSTER = 10
  INC_DIST = 5

  def index
    clusters = Cluster.where("quantity >= ?", MINIMUM_CLUSTER)
    return render status: 204, json: { success: true } if clusters.blank?
    render status: 200, json: { sucess: true, clusters: clusters.to_json }
  end

  def create
    success = @c.new_record? ? @c.save : @c.increment!(:quantity)
    render_response(success)
  end

  def update
    previous_cluster = Cluster.find(params[:id])
    success = true
    previous_cluster.quantity
    unless previous_cluster.id == @c.id
      previous_cluster.quantity == 1 ? previous_cluster.destroy : previous_cluster.decrement!(:quantity)
      success = @c.new_record? ? @c.save : @c.increment!(:quantity)
    end
    render_response(success)
  end

  private
    def cluster_params
      params.require(:cluster).permit!
    end

    def check_inclusion
     clp = cluster_params
     clusters = Cluster.within(INC_DIST, origin: [clp[:lat], clp[:lng]])
     @c = clusters.blank? ? Cluster.new(clp) : clusters.first
    end

    def render_response(success)
      return render status: 400, json: { success: false, errors: @c.errors.full_messages } unless success
      render status: 200, json: { success: true, cluster_id: @c.id }
    end
end
