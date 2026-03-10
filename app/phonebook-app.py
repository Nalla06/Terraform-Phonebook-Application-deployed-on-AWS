from flask import Flask, render_template, request
from flaskext.mysql import MySQL

app = Flask(__name__)
mysql = MySQL()

# Database configuration
app.config['MYSQL_DATABASE_USER'] = 'admin'
app.config['MYSQL_DATABASE_PASSWORD'] = 'Nalla1234'
app.config['MYSQL_DATABASE_DB'] = 'phonebook'

# Read DB endpoint created by Terraform
db_endpoint = open("/home/ec2-user/phonebook/dbserver.endpoint", "r")
app.config['MYSQL_DATABASE_HOST'] = db_endpoint.readline().strip()

mysql.init_app(app)

developer_name = "Lakshmi Rajyam"


def init_phonebook_db():
    conn = mysql.connect()
    cursor = conn.cursor()
    cursor.execute(
        """CREATE TABLE IF NOT EXISTS phonebook.phonebook(
        id INT NOT NULL AUTO_INCREMENT,
        name VARCHAR(100),
        number VARCHAR(100),
        PRIMARY KEY (id)
        );"""
    )
    conn.commit()
    cursor.close()
    conn.close()


@app.route('/')
def index():
    return render_template("index.html", developer_name=developer_name)


@app.route('/search', methods=['POST'])
def search():
    keyword = request.form.get("keyword")

    conn = mysql.connect()
    cursor = conn.cursor()
    query = "SELECT * FROM phonebook WHERE name LIKE %s"
    cursor.execute(query, ("%" + keyword + "%",))

    persons = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template(
        "index.html",
        persons=persons,
        keyword=keyword,
        show_result=True,
        developer_name=developer_name
    )


@app.route('/add')
def add():
    return render_template("add-update.html", action="add", developer_name=developer_name)


@app.route('/add', methods=['POST'])
def add_person():
    name = request.form['name']
    number = request.form['number']

    conn = mysql.connect()
    cursor = conn.cursor()

    query = "INSERT INTO phonebook (name, number) VALUES (%s, %s)"
    cursor.execute(query, (name, number))

    conn.commit()
    cursor.close()
    conn.close()

    return render_template("index.html", msg="Person added successfully", developer_name=developer_name)


@app.route('/update/<int:id>')
def update(id):
    conn = mysql.connect()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM phonebook WHERE id=%s", (id,))
    person = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template("add-update.html", action="update", person=person, developer_name=developer_name)


@app.route('/update/<int:id>', methods=['POST'])
def update_person(id):
    name = request.form['name']
    number = request.form['number']

    conn = mysql.connect()
    cursor = conn.cursor()

    query = "UPDATE phonebook SET name=%s, number=%s WHERE id=%s"
    cursor.execute(query, (name, number, id))

    conn.commit()
    cursor.close()
    conn.close()

    return render_template("index.html", msg="Person updated successfully", developer_name=developer_name)


@app.route('/delete/<int:id>')
def delete(id):
    return render_template("delete.html", id=id, developer_name=developer_name)


@app.route('/delete/<int:id>', methods=['POST'])
def delete_person(id):
    conn = mysql.connect()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM phonebook WHERE id=%s", (id,))
    conn.commit()

    cursor.close()
    conn.close()

    return render_template("index.html", msg="Person deleted successfully", developer_name=developer_name)


if __name__ == "__main__":
    init_phonebook_db()
    app.run(host="0.0.0.0", port=80)