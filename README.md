# Personal Budgeting App Demo

This Ruby on Rails budgeting application was created as a demonstration of [Claude Code](https://claude.ai/code), Anthropic's AI coding assistant. The entire application was built through a conversational interaction with Claude Code, showcasing its ability to help developers build full-featured web applications.

## 🤖 Built with Claude Code

This project demonstrates Claude Code's capabilities in:
- Setting up a Rails 8 application from scratch
- Implementing authentication without external gems (no Devise!)
- Creating complex data models and relationships
- Building responsive UI with Tailwind CSS
- Setting up development environment with Docker
- Preparing for production deployment on Heroku

## 🚀 Features

- **User Authentication**: Custom authentication implementation using Rails' `has_secure_password`
- **Budget Management**: Create monthly, goal-based, or annual budgets
- **Expense Tracking**: Track income and expenses across categories
- **Category Management**: Pre-defined and custom spending categories
- **Income Sources**: Track multiple income streams with different frequencies
- **Visual Analytics**: Progress bars, spending breakdowns, and financial summaries
- **Responsive Design**: Mobile-friendly interface built with Tailwind CSS

## 📋 Prerequisites

- Ruby 3.4.5 (managed with mise)
- PostgreSQL (via Docker)
- Node.js (for Rails asset pipeline)

## 🛠️ Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/vestmark/budgeting-demo.git
   cd budgeting-demo
   ```

2. **Install mise (Ruby version manager)**
   ```bash
   curl https://mise.run | sh
   mise install
   ```

3. **Install dependencies**
   ```bash
   bundle install
   ```

4. **Start PostgreSQL with Docker**
   ```bash
   docker compose up -d
   ```

5. **Setup the database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed  # Creates test user: test@example.com / password123
   ```

6. **Start the application**
   ```bash
   bin/dev
   ```

7. **Visit** http://localhost:3000

## 🧪 Test Credentials

- **Email**: test@example.com
- **Password**: password123

## 📱 Key Features Demonstrated

### Authentication System
- Custom authentication using Rails concerns
- Session management
- Password encryption with bcrypt

### Data Models
- User management with automatic category creation
- Budget types: monthly, goal-based, annual
- Transaction tracking with category validation
- Income source management with recurring schedules

### UI/UX
- Clean, modern interface with Tailwind CSS
- Real-time form validations
- Dynamic JavaScript interactions
- Progress visualizations

## 🚢 Deployment

The app is configured for easy deployment to Heroku:

```bash
heroku create your-app-name
heroku config:set RAILS_MASTER_KEY=$(cat config/master.key)
git push heroku main
heroku run rails db:migrate
heroku run rails db:seed  # Optional
```

See [HEROKU_DEPLOYMENT.md](HEROKU_DEPLOYMENT.md) for detailed instructions.

## 💡 About This Demo

This application was built to demonstrate how Claude Code can assist developers in creating production-ready applications. The entire codebase was generated through natural language conversations, showcasing:

- **Code Generation**: Models, controllers, views, and configurations
- **Best Practices**: Following Rails conventions and security practices
- **Problem Solving**: Handling edge cases and implementing complex features
- **Documentation**: Creating clear setup instructions and deployment guides

## 🏗️ Technical Stack

- **Framework**: Ruby on Rails 8.0.2
- **Database**: PostgreSQL
- **CSS Framework**: Tailwind CSS
- **JavaScript**: Stimulus.js with Import Maps
- **Authentication**: Built-in Rails features (no Devise)
- **Development**: Docker for PostgreSQL, mise for Ruby version management

## 📄 License

This is a demonstration project created with Claude Code. Feel free to use it as a reference or starting point for your own projects.

---

Built with ❤️ and [Claude Code](https://claude.ai/code) by Anthropic
