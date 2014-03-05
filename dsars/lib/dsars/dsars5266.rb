require 'dsars'

class Dsars::Dsars5266 < Dsars::Client

  self.list_url = '/Data/5266/Search.aspx'

  def list_attributes(node)
    attrs = {
      incident_number: './col3',
      dro_number: './col2',
      incident_name: './col4',
      report_number: './col5', 
      report_id: './col1',
      cob_date: './col10',
      status: './col8',
      form_type: './col12'
    }.map{|name, col| [name, node.xpath(col).text]}
    attrs = Hash[attrs]
  end

  def get_url(report_item)
    VERSIONS[report_item.form_type].get_url
  end

  def report_class(report_item)
    VERSIONS[report_item.form_type].const_get 'Report'
  end

  def form_type(report_item)
    VERSIONS[report_item.form_type].form_type
  end

  class Report
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
  end

  Scope = Struct.new(:node, :id, :type, :unit_id, :unit_name, :county_id, :county_name) do
      def self.pretty_print_instance_variables
        super - "@node"
      end

      def parse_int(val)
        val == "" ? nil : val.to_i
      end

      def [](row_num)
        {previous: parse_int(node.attr("L#{row_num}PR#{self.id}")), period: parse_int(node.attr("L#{row_num}PD#{self.id}")), total: parse_int(node.attr("L#{row_num}TO#{self.id}")), changed: (node.attr("L#{row_num}PR#{self.id}") == 'True')}
      end
    end

  self.report_class = Report

  class Version
    class_attribute :version_number
    class_attribute :form_type
    class_attribute :get_url
  end

  class Version1 < Version
    self.version_number = 1
    self.form_type = "5266"
    self.get_url = '/Data/5266/5266.aspx'

    class Report < Dsars::Dsars5266::Report
      def num_lines; 76; end
      def version; 1; end

      def initialize(xml)
        form = xml.xpath('//form5266').first
        @scopes = [Dsars::Dsars5266::Scope.new(form, '', 'Consolidated', '', '', '', '')]
      end
    end
  end

  class Version2 < Version
    self.version_number = 2
    self.form_type = "5266V2"
    self.get_url = '/Data/5266/Misc.aspx'

    class Report < Dsars::Dsars5266::Report
      def num_lines; 165; end
      def version; 2; end

      def initialize(xml)
        form = xml.xpath('//form5266').first
        @scopes = [Dsars::Dsars5266::Scope.new(form, '', 'Consolidated', '', '', '', '')]
      end
    end
  end

  class Version4 < Version
    self.form_type = "5266v4"
    self.get_url = '/Data/5266/5266v4.aspx'

    class Report < Report
      def num_lines; 145; end
      def version; 4; end

      def initialize(xml)
        scopes = []
        forms = xml.xpath('//*[starts-with(name(), \'form5266\')]')
        forms.each do |form|
          form.xpath('./@*').select{|n| n.name =~ /L1PD\d+/}.each do |attr|
            id = /^L1PD(\d+)$/.match(attr.name)[1]
            scopes << Dsars::Dsars5266::Scope.new(form, id, form.attr('L148' + id), form.attr('L146' + id), form.attr('L146' + id + 'name'), form.attr('L147' + id), form.attr('L147' + id + 'name'))
            name = form.attr('L146' + id)
          end
        end
        @scopes = scopes
      end
    end
  end

  VERSIONS = {
    "Revised June - 2010 FY11" => Version4,
    "Revised August '06" => Version2,
    "Prior to August '06" => Version1
  }

end