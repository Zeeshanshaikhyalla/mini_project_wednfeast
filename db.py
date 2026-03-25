"""
db.py – PostgreSQL connection helper using psycopg.
Reads DATABASE_URL from .env or environment.
Format: postgresql://user:password@host:port/dbname
"""
import os
import psycopg
from psycopg.rows import dict_row
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost:5432/wedandfeast")


def get_connection():
    """Return a new psycopg connection."""
    conn = psycopg.connect(DATABASE_URL, row_factory=dict_row)
    return conn


def query(sql, params=None, fetchone=False, fetchall=False, commit=False):
    """
    Helper to run a query.
    - fetchone: returns a single row dict
    - fetchall: returns list of row dicts
    - commit: commits (for INSERT/UPDATE/DELETE)
    """
    conn = get_connection()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params or ())
            if commit:
                conn.commit()
                if cur.description:
                    return cur.fetchone()
                return None
            if fetchone:
                return cur.fetchone()
            if fetchall:
                return cur.fetchall()
    finally:
        conn.close()
