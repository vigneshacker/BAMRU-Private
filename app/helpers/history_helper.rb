module HistoryHelper
  
  def email_changed?(record)
    return false if record.email.nil?
    record.address != record.email.address
  end

  def phone_changed?(record)
    return false if record.phone.nil?
    record.address != record.phone.sms_email
  end

  def deleted?(record)
    record.phone.blank? && record.email.blank?
  end

  def fixed?(record)
    email_changed?(record) || phone_changed?(record) || deleted?(record)
  end

  def address(outbound)
    if outbound.email
      return "<del>#{outbound.address}</del> (changed)" if email_changed?(outbound)
      return outbound.address
    end
    if outbound.phone
      return "<del>#{outbound.address}</del> (changed)" if phone_changed?(outbound)
      return outbound.address
    end
    "<del>#{outbound.address}</del> (deleted)"
  end

  def via(outbound)
    return " via phone" if outbound.phone
    return " via email" if outbound.email
    " "
  end

  def created_time(obj)
    obj.created_at.strftime("%y-%m-%d %H:%M:%S")
  end

  def reply_time(obj)
    obj.send_time.strftime("%y-%m-%d %H:%M:%S")
  end

  def reply_txt(inbound)
    color = fixed?(inbound.outbound_mail) ? "lightblue" : "pink"
    fix   = @recipient == current_member ? link_to("fix", "/members/#{current_member.id}/edit") : "fix"
    lbl   = fixed?(inbound.outbound_mail) ? "" : " (#{fix})"
    v1 = "Reply "
    v2 = "<span style='background-color: #{color}; padding-left: 3px; padding-right:3px;'>Bounce Reply#{lbl}</span>"
    inbound.bounced? ? v2 : v1
  end

  def view(inbound)
    "<a href='#' class=click_view id='#{inbound.id}_view'>view</a>"
  end

  def hide(inbound)
    "<a href='#' class=click_hide id='#{inbound.id}_hide'>hide</a>"
  end

  def body(inbound)
    text = inbound.body.gsub("\n", "<br/>")
  end


end