"""
routes/bookings.py – Booking creation, dashboard, cancellation
"""
from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from db import query
from functools import wraps

bookings_bp = Blueprint('bookings', __name__)


def login_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login to continue.', 'error')
            return redirect(url_for('auth.login'))
        return f(*args, **kwargs)
    return decorated


@bookings_bp.route('/book', methods=['GET', 'POST'])
@login_required
def book():
    venue_id = request.args.get('venue_id', type=int)
    catering_id = request.args.get('catering_id', type=int)

    venue = None
    caterer = None
    if venue_id:
        venue = query("SELECT v.*, c.name as city_name FROM venues v LEFT JOIN cities c ON v.city_id=c.id WHERE v.id=%s", (venue_id,), fetchone=True)
    if catering_id:
        caterer = query("SELECT cs.*, c.name as city_name FROM catering_services cs LEFT JOIN cities c ON cs.city_id=c.id WHERE cs.id=%s", (catering_id,), fetchone=True)

    if request.method == 'POST':
        event_date = request.form.get('event_date')
        event_type = request.form.get('event_type', 'Wedding')
        guests = request.form.get('guests', type=int, default=100)
        special_requests = request.form.get('special_requests', '')
        booking_type = request.form.get('booking_type', 'venue')
        bid_venue_id = request.form.get('venue_id', type=int)
        bid_catering_id = request.form.get('catering_id', type=int)

        if not event_date:
            flash('Please select an event date.', 'error')
            return render_template('booking.html', venue=venue, caterer=caterer)

        # Calculate price
        total_price = 0
        if bid_venue_id and venue:
            total_price = float(venue.get('price_per_day') or 0)
        elif bid_catering_id and caterer:
            ppv = float(caterer.get('price_per_plate_veg') or 0)
            total_price = ppv * guests

        query(
            """INSERT INTO bookings (user_id, booking_type, venue_id, catering_id, event_date, event_type, guests, special_requests, total_price, status)
               VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,'pending')""",
            (session['user_id'], booking_type, bid_venue_id or None, bid_catering_id or None,
             event_date, event_type, guests, special_requests, total_price),
            commit=True
        )
        flash('Booking request submitted successfully! We will confirm shortly.', 'success')
        return redirect(url_for('bookings.dashboard'))

    return render_template('booking.html', venue=venue, caterer=caterer)


@bookings_bp.route('/dashboard')
@login_required
def dashboard():
    bookings = query(
        """SELECT b.*, 
                  v.name as venue_name, v.price_per_day,
                  cs.name as catering_name
           FROM bookings b
           LEFT JOIN venues v ON b.venue_id=v.id
           LEFT JOIN catering_services cs ON b.catering_id=cs.id
           WHERE b.user_id=%s
           ORDER BY b.created_at DESC""",
        (session['user_id'],), fetchall=True
    ) or []
    return render_template('dashboard.html', bookings=bookings)


@bookings_bp.route('/bookings/<int:booking_id>/cancel', methods=['POST'])
@login_required
def cancel_booking(booking_id):
    booking = query("SELECT * FROM bookings WHERE id=%s AND user_id=%s", (booking_id, session['user_id']), fetchone=True)
    if not booking:
        flash('Booking not found.', 'error')
        return redirect(url_for('bookings.dashboard'))
    if booking['status'] == 'cancelled':
        flash('Booking is already cancelled.', 'error')
        return redirect(url_for('bookings.dashboard'))

    query("UPDATE bookings SET status='cancelled' WHERE id=%s", (booking_id,), commit=True)
    flash('Booking cancelled successfully.', 'success')
    return redirect(url_for('bookings.dashboard'))
