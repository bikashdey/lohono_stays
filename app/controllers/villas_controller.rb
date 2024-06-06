class VillasController < ApplicationController
  before_action :check_params
 
  def index
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    number_of_nights = (end_date - start_date).to_i

    # Fetch all villas and their calendar entries for the given date range
    villas_with_entries = Villa.includes(:calendar_entries)
                               .where(calendar_entries: { date: start_date...end_date })
                               .references(:calendar_entries)
    villas = villas_with_entries.map do |villa|
      calendar_entries = villa.calendar_entries.select { |entry| entry.date >= start_date && entry.date < end_date }

      # Checking if the nights are matching with total calender_entries and all should be  available then villa will show available otherwise it will show villa not availble 
      available = calendar_entries.length == number_of_nights && calendar_entries.all?(&:available)

      total_rate = calendar_entries.sum(&:rate)
      average_price_per_night = total_rate / number_of_nights if number_of_nights > 0

      {
        villa: villa,
        average_price_per_night: average_price_per_night,
        available: available
      }
    end

    # Sort the villas based on availability and the selected sorting criteria
    sort_by = params[:sort_by] || 'average_price_per_night'
    order = params[:order] || 'asc'

    if villas.present?
      # Sort first by availability, then by the specified sorting criterion
      villas.sort_by! { |villa| [villa[:available] ? 0 : 1, villa[sort_by.to_sym]] }
      villas.reverse! if order == 'desc'
      render json: { villas: villas }, status: 200
    else
      render json: { message: "No villas available for the specified dates" }, status: 404
    end
  end


  # api for total rate with gst for given dates

  def total_gst_rate_for_villa    
    villa = Villa.find_by(id: params[:villa_id])
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])
    
    total_days = (end_date - start_date).to_i

    if villa.present?
      calendar_entries = villa.calendar_entries.where(date: start_date...end_date, available: true)
      
      available_days = calendar_entries.count
      total_rate = calendar_entries.sum(:rate)
      
      if available_days == total_days
        total_rate_with_gst = total_rate * 1.18
        render json: { available: true, total_rate_with_gst: total_rate_with_gst }
      else
        render json: { available: false, total_rate: 0 }
      end
    else
      render json: {message: "villa not found"}, status: 404
    end
  end

  private

  def check_params
    if params[:start_date].present? && params[:end_date].present?
      begin
        start_date = Date.parse(params[:start_date])
        end_date = Date.parse(params[:end_date])
        if end_date < start_date
          render json: { error: "end_date cannot be earlier than start_date" }, status: 422
        end
      rescue ArgumentError
        render json: { error: "Invalid date format" }, status: 422
      end
    else
      render json: { error: "start_date and end_date are required" }, status: 422
    end
  end
end
