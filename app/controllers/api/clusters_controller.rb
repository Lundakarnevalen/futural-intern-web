class Api::ClustersController < Api::ApiController
  before_filter :authenticate_user_from_token!
  MINIMUM_CLUSTER = 10
  INC_DIST = 5

  def index
    clusters = Cluster.where("quantity >= ?", MINIMUM_CLUSTER)
    return render status: 204, json: { success: true } if clusters.blank?
    render status: 200, json: { sucess: true, clusters: clusters.to_json }
  end

  def create
    clp = cluster_params
    clusters = Cluster.within(INC_DIST, origin: [clp[:lat], clp[:lng]])
    c = clusters.blank? ? Cluster.new(clp) : clusters.first
    success = c.new_record? ? c.save : c.increment!(:quantity)
    return failure(c.errors.full_messages) unless success
    render status: 200, json: { success: true, cluster_id: c.id }
  end

  def update
  end

  private
    def cluster_params
      params.require(:cluster).permit!
    end

    def failure(message)
      return render json: { success: false, errors: message [t(message)] }, status: 400
    end
end
