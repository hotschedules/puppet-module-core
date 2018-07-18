require 'facter/util/ec2'
require 'open-uri'

if Facter.value(:operatingsystem) == 'Amazon' then
    def metadata(id = "")
      open("http://169.254.169.254/2008-02-01/meta-data/#{id||=''}").read.
        split("\n").each do |o|
        key = "#{id}#{o.gsub(/\=.*$/, '/')}"
        if key[-1..-1] != '/'
          value = open("http://169.254.169.254/2008-02-01/meta-data/#{key}").read.
            split("\n")
          symbol = "ec2_#{key.gsub(/\-|\//, '_')}".to_sym
          Facter.add(symbol) { setcode { value.join(',') } }
        else
          metadata(key)
        end
      end
    rescue => details
      Facter.warn "Could not retrieve ec2 metadata: #{details.message}"
    end

    def userdata()
      Facter.add(:ec2_userdata) do
        setcode do
          if userdata = Facter::Util::EC2.userdata
            userdata.split
          end
        end
      end
    end

    Facter.add(:ec2_iam_roleid) do
      shortname = `hostname`.split('.')[0].split('-')
      case shortname.length
        when 3
          instance_environment = shortname[0]
          instance_role = shortname[1]
          setcode do
            Facter::Util::Resolution.exec("aws iam get-role --role-name #{instance_environment}-#{instance_role} --query 'Role.RoleId' 2>/dev/null").gsub("\"","")
          end
        when 4
          instance_product = shortname[0]
          instance_environment = shortname[1]
          instance_role = shortname[2]
          setcode do
            Facter::Util::Resolution.exec("aws iam get-role --role-name #{instance_product}-#{instance_environment}-#{instance_role} --query 'Role.RoleId' 2>/dev/null").gsub("\"","")
          end
        when 5
          instance_product = shortname[0]
          instance_environment = shortname[1]
          instance_role = shortname[2]
          setcode do
            Facter::Util::Resolution.exec("aws iam get-role --role-name #{instance_product}-#{instance_environment}-#{instance_role} --query 'Role.RoleId' 2>/dev/null").gsub("\"","")
          end
      end
    end

    # We might be in a VPC, which fails the normal EC2 MAC address checks
    if !Facter.value('ec2_instance_id') && Facter.value('virtual') =~ /xen/ && Facter::Util::EC2.can_connect?(0.2)
      Facter.debug "This is an EC2 VPC instance"
      metadata
      userdata
     
      # vpc-id is in a newer metadata api rev than the usual EC2 facts
      Facter.add(:ec2_vpc_id) do
        setcode do
          mac = open("http://169.254.169.254/2011-01-01/meta-data/mac").read.chomp
          open("http://169.254.169.254/2011-01-01/meta-data/network/interfaces/macs/#{mac}/vpc-id").read.chomp
        end
      end
    else
      Facter.debug "Still not an EC2 host"
    end

    if Facter.value("ec2_instance_id") != nil
      instance_id = Facter.value("ec2_instance_id")
      region = Facter.value("ec2_placement_availability_zone")[0..-2]
      tags = Facter::Util::Resolution.exec("aws ec2 describe-tags --filter Name=resource-id,Values=#{instance_id} --region #{region} --output text | cut -f 2,5|awk 'BEGIN{FS=\" \";OFS=\"|\"} {$1=$1; print $0}'")
      tags.scan(/(.*)\|+(.*)/) do |key, value|
      fact = "ec2_tag_#{key}"
      Facter.add(fact) { setcode { value } }
    end
  end
end

