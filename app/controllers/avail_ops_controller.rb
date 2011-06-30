class AvailOpsController < ApplicationController

  before_filter :authenticate_member!

  def new
    @member = Member.where(:id => params['member_id']).first
    @avail   = @member.avail_ops.create(:start => Time.now.to_date, :end => 2.days.from_now.to_date)
    redirect_to member_avail_ops_path(@member), :notice => "Created Busy Period"
  end

  def create
    @member = Member.where(:id => params['member_id']).first
    @avail    = AvailOp.create(params[:member_avail])
    @member.member_avails << @avail
    @member.save
    redirect_to member_avail_ops_path(@member), :notice => "Created record"
  end

  def show
    @member = Member.where(:id => params['member_id']).first
  end

  def update
    @member = Member.where(:id => params['member_id']).first
    @member.update_attributes(params["member"])
    redirect_to member_avail_ops_path(@member), :notice => "Updated records"
  end

  def destroy
    @member = Member.where(:id => params['member_id']).first
    @avail  = AvailOp.where(:id => params['id']).first
    @avail.destroy
    redirect_to member_avail_ops_path(@member), :notice => "Deleted Busy Period"
  end

end
