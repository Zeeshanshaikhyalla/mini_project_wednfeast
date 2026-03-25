"""
routes/catering.py – Catering listing, detail, search/filter
"""
from flask import Blueprint, render_template, request, redirect, url_for, flash
from db import query

catering_bp = Blueprint('catering', __name__)


@catering_bp.route('/catering')
def list_catering():
    city_id = request.args.get('city_id', type=int)
    cuisine = request.args.get('cuisine', '').strip()
    max_price = request.args.get('max_price', type=float)

    sql = "SELECT cs.*, c.name as city_name FROM catering_services cs LEFT JOIN cities c ON cs.city_id=c.id WHERE cs.is_active=TRUE"
    params = []

    if city_id:
        sql += " AND cs.city_id=%s"
        params.append(city_id)
    if max_price:
        sql += " AND cs.price_per_plate_veg <= %s"
        params.append(max_price)
    if cuisine:
        sql += " AND cs.cuisines ILIKE %s"
        params.append(f'%{cuisine}%')

    sql += " ORDER BY cs.rating DESC"

    caterers = query(sql, params, fetchall=True) or []
    cities = query("SELECT * FROM cities ORDER BY name", fetchall=True) or []
    all_cuisines = ['North Indian', 'South Indian', 'Mughlai', 'Continental', 'Chinese', 'Punjabi', 'Hyderabadi', 'Bengali', 'Gujarati', 'Rajasthani', 'Asian Fusion']
    return render_template('catering.html', caterers=caterers, cities=cities,
                           all_cuisines=all_cuisines, selected_city=city_id,
                           selected_cuisine=cuisine, max_price=max_price)


@catering_bp.route('/catering/<int:caterer_id>')
def catering_detail(caterer_id):
    caterer = query(
        "SELECT cs.*, c.name as city_name FROM catering_services cs LEFT JOIN cities c ON cs.city_id=c.id WHERE cs.id=%s",
        (caterer_id,), fetchone=True
    )
    if not caterer:
        flash('Catering service not found.', 'error')
        return redirect(url_for('catering.list_catering'))

    reviews = query(
        "SELECT r.*, u.name as user_name FROM reviews r LEFT JOIN users u ON r.user_id=u.id WHERE r.catering_id=%s ORDER BY r.created_at DESC LIMIT 6",
        (caterer_id,), fetchall=True
    ) or []
    return render_template('catering_detail.html', caterer=caterer, reviews=reviews)
