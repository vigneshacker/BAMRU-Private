class EventPhoto < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :event

  has_attached_file :image, :styles => {:medium => "300x300", :small => "150x150", :thumb => "100x100"}

  before_post_process :cleanup_file_name

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----

  def export
    atts = attributes
    %w(id member_id).each {|a| atts.delete(a)}
    atts
  end

  def cleanup_file_name
    self.image.instance_write(:file_name, "#{self.image_file_name.gsub(' ','_')}")
  end

end


# == Schema Information
#
# Table name: event_photos
#
#  id                 :integer         not null, primary key
#  member_id          :integer
#  event_id           :integer
#  caption            :string(255)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :integer
#  position           :integer
#  published          :boolean         default(FALSE)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

