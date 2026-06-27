from flask import render_template, request, flash
from app import app, db
from app.models import Komen


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/p1")
def p1():
    return render_template("p1.html")


@app.route("/p2")
def p2():
    return render_template("p2.html")


@app.route("/p3")
def p3():
    return render_template("p3.html")


@app.route("/p4")
def p4():
    return render_template("p4.html")


@app.route("/komen", methods=["GET", "POST"])
def komen():
    if request.method == "POST":
        try:
            name = request.form.get("name")
            helpful = request.form.get("helpful")
            comment = request.form.get("comment")
            comments = Komen(name=name, helpful=helpful, comment=comment)
            db.session.add(comments)
            db.session.commit()
            flash("Komen Dihantar!", "success")
        except Exception as e:
            db.session.rollback()
            flash("Gagal menghantar komen", "danger")
    return render_template("komen.html")
