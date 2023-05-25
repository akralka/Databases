-------------------przykłady-----------------------
--1.
SELECT P.ProductID, P.ProductName ,(
    SELECT MAX(Quantity) AS MaxQuantity
    FROM [Order Details] AS OD
    WHERE P.ProductID = OD.ProductID
) AS MaxValue
FROM Products AS P

--2.
SELECT DISTINCT productid, quantity
FROM [order details] AS ord1
WHERE quantity = ( SELECT MAX(quantity)
FROM [order details] AS ord2
WHERE ord1.productid =
ord2.productid )
order by productid

--2.1
select productid, max(quantity) as quantity
from [order details]
group by productid
order by productid

--3.
SELECT productname, unitprice
,( SELECT AVG(unitprice)
FROM products as p_wew
WHERE p_zew.categoryid = p_wew.categoryid ) AS
average
FROM products as p_zew

--4.
SELECT productname, unitprice
,( SELECT AVG(unitprice) FROM products as p_wew
WHERE p_zew.categoryid = p_wew.categoryid ) AS
average
FROM products as p_zew
WHERE UnitPrice >
( SELECT AVG(unitprice) FROM products as p_wew
WHERE p_zew.categoryid = p_wew.categoryid )
order by ProductName

--5.
SELECT DISTINCT lastname, e.employeeid
FROM orders AS o
INNER JOIN employees AS e
ON o.employeeid = e.employeeid
WHERE o.orderdate = '9/5/1997'

SELECT lastname, employeeid
FROM employees AS e
WHERE EXISTS (SELECT * FROM orders AS o
WHERE e.employeeid = o.employeeid
AND o.orderdate = '9/5/97')

SELECT lastname, employeeid
FROM employees AS e
WHERE employeeid in (SELECT employeeid FROM orders AS o
WHERE o.orderdate = '9/5/97')

--------------------------------------------------------
-- Podaj nazwy produktów które w marcu 1997 nie były kupowane przez klientów z Francji.
select distinct cus.ProductName from Products as cus 
left join (
select distinct ProductName from Products p left join [Order Details] od on od.ProductID = p.ProductID left JOIN
Orders o on o.OrderID = od.OrderID left JOIN
Customers c on c.CustomerID = o.CustomerID
where year(o.OrderDate) = 1997
and c.Country = 'France'
) as t 
on cus.ProductName = t.ProductName
where t.ProductName IS NULL

-- podaj nazwy klientów którzy w marcu 1997 nie skladali zamówień
select distinct companyname from Customers
where CustomerID not in (select distinct CustomerID from orders
where year(OrderDate) = 1997
and month(OrderDate) = 03
) 
order by  CompanyName

-- 1.Dla każdego takiego produktu podaj jego nazwę, nazwę kategorii do której należy ten produkt oraz jego cenę.
 
-- 2.Podaj nazwy produktów z kategorii confection, które w marcu 1997 nie były kupowane przez klientów z Francji.
 
-- 3.Dla każdego takiego produktu podaj jego nazwę, nazwę kategorii do której należy ten produkt oraz jego cenę.
 
-- 4.Wyświetl nazwy produktów, kupionych między '1997-02-01' i '1997-05-01' przez co najmniej 6 różnych klientów

-- 5.Dla każdego dorosłego czytelnika podaj sumę kar zapłaconych za
-- przetrzymywanie książek przez jego dzieci
-- interesują nas czytelnicy którzy mają dzieci
----------------------------
--1.
with rec as
(
select 1 as x
union all
select x+1 from rec where x<30
)
select x from rec;

--2.
select * from generate_series(cast('2023-01-20' as date),cast('2022-03-02' as date));

--3.
with t as (
select value from generate_series(1,12)
)
select dateadd(day, value, cast('2023-01-20' as date)) from t

