/**
 * filter.js – Client side UI enhancements for Filters
 * Auto-submits on change.
 */

document.addEventListener('DOMContentLoaded', () => {
    // If we wanted pure client-side filtering without page reloads, 
    // we would handle AJAX fetching here. Currently, forms trigger a clean GET request.
    
    // Example: Highlight active filters
    const urlParams = new URLSearchParams(window.location.search);
    const hasFilters = urlParams.has('city_id') || urlParams.has('max_price') || urlParams.has('venue_type') || urlParams.has('cuisine');
    
    if (hasFilters) {
        const resetBtn = document.querySelector('.filter-sidebar .text-muted');
        if (resetBtn) resetBtn.style.color = 'var(--danger)';
    }
});
