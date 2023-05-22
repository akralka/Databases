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
SELECT DISTINCT Suppliers.CompanyName, Suppliers.Phone
FROM Products
JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE Products.UnitsInStock = 0;

SELECT CompanyName, Phone
FROM Suppliers
WHERE SupplierID IN (
  SELECT DISTINCT SupplierID
  FROM Products
  WHERE UnitsInStock = 0
);

-------------------------------------------------------------------------------------
-- Zadanie1: dla każdego kliena podaj w ilu różnych miesiącach i latach robił zakupy w 1997r
SELECT C.CustomerID, COUNT(DISTINCT YEAR(OrderDate)) AS ROCZEK, COUNT(DISTINCT MONTH(OrderDate)) AS MIESIAC
FROM CUSTOMERS C LEFT JOIN ORDERS O ON
C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) = 1997
GROUP BY C.CustomerID

--1.1 Dla każdego klienta podaj liczbę zamówień w każdym z z lat 1997, 98
SELECT C.CustomerID, YEAR(O.OrderDate) AS YearDate,  COUNT(Year(O.OrderDate)) AS YearCount
FROM Customers AS C
LEFT JOIN Orders AS O
ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) IN (1997, 1998)
GROUP BY YEAR(O.OrderDate), C.CustomerID
ORDER BY C.CustomerID

-- Zadanie2: Dla każdego klienta podaj liczbę zamówień w każdym z miesięcy 1997, 98
SELECT C.CustomerID, YEAR(O.OrderDate) AS YearDate, 
MONTH(O.OrderDate) AS MonthDate, COUNT(MONTH(O.OrderDate)) AS MonthCount
FROM Customers AS C
LEFT JOIN Orders AS O
ON C.CustomerID = O.CustomerID AND YEAR(O.OrderDate) IN (1997, 1998)
GROUP BY YEAR(O.OrderDate), MONTH(O.OrderDate), C.CustomerID
ORDER BY C.CustomerID

-- Zadanie3:  Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma ‘United Package’
select c.CompanyName, c.phone
from customers c join orders o on o.CustomerID=c.CustomerID
where YEAR(ShippedDate) = 1997
AND o.ShipVia IN (
    select ShipperID
    from Shippers
    where CompanyName = 'United Package'
)

-- Zadanie3.1 zmodyfikuj tak, zeby podac liczbę takich zamowien które były zrealizowane dla konkretnego klienta: 
select c.CompanyName, count(CompanyName) AS NumOrders
from customers c join orders o on o.CustomerID=c.CustomerID
AND YEAR(o.ShippedDate) = '1997'
AND o.ShipVia IN (
    select ShipperID
    from Shippers
    where CompanyName = 'United Package'
)
group by CompanyName

-- Zadanie4: Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłek nie dostarczała firma ‘United Package’
select distinct CustomerID from Customers 
where CustomerID not in(
select distinct c.CustomerID
from customers c join orders o on o.CustomerID=c.CustomerID
AND YEAR(o.OrderDate) = 1997
AND o.ShipVia IN (
    select ShipperID
    from Shippers
    where CompanyName = 'United Package'
))

SELECT c.CompanyName, c.phone
FROM Customers c
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT c.CustomerID
    FROM customers c
    JOIN orders o ON o.CustomerID = c.CustomerID
    JOIN Shippers s ON o.ShipVia = s.ShipperID
    WHERE YEAR(o.OrderDate) = 1997
    AND s.CompanyName = 'United Package'
)
-------------------------------------------------------------------------------------
-- 1. Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza
-- library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
select CONCAT(firstname,' ', lastname) as results, birth_date
from member m join juvenile j ON
m.member_no = j.member_no

-- 2. Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao
-- Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką
-- zapłacono kar
SELECT l.copy_no, t.title, l.in_date, l.due_date, l.fine_assessed, l.fine_paid, 
DATEDIFF(day, l.in_date, l.due_date) AS diff
FROM loanhist AS l
JOIN title AS t ON l.title_no = t.title_no
WHERE t.title = 'Tao Teh King' AND l.fine_assessed IS NOT NULL;

-- 3. Napisz polecenie które podaje listę książek (mumery ISBN) zarezerwowanych
-- przez osobę o nazwisku: Stephen A. Graff
SELECT reservation.ISBN
FROM Reservation
JOIN Member ON Reservation.member_no = Member.member_no
WHERE Member.lastname = 'Graff' AND Member.firstname = 'Stephen'

--3.1-------------------------------------------------------------------------------------
-- 1. Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta
select O.OrderID, C.CompanyName, sum(Quantity) as SumOfProducts
from [Order Details] as OD
inner join Orders as O on OD.OrderID = O.OrderID
inner join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, C.CompanyName;

-- 2. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczbę zamówionych jednostek jest większa niż 250
select O.OrderID, C.CompanyName, sum(Quantity) as SumOfProducts
from [Order Details] as OD
inner join Orders as O on OD.OrderID = O.OrderID
inner join Customers as C on O.CustomerID = C.CustomerID
group by O.OrderID, C.CompanyName
having sum(Quantity) > 250

-- 3. Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę
-- klienta.
select o.OrderID, c.CompanyName, round(sum(UnitPrice * Quantity * (1-Discount)),2) as total from orders o join Customers c ON
o.CustomerID = c.CustomerID join [Order Details] d
ON o.OrderID = d.OrderID
group by o.OrderID, c.CompanyName
order by OrderID

-- 4. Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których
-- łączna liczba jednostek jest większa niż 250.
select o.OrderID, c.CompanyName, round(sum(UnitPrice * Quantity * (1-Discount)),2) as total from orders o join Customers c ON
o.CustomerID = c.CustomerID join [Order Details] d
ON o.OrderID = d.OrderID
group by o.OrderID, c.CompanyName
having sum(UnitPrice * Quantity * (1-Discount)) > 250
order by OrderID

-- 5. Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówienie
select o.OrderID, c.CompanyName, concat(firstname, ' ', lastname) as pracownik, round(sum(UnitPrice * Quantity * (1-Discount)),2) as total
from orders o join Customers c ON
o.CustomerID = c.CustomerID join [Order Details] d
ON o.OrderID = d.OrderID join Employees e 
ON e.EmployeeID = o.EmployeeID
group by o.OrderID, c.CompanyName,  concat(firstname, ' ', lastname)
having sum(Quantity) > 250
order by OrderID

-- 6. Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez
-- klientów jednostek towarów z tej kategorii.
select CategoryName, sum(Quantity)
from Categories
join Products P on Categories.CategoryID = P.CategoryID
join [Order Details] od on P.ProductID = od.ProductID
group by CategoryName, P.CategoryID

-- 7. Posortuj wyniki w zapytaniu z poprzedniego punktu wg:
-- a) łącznej wartości zamówień
select CategoryName, sum(Quantity) as TotalValue
from Categories
join Products P on Categories.CategoryID = P.CategoryID
join [Order Details] od on P.ProductID = od.ProductID
group by CategoryName, P.CategoryID
order by sum(Quantity * od.UnitPrice * (1-Discount)) DESC 

-- b) łącznej liczby zamówionych przez klientów jednostek towarów.
select CategoryName, sum(Quantity)
from Categories
join Products P on Categories.CategoryID = P.CategoryID
join [Order Details] od on P.ProductID = od.ProductID
group by CategoryName, P.CategoryID
order by sum(Quantity) DESC 

-- 8. Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
select Orders.OrderID,
round(sum((od.UnitPrice * od.Quantity * (1 - od.Discount))),3)
+ Orders.Freight as 'kwota'
from [Order Details] od
inner join Orders
on od.OrderID = Orders.OrderID
group by Orders.OrderID, Orders.Freight
---------------------------------------------------------------------------------------

-- 1. Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli w 1997r
select CompanyName, count(OrderID) from Shippers   
left join Orders O on Shippers.ShipperID = O.ShipVia
where year(O.ShippedDate) =1997 
group by CompanyName, ShipperID 

-- 1.1 Dla każdego przewoźnika (nazwa) podaj liczbę zamówień które przewieźli od '1997-03-01' do '1997-03-03'
select CompanyName, count(OrderID)
from Shippers left join Orders O on Shippers.ShipperID = O.ShipVia   
and o.ShippedDate between '1997-03-01' and '1997-03-03'group by CompanyName, ShipperID

-- 2. Który z przewoźników był najaktywniejszy (przewiózł największą liczbę
-- zamówień) w 1997r, podaj nazwę tego przewoźnika
select top 1 CompanyName, count(OrderID) c from Shippers   
left join Orders O on Shippers.ShipperID = O.ShipVia
where year(O.ShippedDate) =1997 
group by CompanyName 
order by c desc 

-- 3. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika
select lastname, firstname, count(*)
from Employees e left join Orders o on e.EmployeeID=o.EmployeeID
group by LastName, FirstName

-- 4. Który z pracowników obsłużył największą liczbę zamówień w 1997r, podaj imię i
-- nazwisko takiego pracownika
select top 1 lastname, firstname, count(*) c
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
WHERE YEAR(o.OrderDate) = 1997
group by LastName, FirstName
order by c desc

-- 5. Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o
-- największej wartości) w 1997r, podaj imię i nazwisko takiego pracownika
SELECT TOP 1 e.LastName, e.FirstName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS OrderValue 
FROM employees e 
JOIN orders o ON o.EmployeeID = e.EmployeeID 
JOIN [order details] od ON od.OrderID = o.OrderID 
WHERE YEAR(o.OrderDate) = 1997 
GROUP BY e.LastName, e.FirstName 
ORDER BY OrderValue DESC;

-- 6. Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień
-- obsłużonych przez tego pracownika oraz ogranicz wynik tylko do pracowników:
-- a) którzy mają podwładnych
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice*OD.Quantity*(1-OD.Discount)) AS TotalValue
FROM Employees AS E
JOIN (
    SELECT DISTINCT ReportsTo
    FROM Employees
) AS K ON E.EmployeeID = K.ReportsTo
LEFT JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
GROUP BY E.EmployeeID, E.FirstName, E.LastName

SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalValue
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE E.EmployeeID IN (SELECT ReportsTo FROM Employees)
GROUP BY E.EmployeeID, E.FirstName, E.LastName

-- b) którzy nie mają podwładnych
SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.Quantity*OD.UnitPrice*(1-OD.Discount)) AS TotalValue
FROM Employees AS E
LEFT JOIN (
    SELECT DISTINCT ReportsTo 
    FROM Employees
) AS K ON E.EmployeeID = K.ReportsTo
JOIN Orders AS O
ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] AS OD
ON O.OrderID = OD.OrderID
WHERE K.ReportsTo IS NULL
GROUP BY E.EmployeeID, E.FirstName, E.LastName


SELECT E.EmployeeID, E.FirstName, E.LastName, SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) AS TotalValue
FROM Employees AS E
JOIN Orders AS O ON E.EmployeeID = O.EmployeeID
JOIN [Order Details] AS OD ON O.OrderID = OD.OrderID
WHERE E.EmployeeID NOT IN (SELECT ReportsTo FROM Employees  WHERE ReportsTo IS NOT NULL)
GROUP BY E.EmployeeID, E.FirstName, E.LastName

------------------------------------------------------------------------------------
--3. Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections’

SELECT DISTINCT Customers.CompanyName, Customers.Phone 
FROM Customers INNER JOIN Orders O 
on Customers.CustomerID = O.CustomerID 
INNER JOIN [Order Details] od on O.OrderID = od.OrderID 
INNER JOIN Products P on P.ProductID = od.ProductID 
INNER JOIN Categories C
on C.CategoryID = P.CategoryID WHERE C.CategoryName = 'Confections'

select CompanyName, Phone from Customers C where C.CustomerID 
in (select CustomerID                   
from Orders O                    
inner join [Order Details] od on O.OrderID = od.OrderID   
inner join Products P on P.ProductID = od.ProductID         
inner join Categories C2 on C2.CategoryID = P.CategoryID            
where C2.CategoryName = 'Confections')

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

-- dla kazdego dostawcy liczba dostarczanych zamowien:
SELECT p.supplierid, companyname, count(*) as 'liczba zamowień'
FROM products p
JOIN suppliers s
ON p.supplierid = s.supplierid
group by p.supplierid, CompanyName


select c.CustomerID, CompanyName, month(OrderDate) as month, year(OrderDate) as year, count(OrderID) as suma
from Customers c left join Orders O on c.CustomerID = O.CustomerID 
and year(OrderDate) = 1997 or year(OrderDate) = 1998
where c.CustomerID = 'CENTC'
group by c.CustomerID, CompanyName, year(OrderDate), month(OrderDate)   
order by year(OrderDate), month(OrderDate), CustomerID

