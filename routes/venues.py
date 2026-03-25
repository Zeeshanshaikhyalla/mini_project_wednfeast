"""
routes/venues.py – Venue listing, detail, search/filter
"""
from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from db import query

venues_bp = Blueprint('venues', __name__)


@venues_bp.route('/venues')
def list_venues():
    city_id = request.args.get('city_id', type=int)
    min_cap = request.args.get('min_capacity', type=int)
    max_price = request.args.get('max_price', type=float)
    venue_type = request.args.get('venue_type', '')

    sql = "SELECT v.*, c.name as city_name FROM venues v LEFT JOIN cities c ON v.city_id=c.id WHERE v.is_active=TRUE"
    params = []

    if city_id:
        sql += " AND v.city_id=%s"
        params.append(city_id)
    if min_cap:
        sql += " AND v.capacity >= %s"
        params.append(min_cap)
    if max_price:
        sql += " AND v.price_per_day <= %s"
        params.append(max_price)
    if venue_type:
        sql += " AND v.venue_type=%s"
        params.append(venue_type)

    sql += " ORDER BY v.rating DESC"

    venues = query(sql, params, fetchall=True) or []
    cities = query("SELECT * FROM cities ORDER BY name", fetchall=True) or []
    return render_template('venues.html', venues=venues, cities=cities,
                           selected_city=city_id, selected_type=venue_type,
                           max_price=max_price, min_cap=min_cap)


@venues_bp.route('/venues/<int:venue_id>')
def venue_detail(venue_id):
    venue = query(
        "SELECT v.*, c.name as city_name FROM venues v LEFT JOIN cities c ON v.city_id=c.id WHERE v.id=%s",
        (venue_id,), fetchone=True
    )
    if not venue:
        flash('Venue not found.', 'error')
        return redirect(url_for('venues.list_venues'))

    reviews = query(
        "SELECT r.*, u.name as user_name FROM reviews r LEFT JOIN users u ON r.user_id=u.id WHERE r.venue_id=%s ORDER BY r.created_at DESC LIMIT 6",
        (venue_id,), fetchall=True
    ) or []
    return render_template('venue_detail.html', venue=venue, reviews=reviews)
