# 🍕 Food Ordering Website

This is a full-stack web application for managing food orders and restaurant operations. It enables customers to browse products, manage shopping carts, and place orders through a responsive and user-friendly interface. The system includes role-based access, allowing admins to manage products and orders across all users. Built with modern technologies, it is designed to be both functional and beautiful.

---

## ✨ Features

- 🔐 *User Authentication* - Secure registration and login using JWT-based authentication with Devise.
- 👥 *Role Management*
  - Regular users can browse products, manage their cart, and place orders.
  - Admins have full visibility and control over all products and orders.
- 🛍️ *Product Management* - Browse products by category with detailed information and pricing.
- 🛒 *Shopping Cart System*
  - Add, update, and remove items from cart.
  - Persistent cart management across sessions.
- 📦 *Order Management*
  - Place orders with cart items.
  - Track order status (pending, completed, cancelled).
  - Reorder functionality for previous orders.
- ✏️ *Edit & Delete* - Modify or remove cart items and orders with proper validation.
- 🔍 *Filtering & Sorting*
  - Browse products by category.
  - View order history and status.
- 📊 *Admin Dashboard*
  - Manage all products (CRUD operations).
  - Monitor and update order statuses.
  - Full order management capabilities.
- 🌐 *API-First Design*
  - RESTful API endpoints for all operations.
  - JSON API serialization for consistent data format.
  - Comprehensive API documentation with Apipie.

---

## 🛠 Tech Stack

- *Backend*: Ruby on Rails 8.0.2 - Modern Rails with latest features
- *Database*: SQLite3 (development)
- *Authentication*: Devise with JWT tokens for secure API access
- *API Serialization*: JSON API Serializer and Alba for flexible data formatting
- *Testing*: RSpec with Factory Bot for comprehensive testing
- *Documentation*: Apipie for API documentation generation

---

## 🔒 Security

- Passwords are securely hashed using bcrypt.
- All protected API endpoints require a valid JWT token.
- Admin routes are enforced with role-based access control.

---

## 🎯 Purpose

This project demonstrates a complete, real-world web application for food ordering and restaurant management. It showcases modern Rails development practices, secure authentication, comprehensive API design, and user experience focused features like shopping cart management and order tracking. The system is designed to handle real restaurant operations with proper validation and error handling.

---

## 🚀 Getting Started

### Prerequisites
- Ruby 3.2.2
- Rails 8.0.2
- SQLite3

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Ana-Bogdan/FoodOrderingWebsite.git
cd FoodOrderingWebsite
```

2. Install dependencies:
```bash
bundle install
```

3. Set up the database:
```bash
rails db:create
rails db:migrate
rails db:seed
```

4. Start the server:
```bash
rails server
```

5. Visit `http://localhost:3000` in your browser.

### API Documentation

When running in development mode, visit `/apipie` for comprehensive API documentation.

---

## 📁 Project Structure

```
app/
├── controllers/         # Web and API controllers
│   ├── api/v1/          # RESTful API endpoints
│   └── admin/           # Admin-specific controllers
├── models/              # Data models and business logic
├── serializers/         # JSON API serialization
├── views/               # Web interface templates
└── assets/              # CSS, JavaScript, and images

config/                  # Application configuration
db/                      # Database migrations and seeds
spec/                    # RSpec test suite
```

---

## 🔧 Development

### Running Tests
```bash
bundle exec rspec
```

### Code Quality
```bash
bundle exec rubocop
```

### Database Console
```bash
rails console
```

---

*Built with ❤️ using Ruby on Rails*
