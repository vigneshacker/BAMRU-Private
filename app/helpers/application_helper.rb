module ApplicationHelper

  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block)}
    uri = URI.parse("#{FAYE_SERVER}/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
  
  def app_notice
    notice_value = notice
    notice_value.blank? ? "<p/>" : "<p class='notice'>#{notice_value}</p>"
  end

  def app_alert
    alert_value = alert
    alert_value.blank? ? "<p/>" : "<p class='alert'>#{alert_value}</p>"
  end

  def sign_out_link
    "<a href='/logout'>log out</a>"
  end

  def sign_up_or_in_link
    sign_in_link = "<a href='/members/sign_in'>sign in</a>"
    sign_up_link = "<a href='/members/sign_up'>sign up</a>"
    sign_in_link + ' | ' + sign_up_link
  end

  def sign_up_link
    link_to_unless_current("log in", '/login')
  end

  def signed_in_header_nav
    roster = link_to_unless_current("Roster", members_path)
    photos = link_to_unless_current("Photos", unit_photos_path)
    certs  = link_to_unless_current("Certs", unit_certs_path)
    avail  = link_to_unless_current("Availability", unit_avail_ops_path)
    duty   = link_to_unless_current("DO", do_assignments_path)
    report = link_to_unless_current("Reports", '/reports')
    opts   = [roster, photos, certs, avail, duty, report]
    opts.join(' | ')
  end

  def favicon_file
    ENV['RAILS_ENV'] == "development" ? "favicon_d1.ico" : "favicon_p1.ico"
  end

  def header_nav
    if member_signed_in?
      signed_in_header_nav
    else
      ""
    end
  end

  def user_nav
    if member_signed_in?
      "welcome <b>#{current_member.first_name}</b> | #{sign_out_link}"
    else
      sign_up_link
    end
  end

  # ----- Misc Helpers -----
  def next_quarter(hash)
    lh = hash.clone
    if lh[:quarter] == 4
      lh[:year] += 1
      lh[:quarter] = 1
    else
      lh[:quarter] += 1
    end
    lh.delete(:week); lh.delete(:org_id)
    lh
  end

  def prev_quarter(hash)
    lh = hash.clone
    if lh[:quarter] == 1
      lh[:year] -= 1
      lh[:quarter] = 4
    else
      lh[:quarter] -= 1
    end
    lh.delete(:week); lh.delete(:org_id)
    lh
  end

  def link_prev(hash)
    link_to "<", do_assignments_path(prev_quarter(hash))
  end

  def link_next(hash)
    link_to ">", do_assignments_path(next_quarter(hash))
  end

  def link_current_quarter
    link_to "Current Quarter", do_assignments_path
  end

  def avail_dos_link_prev(hash)
    link_to "<", member_avail_dos_path(prev_quarter(hash))
  end

  def avail_dos_link_next(hash)
    link_to ">", member_avail_dos_path(next_quarter(hash))
  end

  def avail_dos_link_current_quarter(hash)
    link_to "Current Quarter", member_avail_dos_path(hash[:member_id])
  end

  def edit_link_prev(hash)
    link_to "<", edit_do_assignment_path(prev_quarter(hash))
  end

  def edit_link_next(hash)
    link_to ">", edit_do_assignment_path(next_quarter(hash))
  end

  def edit_link_current_quarter
    link_to "Current Quarter", edit_do_assignment_path
  end

  def day_label(offset = 0)
    (Time.now + offset.days).strftime("%b %e")
  end

  def day_helper(member, offset = 0)
    day = Time.now + offset.days
    if member.avail_ops.busy_on?(day)
      "<td align=center style='background-color: pink;'>No</td>"
    else
      "<td></td>"
    end
  end

  def return_date_helper(member, offset)
    day = Time.now + offset.days
    return_date = member.avail_ops.return_date(day)
    return_date.nil? ? "" : (return_date + 1.day).strftime("%y-%m-%d")
  end

  # ----- Debug Helpers -----

  def params_debug_text
    "<b>#{params["controller"]}##{params["action"]}</b> (params: #{params.inspect})"
  end

  def request_env_debug_text
    "<b>Request.env:</b><br/>#{request.env["HTTP_COOKIE"].inspect}"
  end

  def debug_footer_text
    params_debug_text
  end

end