-- 1. Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej
-- pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy

select productName, unitprice, address, city, Country 
from suppliers JOIN products
ON suppliers.SupplierID = products.SupplierID
WHERE unitprice Between 20.00 AND 30.00 

-- 2. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów
-- dostarczanych przez firmę ‘Tokyo Traders’ 

select productname, unitsinstock
from Products p join Suppliers s
ON p.SupplierID = s.SupplierID
where CompanyName = 'Tokyo Traders'

select ProductName, UnitsInStock from Products
where SupplierID in (select SupplierID from Suppliers where CompanyName = 'Tokyo Traders');

declare @id int;set @id = (select SupplierID from Suppliers where CompanyName = 'Tokyo Traders')
select ProductName, UnitsInStock from Products where SupplierID = @id;

-- 3. Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku, jeśli tak
-- to pokaż ich dane adresowe

SELECT C.CustomerID, C.CompanyName, CONCAT( Address, City, Region, PostalCode, Country) as Address 
FROM Customers C LEFT JOIN Orders O
ON C.CustomerID = O.CustomerID
AND YEAR(OrderDate) IN ('1997')
WHERE O.OrderID IS NULL


select distinct c.CustomerID, ContactName from Customers c
left outer join orders o on c.CustomerID  = o.CustomerID
where c.CustomerID not in (
    select CustomerID from Orders
    where year(OrderDate) = 1997
)
order by c.CustomerID

select c.CustomerID, c.CompanyName, c.City from Customers c left join Orders o on c.CustomerID = o.CustomerID                                      
and year(orderdate) = 1997 group by c.CustomerID, c.CompanyName, c.City having count(orderid) = 0

select c.CustomerID, c.CompanyName, c.City from Customers c left join (select orderid, customerid from Orders o 
where year(orderdate) = 1997) o97               
on c.CustomerID = o97.CustomerID where orderid is null order by orderid

SELECT *
FROM Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM Orders
    WHERE YEAR(OrderDate) = 1997
);

-- 4. Wybierz nazwy i numery telefonów dostawców, dostarczających produkty,
-- których aktualnie nie ma w magazynie
-- SELECT DISTINCT Suppliers.CompanyName, Suppliers.Phone
-- FROM Products
-- JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
-- WHERE Products.UnitsInStock = 0;

-- SELECT CompanyName, Phone
-- FROM Suppliers
-- WHERE SupplierID IN (
--   SELECT DISTINCT SupplierID
--   FROM Products
--   WHERE UnitsInStock = 0
-- );

-------------------------------------------------------------------------------------
-- Zadanie1: dla każdego kliena podaj w ilu różnych miesiącach i latach robił zakupy w 1997r

-- SELECT C.CustomerID, COUNT(DISTINCT YEAR(OrderDate)) AS ROCZEK, COUNT(DISTINCT MONTH(OrderDate)) AS MIESIAC
-- FROM CUSTOMERS C LEFT JOIN ORDERS O ON
-- C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) = 1997
-- GROUP BY C.CustomerID

-- Zadanie2: Dla każdego klienta podaj liczbę zamówień w każdym z miesięcy 1997, 98
-- SELECT C.CustomerID, YEAR(O.OrderDate) AS YearDate, 
--     MONTH(O.OrderDate) AS MonthDate, COUNT(MONTH(O.OrderDate)) AS MonthCount
-- FROM Customers AS C
-- LEFT JOIN Orders AS O
-- ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) IN (1997, 1998)
-- GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate), C.CustomerID
-- ORDER BY C.CustomerID

-- Zadanie3:  Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma ‘United Package’

-- select c.CompanyName, c.phone
-- from customers c join orders o on o.CustomerID=c.CustomerID
-- AND YEAR(o.OrderDate) = 1997
-- AND o.ShipVia IN (
--     select ShipperID
--     from Shippers
--     where CompanyName = 'United Package'
-- )

-- Zadanie3.1 zmodyfikuj tak, zeby podac liczbę takich zamowien które były zrealizowane dla konkretnego klienta: 
-- select c.CompanyName, count(CompanyName) AS NumOrders
-- from customers c join orders o on o.CustomerID=c.CustomerID
-- AND YEAR(o.OrderDate) = '1997'
-- AND o.ShipVia IN (
--     select ShipperID
--     from Shippers
--     where CompanyName = 'United Package'
-- )
-- group by CompanyName

-- Zadanie4: Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłek nie dostarczała firma ‘United Package’
-- select c.CompanyName, c.phone
-- from customers c join orders o on o.CustomerID=c.CustomerID
-- AND YEAR(o.OrderDate) = 1997
-- AND o.ShipVia NOT IN (
--     select ShipperID
--     from Shippers
--     where CompanyName = 'United Package'
-- )


-- select count(*) from Orders where YEAR(OrderDate) = 1997
-------------------------------------------------------------------------------------
-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
-- select CONCAT_WS(' ', firstname, lastname) as results, birth_date
-- from member m join juvenile j ON
-- m.member_no = j.member_no


-- 2. Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek

-- 3. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao
-- Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką
-- zapłacono kar
-- SELECT l.copy_no, t.title, l.in_date, l.due_date, l.fine_assessed, l.fine_paid, DATEDIFF(day, l.in_date, l.due_date) AS diff
-- FROM loanhist AS l
-- JOIN title AS t ON l.title_no = t.title_no
-- WHERE t.title = 'Tao Teh King' AND l.fine_assessed IS NOT NULL;


-- 4. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych
-- przez osobę o nazwisku: Stephen A. Graff

-- SELECT reservation.ISBN
-- FROM Reservation
-- JOIN Member ON Reservation.member_no = Member.member_no
-- WHERE Member.lastname = 'Graff' AND Member.firstname = 'Stephen'








--3.1-------------------------------------------------------------------------------------
-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta
-- select O.OrderID, C.CompanyName, sum(Quantity) as SumOfProducts
-- from [Order Details] as OD
-- inner join Orders as O on OD.OrderID = O.OrderID
-- inner join Customers as C on O.CustomerID = C.CustomerID
-- group by O.OrderID, C.CompanyName;

-- 2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczbę zamówionych jednostek jest większa niż 250


-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
-- klienta.


-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250.


-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówienie
-- select O.OrderID, C.CompanyName, concat(E.FirstName, ' ', E.LastName) as Employee , sum((UnitPrice * Quantity) * (1 - Discount)) as TotalSum
-- from [Order Details] as OD
-- inner join Orders as O on OD.OrderID = O.OrderID
-- inner join Customers as C on O.CustomerID = C.CustomerID
-- inner join Employees E on O.EmployeeID = E.EmployeeID
-- group by O.OrderID, C.CompanyName, E.FirstName, E.LastName
-- having sum(Quantity) > 250

-- 1.Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.


-- 2. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tek kategorii.
-- select CategoryName, sum(Quantity)
-- from Categories
-- join Products P on Categories.CategoryID = P.CategoryID
-- join [Order Details] "[O D]" on P.ProductID = "[O D]".ProductID
-- group by CategoryName, P.CategoryID



-- 3. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
-- b) łącznej liczby zamówionych przez klientów jednostek towarów.


-- 4. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
-- select Orders.OrderID,
-- sum(cast(([Order Details].UnitPrice * [Order Details].Quantity * (1 - [Order Details].Discount)) as decimal(10,2)))
-- + Orders.Freight as 'kwota'
-- from [Order Details]
-- inner join Orders
-- on [Order Details].OrderID = Orders.OrderID
-- group by Orders.OrderID, Orders.Freight
---------------------------------------------------------------------------------------

-- 1. -- Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
-- select CompanyName, count(OrderID) from Shippers   
-- left join Orders O on Shippers.ShipperID = O.ShipVia
-- and year(O.ShippedDate) =1997 
-- group by CompanyName, ShipperID 

-- select CompanyName, count(OrderID)
-- from Shippers left join Orders O on Shippers.ShipperID = O.ShipVia  
-- where year(O.ShippedDate) =1997group by CompanyName, ShipperID

-- select CompanyName, count(OrderID)
-- from Shippers left join Orders O on Shippers.ShipperID = O.ShipVia   
-- and o.ShippedDate between '1997-03-01' and '1997-03-03'group by CompanyName, ShipperID


-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę
-- zamówień) w 1997r, podaj nazwę tego przewoźnika

-- select top 1 CompanyName, count(OrderID) c from Shippers   
-- left join Orders O on Shippers.ShipperID = O.ShipVia
-- and year(O.ShippedDate) =1997 
-- group by CompanyName 
-- order by c desc 

-- 3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
-- select lastname, firstname, count(*)
-- from Employees e join Orders o on e.EmployeeID=o.EmployeeID
-- group by LastName, FirstName

-- 4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
-- nazwisko takiego pracownika
-- select top 1 lastname, firstname, count(*) c
-- from Employees e join Orders o on e.EmployeeID=o.EmployeeID
-- WHERE YEAR(o.OrderDate) = 1997
-- group by LastName, FirstName
-- order by c desc

-- 5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
-- SELECT TOP 1 e.LastName, e.FirstName, SUM(od.UnitPrice * od.Quantity) AS OrderValue 
-- FROM employees e 
-- JOIN orders o ON o.EmployeeID = e.EmployeeID 
-- JOIN [order details] od ON od.OrderID = o.OrderID 
-- WHERE YEAR(o.OrderDate) = 1997 
-- GROUP BY e.LastName, e.FirstName 
-- ORDER BY OrderValue DESC;


-- 1. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
-- – Ogranicz wynik tylko do pracowników
-- a) którzy mają podwładnych
-- b) którzy nie mają podwładnych

------------------------------------------------------------------------------------
-- select c.CustomerID, CompanyName, month(OrderDate), year(OrderDate), count(OrderID)
-- from Customers c    left join Orders O on c.CustomerID = O.CustomerID 
-- and year(OrderDate) = 1997 or year(OrderDate) = 1998
-- where c.CustomerID = 'CENTC'group by c.CustomerID, CompanyName, year(OrderDate), month(OrderDate)   
-- order by year(OrderDate), month(OrderDate), CustomerID

--1. Dla każdego klienta podaj liczbę zamówień w każdym z z lat 1997, 98
SELECT C.CustomerID, YEAR(O.OrderDate) AS YearDate,  COUNT(Year(O.OrderDate)) AS YearCount
FROM Customers AS C
LEFT JOIN Orders AS O
ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) IN (1997, 1998)
GROUP BY YEAR(O.OrderDate), C.CustomerID
ORDER BY C.CustomerID

--2. Dla każdego klienta podaj liczbę zamówień w każdym z miesięcy 1997, 98

SELECT C.CustomerID, YEAR(O.OrderDate) AS YearDate, 
    MONTH(O.OrderDate) AS MonthDate, COUNT(MONTH(O.OrderDate)) AS MonthCount
FROM Customers AS C
LEFT JOIN Orders AS O
ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) IN (1997, 1998)
GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate), C.CustomerID
ORDER BY C.CustomerID

--3. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections’

-- SELECT DISTINCT Customers.CompanyName, Customers.Phone 
-- FROM Customers INNER JOIN Orders O 
-- on Customers.CustomerID = O.CustomerID 
-- INNER JOIN [Order Details] od on O.OrderID = od.OrderID 
-- INNER JOIN Products P on P.ProductID = od.ProductID 
-- INNER JOIN Categories C
-- on C.CategoryID = P.CategoryID WHERE C.CategoryName = 'Confections'

-- select CompanyName, Phone from Customers C where C.CustomerID 
-- in (select CustomerID                   
-- from Orders O                    
-- inner join [Order Details] od on O.OrderID = od.OrderID   
-- inner join Products P on P.ProductID = od.ProductID         
-- inner join Categories C2 on C2.CategoryID = P.CategoryID            
-- where C2.CategoryName = 'Confections')
----------


-- 4.Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produków z kategorii ‘Confections’

SELECT Customers.CompanyName, Customers.Phone
FROM Customers LEFT OUTER JOIN Orders O on Customers.CustomerID = O.CustomerID 
LEFT OUTER JOIN [Order Details] od on O.OrderID = od.OrderID
LEFT  OUTER JOIN Products P on P.ProductID = od.ProductID
LEFT  OUTER JOIN Categories C on C.CategoryID = P.CategoryID AND (C.CategoryName = 'Confections')
GROUP BY Customers.CustomerID, Customers.CompanyName, Customers.Phone
HAVING COUNT(C.CategoryID) = 0

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
--5. Wybierz nazwy i numery telefonów klientów, którzy w 1997 kupowali produkty z kategorii ‘Confections’


--6.  Wybierz nazwy i numery telefonów klientów, którzy w 1997 nie kupowali produków z kategorii ‘Confections’



-----------------------przykłady--------------------------------------

-- select sum(UnitPrice*Quantity*(1-Discount))
-- from [Order Details]
-- where OrderID = 10250

-- select Freight
-- from Orders
-- where OrderID = 10250

use joindb
select * from Produce
select * from Sales
select * from Buyers


select buyer_name, s.buyer_id, prod_id, qty 
from buyers JOIN sales as s
ON buyers.buyer_id = s.buyer_id

--TO SAMO CO WYŻEJ:

select buyer_name, s.buyer_id, prod_id, qty 
from buyers b, sales as s
WHERE b.buyer_id = s.buyer_id

SELECT buyer_name, sales.buyer_id, qty
FROM buyers left OUTER JOIN sales
ON buyers.buyer_id = sales.buyer_id

use Northwind
SELECT productname, companyname
FROM products
INNER JOIN suppliers
ON products.supplierid = suppliers.supplierid

-- dla kazdego dostawcy liczba dostarczancyh zamowien:
select SupplierID, count(*) as liczba
from Products
group by SupplierID

-- połączone:
SELECT products.supplierid, companyname, count(*) as 'liczba zamowień na poszczególnego'
FROM products
INNER JOIN suppliers
ON products.supplierid = suppliers.supplierid
group by products.supplierid, CompanyName

select * from Customers
select * from Orders

SELECT companyname, customers.customerid, orderdate
FROM customers
LEFT JOIN orders
ON customers.customerid = orders.customerid
where orderdate IS NULL