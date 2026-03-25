"""
routes/vendors.py – Vendor dashboard: view & add their venues/catering
"""
from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from db import query
from functools import wraps

vendors_bp = Blueprint('vendors', __name__)


def vendor_required(f):
    @wraps(f)
    def decorated(*args, **kwargs):
        if 'user_id' not in session:
            flash('Please login to continue.', 'error')
            return redirect(url_for('auth.login'))
        if session.get('user_role') != 'vendor':
            flash('Access restricted to vendors.', 'error')
            return redirect(url_for('main.index'))
        return f(*args, **kwargs)
    return decorated


@vendors_bp.route('/vendor/dashboard')
@vendor_required
def dashboard():
    venues = query(
        "SELECT v.*, c.name as city_name FROM venues v LEFT JOIN cities c ON v.city_id=c.id WHERE v.vendor_id=%s ORDER BY v.created_at DESC",
        (session['user_id'],), fetchall=True
    ) or []
    caterers = query(
        "SELECT cs.*, c.name as city_name FROM catering_services cs LEFT JOIN cities c ON cs.city_id=c.id WHERE cs.vendor_id=%s ORDER BY cs.created_at DESC",
        (session['user_id'],), fetchall=True
    ) or []
    bookings = query(
        """SELECT b.*, u.name as client_name, u.phone as client_phone,
                  v.name as venue_name, cs.name as catering_name
           FROM bookings b
           LEFT JOIN users u ON b.user_id=u.id
           LEFT JOIN venues v ON b.venue_id=v.id
           LEFT JOIN catering_services cs ON b.catering_id=cs.id
           WHERE v.vendor_id=%s OR cs.vendor_id=%s
           ORDER BY b.created_at DESC""",
        (session['user_id'], session['user_id']), fetchall=True
    ) or []
    cities = query("SELECT * FROM cities ORDER BY name", fetchall=True) or []
    return render_template('vendor_dashboard.html', venues=venues, caterers=caterers, bookings=bookings, cities=cities)


@vendors_bp.route('/vendor/venue/add', methods=['POST'])
@vendor_required
def add_venue():
    name = request.form.get('name', '').strip()
    city_id = request.form.get('city_id', type=int)
    description = request.form.get('description', '').strip()
    capacity = request.form.get('capacity', type=int, default=100)
    price_per_day = request.form.get('price_per_day', type=float, default=0)
    amenities = request.form.get('amenities', '').strip()
    venue_type = request.form.get('venue_type', 'banquet_hall')

    if not name or not city_id:
        flash('Name and city are required.', 'error')
        return redirect(url_for('vendors.dashboard'))

    query(
        """INSERT INTO venues (name, city_id, description, capacity, price_per_day, amenities, venue_type, vendor_id)
           VALUES (%s,%s,%s,%s,%s,%s,%s,%s)""",
        (name, city_id, description, capacity, price_per_day, amenities, venue_type, session['user_id']),
        commit=True
    )
    flash('Venue added successfully!', 'success')
    return redirect(url_for('vendors.dashboard'))


@vendors_bp.route('/vendor/booking/<int:booking_id>/confirm', methods=['POST'])
@vendor_required
def confirm_booking(booking_id):
    query("UPDATE bookings SET status='confirmed' WHERE id=%s", (booking_id,), commit=True)
    flash('Booking confirmed!', 'success')
    return redirect(url_for('vendors.dashboard'))


@vendors_bp.route('/vendor/booking/<int:booking_id>/reject', methods=['POST'])
@vendor_required
def reject_booking(booking_id):
    query("UPDATE bookings SET status='cancelled' WHERE id=%s", (booking_id,), commit=True)
    flash('Booking rejected.', 'success')
    return redirect(url_for('vendors.dashboard'))
