require 'puppet'
require 'puppet/network/http_pool'
require 'uri'
require 'yaml'

Puppet::Reports.register_report(:multi_http) do

  configfile = File.join(Puppet[:confdir], 'multi_http.yaml')
  raise(Puppet::ParseError, "Could not find #{configfile}") unless File.exist?(configfile)
  CONFIG = YAML.load_file(configfile)

  desc <<-DESC
    Functions exactly the same as the built-in HTTP report processor, but supports
    posting to multiple URLs. This is useful if you wish to use Puppet Dashboard
    with another service that works over HTTP.
  DESC

  def process
    CONFIG[:urls].each do |url|
      begin
        process_url url
      rescue => e
        Puppet.err "Unable to submit report to #{url.to_s} [#{e.message}]"
      end
    end
  end

  def process_url(url)
    url = URI.parse(url)
    body = self.to_yaml
    headers = { "Content-Type" => "application/x-yaml" }
    use_ssl = url.scheme == 'https'
    conn = Puppet::Network::HttpPool.http_instance(url.host, url.port, use_ssl)
    response = conn.post(url.path, body, headers)
    unless response.kind_of?(Net::HTTPSuccess)
      Puppet.err "Unable to submit report to #{url.to_s} [#{response.code}] #{response.msg}"
    end
  end
end

