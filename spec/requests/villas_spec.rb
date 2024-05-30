require 'rails_helper'

RSpec.describe "Villas API", type: :request do
  let!(:villa) { create(:villa) }
  let!(:start_date) { '2021-01-01' }
  let!(:end_date) { '2021-01-05' }
  let!(:headers) { { "Content-Type" => "application/json" } }

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

  
  describe "GET /total_gst_rate_for_villa" do
    context "when the villa is available" do
      it "returns the total rate with GST" do
        get '/villas/total_gst_rate_for_villa', params: { villa_id: villa.id, start_date: start_date, end_date: end_date }, headers: headers
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['total_rate_with_gst']).to eq(40_000 * 4 * 1.18)
        expect(JSON.parse(response.body)['available']).to be true
      end
    end

    context "when the villa is not available for all days" do
      before do
        villa.calendar_entries.where(date: '2021-01-03').update_all(available: false)
        get '/villas/total_gst_rate_for_villa', params: { villa_id: villa.id, start_date: start_date, end_date: end_date }, headers: headers
      end

      it "returns availability as false and total rate as 0" do
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['available']).to be false
        expect(JSON.parse(response.body)['total_rate']).to eq(0)
      end
    end

    context "when the villa is not found" do
      before { get '/villas/total_gst_rate_for_villa', params: { villa_id: 0, start_date: start_date, end_date: end_date }, headers: headers }

      it "returns a 404 status" do
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['message']).to eq("villa not found")
      end
    end
  end
end
