-- 1) Podaj listę dzieci będących członkami biblioteki, które w dniu '2001-12-14' 
-- zwróciły do biblioteki książkę o tytule 'Walking'. Zbiór wynikowy powinien 
-- zawierać imię i nazwisko oraz dane adresowe dziecka. (baza library)

select distinct m.firstname, m.lastname, a.street, a.city, a.state from member m JOIN
juvenile j on j.member_no = m.member_no JOIN
adult a on a.member_no = j.adult_member_no join
loanhist lh on lh.member_no = m.member_no join 
title t on t.title_no = lh.title_no 
where title = 'Walking'
and year(lh.in_date) = 2001
and  month(lh.in_date) = 12
and day(lh.in_date) = 14

-- 2) Podaj nazwy produktów należących do kategorii 'Dairy Products',
-- które w marcu 1997 nie były kupowane przez klientów z Francji.
-- Dla każdego takiego produktu podaj jego nazwę, cenę, oraz nazwę
-- dostawcy (dostawcy to suppliers). Zbiór wynikowy powinien zawierać
-- nazwę produktu, cenę, nazwę dostawcy. Zbiór wynikowy powinien być
-- uporządkowany wg nazwy produktu. (baza northwind)
    
use Northwind
select pr.ProductName, pr.UnitPrice, s.CompanyName from Categories cat join Products pr on pr.CategoryID = cat.CategoryID join 
Suppliers s on s.SupplierID = pr.SupplierID
left join (
    select p.ProductName from customers c join orders o on o.customerid = c.customerid
    join [Order Details] od on od.OrderID = o.OrderID join Products p on 
    p.ProductID = od.ProductID
    where c.Country = 'France'
    and year(OrderDate) = 1997
    and month(orderdate) = 03
) as t 
on t.ProductName = pr.productname
where t.ProductName is NULL
and cat.CategoryName = 'Dairy Products'
order by ProductName
    
----------------------------------------------------------------------------
SELECT Products.ProductName, Products.UnitPrice, S.CompanyName FROM 
Products
INNER JOIN Categories C on C.CategoryID = Products.CategoryID
LEFT OUTER JOIN Suppliers S on Products.SupplierID = S.SupplierID
WHERE C.CategoryName = 'Dairy Products' AND Products.ProductID NOT IN (
    SELECT P.ProductID FROM Customers
    INNER JOIN Orders O on Customers.CustomerID = O.CustomerID
    INNER JOIN [Order Details] "[O D]" on O.OrderID = "[O D]".OrderID
    INNER JOIN Products P on P.ProductID = "[O D]".ProductID
    INNER JOIN Categories C on C.CategoryID = P.CategoryID
    WHERE Country = 'France' AND YEAR(O.OrderDate) = 1997 AND 
MONTH(O.OrderDate) = 3 AND C.CategoryName = 'Dairy Products')
ORDER BY Products.ProductName


-- 3)
-- Podaj liczbę̨ zamówień oraz wartość zamówień (uwzględnij opłatę za przesyłkę) 
-- obsłużonych przez każdego pracownika w lutym 1997. Za datę obsłużenia zamówienia 
-- należy uznać datę jego złożenia (orderdate). Jeśli pracownik nie obsłużył w 
-- tym okresie żadnego zamówienia, to też powinien pojawić się na liście 
-- (liczba obsłużonych zamówień oraz ich wartość jest w takim przypadku równa 0).
-- Zbiór wynikowy powinien zawierać: imię i nazwisko pracownika,
-- liczbę obsłużonych zamówień, wartość obsłużonych zamówień. (baza northwind)

with t as (
    select sum(unitprice * quantity * (1-discount) + Freight) as dochod, count(o.OrderID) as ile_zamowien, e.EmployeeID
    from orders o join [order details] od on o.orderid= od.orderid JOIN
    Employees e on e.EmployeeID = o.EmployeeID
    WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = '02'
    group by e.EmployeeID, Freight
)

select  e.FirstName, e.LastName, ISNULL(SUM(t.ile_zamowien), 0) as liczba_zamowien, ISNULL(Sum(t.dochod),0) as dochód from Employees e 
left join t on e.EmployeeID = t.EmployeeID
group by e.LastName, e.FirstName
ORDER BY e.LastName


--4) Pokaż nazwy produktów, które nie byly z kategorii 'Beverages' które nie były kupowane w
--okresie od '1997.02.20' do '1997.02.25'. Dla każdego takiego produktu podaj jego nazwę,
--nazwę dostawcy (supplier), oraz nazwę kategorii.
--Zbiór wynikowy powinien zawierać nazwę produktu, nazwę dostawcy oraz nazwę kategorii.

use northwind
select pr.ProductName, s.CompanyName, cat.CategoryName from Products pr join Suppliers s on s.SupplierID = pr.SupplierID join 
Categories cat on cat.CategoryID = pr.CategoryID
left join (
    select p.ProductName from Products p join 
    [Order Details] od on od.ProductID = p.ProductID JOIN
    Orders o on o.OrderID = od.OrderID
    where O.OrderDate BETWEEN '1997.02.20' and '1997.02.25'
) as t 
on t.ProductName = pr.productname
where t.ProductName IS NULL
and cat.CategoryName != 'Beverages'

--
USE Northwind
SELECT DISTINCT Products.ProductName, CompanyName, CategoryName
FROM [Order Details]
JOIN [Orders]
ON [Order Details].[OrderID] = Orders.OrderID
JOIN Products
ON Products.ProductID = [Order Details].ProductID
JOIN Suppliers
ON Suppliers.SupplierID = Products.SupplierID
JOIN Categories
ON Categories.CategoryID = Products.CategoryID
WHERE Categories.CategoryName <> 'Beverages' AND Products.ProductID NOT IN (
    SELECT ProductID
    FROM [Order Details]
    JOIN [Orders]
    ON [Order Details].[OrderID] = Orders.OrderID AND (Orders.OrderDATE BETWEEN '1997-02-20' AND '1997-02-25')
)

----------
SELECT DISTINCT
    ProductName,
    CategoryName,
    CompanyName
FROM
    [Order Details]
INNER JOIN
    Products
ON
    [Order Details].ProductID = Products.ProductID
INNER JOIN
    Suppliers
ON
    Suppliers.SupplierID = Products.SupplierID
INNER JOIN
    Categories
On
    Categories.CategoryID = Products.CategoryID
WHERE
    [Order Details].ProductID NOT IN
    (
        SELECT
            ProductID
        FROM
            Products
        INNER JOIN
            Categories
        ON
            Products.CategoryID = Categories.CategoryID
        WHERE
            CategoryName = 'Beverages'
    )
    AND [Order Details].ProductID NOT IN
    (
        SELECT
            ProductID
        FROM
            [Order Details]
        INNER JOIN
            Orders
        ON
            [Order Details].OrderID = Orders.OrderID
        WHERE
            year(OrderDate) = 1997
            AND month(OrderDate) = 02
            AND day(OrderDate) BETWEEN 20 AND 25
    )

-- 5) Podaj listę dzieci będących członkami biblioteki, dla każdego z tych dzieci podaj:
-- Imię, nazwisko, imię rodzica (opiekuna), nazwisko rodzica (opiekuna)

USE library
SELECT m1.firstname as imie_dziecka, m1.lastname as nazwisko_dziecka, m2.firstname as imie_rodzica,
m2.lastname as nazwisko_rodzica
FROM juvenile
JOIN adult
ON juvenile.adult_member_no = adult.member_no
JOIN member m1
ON juvenile.member_no = m1.member_no
JOIN member m2
ON adult.member_no = m2.member_no


--6) Wyświetl wszystkich pracowników, którzy mają podwładnych. Dla każdego z takich
--pracowników podaj wartość obsłużonych przez niego zamówień w 1997r (sama wartość
--zamówień bez opłaty za przesyłkę)
use Northwind
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalValue
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE E.EmployeeID IN (SELECT ReportsTo FROM Employees)
and year(orderdate) = 1997
GROUP BY E.EmployeeID, E.FirstName, E.LastName

-- tu nie mają podwładnych
SELECT  E.FirstName, E.LastName, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalValue
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE E.EmployeeID NOT IN (SELECT ReportsTo FROM Employees  WHERE ReportsTo IS NOT NULL)
GROUP BY  E.FirstName, E.LastName


--7) Wyświetl nr zamówień złożonych w marcu 1997, które nie zawierały produktów z kategorii
--"confections"

select o.orderid from Orders o
left join(
select od.OrderID from [Order Details] od join Products p on p.ProductID = od.ProductID JOIN
Categories c on c.CategoryID = p.CategoryID
where c.CategoryName = 'Confections'
) as t 
on t.orderid = o.OrderID
where t.OrderID IS NULL
and year(orderdate) =  1997
and month(OrderDate) = 03
order by OrderID

---
select OrderID
from orders
where year(orderdate) = 1997
  and month(orderdate) = 3
  and orderid not in (select orderid
                      from [order details] od
                               inner join products p on od.productid = p.productid
                               inner join categories c on p.categoryid = c.categoryid
                      where categoryname = 'confections')

------
USE Northwind
SELECT DISTINCT Orders.OrderID
FROM Orders
JOIN [Order Details]
ON [Order Details].OrderID = Orders.OrderID
JOIN Products 
ON Products.ProductID = [Order Details].[ProductID]
WHERE YEAR(Orders.OrderDate) = '1997' AND MONTH(Orders.OrderDate) = '03' AND Orders.OrderID NOT IN (
    SELECT Orders.OrderID
    FROM Orders
    JOIN [Order Details]
    ON [Order Details].OrderID = Orders.OrderID
    JOIN Products 
    ON Products.ProductID = [Order Details].[ProductID]
    JOIN Categories
    ON Categories.CategoryID = Products.CategoryID AND Categories.CategoryName = 'Confections'
    WHERE YEAR(Orders.OrderDate) = '1997' AND MONTH(Orders.OrderDate) = '03'
)


-- 8) Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produków z kategorii ‘Confections’
SELECT DISTINCT CA.CustomerID 
FROM Customers AS CA
LEFT JOIN (
    SELECT 
    DISTINCT C.CustomerID
    FROM Customers C
    JOIN Orders O ON O.CustomerID = C.CustomerID
    JOIN [Order Details] OD ON OD.OrderID = O.OrderID
    JOIN Products P ON P.ProductID = OD.ProductID
    JOIN Categories Cat ON Cat.CategoryID = P.CategoryID
    WHERE Cat.CategoryName = 'Confections'
) AS CC
ON CA.CustomerID = CC.CustomerID
WHERE CC.CustomerID IS NULL 

    
-- 9.)Napisz polecenie które wyświetla imiona i nazwiska dorosłych członków biblioteki,
--  mieszkających w Arizonie (AZ) lub Kalifornii (CA),
--  których wszystkie dzieci są urodzone przed '2000-10-14'

use library
SELECT DISTINCT mr.firstname, mr.lastname
FROM adult a
JOIN member mr ON a.member_no = mr.member_no
LEFT JOIN juvenile j ON a.member_no = j.adult_member_no  --left bo uwzgledniamy kto ma dzieci
WHERE state IN ('AZ', 'CA')
  AND NOT EXISTS (
    SELECT *
    FROM juvenile j2
    WHERE j2.adult_member_no = a.member_no --Jeśli nie istnieje żadne dziecko, które jest urodzone po
    AND j2.birth_date >= '2000-10-14'    -- '2000-10-14', to wybieramy
  );                              

 -- 10.) Imie nazwisko i adres czytelnika, ile książek wypożyczył aktualnie. Jesli żadnej to też ma sie pojawić
SELECT c.FirstName, c.LastName, c.Address, COALESCE(COUNT(b.BookID), 0) AS BooksBorrowed
FROM Borrowers b
RIGHT JOIN Customers c ON b.CardID = c.CardID
WHERE b.Status IN ('borrowed', 'overdue') OR b.Status IS NULL
GROUP BY c.FirstName, c.LastName, c.Address
ORDER BY c.LastName, c.FirstName

---------
SELECT c.FirstName, c.LastName, c.Address, COALESCE((
    SELECT COUNT(*)
    FROM Borrowers b
    WHERE b.CardID = c.CardID AND b.Status IN ('borrowed', 'overdue')
), 0) AS BooksBorrowed
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Borrowers b
    WHERE b.CardID = c.CardID AND b.Status IN ('borrowed', 'overdue')
)
ORDER BY c.LastName, c.FirstName


-- 11.) Liczba i ilość zamówień dla każdego klienta w lutym 1997. Jeśli nie składał, też ma być na liście
SELECT Customers.CompanyName, ISNULL(COUNT(DISTINCT Orders.OrderID), 0) AS LiczbaZamowien, ISNULL(SUM((OrderDetails.UnitPrice * OrderDetails.Quantity * (1 - OrderDetails.Discount))) + ISNULL(Orders.Freight, 0), 0) AS SumaZamowien
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID AND YEAR(Orders.OrderDate) = 1997 AND MONTH(Orders.OrderDate) = 2
LEFT JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.CompanyName
ORDER BY Customers.CompanyName


-- 12.) Klienci którzy nigdy nie zamówili produktu z kat. 'Seafood'
SELECT DISTINCT CompanyName
FROM Customers
LEFT JOIN (
    SELECT DISTINCT Orders.CustomerID
    FROM Orders
    INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
    INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
    INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
    WHERE Categories.CategoryName = 'Seafood'
) AS SeafoodCustomers
ON Customers.CustomerID = SeafoodCustomers.CustomerID
WHERE SeafoodCustomers.CustomerID IS NULL
