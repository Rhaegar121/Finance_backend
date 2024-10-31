class TransactionsController < ApplicationController
  def by_month
    month_year = params[:month_year]
    date = Date.strptime(month_year, "%B %Y") 

    # Calculate start and end dates
    start_date = date.beginning_of_month
    end_date = date.end_of_month

    # Fetch transactions within the given month
    @transactions = Transaction.where(date: start_date..end_date)

    # Assuming you might want to render these transactions as JSON
    render json: @transactions
  end

  def by_date_range
    # Retrieve start and end dates from params
    start_date = params[:start_date]
    end_date = params[:end_date]

    # Convert string dates to Date objects (assuming the format is YYYY-MM-DD)
    start_date = Date.parse(start_date)
    end_date = Date.parse(end_date)

    # Fetch transactions within the given date range
    @transactions = Transaction.where(date: start_date..end_date)

    # Render the transactions as JSON
    render json: @transactions
  end

  def search
    # Ensure date parameter is present
    if params[:date].present?
      # Parse the date to ensure valid formatting and to avoid SQL injection
      begin
        date = Date.parse(params[:date])
        @transactions = Transaction.where(date: date)
        render json: @transactions
      rescue ArgumentError
        render json: { error: 'Invalid date format' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Date parameter is required' }, status: :bad_request
    end
  end
end
