SET search_path TO classicmodels;

-- Nomor 1
SELECT
    customerNumber,
    SUM(amount) AS total_pembayaran,
    COUNT(DISTINCT checkNumber) AS jumlah_transaksi,
    MAX(amount) AS pembayaran_terbesar
FROM payments
GROUP BY customerNumber
HAVING COUNT(DISTINCT checkNumber) > 4
   AND AVG(amount) > 20000;

-- Nomor 2
SELECT
    customerNumber,
    SUM(amount) AS total_pembayaran
FROM payments
GROUP BY customerNumber
HAVING SUM(amount) > 80000
ORDER BY total_pembayaran DESC;

-- Nomor 3
SELECT
    productLine AS kategori_produk,
    COUNT(productCode) AS jumlah_produk,
    ROUND(AVG(MSRP), 2) AS rata_rata_harga,
    STRING_AGG(productName, ', ' ORDER BY productName)
        AS daftar_produk
FROM products
GROUP BY productLine
HAVING COUNT(productCode) > 10;

-- Nomor 4 
SELECT DISTINCT reportsTo
FROM employees
WHERE reportsTo IS NOT NULL 
EXCEPT
SELECT employeeNumber
FROM employees
WHERE jobTitle ILIKE '%VP%' OR jobTitle ILIKE '%President%';

-- Nomor 5
SELECT
    productCode,
    SUM(quantityOrdered) AS total_unit_terjual,
    ROUND(AVG(priceEach), 2) AS rata_rata_harga
FROM orderdetails
WHERE priceEach > 100
GROUP BY productCode
HAVING SUM(quantityOrdered) > 50
ORDER BY total_unit_terjual DESC;

-- Nomor 6
SELECT
    productCode,
    SUM(quantityOrdered) AS total_unit_dipesan,
    SUM(quantityOrdered * priceEach) AS total_pendapatan,
    ROUND(AVG(priceEach), 2) AS rata_rata_harga,
    MAX(priceEach) - MIN(priceEach) AS rentang_harga
FROM orderdetails
WHERE quantityOrdered > 20
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY total_pendapatan DESC;

-- Nomor 7 
(
    SELECT customerNumber
    FROM customers
    WHERE creditLimit > 80000

    INTERSECT

    SELECT customerNumber
    FROM orders
    WHERE status = 'Cancelled'
       OR status = 'On Hold'
)
EXCEPT
(
    SELECT customerNumber
    FROM payments
    GROUP BY customerNumber
    HAVING SUM(amount) > 100000
)
ORDER BY customerNumber;