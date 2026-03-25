"""
app.py – Wed n Feast Flask Application Entry Point
"""
import os
from flask import Flask, render_template, session
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "wednfeast_super_secret_key_2024")

# Register blueprints
from routes.auth import auth_bp
from routes.venues import venues_bp
from routes.catering import catering_bp
from routes.bookings import bookings_bp
from routes.vendors import vendors_bp

app.register_blueprint(auth_bp)
app.register_blueprint(venues_bp)
app.register_blueprint(catering_bp)
app.register_blueprint(bookings_bp)
app.register_blueprint(vendors_bp)

# Main / index route
from flask import Blueprint
main_bp = Blueprint('main', __name__)

@main_bp.route('/')
def index():
    from db import query
    cities = query("SELECT * FROM cities ORDER BY name", fetchall=True) or []
    featured_venues = query(
        "SELECT v.*, c.name as city_name FROM venues v LEFT JOIN cities c ON v.city_id=c.id WHERE v.is_active=TRUE ORDER BY v.rating DESC LIMIT 6",
        fetchall=True
    ) or []
    featured_caterers = query(
        "SELECT cs.*, c.name as city_name FROM catering_services cs LEFT JOIN cities c ON cs.city_id=c.id WHERE cs.is_active=TRUE ORDER BY cs.rating DESC LIMIT 4",
        fetchall=True
    ) or []
    return render_template('index.html', cities=cities, featured_venues=featured_venues, featured_caterers=featured_caterers)

app.register_blueprint(main_bp)

# Context processor – inject session data into all templates
@app.context_processor
def inject_user():
    return dict(
        current_user={
            'id': session.get('user_id'),
            'name': session.get('user_name'),
            'role': session.get('user_role'),
            'is_authenticated': 'user_id' in session
        }
    )

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
