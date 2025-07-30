# Project Overview

This is a Ruby on Rails 8 application for budgeting.

## Technology Stack

- Ruby: 3.3.0 (latest stable)
- Rails: 8.0.0
- Database: PostgreSQL
- Ruby version manager: mise
- Test framework: Minitest (Rails default)
- Asset pipeline: Propshaft (Rails 8 default)
- CSS: Tailwind CSS (Rails 8 default)
- JavaScript: Importmap (Rails 8 default)

## Setup Instructions

1. Install mise if not already installed:
   ```bash
   curl https://mise.run | sh
   ```

2. Install Ruby and project dependencies:
   ```bash
   mise install
   bundle install
   ```

3. Setup database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server:
   ```bash
   bin/dev
   ```

## Key Commands

- Run tests: `rails test`
- Run linter: `bundle exec standardrb`
- Fix linting issues: `bundle exec standardrb --fix`
- Run console: `rails console`
- Run database migrations: `rails db:migrate`
- Run seeds: `rails db:seed`
- View routes: `rails routes`

## Project Structure

- `app/controllers/` - Application controllers
- `app/models/` - ActiveRecord models
- `app/views/` - View templates (ERB)
- `app/javascript/` - JavaScript files (using Importmap)
- `app/assets/` - Static assets and stylesheets
- `config/` - Application configuration
- `db/` - Database migrations and schema
- `test/` - Test files (Minitest)
- `bin/` - Executable scripts

## Authentication

This project uses Rails' built-in authentication features without Devise:
- Custom authentication implementation in `app/controllers/concerns/authentication.rb`
- Session-based authentication
- BCrypt for password hashing (via `has_secure_password`)

## Development Guidelines

1. Follow Rails conventions and best practices
2. Use StandardRB for Ruby code formatting
3. Write tests for all new features
4. Use strong parameters in controllers
5. Follow RESTful routing conventions
6. Use Rails concerns for shared functionality
7. Keep controllers thin, models fat
8. Use service objects for complex business logic

## Testing

- Run all tests: `rails test`
- Run specific test file: `rails test test/models/user_test.rb`
- Run system tests: `rails test:system`

## Common Tasks

### Creating a new model
```bash
rails generate model ModelName field:type
rails db:migrate
```

### Creating a new controller
```bash
rails generate controller ControllerName action1 action2
```

### Adding a new gem
1. Add to Gemfile
2. Run `bundle install`
3. Restart server if needed

## mise Configuration

The project uses `.mise.toml` for Ruby version management:
```toml
[tools]
ruby = "3.3.0"
```