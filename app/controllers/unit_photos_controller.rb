class UnitPhotosController < ApplicationController

  before_filter :authenticate_member!

  def index
    @members = Member.registered.with_photos.order_by_last_name.includes(:photos).all
  end

end
