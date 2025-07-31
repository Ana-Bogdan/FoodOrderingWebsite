# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Product.create!([
  { name: "Pasta Carbonara", category: "Second courses", vegetarian: false, price: 25.00, image: "https://i.pinimg.com/736x/f1/cf/4e/f1cf4eca27e0fa3dc35e1e0efde3c2ce.jpg" },
  { name: "Chicken Soup", category: "Entrees", vegetarian: false, price: 16.00, image: "https://www.kindpng.com/picc/m/242-2423145_food-hd-png-download.png" },
  { name: "Vitamin Salad", category: "Salads", vegetarian: true, price: 20.00, image: "https://www.kindpng.com/picc/m/69-694225_plate-food-png-free-transparent-png.png" },
  { name: "Pasta With Walnut", category: "Second courses", vegetarian: true, price: 27.00, image: "https://www.pngitem.com/pimgs/m/114-1147086_plate-of-spaghetti-png-pasta-png-transparent-png.png" },
  { name: "Fancy Steak", category: "Main courses", vegetarian: false, price: 32.00, image: "https://www.kindpng.com/picc/m/152-1520145_food-sutherland-foodservice-plate-of-food-png-transparent.png" },
  { name: "Chicken With Potatoes", category: "Main courses", vegetarian: false, price: 30.00, image: "https://www.kindpng.com/picc/m/4-41391_food-on-plate-png-transparent-png.png" },
  { name: "Pepperoni Pizza", category: "Second courses", vegetarian: false, price: 23.00, image: "https://plus.unsplash.com/premium_photo-1733259709671-9dbf22bf02cc?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8cGl6emElMjBwbmd8ZW58MHx8MHx8fDA%3D" },
  { name: "Extravagant Duck", category: "Main courses", vegetarian: false, price: 29.00, image: "https://www.kindpng.com/picc/m/315-3151202_food-in-plate-png-transparent-png.png" },
  { name: "Salmon Salad", category: "Salads", vegetarian: false, price: 35.00, image: "https://www.kindpng.com/picc/m/110-1105729_meal-png-download-image-food-top-view-png.png" }
])
