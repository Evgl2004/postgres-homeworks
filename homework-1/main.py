"""Скрипт для заполнения данными таблиц в БД Postgres."""
import csv
import psycopg2


def load_data_from_csv(connect_pg, file_name: str):

    try:
        with open("./north_data/" + file_name, "rt", encoding="windows-1251") as csvfile:

            reader = csv.DictReader(csvfile)

            with connect_pg:
                with connect_pg.cursor() as cursor_pg:
                    if file_name == 'customers_data.csv':
                        for row in reader:
                            cursor_pg.execute("INSERT INTO customers VALUES (%s, %s, %s)",
                                              (row["customer_id"], row["company_name"], row["contact_name"]))

                    elif file_name == 'employees_data.csv':
                        for row in reader:
                            cursor_pg.execute("INSERT INTO employees VALUES (%s, %s, %s, %s, %s, %s)",
                                              (int(row["employee_id"]), row["first_name"], row["last_name"],
                                               row["title"], row["birth_date"], row["notes"]))

                    elif file_name == 'orders_data.csv':
                        for row in reader:
                            cursor_pg.execute("INSERT INTO orders VALUES (%s, %s, %s, %s, %s)",
                                              (int(row["order_id"]), row["customer_id"], row["employee_id"],
                                               row["order_date"], row["ship_city"]))
    except Exception:
        raise Exception


if __name__ == '__main__':

    connect_pg = psycopg2.connect(
        host="localhost",
        database="north",
        user="postgres",
        password="1234"
    )

    try:
        load_data_from_csv(connect_pg, "customers_data.csv")
        load_data_from_csv(connect_pg, "employees_data.csv")
        load_data_from_csv(connect_pg, "orders_data.csv")
    finally:
        connect_pg.close()
