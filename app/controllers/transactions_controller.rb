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

  def filter
    if params[:month_year].present?
      date = Date.strptime(params[:month_year], "%B %Y")
      start_date = date.beginning_of_month
      end_date = date.end_of_month
    elsif params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])
    else
      render json: { error: 'Invalid or missing parameters' }, status: :bad_request and return
    end

    @transactions = Transaction.where(date: start_date..end_date)
    render json: @transactions
  end

  def search
    if params[:date].present?

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
  def transaction_params
    params.require(:transaction).permit(:date, :amount, :description, :category, :income)
  end

  def set_transaction
    @transaction = Transaction.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Transaction not found' }, status: :not_found
  end
end
