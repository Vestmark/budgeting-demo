# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Create test user
test_user = User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.first_name = "Test"
  user.last_name = "User"
end

puts "✅ Created test user: test@example.com (password: password123)"

# Get the user's categories (they should be auto-created)
housing_category = test_user.categories.find_by(name: "Housing")
transportation_category = test_user.categories.find_by(name: "Transportation")
food_category = test_user.categories.find_by(name: "Food")
entertainment_category = test_user.categories.find_by(name: "Entertainment")
healthcare_category = test_user.categories.find_by(name: "Healthcare")
salary_category = test_user.categories.find_by(name: "Salary")
freelance_category = test_user.categories.find_by(name: "Freelance")

# Create income sources
salary_income = IncomeSource.find_or_create_by!(
  user: test_user,
  name: "Main Job Salary"
) do |income|
  income.amount = 5000
  income.frequency = "monthly"
  income.category = salary_category
  income.start_date = 6.months.ago
  income.active = true
end

freelance_income = IncomeSource.find_or_create_by!(
  user: test_user,
  name: "Freelance Projects"
) do |income|
  income.amount = 1500
  income.frequency = "monthly"
  income.category = freelance_category
  income.start_date = 3.months.ago
  income.active = true
end

puts "✅ Created income sources"

# Create budgets
monthly_budget = Budget.find_or_create_by!(
  user: test_user,
  name: "Monthly Expenses Budget",
  budget_type: "monthly"
) do |budget|
  budget.amount = 4500
  budget.start_date = Date.current.beginning_of_month
  budget.end_date = Date.current.end_of_month
end

# Add categories to monthly budget
[
  { category: housing_category, amount: 1500 },
  { category: transportation_category, amount: 500 },
  { category: food_category, amount: 800 },
  { category: entertainment_category, amount: 300 },
  { category: healthcare_category, amount: 200 }
].each do |budget_cat|
  BudgetCategory.find_or_create_by!(
    budget: monthly_budget,
    category: budget_cat[:category]
  ) do |bc|
    bc.amount = budget_cat[:amount]
  end
end

vacation_budget = Budget.find_or_create_by!(
  user: test_user,
  name: "Summer Vacation Fund",
  budget_type: "goal_based"
) do |budget|
  budget.amount = 3000
  budget.start_date = 2.months.ago
  budget.end_date = 4.months.from_now
end

puts "✅ Created budgets"

# Create transactions for the current month
current_month_transactions = [
  # Income transactions
  { date: Date.current.beginning_of_month, amount: 5000, description: "Monthly Salary", category: salary_category, transaction_type: "income" },
  { date: Date.current.beginning_of_month + 5.days, amount: 750, description: "Website Project", category: freelance_category, transaction_type: "income" },
  { date: Date.current.beginning_of_month + 15.days, amount: 750, description: "Logo Design Project", category: freelance_category, transaction_type: "income" },
  
  # Expense transactions
  { date: Date.current.beginning_of_month + 1.day, amount: 1500, description: "Rent Payment", category: housing_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 2.days, amount: 125, description: "Electricity Bill", category: housing_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 3.days, amount: 85, description: "Internet Bill", category: housing_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 4.days, amount: 65, description: "Gas for Car", category: transportation_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 5.days, amount: 145, description: "Grocery Shopping", category: food_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 7.days, amount: 35, description: "Lunch with Friends", category: food_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 8.days, amount: 15, description: "Netflix Subscription", category: entertainment_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 10.days, amount: 75, description: "Doctor Visit Copay", category: healthcare_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 12.days, amount: 250, description: "Weekly Grocery Run", category: food_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 14.days, amount: 45, description: "Movie Tickets", category: entertainment_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 16.days, amount: 80, description: "Gas Fillup", category: transportation_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 18.days, amount: 180, description: "Grocery Shopping", category: food_category, transaction_type: "expense" },
  { date: Date.current.beginning_of_month + 20.days, amount: 50, description: "Uber Rides", category: transportation_category, transaction_type: "expense" }
]

# Create some transactions from previous month
previous_month_transactions = [
  { date: 1.month.ago.beginning_of_month, amount: 5000, description: "Monthly Salary", category: salary_category, transaction_type: "income" },
  { date: 1.month.ago.beginning_of_month + 1.day, amount: 1500, description: "Rent Payment", category: housing_category, transaction_type: "expense" },
  { date: 1.month.ago.beginning_of_month + 5.days, amount: 500, description: "Website Maintenance", category: freelance_category, transaction_type: "income" },
  { date: 1.month.ago.beginning_of_month + 10.days, amount: 600, description: "Monthly Groceries", category: food_category, transaction_type: "expense" },
  { date: 1.month.ago.beginning_of_month + 15.days, amount: 200, description: "Entertainment", category: entertainment_category, transaction_type: "expense" }
]

all_transactions = current_month_transactions + previous_month_transactions

all_transactions.each do |trans_data|
  Transaction.find_or_create_by!(
    user: test_user,
    date: trans_data[:date],
    description: trans_data[:description]
  ) do |transaction|
    transaction.amount = trans_data[:amount]
    transaction.category = trans_data[:category]
    transaction.transaction_type = trans_data[:transaction_type]
  end
end

puts "✅ Created #{all_transactions.length} transactions"

# Create some savings transactions for the vacation budget
vacation_savings = [
  { date: 2.months.ago, amount: 500, description: "Vacation Savings", category: test_user.categories.find_by(name: "Savings & Investments"), transaction_type: "expense" },
  { date: 1.month.ago, amount: 500, description: "Vacation Savings", category: test_user.categories.find_by(name: "Savings & Investments"), transaction_type: "expense" },
  { date: Date.current.beginning_of_month, amount: 500, description: "Vacation Savings", category: test_user.categories.find_by(name: "Savings & Investments"), transaction_type: "expense" }
]

vacation_savings.each do |trans_data|
  Transaction.find_or_create_by!(
    user: test_user,
    date: trans_data[:date],
    description: trans_data[:description]
  ) do |transaction|
    transaction.amount = trans_data[:amount]
    transaction.category = trans_data[:category]
    transaction.transaction_type = trans_data[:transaction_type]
  end
end

puts "✅ Created vacation savings transactions"
puts "🎉 Seed data created successfully!"
puts "\n📧 Login with: test@example.com / password123"
