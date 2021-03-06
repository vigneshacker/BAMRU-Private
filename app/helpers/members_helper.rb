module MembersHelper

  def generate_preview_options
    mem = current_member
    opts = {
      :author_name       => mem.full_name,
      :author_short_name => mem.short_name,
      :author_last_name  => mem.last_name,
      :author_mobile     => mem.phones.order('position ASC').first.try(:number),
      :author_email      => mem.emails.order('position ASC').first.try(:address)
    }
    body = opts.map {|k,v | "#{k.to_s}:'#{v}'"}.join(',')
    "{#{body}}"
  end

  def rsvp_select
    first_opt = "<option id=blank_select value='NA' selected='selected'></option>\n"
    opts = first_opt + RsvpTemplate.order('position ASC').all.map do |i|
      "<option value='#{i.name}' data-prompt='#{i.output_json}'>#{i.name}</option>\n"
    end.join
    "<select id=rsvp_select>\n" + opts + "</select"
  end

  def roster_oot_class(member)
    return "" unless member.avail_ops.busy_on?(Time.now)
    raw " style='background-color: pink;' class='oot_member'"
  end

  def roster_oot_label(member)
    return "" unless member.avail_ops.busy_on?(Time.now)
    " (<a href='/members/#{member.id}/avail_ops'>Unavail</a>)"
  end

  def return_date_label(member)
    day = Time.now
    return_date = member.avail_ops.return_date(day)
    return_date.nil? ? "" : (return_date + 1.day).strftime("%b %d")
  end

  def show_oot_label(member)
    return "" unless member.avail_ops.busy_on?(Time.now)
    " <span style='background: #fef;'>(<a href='/members/#{member.id}/avail_ops'>Unavailable until #{return_date_label(member)}</a>)</span><p></p>"
  end
  
  def phone_checkbox(member)
    list = member.phones.pagable
    if list.blank?
      "<td></td>"
    else
      check_val = @page_gen.should_check?(member) ? "checked" : ""
      "<td align=center class=checkbox><input class='sms_ck rck #{member.full_roles}' name='history[#{member.id}_phone]' type='checkbox' #{check_val}></td>"
    end
  end

  def email_checkbox(member)
    list = member.emails.pagable
    if list.blank?
      "<td></td>"
    else
      check_val = @page_gen.should_check?(member) ? "checked" : ""
      "<td align=center class=checkbox><input class='mail_ck rck #{member.full_roles}' name='history[#{member.id}_email]' type='checkbox' #{check_val}></td>"
    end
  end

  def link_to_remove_field(name, f)
    link_to_function(name, "remove_fields(this);", :class => "add")
  end

  def link_to_add_fields(name, f, association, params={})
    new_object = f.object.class.reflect_on_association(association).klass.new(params)
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, "add_fields(this, '#{association}', '#{escape_javascript(fields)}')", :id => "add_#{association.to_s.singularize}")
  end

  # ----- For Help Message -----

  def check_style(f)
    return nil if f.nil?
    return unless f.respond_to?(:non_standard_typ?)
    "background-color: lightyellow;" if f.non_standard_typ?
  end

  def pagable?(f)
    return nil if f.nil?
    f.pagable?
  end

  def has_non_standard_records(mem)
    mem.phones.where
  end

  def edit_info_message
    <<-ERB
      <div style='background-color: lightyellow; font-size: 10px; text-align: center;'>
        Please move highlighted records to "Emergency Contacts" or  "Other Info". (#{link_to("more", '/home/edit_info', :target => "_blank")})
      </div>
    ERB
  end

  def box_link(item, klass)
    color = item.try(:pagable?) ? "green" : "black"
    link_to("", '#', :class => "#{klass} #{color}_box")

  end

end
