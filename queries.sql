-- ===============================
-- CHINOOK SQL ANALYSIS
-- BigQuery Standard SQL
-- ===============================

-- =========================================
-- 1. Топ стран по количеству инвойсов
-- =========================================

SELECT BillingCountry,
       COUNT(*) AS TotalInvoices
FROM `da-nfactorial.chinook.invoice`
GROUP BY BillingCountry
ORDER BY TotalInvoices DESC;


-- =========================================
-- 2. Общая выручка по странам
-- =========================================

SELECT BillingCountry,
       ROUND(SUM(Total), 2) AS TotalRevenue
FROM `da-nfactorial.chinook.invoice`
GROUP BY BillingCountry
ORDER BY TotalRevenue DESC
LIMIT 5;


-- =========================================
-- 3. Выручка по жанрам
-- =========================================

SELECT g.Name AS Genre,
       ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS TotalRevenue
FROM `da-nfactorial.chinook.invoiceline` il
JOIN `da-nfactorial.chinook.track` t
  ON il.TrackId = t.TrackId
JOIN `da-nfactorial.chinook.genre` g
  ON t.GenreId = g.GenreId
GROUP BY Genre
ORDER BY TotalRevenue DESC;


-- =========================================
-- 4. Топ 5 артистов по продажам треков
-- =========================================

SELECT a.Name AS Artist,
       SUM(il.Quantity) AS TotalTracksSold
FROM `da-nfactorial.chinook.invoiceline` il
JOIN `da-nfactorial.chinook.track` t
  ON il.TrackId = t.TrackId
JOIN `da-nfactorial.chinook.album` al
  ON t.AlbumId = al.AlbumId
JOIN `da-nfactorial.chinook.artist` a
  ON al.ArtistId = a.ArtistId
GROUP BY Artist
ORDER BY TotalTracksSold DESC
LIMIT 5;


-- =========================================
-- 5. Средний чек по странам
-- =========================================

SELECT BillingCountry,
       ROUND(AVG(Total), 2) AS AvgInvoice
FROM `da-nfactorial.chinook.invoice`
GROUP BY BillingCountry
ORDER BY AvgInvoice DESC
LIMIT 10;


-- =========================================
-- 6. Самый прибыльный клиент в каждой стране
-- =========================================

WITH CustomerTotals AS (
  SELECT c.CustomerId,
         c.FirstName,
         c.LastName,
         c.Country,
         SUM(i.Total) AS TotalSpent
  FROM `da-nfactorial.chinook.customer` c
  JOIN `da-nfactorial.chinook.invoice` i
    ON c.CustomerId = i.CustomerId
  GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Country
)

SELECT *
FROM CustomerTotals
QUALIFY ROW_NUMBER() OVER (PARTITION BY Country ORDER BY TotalSpent DESC) = 1
ORDER BY Country;


-- =========================================
-- 7. Самый длинный трек
-- =========================================

SELECT Name,
       Milliseconds
FROM `da-nfactorial.chinook.track`
ORDER BY Milliseconds DESC
LIMIT 1;

