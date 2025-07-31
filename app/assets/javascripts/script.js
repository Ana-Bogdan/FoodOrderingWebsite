document.addEventListener('DOMContentLoaded', function() {
  console.log('Script loaded successfully');
  
  initializeFiltering();
});

function initializeFiltering() {
  console.log('Initializing filtering...');
  
  const priceMin = document.getElementById('price-min');
  const priceMax = document.getElementById('price-max');
  
  console.log('Price min element:', priceMin);
  console.log('Price max element:', priceMax);
  
  if (!priceMin || !priceMax) {
    console.error('Price sliders not found');
    return;
  }

  // Filter variables
  let selectedCategory = 'All';
  let selectedSort = '';
  let selectedVegetarian = 'All';

  function updatePriceRangeDisplay() {
    const minLabel = document.getElementById('price-min-label');
    const maxLabel = document.getElementById('price-max-label');
    if (minLabel) minLabel.textContent = `$${priceMin.value}`;
    if (maxLabel) maxLabel.textContent = `$${priceMax.value}`;
  }

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
    updatePriceRangeDisplay();
  }

  // Price slider event listeners
  priceMin.addEventListener('input', () => {
    console.log('Price min changed:', priceMin.value);
    if (Number(priceMin.value) > Number(priceMax.value)) {
      priceMin.value = priceMax.value;
    }
    updateSliderHighlight();
    filterMenu();
  });

  priceMax.addEventListener('input', () => {
    console.log('Price max changed:', priceMax.value);
    if (Number(priceMax.value) < Number(priceMin.value)) {
      priceMax.value = priceMin.value;
    }
    updateSliderHighlight();
    filterMenu();
  });

  // Initialize price display
  updateSliderHighlight();

  // Dropdown functionality
  const chevronLabels = document.querySelectorAll('.chevron-label');
  console.log('Found chevron labels:', chevronLabels.length);
  
  chevronLabels.forEach(label => {
    label.addEventListener('click', (e) => {
      e.stopPropagation();
      console.log('Dropdown clicked:', label.getAttribute('data-label'));
      
      // Close other dropdowns
      chevronLabels.forEach(l => {
        if (l !== label) {
          l.classList.remove('active');
          const dc = l.querySelector('.dropdown-content');
          if (dc) dc.style.display = 'none';
        }
      });
      
      // Toggle current dropdown
      const dropdown = label.querySelector('.dropdown-content');
      if (dropdown) {
        const isOpen = dropdown.style.display === 'block';
        dropdown.style.display = isOpen ? 'none' : 'block';
        console.log('Dropdown display set to:', dropdown.style.display);
        if (!isOpen) {
          label.classList.add('active');
        } else {
          label.classList.remove('active');
        }
      }
    });
  });

  // Close dropdowns when clicking outside
  document.addEventListener('click', () => {
    chevronLabels.forEach(l => {
      l.classList.remove('active');
      const dc = l.querySelector('.dropdown-content');
      if (dc) dc.style.display = 'none';
    });
  });

  // Dropdown option selection
  chevronLabels.forEach(label => {
    const dropdown = label.querySelector('.dropdown-content');
    if (!dropdown) return;

    dropdown.querySelectorAll('.option').forEach(option => {
      option.addEventListener('click', (e) => {
        e.stopPropagation();
        console.log('Option selected:', option.textContent);
        
        // Remove selected class from all options in this dropdown
        dropdown.querySelectorAll('.option').forEach(o => o.classList.remove('selected'));
        
        // Add selected class to clicked option
        option.classList.add('selected');
        
        // Update filter variables
        const labelType = label.getAttribute('data-label');
        if (labelType === 'CATEGORY') {
          selectedCategory = option.textContent;
          console.log('Category selected:', selectedCategory);
        }
        if (labelType === 'SORTING') {
          selectedSort = option.textContent;
          console.log('Sorting selected:', selectedSort);
        }
        if (labelType === 'VEGETARIAN') {
          selectedVegetarian = option.textContent;
          console.log('Vegetarian selected:', selectedVegetarian);
        }
        
        // Close dropdown
        dropdown.style.display = 'none';
        label.classList.remove('active');
        
        // Apply filters
        filterMenu();
      });
    });
  });

  function filterMenu() {
    console.log('Filtering menu...');
    console.log('Category:', selectedCategory);
    console.log('Vegetarian:', selectedVegetarian);
    console.log('Sorting:', selectedSort);
    
    const min = Math.min(Number(priceMin.value), Number(priceMax.value));
    const max = Math.max(Number(priceMin.value), Number(priceMax.value));
    console.log('Price range:', min, '-', max);
    
    const items = document.querySelectorAll('.menu-item');
    console.log('Total items found:', items.length);
    
    items.forEach(item => {
      const price = Number(item.getAttribute('data-price'));
      const category = item.getAttribute('data-category');
      const vegetarian = item.getAttribute('data-vegetarian');
      
      let show = true;
      
      // Category filter
      if (selectedCategory !== 'All' && selectedCategory !== category) {
        show = false;
      }
      
      // Vegetarian filter
      if (selectedVegetarian === 'Vegetarian only' && vegetarian !== 'yes') {
        show = false;
      }
      
      // Price filter
      if (price < min || price > max) {
        show = false;
      }
      
      item.style.display = show ? '' : 'none';
    });

    // Sorting
    let sortedItems = Array.from(items).filter(item => item.style.display !== 'none');
    console.log('Visible items after filtering:', sortedItems.length);
    
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
    if (grid) {
      sortedItems.forEach(item => grid.appendChild(item));
    }
  }

  // Initial filter
  filterMenu();
}
