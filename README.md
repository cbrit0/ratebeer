# ratebeer

This repository contains my implementation of the projects and exercises from the [Ruby on Rails Server-Side Web Development](https://github.com/mluukkai/WebPalvelinohjelmointi2023/blob/main/wadror-english.md) course by the University of Helsinki. The main project is **RateBeer**, an application for rating and managing beers, breweries, and related content.  

## Project: RateBeer  

**RateBeer** is a Rails-based application for beer enthusiasts. The app allows users to:  
- Rate and review beers.  
- Explore and manage breweries.  
- Create and manage user accounts.  
- View beer styles, ratings, and recommendations.  

### Features:  
- Rate and review beers.  
- Manage breweries, beers, and user profiles.  
- Authentication with secure password storage (`bcrypt`).  
- Bootstrap integration for responsive design.  
- Background job processing with `sucker_punch`.  
- Comprehensive testing suite using `RSpec` and `Capybara`.  

## Repository Structure  

- **app/**: Core application code (models, controllers, views).  
- **db/**: Database schema, migrations, and seed data.  
- **spec/**: RSpec tests for the application.  
- **config/**: Application configuration files.  

## Getting Started  

### Prerequisites  
- Ruby **3.1.6**  
- Rails **7.0.8**  
- SQLite (development and test environments)  
- PostgreSQL (production environment)  

### Setup  
1. Clone the repository:  
   ```bash  
   git clone https://github.com/cbrit0/ratebeer.git  
   cd ratebeer  

2. Install dependencies:
    ```bash
    bundle install

3. Set up the database:
    ```bash
    rails db:create db:migrate db:seed

4. Run the application:
    ```bash
    rails server  

5. Visit the app in your browser at http://localhost:3000.

## Testing
The project uses RSpec for testing, with support for system tests via Capybara and Selenium.

    rspec

Additional Testing Tools:

- SimpleCov: Tracks test coverage.
- FactoryBot: Generates test data.
- WebMock: Stubs HTTP requests.

[![Maintainability](https://api.codeclimate.com/v1/badges/63ab2b42737618aebc62/maintainability)](https://codeclimate.com/github/cbrit0/ratebeer/maintainability)