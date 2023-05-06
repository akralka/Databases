-- 1. Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż
-- 20$
SELECT COUNT(*) FROM products WHERE UnitPrice NOT BETWEEN 10.00 AND 20.00

-- 2. Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
select TOP 1 UnitPrice from Products where UnitPrice < 20.00 ORDER BY UnitPrice DESC
select MAX(Unitprice) from Products where unitprice < 20.00

-- 3. Podaj maksymalną i minimalną i średnią cenę produktu dla produktów o
-- produktach sprzedawanych w butelkach (‘bottle’)
select MAX(unitprice) AS max, MIN(UnitPrice) AS min, AVG(UnitPrice) AS avg from Products
 where QuantityPerUnit LIKE '%bottle%'

-- 4. Wypisz informację o wszystkich produktach o cenie powyżej średniej
SELECT * FROM products WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM products)

-- 5. Podaj sumę/wartość zamówienia o numerze 10250
select sum(unitprice * quantity * (1-Discount)) from [Order Details] where orderid = 10250

-- 1. Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select orderid, MAX(unitprice) from [order details] group by orderid order by orderid

-- 2. Posortuj zamówienia wg maksymalnej ceny produktu
select orderid, MAX(unitprice) AS maximum from [Order Details] group by orderid order by maximum DESC

-- 3. Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego
-- zamówienia
select orderid, MAX(unitprice) AS maximum, MIN(unitprice) AS minimum from [Order Details] 
group by orderid order by orderid

-- 4. Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów
-- (przewoźników)
SELECT ShipVia, COUNT(*) AS num_orders
FROM Orders
GROUP BY ShipVia

-- 5. Który z spedytorów był najaktywniejszy w 1997 roku
SELECT TOP 1 ShipVia, COUNT(*) AS num_orders
FROM Orders
GROUP BY ShipVia
order by num_orders DESC

-- 1. Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
SELECT OrderID, OrderDate
FROM Orders
WHERE OrderID IN (
  SELECT OrderID
  FROM [Order Details]
  GROUP BY OrderID
  HAVING COUNT(*) > 5
)

select orders.orderid from orders join [Order Details]
on orders.OrderID = [Order Details].OrderID
group by orders.orderid 
having count(*) > 5

-- 2. Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień
-- (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla
-- każdego z klientów)
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS total_spent
FROM Customers c, Orders o, [Order Details] od
WHERE c.CustomerID = o.CustomerID
AND o.OrderID = od.OrderID
AND YEAR(o.OrderDate) = 1998
AND c.CustomerID IN (
  SELECT CustomerID
  FROM Orders
  WHERE YEAR(OrderDate) = 1998
  GROUP BY CustomerID
  HAVING COUNT(*) > 8
)
GROUP BY c.CustomerID, c.CompanyName
ORDER BY total_spent DESC


-- ------2.1-----------------------------------------
-- 1. Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia
-- w tablicy order details i zwraca wynik posortowany w malejącej kolejności
-- (wg wartości sprzedaży).
select orderid, SUM(UnitPrice * Quantity * (1- Discount)) AS value
from [Order Details] 
group by OrderID order by value desc

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych
-- 10 wierszy
select TOP 10 orderid, SUM(UnitPrice * Quantity * (1- Discount)) AS value
from [Order Details] 
group by OrderID order by value desc

-- 1. Podaj liczbę zamówionych jednostek produktów dla produktów, dla których
-- productid < 3
SELECT SUM(Quantity) AS TotalUnitsOrdered
FROM [Order Details]
WHERE ProductID < 3

-- 2. Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę
-- zamówionych jednostek produktu dla wszystkich produktów
SELECT ProductID, SUM(Quantity) AS TotalUnitsOrdered
FROM [Order Details]
GROUP BY ProductID
having ProductID < 3

-- 3. Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których
-- łączna liczba zamawianych jednostek produktów jest > 250
select orderid, SUM(unitprice * Quantity) AS suma_zamowienia from [Order Details]
group by orderid
having SUM(Quantity) > 250

-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień
select EmployeeID, COUNT(OrderID) from orders group by EmployeeID 

-- 2. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień
select ShipVia, sum(freight) AS opłata from orders group by ShipVia 

-- 3. Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę"
-- przewożonych przez niego zamówień w latach od 1996 do 1997
select ShipVia, sum(freight) AS opłata from orders 
where orderdate IN (
  SELECT OrderDate
  FROM Orders
  WHERE YEAR(OrderDate) = 1996
  OR YEAR(OrderDate) = 1997
)
group by ShipVia 

SELECT ShipVia, SUM(Freight) AS WartoscOplaty
FROM orders
WHERE YEAR(OrderDate) BETWEEN 1996 AND 1997
GROUP BY ShipVia


-- 1. Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z
-- podziałem na lata i miesiące
SELECT 
    EmployeeID,
    YEAR(OrderDate) AS Rok,
    MONTH(OrderDate) AS Miesiac,
    COUNT(*) AS LiczbaZamowien
FROM orders
GROUP BY 
    EmployeeID, 
    YEAR(OrderDate), 
    MONTH(OrderDate)
ORDER BY 
    EmployeeID, 
    YEAR(OrderDate), 
    MONTH(OrderDate)

-- 2. Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej
-- kategorii
select CategoryID, MAX(Unitprice) as maxi, MIN(UnitPrice) AS mini 
from products
group by CategoryID

-----------------przykłady---------------------------

SELECT productid, sum(quantity) AS total_quantity
FROM [order details]
where ProductID between 10 and 15
group by productid
order by productid

SELECT productid, SUM(quantity)
AS total_quantity
FROM [Order Details]
GROUP BY productid
HAVING SUM(quantity)<=200
order by total_quantity