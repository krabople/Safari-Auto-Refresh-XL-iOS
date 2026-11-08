require "base64"
require "json"
require "net/http"
require "openssl"
require "uri"

def base64url(value) = Base64.urlsafe_encode64(value).delete("=")
def fixed_width(value) = [value.to_i.to_s(16).rjust(64, "0")].pack("H*")

now = Time.now.to_i
header = base64url({alg: "ES256", kid: ENV.fetch("APPSTORE_KEY_ID"), typ: "JWT"}.to_json)
payload = base64url({iss: ENV.fetch("APPSTORE_ISSUER_ID"), iat: now, exp: now + 900, aud: "appstoreconnect-v1"}.to_json)
unsigned = "#{header}.#{payload}"
key = OpenSSL::PKey.read(ENV.fetch("APPSTORE_PRIVATE_KEY"))
signature = key.dsa_sign_asn1(OpenSSL::Digest::SHA256.digest(unsigned))
parts = OpenSSL::ASN1.decode(signature).value
token = "#{unsigned}.#{base64url(parts.map { |part| fixed_width(part.value) }.join)}"

uri = URI("https://api.appstoreconnect.apple.com/v1/builds")
uri.query = URI.encode_www_form(
  "filter[app]" => "6809041904",
  "fields[builds]" => "version,processingState,uploadedDate,expired",
  "limit" => "50"
)
request = Net::HTTP::Get.new(uri)
request["Authorization"] = "Bearer #{token}"
response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
abort "App Store Connect returned #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

builds = JSON.parse(response.body).fetch("data")
puts "App Store Connect returned #{builds.length} Listello build record(s)."
builds.sort_by { |build| build.dig("attributes", "uploadedDate").to_s }.reverse_each do |build|
  attributes = build.fetch("attributes")
  puts [
    "build=#{attributes["version"]}",
    "state=#{attributes["processingState"]}",
    "uploaded=#{attributes["uploadedDate"]}",
    "expired=#{attributes["expired"]}",
    "id=#{build["id"]}"
  ].join(" ")
end
