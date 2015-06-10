module Helpers
  def expect_response_has_error(status, message=nil)
      expect(response.status).to eq(status)
      expect(response.body.downcase).to include(message) if message
  end

  def expect_response_to_have(expected_keys=[], expected_values={})
      json = JSON.parse(response.body).with_indifferent_access
      expected_keys.each do |key|
          expect(json.has_key?(key)).to be_truthy
      end

      expected_values.each do |key, value|
          expect(json.has_key?(key)).to be_truthy
          expect(json[key]).to eq(value)
      end
  end
end
