require 'dsars'

class Dsars::Dsars5233 < Dsars::Client
  self.list_url = '/Data/5233/Search.aspx'
  self.get_url = '/Data/5233/5233.aspx'
  self.form_type = '5233'

  def list_attributes(node)
    attrs = {
      incident_number: './col4',
      dro_number: './col2',
      incident_name: './col5',
      report_number: './col6', 
      report_id: './col1',
      cob_date: './col11',
      status: './col9'
    }.map{|name, col| [name, node.xpath(col).text]}
    attrs = Hash[attrs]
  end

  class Report
    def initialize(xml)
      scopes = []
      form = xml.xpath('//form5233').first
      form.xpath('./@*').select{|n| n.name =~ /f15\d+/}.each do |attr|
        id = /^f15(\d+)$/.match(attr.name)[1]
        scopes << Scope.new(form, id, form.attr('f13' + id), form.attr('f12' + id), form.attr('f14'), form.attr('f15' + id))      end
      @scopes = scopes
    end

    attr_accessor :scopes

    def consolidated
      scopes.detect{|s| s.type == 'Consolidated'}
    end

    def chapter(id_or_name)
      scopes.detect{|s| s.type == 'Chapter' && (s.unit_name == id_or_name || s.unit_id == id_or_name)}
    end

    def county(id_or_name)
      scopes.detect{|s| s.type == 'County' && (s.county_id == id_or_name || s.county_name == id_or_name)}
    end

    Scope = Struct.new(:node, :id, :unit_id, :unit_name, :county_id, :county_name) do
      def self.pretty_print_instance_variables
        super - "@node"
      end

      def parse_int(val)
        val == "" ? nil : val.to_i
      end

      MAPPING = {
        'sfd_destroyed' => 19, 'sfd_major' =>  20, 'sfd_minor' =>  21, 'sfd_affected'=> 22, 'sfd_total' => 23, 'sfd_inaccessible' => 24,
        'mh_destroyed' => 25, 'mh_major' =>  26, 'mh_minor' =>  27, 'mh_affected'=> 28, 'mh_total' => 29, 'mh_inaccessible' => 30,
        'apt_destroyed' => 31, 'apt_major' =>  32, 'apt_minor' =>  33, 'apt_affected'=> 34, 'apt_total' => 35, 'apt_inaccessible' => 36,
        'total' => 37, 'completion' => 38
      }

      def attributes
        Hash[MAPPING.map{|n, line| [n, self[line]]}]
      end

      def [](row_num)
        parse_int(node.attr("f#{row_num}#{self.id}"))
      end
    end

  end

  self.report_class = Report
end