module ImportCds
  def self.clean_phone(phone)
    phone ? phone.gsub(/[ \.\-()=]/, "") : nil
  end

  def self.contact_matches_member(c, mbe, mbp)
    if c.email && (m = mbe[c.email])
      return m
    elsif clean_phone(c.mobile) && (m = mbp[clean_phone(c.mobile)])
      return m
    elsif clean_phone(c.home) && (m = mbp[clean_phone(c.home)])
      return m
    end
    return nil
  end

  def self.contact_has_no_matchable_info?(c)
    c.email.blank? && c.home.blank? && c.mobile.blank? && c.work.blank?
  end

  def self.import_contacts_csv2_local(contacts_csv_string)
    import_contacts2(CSV.read(contacts_csv_string)[1..-1])
  end

  def self.import_contacts_csv2(contacts_csv_string)
    import_contacts2(CSV.parse(contacts_csv_string)[1..-1])
  end

  def self.import_contacts2(contacts)
    puts "contacts.size = #{contacts.size}"
    contacts = contacts.map do |r|
      districts = []
      if r[0]
        cd = r[0].strip
        if cd
          districts.push("CD-#{cd}")
        end
      end

      if r[1]
        # SDnn (LM)?
        # HDnna
        # DNC - Democratic National Committee
        # AL - At large
        # ?
        # BSW-15
        # County Name
        # St Louis-03
        district = r[1].downcase.strip
        case district
        when /^sd(\d+)/i
          district = "SD-#{$1}"
        when /^cd(\d+)/i
          district = "CD-#{$1}"
          district = nil if districts.include?(district)
        when /^hd(\d+\w)/
          district = "HD-#{$1}"
        when /^([\w\s]+)-(\d+)$/
          county = $1
          sub_unit = $2
          county2 = county.gsub(/\s+/, '-').gsub(/\./, '')
          district = "CTY-#{county2}-#{sub_unit}"
        when /^dnc$/
          district = "democratic-national-committee"
        when /^al/
          district = "at-large"
        when /^\?/
          district = nil
        else
          if district.present?
            county = district.gsub(/\s+/, '-').gsub(/\./, '')
            district = "CTY-#{county}"
          else
            district = nil
          end
        end
        districts.push(district) if district
      end


      if r[2]
        delegate = r[2].downcase.strip
        if delegate =~ /scc delegate/
          delegate = "delegate"
        elsif delegate =~ /scc alternate/
          delegate = "alternate"
        else
          delegate = nil
        end
      end

      tags = []
      districts.each do |district|
        tags << "district:#{district}"
      end
      tags << "delegate_type:#{delegate}" if delegate
      tags << "source:scc-2-15-2019.csv"

      OpenStruct.new(first:   r[3], last:   r[4],
                     address: r[5], city:   r[6],   zip: r[7],
                     home:    r[8], mobile: r[9],
                     email: nil, tags: tags.join(' '))
    end

    import_contacts_as_members(contacts)
  end

  def self.import_contacts_csv(contacts_csv_string)
    import_contacts(CSV.parse(contacts_csv_string)[1..-1])
  end

  def self.import_contacts(contacts)
    contacts = contacts.map do |r|
      is_bernie = is_hillary = district = sources = nil

      if r[8]
        district = r[8].downcase.strip
        if district =~ /SD (\d+)/i
          district = "SD-#{$1}"
        elsif district =~ /^(\w+) W\s*-?\s*(\d+)\s*P\s*-?\s*(\d+)$/i
          district = "PR-#{$1}-W#{$2}-P#{$3}"
        else
          district = nil
        end
      end

      if r[9]
        subcaucus = r[9].downcase
        is_bernie = subcaucus =~ /sanders/ || subcaucus =~ /bernie/
        is_hillary = subcaucus =~ /clinton/ || subcaucus =~ /hillary/
      end

      if r[10]
        sources = r[10].downcase.split(/:/)
      end


      tags = []
      tags << "subcaucus:sanders" if is_bernie
      tags << "subcaucus:clinton" if is_hillary
      tags << "district:#{district}" if district
      sources.each{|s| tags << "source:#{s}"} if sources.present?

      OpenStruct.new(first: r[0], last: r[1], email: r[2], mobile: r[3], home: r[4],
                     address: r[5], city: r[6], zip: r[7],
                     is_bernie: is_bernie, is_hillary: is_hillary, tags: tags.join(' '))
    end

    import_contacts_as_members(contacts)
  end

  def self.add_tags(m, c)
    added = false
    if c.tags.present?
      c.tags.split(/ /).each do |tag|
        case tag
        when /district:(.*)$/
          m.district_list.add($1)
          added = true
        when /subcaucus:(.*)$/
          m.subcaucus_list.add($1)
          added = true
        when /source:(.*)$/
          m.source_list.add($1)
          added = true
        else
          if /^(\w+):(.*)$/.match(tag)
            m.general_tag_list.add(tag)
            added = true
          end
        end
      end

      added
      #  puts "Tags for #{c.first} #{c.last} - #{c.tags}"
    end
  end

  def self.import_contacts_as_members(contacts)
    members = Member.all.to_a
    members_by_email = {}
    members.each{|m| members_by_email[m.email] = m}
    members_by_phone = {}
    members.each do |m|
      members_by_phone[clean_phone(m.home_phone)] = m if m.home_phone
      members_by_phone[clean_phone(m.mobile_phone)] = m if m.mobile_phone
      members_by_phone[clean_phone(m.work_phone)] = m if m.work_phone
    end

    members_to_contact = {}
    contacts_without_members = []
    contacts_with_members = []
    contacts_with_no_matchable_info = []
    contacts.each do |c|
      if contact_has_no_matchable_info?(c)
        contacts_with_no_matchable_info.push(c)
      elsif m = contact_matches_member(c, members_by_email, members_by_phone)
        if members_to_contact[m.id]
          members_to_contact[m.id].push(c)
        else
          members_to_contact[m.id] = [c]
        end
        contacts_with_members.push(c)
      else
        contacts_without_members.push(c)
      end
    end
    users = members_to_contact.map{|m_id, c| Member.find(m_id)}.select{|m| m.user_id.present?}

    # contacts.each do |contact|
    #   puts "#{contact.first}, #{contact.last}: #{contact.email} -  #{contact.tags}"
    # end

    # return

    # contacts_with_no_matchable_info.each do |contact|
    #   puts "#{contact.first}, #{contact.last}: #{contact.email} -  #{contact.tags}"
    # end

    puts "total contacts: #{contacts.size}"
    puts "total bernies: #{contacts.select(&:is_bernie).size}"
    puts "total hillaries: #{contacts.select(&:is_hillary).size}"
    puts "found #{members_to_contact.values.size} matching members hash size"
    puts "found #{contacts_with_no_matchable_info.size} no matchable info contacts"
    puts "found #{contacts_with_members.size}    matching members"
    puts "found #{contacts_without_members.size} not-matching members"
    puts "found #{users.size} matching users"
    puts "found #{Member.all.size} total members"
    #puts "found #{members_to_contact.values.select(&:is_bernie).size} matching bernies"
    # puts "found #{members_to_contact.values.select(&:is_hillary).size} matching hillaries"

    puts("-" * 60)

    # members_to_contact.each do |m, c|
    #   if c.is_bernie
    #     member = Member.find(m)
    #     is_user = member.user.present?
    #     puts "#{c.first} #{c.last}: #{m}, #{member.email}, #{is_user}"
    #   end
    # end
    #
    # puts("-" * 60)
    #

    members_to_contact.each do |m_id, cs|
      m = Member.find(m_id)
      # if cs.size > 1
      #   puts "for member: #{m.first_name} #{m.last_name}, #{m.email}, #{m.mobile_phone}, #{m.home_phone}, #{m.work_phone}"
      #   cs.each do |c|
      #     puts "  matches contact: #{c.first} #{c.last}, #{c.email}, #{c.mobile}, #{c.home}, #{c.work}"
      #   end
      # end

      cs.each do |c|
        if add_tags(m, c)
          m.save
        end
        # source = c.tags.split(/ /).select{|t| /source:/.match(t)}.map{|t|match = /source:([^\s]+)/.match(t); match ? match[1]: nil}.first
        # if !(m.source_list.include?(source))
        #   m.source_list.add(source)
        #   m.save
        # end
      end

      if m.user_id.nil?
        cs.each do |c|
          if (c.address && m.address_1.blank?) ||
              (c.city && m.city.blank?) ||
              (c.zip && m.zip.blank?)
            # if none of the changes would cause an overwrite
            if (
              (c.address.present? || c.city.present? || c.zip.present?) &&
              (m.address_1.blank? && m.city.blank?   && m.zip.present?)
            )
              puts "Updating: #{m.first_name} #{m.last_name} ------------"
              puts "  one of multiple" if cs.size > 1
              if c.address.present? && m.address_1.blank?
                puts "  address: #{c.address}"
                m.address_1 = c.address
              end

              if c.city.present? && m.city.blank?
                puts "  city: #{c.city}"
                m.city = c.city
              end

              if c.zip.present? && m.zip.blank?
                puts "  zip: #{c.zip}"
                m.zip = c.zip
              end

              m.save
            end
          end
        end
      end
    end

    puts("-" * 60)

    contacts_without_members.each do |c|
      m = Member.new(first_name:    c.first,
                     last_name:     c.last,
                     mobile_phone:  c.mobile,
                     home_phone:    c.home,
                     work_phone:    c.work,
                     address_1:     c.address,
                     city:          c.city,
                     state:         (c.state.present? ? c.state : "mn"),
                     zip:           c.zip,
                     is_non_member: true)
      m.email = c.email if c.email
      add_tags(m, c)
      # if c.tags.present?
      #   c.tags.split(/ /).each do |tag|
      #     case tag
      #     when /district:(.*)$/
      #       m.district_list.add($1)
      #     when /subcaucus:(.*)$/
      #       m.subcaucus_list.add($1)
      #     when /source:(.*)$/
      #       m.source_list.add($1)
      #     else
      #       m.general_tag_list.add($1)
      #     end
      #   end
      #   #  puts "Tags for #{c.first} #{c.last} - #{c.tags}"
      # end
      if !m.save
        puts "unable to save #{m.first_name} #{m.last_name}  - #{m.email} because: #{m.errors.full_messages}"
        puts "#{m.mobile_phone}, #{m.home_phone}, #{m.work_phone}"
      end
    end
  end
end