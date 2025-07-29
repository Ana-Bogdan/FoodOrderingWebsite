function getProducts() {
  return JSON.parse(localStorage.getItem('products') || '[]');
}

function saveProducts(products) {
  localStorage.setItem('products', JSON.stringify(products));
}

function renderProducts() {
  const products = getProducts();
  const tbody = document.querySelector('#products-table tbody');
  tbody.innerHTML = '';

  products.forEach((prod, idx) => {
    const tr = document.createElement('tr');
    tr.innerHTML = `
      <td>${prod.name}</td>
      <td>${prod.category}</td>
      <td>${prod.vegetarian === 'yes' ? 'Yes' : 'No'}</td>
      <td>$${parseFloat(prod.price).toFixed(2)}</td>
      <td><img src="${prod.image}" alt="${prod.name}" style="width:48px;height:48px;border-radius:8px;object-fit:cover;"></td>
      <td><button class="remove-btn" data-idx="${idx}">Remove</button></td>
    `;
    tbody.appendChild(tr);
  });
}

document.getElementById('add-product-form').addEventListener('submit', function(e) {
  e.preventDefault();
  const name = document.getElementById('product-name').value.trim();
  const category = document.getElementById('product-category').value;
  const vegetarian = document.getElementById('product-vegetarian').value;
  const price = document.getElementById('product-price').value.trim();
  const image = document.getElementById('product-image').value.trim();

  if (!name || !category || !vegetarian || !price || !image) return;

  const products = getProducts();
  products.push({ name, category, vegetarian, price, image });
  saveProducts(products);
  renderProducts();
  this.reset();
});

document.querySelector('#products-table tbody').addEventListener('click', function(e) {
  if (e.target.classList.contains('remove-btn')) {
    const idx = parseInt(e.target.getAttribute('data-idx'));
    const products = getProducts();
    products.splice(idx, 1);
    saveProducts(products);
    renderProducts();
  }
});

renderProducts(); 
