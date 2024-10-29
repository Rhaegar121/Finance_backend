require 'roo'
require_relative '../config/environment'

def load_transactions_from_excel(file_path)
  # Open the Excel file
  xlsx = Roo::Excelx.new(file_path)
  
  # Select the first sheet or specify if you know the name: xlsx.sheet('Sheet1')
  xlsx.default_sheet = xlsx.sheets.first
  
  # Prepare an array to hold all transactions
  transactions = []
  
  # Iterate over each row in the sheet starting from row 2 assuming row 1 contains headers
  (2..xlsx.last_row).each do |row|
    date = xlsx.cell(row, 'A')  # Column A: Date
    amount = xlsx.cell(row, 'B') # Column B: Amount
    description = xlsx.cell(row, 'C') # Column C: Description
    category = xlsx.cell(row, 'D') # Column D: Category
    
    # Append each transaction to the array
    transactions << { date: date, amount: amount, description: description, category: category }
  end
  
  # Now transactions array can be used to seed data or further processing
  transactions
end

transactions = load_transactions_from_excel('Finance data.xlsx')

#print the transactions
transactions.each do |transaction|
  Transaction.create!(transaction)
end
