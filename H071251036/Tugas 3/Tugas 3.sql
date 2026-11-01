-- SOAL 1
SELECT
    orderNumber,
    UPPER(productCode) AS "Kode Produk",
    quantityOrdered,
    priceEach
FROM orderdetails
WHERE
    (quantityOrdered BETWEEN 20 AND 50
     OR priceEach < 30)
    AND LEFT(productCode, 3) = 'S18'
ORDER BY quantityOrdered DESC;


-- SOAL 2
SELECT
    customerNumber,
    customerName,
    country,
    creditLimit,
    CONCAT(contactFirstName, ' ', contactLastName) AS "Nama Kontak",
    creditLimit - 10000 AS "Selisih Kredit"
FROM customers
WHERE
    country IN ('USA', 'Canada', 'France')
    AND creditLimit > 30000
ORDER BY creditLimit DESC;


-- SOAL 3
SELECT
    productCode,
    productName,
    buyPrice,
    MSRP,
    GREATEST(buyPrice, MSRP) AS "Harga Tertinggi",
    LEAST(buyPrice, MSRP) AS "Harga Terendah"
FROM products
WHERE LOWER(productName) LIKE '%car%';


-- SOAL 4
SELECT
    orderNumber,
    orderDate,
    shippedDate,
    EXTRACT(YEAR FROM orderDate) AS "Tahun",
    EXTRACT(MONTH FROM orderDate) AS "Bulan",
    (shippedDate - orderDate) AS "Jumlah Hari",
    (shippedDate - orderDate) * INTERVAL '1 day' AS "Interval",
    CURRENT_DATE AS "Tanggal Laporan",
    CURRENT_TIME AS "Waktu Laporan"
FROM orders
WHERE shippedDate IS NOT NULL;


-- SOAL 5
SELECT
    orderNumber,
    orderDate,
    shippedDate,
    orderDate + INTERVAL '10 days' AS "Estimasi Kirim",
    COALESCE(
        shippedDate,
        orderDate + INTERVAL '10 days'
    ) AS "Tanggal Aktual",
    CASE
        WHEN shippedDate IS NOT NULL
        THEN (shippedDate - orderDate) * INTERVAL '1 day'
        ELSE NULL
    END AS "Selisih Waktu"
FROM orders
WHERE
    LOWER(comments) LIKE '%customer%'
    AND EXTRACT(MONTH FROM orderDate) BETWEEN 10 AND 12
    AND orderNumber % 2 = 1
ORDER BY orderDate DESC;