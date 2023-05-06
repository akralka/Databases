-- 1. Wybierz nazwy i adresy wszystkich klientów
SELECT CompanyName, Address, City, Region,PostalCode,Country FROM Customers

-- 2. Wybierz nazwiska i numery telefonów pracowników
select LastName, HomePhone from Employees;

-- 3. Wybierz nazwy i ceny produktów
select ProductName, UnitPrice from Products; 

-- 4. Pokaż wszystkie kategorie produktów (nazwy i opisy)
select CategoryName, Description from Categories;

-- 5. Pokaż nazwy i adresy stron www dostawców
select HomePage from Suppliers;
------------------------------------------

-- 1. Wybierz nazwy i adresy wszystkich klientów mających siedziby w Londynie
select CompanyName, Address, City, Region, PostalCode, Country from Customers WHERE city='London';

-- 2. Wybierz nazwy i adresy wszystkich klientów mających siedziby we Francji lub w Hiszpanii
select CompanyName, Address from Customers WHERE Country='France' OR Country='Spain';

-- 3. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 20 AND 30

-- 4. Wybierz nazwy i ceny produktów z kategorii ‘meat’
SELECT ProductName, UnitPrice FROM Products
INNER JOIN Categories C on C.CategoryID = Products.CategoryID
WHERE C.CategoryName LIKE '%meat%'

SELECT ProductName, UnitPrice
FROM Products
WHERE CategoryID IN (
    SELECT CategoryID
    FROM Categories
    WHERE CategoryName LIKE '%meat%'
);

-- 5. Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’ */
select ProductName, UnitsInStock from Products
where SupplierID in (select SupplierID from Suppliers where CompanyName = 'Tokyo Traders');

SELECT ProductName, UnitsInStock FROM Products
INNER JOIN Suppliers S on S.SupplierID = Products.SupplierID
WHERE S.CompanyName = 'Tokyo Traders'

-- 6. Wybierz nazwy produktów których nie ma w magazynie
SELECT ProductName FROM Products WHERE UnitsInStock = 0
----------------------------------------------------------

-- 1. Szukamy informacji o produktach sprzedawanych w butelkach (‘bottle’)
select ProductName, QuantityPerUnit from Products where QuantityPerUnit like '%bottle%'
-- 
-- 2. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę z zakresu od B do L
SELECT Title, LastName FROM Employees WHERE LastName LIKE '[b-l]%'
SELECT Title, LastName FROM Employees WHERE LastName >= 'B' AND LastName < 'M'

-- 3. Wyszukaj informacje o stanowisku pracowników, których nazwiska zaczynają się na literę B lub L
select LastName, Title from Employees where LastName LIKE '[BL]%';

-- 4. Znajdź nazwy kategorii, które w opisie zawierają przecinek
SELECT CategoryName, Description FROM Categories WHERE Categories.Description LIKE '%,%'

-- 5. Znajdź klientów, którzy w swojej nazwie mają w którymś miejscu słowo ‘Store’
select ContactName, CompanyName from Customers WHERE CompanyName LIKE '%Store%';
----------------------------------------------------------------------------

-- 1. Szukamy informacji o produktach o cenach mniejszych niż 10 lub większych niż 20  
select * from Products WHERE UnitPrice NOT BETWEEN 10 AND 22; 
select * from Products WHERE (UnitPrice < 10.00 OR UnitPrice > 22.00) 

-- 2. Wybierz nazwy i ceny produktów o cenie jednostkowej pomiędzy 20.00 a 30.00
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice BETWEEN 20 AND 30
---------------------------------------------------------------------------
-- 
-- 1. Wybierz nazwy i kraje wszystkich klientów mających siedziby we Włoszech (Italy) lub w Szwecji (Sweden)
SELECT CompanyName, Country FROM Customers WHERE Country = 'Italy' OR Country = 'Sweden'
SELECT CompanyName, Country FROM Customers WHERE Country IN ('Sweden','Italy')

-- 2. Napisz instrukcję select tak aby wybrać numer zlecenia, datę zamówienia, numer
klienta dla wszystkich niezrealizowanych jeszcze zleceń, dla których krajem
odbiorcy jest Argentyna
select OrderID, OrderDate, CustomerID from Orders
where ShipCountry='Argentina' and (ShippedDate is null or ShippedDate >= getdate());                   
------------------------------------------------------------------------------------

-- 1. Wybierz nazwy i kraje wszystkich klientów, wyniki posortuj według kraju, w
ramach danego kraju nazwy firm posortuj alfabetycznie
SELECT CompanyName,Country FROM Customers ORDER BY Country, CompanyName

-- 2. Wybierz informację o produktach (grupa, nazwa, cena), produkty posortuj wg
grup a w grupach malejąco wg ceny

SELECT Products.CategoryID, Categories.CategoryID , Categories.CategoryName, Products.UnitPrice 
FROM Products, Categories 
WHERE Products.CategoryID = Categories.CategoryID 
ORDER BY Categories.CategoryName, Products.UnitPrice DESC;

SELECT C.CategoryID, CategoryName, UnitPrice FROM Products
INNER JOIN Categories C on C.CategoryID = Products.CategoryID
ORDER BY C.CategoryName, UnitPrice DESC

-- 3. Wybierz nazwy i kraje wszystkich klientów mających siedziby w Japonii (Japan)
lub we Włoszech (Italy), wyniki posortuj tak jak w pkt 1
SELECT CompanyName, Country FROM Customers
         WHERE Country = 'Japan' OR Country = 'Italy'
 ORDER BY Country, CompanyName
----------------------------------------------------------------------

-- 1. Napisz polecenie, które oblicza wartość każdej pozycji zamówienia o numerze 10250
SELECT *, ROUND(UnitPrice *  Quantity * (1 - Discount), 2)FROM [Order Details] WHERE ORderID = 10250
select *, ((UnitPrice * Quantity)* (1-Discount)) AS 'cena ostateczna' from [Order Details] where OrderID = '10250'

-- 2. Napisz polecenie które dla każdego dostawcy (supplier) pokaże pojedynczą
kolumnę zawierającą nr telefonu i nr faksu w formacie
(numer telefonu i faksu mają być oddzielone przecinkiem)

SELECT IIF(Fax IS NULL, Phone, CONCAT(Phone, ',', Fax)) AS formatted FROM Suppliers
SELECT CONCAT(Phone, ISNULL(',' + Fax, '')) AS formatted FROM Suppliers

-- pokaż zamówienia złożone w marcu 97
SELECT * FROM orders
WHERE YEAR(OrderDate) = 1997 AND MONTH(OrderDate) = 3

-- Dla każdego zamówienia wyświetl ile dni upłynęło od daty zamówienia do daty wysyłki
SELECT ShippedDate, RequireDdate, DATEDIFF(day, ShippedDate, RequiredDate) AS DaysBetween
FROM orders
WHERE ShippedDate IS NOT NULL

-- Pokaz przeterminowane zamówienia
SELECT *
FROM orders
WHERE ShippedDate IS NULL AND RequiredDate < GETDATE()

-- Ile lat przepracował w firmie każdy z pracowników?
select *,  DATEDIFF(year, HireDate, Getdate()) AS Yearsincompany from employees 

-- Dla każdego pracownika wyświetl imię, nazwisko oraz wiek
SELECT FirstName, LastName, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM employees

-- Wyświetl wszystkich pracowników, którzy mają teraz więcej niż 65 lat.
SELECT FirstName, LastName, DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
FROM employees
WHERE DATEDIFF(YEAR, BirthDate, GETDATE()) > 65

-- Policz średnią liczbę miesięcy przepracowanych przez każdego pracownika
SELECT AVG(DATEDIFF(MONTH, HireDate, GETDATE())) AS AverageMonths
FROM employees

-- Wyświetl dane wszystkich pracowników, którzy przepracowali w firmie co najmniej 320 miesięcy, ale nie więcej niż 333

-- Dla każdego pracownika wyświetl imię, nazwisko, rok urodzenia, rok, w którym został
-- zatrudniony, oraz liczbę lat, którą miał w momencie zatrudnienia

-- Dla każdego pracownika wyświetl imię, nazwisko oraz rok, miesiąc i dzień jego
-- urodzenia oraz dzień tygodnia w jakim się urodził

-- Policz, z ilu liter składa się najkrótsze imię pracownika

-- Wyświetl, ile lat minęło od daty 1 stycznia 1990 roku.


