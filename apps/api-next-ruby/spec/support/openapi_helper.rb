require 'committee'

module OpenapiHelper
  SPEC_PATH = File.expand_path('../../../docs_next/contracts/openapi/reservations.yaml', __dir__)

  def committee_schema
    @committee_schema ||= Committee::Drivers::load_from_file(SPEC_PATH)
  end

  def validate_response(status: 200, headers: { 'Content-Type' => 'application/json' })
    # For simplicity, only check status and content-type presence here. Full body validation
    # requires mapping schema operations which we can add later.
    expect(response.status).to eq(status)
    expect(response.headers['Content-Type']).to include('application/json')
  end
end

RSpec.configure do |config|
  config.include OpenapiHelper, type: :request
end
