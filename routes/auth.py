"""
routes/auth.py – Registration, Login, Logout
"""
import bcrypt
from flask import Blueprint, render_template, request, redirect, url_for, flash, session
from db import query

auth_bp = Blueprint('auth', __name__)


def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


def check_password(password: str, hashed: str) -> bool:
    return bcrypt.checkpw(password.encode(), hashed.encode())


@auth_bp.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form.get('name', '').strip()
        email = request.form.get('email', '').strip().lower()
        password = request.form.get('password', '')
        role = request.form.get('role', 'user')
        phone = request.form.get('phone', '').strip()

        if not name or not email or not password:
            flash('All fields are required.', 'error')
            return render_template('register.html')

        existing = query("SELECT id FROM users WHERE email=%s", (email,), fetchone=True)
        if existing:
            flash('Email already registered. Please login.', 'error')
            return render_template('register.html')

        hashed = hash_password(password)
        query(
            "INSERT INTO users (name, email, password_hash, role, phone) VALUES (%s,%s,%s,%s,%s)",
            (name, email, hashed, role, phone), commit=True
        )
        flash('Account created! Please login.', 'success')
        return redirect(url_for('auth.login'))

    return render_template('register.html')


@auth_bp.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email', '').strip().lower()
        password = request.form.get('password', '')

        user = query("SELECT * FROM users WHERE email=%s", (email,), fetchone=True)
        if not user or not check_password(password, user['password_hash']):
            flash('Invalid email or password.', 'error')
            return render_template('login.html')

        session['user_id'] = user['id']
        session['user_name'] = user['name']
        session['user_role'] = user['role']
        flash(f'Welcome back, {user["name"]}!', 'success')

        if user['role'] == 'vendor':
            return redirect(url_for('vendors.dashboard'))
        return redirect(url_for('bookings.dashboard'))

    return render_template('login.html')


@auth_bp.route('/logout')
def logout():
    session.clear()
    flash('Logged out successfully.', 'success')
    return redirect(url_for('main.index'))
