const priceMin = document.getElementById('price-min');
const priceMax = document.getElementById('price-max');

function updatePriceRangeDisplay() {
  document.getElementById('price-min-label').textContent = `$${priceMin.value}`;
  document.getElementById('price-max-label').textContent = `$${priceMax.value}`;
}

priceMin.addEventListener('input', () => {
  if (Number(priceMin.value) > Number(priceMax.value)) {
    priceMin.value = priceMax.value;
  }
  updatePriceRangeDisplay();
  filterMenu();
});
priceMax.addEventListener('input', () => {
  if (Number(priceMax.value) < Number(priceMin.value)) {
    priceMax.value = priceMin.value;
  }
  updatePriceRangeDisplay();
  filterMenu();
});
updatePriceRangeDisplay();

const chevronLabels = document.querySelectorAll('.chevron-label');
chevronLabels.forEach(label => {
  label.addEventListener('click', (e) => {
    e.stopPropagation();
    chevronLabels.forEach(l => {
      if (l !== label) {
        l.classList.remove('active');
        const dc = l.querySelector('.dropdown-content');
        if (dc) dc.style.display = 'none';
      }
    });
    const dropdown = label.querySelector('.dropdown-content');
    if (dropdown) {
      const isOpen = dropdown.style.display === 'block';
      dropdown.style.display = isOpen ? 'none' : 'block';
      if (!isOpen) label.classList.add('active');
      else label.classList.remove('active');
    }
  });
});
document.addEventListener('click', () => {
  chevronLabels.forEach(l => {
    l.classList.remove('active');
    const dc = l.querySelector('.dropdown-content');
    if (dc) dc.style.display = 'none';
  });
});
chevronLabels.forEach(label => {
  const dropdown = label.querySelector('.dropdown-content');
  if (!dropdown) return;
  dropdown.querySelectorAll('.option').forEach(option => {
    option.addEventListener('click', () => {
      dropdown.querySelectorAll('.option').forEach(o => o.classList.remove('selected'));
      option.classList.add('selected');
      const labelType = label.getAttribute('data-label');
      if (labelType === 'CATEGORY') selectedCategory = option.textContent;
      if (labelType === 'SORTING') selectedSort = option.textContent;
      if (labelType === 'VEGETARIAN') selectedVegetarian = option.textContent;
      dropdown.style.display = 'none';
      label.classList.remove('active');
      filterMenu();
    });
  });
});
function updateSliderHighlight() {
  const min = Math.min(Number(priceMin.value), Number(priceMax.value));
  const max = Math.max(Number(priceMin.value), Number(priceMax.value));
  const range = priceMax.max - priceMin.min;
  const left = ((min - priceMin.min) / range) * 100;
  const right = ((max - priceMin.min) / range) * 100;
  const highlight = document.querySelector('.slider-range-highlight');
  if (highlight) {
    highlight.style.left = left + '%';
    highlight.style.width = (right - left) + '%';
  }
  document.getElementById('price-min-label').textContent = `$${priceMin.value}`;
  document.getElementById('price-max-label').textContent = `$${priceMax.value}`;
}
priceMin.addEventListener('input', () => {
  if (Number(priceMin.value) > Number(priceMax.value)) {
    priceMin.value = priceMax.value;
  }
  updatePriceRangeDisplay();
  updateSliderHighlight();
  filterMenu();
});
priceMax.addEventListener('input', () => {
  if (Number(priceMax.value) < Number(priceMin.value)) {
    priceMax.value = priceMin.value;
  }
  updatePriceRangeDisplay();
  updateSliderHighlight();
  filterMenu();
});
updatePriceRangeDisplay();
updateSliderHighlight();

let selectedCategory = 'All';
let selectedSort = '';
let selectedVegetarian = 'All';

document.querySelectorAll('.filter-dropdown').forEach(dropdown => {
  dropdown.querySelectorAll('.option').forEach(option => {
    option.addEventListener('click', () => {
      const btn = dropdown.querySelector('.filter-btn');
      const label = btn.getAttribute('data-label');
      btn.textContent = `${label}: ${option.textContent} ▾`;
      if (label === 'CATEGORY') selectedCategory = option.textContent;
      if (label === 'SORTING') selectedSort = option.textContent;
      if (label === 'VEGETARIAN') selectedVegetarian = option.textContent;
      filterMenu();
    });
  });
});

function filterMenu() {
  const min = Math.min(Number(priceMin.value), Number(priceMax.value));
  const max = Math.max(Number(priceMin.value), Number(priceMax.value));
  const items = document.querySelectorAll('.menu-item');
  items.forEach(item => {
    const price = Number(item.getAttribute('data-price'));
    const category = item.getAttribute('data-category');
    const vegetarian = item.getAttribute('data-vegetarian');
    let show = true;
    if (selectedCategory !== 'All' && selectedCategory !== category) show = false;
    if (selectedVegetarian === 'Vegetarian only' && vegetarian !== 'yes') show = false;
    if (price < min || price > max) show = false;
    item.style.display = show ? '' : 'none';
  });
  let sortedItems = Array.from(items).filter(item => item.style.display !== 'none');
  if (selectedSort === 'Price: Low to High') {
    sortedItems.sort((a, b) => {
      let pa = Number(a.getAttribute('data-price'));
      let pb = Number(b.getAttribute('data-price'));
      return pa - pb;
    });
  } else if (selectedSort === 'Price: High to Low') {
    sortedItems.sort((a, b) => {
      let pa = Number(a.getAttribute('data-price'));
      let pb = Number(b.getAttribute('data-price'));
      return pb - pa;
    });
  }
  const grid = document.querySelector('.menu-grid');
  sortedItems.forEach(item => grid.appendChild(item));
}

function renderMenuFromLocalStorage() {
  const grid = document.querySelector('.menu-grid');
  if (!grid) return;
  grid.innerHTML = '';
  const products = JSON.parse(localStorage.getItem('products') || '[]');
  if (!products.length) {
    grid.innerHTML = '<div style="text-align:center;width:100%;color:#888;font-size:1.2em;padding:2em 0;">No menu items available. Add products in the Dashboard.</div>';
    return;
  }
  products.forEach(prod => {
    const div = document.createElement('div');
    div.className = 'menu-item';
    div.setAttribute('data-category', prod.category);
    div.setAttribute('data-vegetarian', prod.vegetarian);
    div.setAttribute('data-price', prod.price);
    div.innerHTML = `
      <img src="${prod.image}" alt="${prod.name}">
      <h3>${prod.name}</h3>
      <p class="category">${prod.category}</p>
      <p class="price">$${parseFloat(prod.price).toFixed(2)}</p>
    `;
    grid.appendChild(div);
  });
}

filterMenu();

document.addEventListener('DOMContentLoaded', function() {
  renderMenuFromLocalStorage();
  var dashBtn = document.getElementById('dashboard-btn');
  if (dashBtn) {
    dashBtn.addEventListener('click', function() {
      window.open('dashboard.html', '_blank');
    });
  }
});
