require 'rails_helper'

RSpec.describe "Sums", type: :request do
  describe "POST /sum" do
    it "returns sum of numbers in string" do
      post "/sum", params: { input: "1,2,3" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 6 })
    end

    it "returns 0 for empty string" do
      post "/sum", params: { input: "" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 0 })
    end

    it "handles non-digit characters" do
      post "/sum", params: { input: "a1b2c3" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 6 })
    end

    it "handles non-digit characters" do
      post "/sum", params: { input: "1,2\n3\n4" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 10 })
    end

    it "handles non-digit characters" do
      post "/sum", params: { input: "//;\n1;2" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 3 })
    end
    
    it "returns error for negative numbers" do
      post "/sum", params: { input: "1,-2,3,-4" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to eq({ "error" => "negative numbers are not allowed: -2, -4" })
    end
    
    it "handles non-digit characters" do
      post "/sum", params: { input: "//[***]\n1***2***3" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 6 })
    end
      
    it "handles non-digit characters" do
      post "/sum", params: { input:  "//[*][%]\n1*2%3" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 6 })
    end

    it "ignores numbers 1000 or more" do
      post "/sum", params: { input: "2,1000,2008,3" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 5 })
    end

    it "sums numbers from a real-world sentence" do
      post "/sum", params: { input: "22 buses having 368 passengers going in 12 different directions" }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "sum" => 402 })
    end
   
  end
end