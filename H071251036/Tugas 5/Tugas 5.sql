SET search_path TO classicmodels;

-- 1
SELECT
    c.contactfirstname,
    c.customername,
    off.city,
    e.firstname || ' ' || e.lastname AS sales_rep_name
FROM customers c
JOIN employees e
    ON c.salesrepemployeenumber = e.employeenumber
JOIN offices off
    ON e.officecode = off.officecode
WHERE c.contactfirstname ILIKE 'A%'
  AND off.city <> 'NYC'
ORDER BY c.customername ASC;

-- 2
SELECT
    c.customername,
    SUM(p.amount) AS total_payment,
    MAX(p.amount) AS max_single_payment
FROM customers c
JOIN payments p
    ON c.customernumber = p.customernumber
GROUP BY c.customernumber, c.customername
HAVING SUM(p.amount) > 50000
ORDER BY total_payment DESC;

-- 3
SELECT
    c.customername,
    COUNT(DISTINCT o.ordernumber) AS total_order,
    ROUND(AVG(od.quantityordered), 2) AS avg_quantity_per_order
FROM customers c
JOIN orders o
    ON c.customernumber = o.customernumber
JOIN orderdetails od
    ON o.ordernumber = od.ordernumber
GROUP BY c.customernumber, c.customername
HAVING COUNT(DISTINCT o.ordernumber) > 3
   AND AVG(od.quantityordered) > 35
ORDER BY total_order DESC, avg_quantity_per_order DESC;

-- 4
SELECT
    p.productline,
    SUM(od.quantityordered) AS total_terjual,
    ROUND(AVG(od.priceeach), 2) AS rata_rata_harga,
    ROUND(AVG((p.msrp - od.priceeach) / p.msrp * 100), 2) AS avg_discount_percentage
FROM products p
JOIN orderdetails od
    ON p.productcode = od.productcode
GROUP BY p.productline
HAVING SUM(od.quantityordered) > 3000
   AND AVG(od.priceeach) > 80
ORDER BY total_terjual DESC;

-- 5
SELECT
    c.customername,
    SUM(od.quantityordered * od.priceeach) AS total_transaksi,
    COUNT(DISTINCT o.ordernumber)
        FILTER (WHERE o.status = 'Shipped') AS total_shipped_orders,
    ROUND(
        SUM(od.quantityordered * od.priceeach)
        / COUNT(DISTINCT o.ordernumber),
        2
    ) AS avg_transaction_per_order
FROM customers c
JOIN orders o
    ON c.customernumber = o.customernumber
JOIN orderdetails od
    ON o.ordernumber = od.ordernumber
GROUP BY c.customernumber, c.customername
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 1
ORDER BY total_transaksi DESC
LIMIT 5;

-- 6
SELECT
    c.customername,
    c.city AS customer_city,
    off.city AS office_city,
    SUM(od.quantityordered) AS total_unit_terjual,
    ROUND(
        SUM(od.quantityordered * od.priceeach) / COUNT(DISTINCT o.ordernumber),
        2
    ) AS avg_nilai_per_order
FROM customers c
JOIN employees e
    ON c.salesrepemployeenumber = e.employeenumber
JOIN offices off
    ON e.officecode = off.officecode
JOIN orders o
    ON c.customernumber = o.customernumber
JOIN orderdetails od
    ON o.ordernumber = od.ordernumber
WHERE off.territory = 'EMEA'
GROUP BY
    c.customernumber,
    c.customername,
    c.city,
    off.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 2
   AND SUM(od.quantityordered) > 1000
   AND SUM(od.quantityordered * od.priceeach) / COUNT(DISTINCT o.ordernumber) > 10000
ORDER BY avg_nilai_per_order DESC;