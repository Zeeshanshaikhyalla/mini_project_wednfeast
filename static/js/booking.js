/**
 * booking.js – Booking Form Client Logic
 * Calculates dynamic totals based on inputs.
 */

document.addEventListener('DOMContentLoaded', () => {
    const bookingForm = document.getElementById('bookingForm');
    
    if (bookingForm) {
        // Minimum Date logic – Restrict to tomorrow
        const dateInput = document.getElementById('event_date');
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const yyyy = tomorrow.getFullYear();
        const mm = String(tomorrow.getMonth() + 1).padStart(2, '0');
        const dd = String(tomorrow.getDate()).padStart(2, '0');
        dateInput.min = `${yyyy}-${mm}-${dd}`;

        // Dynamic form validation preview could go here
    }
});
