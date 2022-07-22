import psycopg2

# MERK: Må kjøres med Python 3!

# Login details for database user
dbname = "abdulrad" #Set in your UiO-username
user = "æææææææ" # Set in your priv-user (UiO-username + _priv)
pwd = "ææææææ" # Set inn the password for the _priv-user you got in a mail

# Gather all connection info into one string
connection = \
    "host='dbpg-ifi-kurs01.uio.no' " + \
    "dbname='" + dbname + "' " + \
    "user='" + user + "' " + \
    "port='5432' " + \
    "password='" + pwd + "'"

def administrator():
    conn = psycopg2.connect(connection)
    
    ch = 0
    while (ch != 3):
        print("-- ADMINISTRATOR --")
        print("Please choose an option:\n 1. Create bills\n 2. Insert new product\n 3. Exit")
        ch = get_int_from_user("Option: ", True)

        if (ch == 1):
            make_bills(conn)
        elif (ch == 2):
            insert_product(conn)
    
def make_bills(conn):
    # Oppg 2
    cur = conn.cursor()
    cur.execute("select u.name, u.address, sum(p.price*o.num) as total from ws.users as u join ws.orders as o using (uid) join ws.products as p on (o.pid = p.pid) group by u.name, u.address, o.payed having o.payed = 0;")
    rows = cur.fetchall()
    for col in rows:
        print("--Bill--")
        print(f'Name: {col[0]}')
        print(f'Address: {col[1]}')
        print(f'Total due: {col[2]}')
        print()
    conn.commit()

def insert_product(conn):
    print("-- INSERT NEW PRODUCT --")
    navn = input("Product name: ")
    pris = int(input("Price: "))
    kategori = input("Category: ")
    cid = 0
    if kategori == "food":
        cid = 1
    elif kategori == "electronics":
        cid = 2
    elif kategori == "clothing":
        cid = 3
    else:
        cid = 4
    
    beskriv = input("Description: ")

    cur = conn.cursor()
    cur.execute("insert into ws.products(name, price, cid, description) values (%s, %s, (select c.cid from ws.categories as c where c.cid = %s), %s);", (navn, pris,cid,beskriv))
    conn.commit()
    print(f'New product {navn} inserted')


def get_int_from_user(msg, needed):
    # Utility method that gets an int from the user with the first argument as message
    # Second argument is boolean, and if false allows user to not give input, and will then
    # return None
    while True:
        numStr = input(msg)
        if (numStr == "" and not needed):
            return None;
        try:
            return int(numStr)
        except:
            print("Please provide an integer or leave blank.");


if __name__ == "__main__":
    administrator()
