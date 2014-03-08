require 'httparty'
require 'nokogiri'
require 'date'

class Dsars::Client
  include HTTParty
  base_uri 'https://dsars.redcross.org'
  #debug_output

  class_attribute :list_url
  class_attribute :get_url
  class_attribute :form_type
  class_attribute :report_class

  def list_reports(incident_number, only_status=[:approved, :submitted])
    resp = self.class.get(list_url, query: {startrecord: 1, endrecord: 500, sortorder: 'ascending', sortcolumn: 'col2', incid: incident_number, searchtype: 'advanced'}, cookies: self.cookies)
  
    xml = Nokogiri::XML(resp.body)
    list = xml.xpath('//row').map{|node| ReportListItem.from_row(self, self.list_attributes(node)) }.select{|item| only_status.include? item.status}
  end

  def get_report(report_item)
    resp = self.class.get(get_url(report_item), cookies: self.cookies, body: { "Open#{form_type(report_item)}" => 'true', id: report_item.report_id})

    xml = Nokogiri::XML(resp.body)
    unless xml.xpath("//status").text == "success"
      raise "Error retrieving report"
    end
    report_class(report_item).new(xml)
  end

  def get_url(report_item)
    self.class.get_url
  end

  def list_url
    self.class.list_url
  end

  def report_class(report_item)
    self.class.report_class
  end

  def form_type(report_item)
    self.class.form_type
  end

  attr_accessor :cookies

  def login(username, password)
    resp = self.class.get('/Login.aspx')

    viewstate = /id="__VIEWSTATE" value="([^"]+)"/.match(resp.body)[1]
    validation = /id="__EVENTVALIDATION" value="([^"]+)"/.match(resp.body)[1]

    resp = self.class.post('/Login.aspx', body: {txtUserName: username, txtPassword: password, ButtonLogin: 'OK', "__EVENTVALIDATION" => validation, "__VIEWSTATE" => viewstate})

    self.cookies = HTTParty::CookieHash.new
    resp.headers.get_fields('Set-Cookie').each {|h| self.cookies.add_cookies h}
  end

  ReportListItem = Struct.new(:dsars, :incident_number, :dro_number, :incident_name, :report_number, :report_id, :cob_date, :status, :form_type) do
    def self.from_row(query, attrs)
      attrs[:status] = case attrs[:status]
        when 'Approved' then :approved
        when 'Submitted' then :submitted
        else :unsubmitted
      end
      attrs[:cob_date] = Time.strptime(attrs[:cob_date], "%m/%d/%Y").to_date

      item = self.new(query)
      attrs.each do |attr, val|
        item.send "#{attr}=", val
      end
      item
    end

    def report
      @report ||= dsars.get_report(self)
    end
  end
end
