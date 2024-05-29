class VillasController < ApplicationController
  before_action :check_params
  def index
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    # Calculate the number of nights
    number_of_nights = (end_date - start_date).to_i

    # Use ActiveRecord to filter villas with the correct availability and calculate the total rate
    villas_with_total_rate = Villa.joins(:calendar_entries)
                                  .where(calendar_entries: { date: start_date...end_date })
                                  .group('villas.id')
                                  .having('COUNT(calendar_entries.id) = ?', number_of_nights)
                                  .select('villas.*, SUM(calendar_entries.rate) AS total_rate')

    # Calculate average price per night and construct the final data structure
    villas = villas_with_total_rate.map do |villa|
      {
        villa: villa,
        average_price_per_night: villa.total_rate / number_of_nights,
        available: true
      }
    end


    # Sort the villas
    sort_by = params[:sort_by] || 'average_price_per_night'
    order = params[:order] || 'asc'

    if villas.present?
      villas.sort_by! { |villa| villa[sort_by.to_sym] }
      villas.reverse! if order == 'desc'
      render json: { villas: villas}, status: 200
    else 
      render json: {message: "villas are not available on this date"}, status: 404
    end
  end


  private

  def check_params
    return render json: {error: "dates are invalid"}, status: 422 unless params[:start_date] && params[:end_date] && params[:end_date] >= params[:start_date]
  end
end
