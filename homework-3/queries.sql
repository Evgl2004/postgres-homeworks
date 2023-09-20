-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)
SELECT
    customers.company_name AS company_name,
    CONCAT(employees.first_name, ' ', employees.last_name) AS full_name
FROM
    orders
        LEFT JOIN customers
        ON orders.customer_id = customers.customer_id
			LEFT JOIN employees
			ON orders.employee_id = employees.employee_id
				LEFT JOIN shippers
				ON orders.ship_via = shippers.shipper_id
WHERE
	customers.city = 'London'
	AND employees.city = 'London'
	AND shippers.company_name = 'United Package'


-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.
SELECT
    products.product_name AS product_name,
    products.units_in_stock AS units_in_stock,
	suppliers.contact_name AS contact_name,
	suppliers.phone AS phone
FROM
    products
        LEFT JOIN suppliers
        ON products.supplier_id = suppliers.supplier_id
			LEFT JOIN categories
        	ON products.category_id = categories.category_id
WHERE
	products.discontinued <> 1
	AND (categories.category_name = 'Dairy Products'
		OR categories.category_name = 'Condiments')
	AND products.units_in_stock < 25
ORDER BY
	products.units_in_stock


-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа
SELECT
    customers.company_name AS company_name
FROM
    customers
WHERE
	customers.customer_id NOT IN (
		SELECT DISTINCT
			orders.customer_id
		FROM
			orders)


-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.
SELECT
	products.product_name AS product_name
FROM
	products
WHERE
	products.product_id IN (
		SELECT DISTINCT
			order_details.product_id
		FROM
			order_details
		WHERE
			order_details.quantity = 10)
