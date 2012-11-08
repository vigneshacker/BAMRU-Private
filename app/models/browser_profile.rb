class BrowserProfile < ActiveRecord::Base

  # ----- Associations -----
  belongs_to   :member

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----

  scope :os_linux,    where(ostype: "Linux")
  scope :not_linux,   where('ostype != ? or ostype IS NULL', "Linux")
  scope :os_windows,  where(ostype: "Windows")
  scope :not_windows, where('ostype != ? or ostype IS NULL', "Windows")
  scope :os_mac,      where(ostype: "Mac")
  scope :not_mac,     where('ostype != ? or ostype IS NULL', "Mac")
  scope :os_other,    not_linux.not_windows.not_mac

  scope :browser_ie,      where(browser_type: "IE")
  scope :not_ie,          where('browser_type != ? or browser_type IS NULL', "IE")
  scope :browser_chrome,  where(browser_type: "Chrome")
  scope :not_chrome,      where('browser_type != ? or browser_type IS NULL', "Chrome")
  scope :browser_firefox, where(browser_type: "Firefox")
  scope :not_firefox,     where('browser_type != ? or browser_type IS NULL', "Firefox")
  scope :browser_other,   not_ie.not_chrome.not_firefox


  # ----- Local Methods-----

end

# == Schema Information
#
# Table name: browser_profiles
#
#  id              :integer         not null, primary key
#  member_id       :integer
#  ip              :string(255)
#  browser_type    :string(255)
#  browser_version :string(255)
#  user_agent      :string(255)
#  ostype          :string(255)
#  javascript      :boolean
#  cookies         :boolean
#  screen_height   :integer
#  screen_width    :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#
