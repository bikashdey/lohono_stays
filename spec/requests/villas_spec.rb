require 'rails_helper'

RSpec.describe "Villas API", type: :request do
  let!(:villa) { create(:villa) }
  let(:start_date) { '2021-01-01' }
  let(:end_date) { '2021-01-05' }
  let(:headers) { { "Content-Type" => "application/json" } }

  before do
    villa.calendar_entries.where(date: start_date...end_date).update_all(available: true, rate: 40_000)
  end

  describe "GET /villas" do
    context "when villas are available" do
      before { get '/villas', params: { start_date: start_date, end_date: end_date }, headers: headers }

      it "returns the villas" do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['villas']).not_to be_empty
        expect(JSON.parse(response.body)['villas'].size).to eq(1)
      end

      it "returns the average price per night" do
        expect(JSON.parse(response.body)['villas'].first['average_price_per_night']).to eq(40_000)
      end

      it "returns the availability as true" do
        expect(JSON.parse(response.body)['villas'].first['available']).to be true
      end
    end

    context "when villas are not available" do
      before do
        villa.calendar_entries.where(date: '2021-01-03').update_all(available: false)
        get '/villas', params: { start_date: start_date, end_date: end_date }, headers: headers
      end

      it "returns a 404 status" do
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['message']).to eq("villas are not available on this date")
      end
    end

    context "when date params is invalid" do
      it "returns the missing date" do
      	get '/villas', params: { start_date: start_date, end_date: nil }, headers: headers
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq("dates are invalid")
      end

      it "returns the invalid date" do
      	get '/villas', params: { start_date: start_date, end_date: '2020-09-19' }, headers: headers
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq("dates are invalid")
      end
    end
  end
end
