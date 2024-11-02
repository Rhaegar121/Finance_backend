class TransactionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_transaction, only: [:update, :destroy]

  def create
    @transaction = Transaction.new(transaction_params)
    
    if @transaction.save
      render json: @transaction, status: :created
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      render json: { message: 'Transaction updated successfully', transaction: @transaction }, status: :ok
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    if @transaction.destroyed?
      render json: { message: 'Transaction deleted successfully' }, status: :ok
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

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

  private
  # Only allow a trusted parameter "white list" through.
  def transaction_params
    params.require(:transaction).permit(:date, :amount, :description, :category, :income)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Transaction not found' }, status: :not_found
  end
end
