-- 1.2 Biblioteka
-- • Książka może być pożyczona na okres max 14 dni. Czytelnik może
-- mieć co najwyżej 4 książki.
-- • Gdy termin zwrotu został przekroczony, czytelnik po tygodniu
-- dostaje upomnienie.
-- • Czytelnik wybiera książki, podaje obsłudze kartę magnetyczną na
-- podstawie której następuje identyfikacja czytelnika. Pokazują się
-- dane czytelnika oraz informacje o ważności karty.
-- • Pokazują się również informacje o wypożyczeniach, tzn. tytuł, data
-- zwrotu, ew. zaległości.
-- • Gdy wszystko jest w porządku, książka jest wypożyczana
-- • Jeśli czytelnik przekroczy ustalony termin zwrotu, moe zostać
-- naliczona kara.
-- • Każda książka (tytuł) może mieć kilka wydań. Różne wydania mają
-- różne ISBN. W bibliotece jest zwykle kilka egzemplarzy danego
-- wydania.
-- • Jeżeli czytelnik chce pożyczyć książkę, której aktualnie nie ma jest
-- robiona dla niego rezerwacja. Gdy książka zostaje zwrócona
-- powiadamia się czytelnika najdłużej czekającego (max 4 rezerwacje)
-- • Nowy czytelnik musi podać adres i telefon. Dostaje ważną na rok
-- kartę biblioteczną
-- • Młodzież do 18 roku może być czytelnikiem, za zgodą dorosłego
-- czytelnika. Jego karta ważna wraz z ważnością karty dorosłego


--1.3------------------------------------------------------------

-- 1. Napisz polecenie select, za pomocą którego uzyskasz tytuł i numer książki
select title_no, title from title

-- 2. Napisz polecenie, które wybiera tytuł o numerze 10
select title from title where title_no = 10

-- 3. Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i
-- autora z tablicy title dla wszystkich książek, których autorem jest Charles
-- Dickens lub Jane Austen
select title_no, author from title where author IN ('Jane Austen', 'Charles Dickens')

-- 1. Napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich książek,
-- których tytuły zawierających słowo „adventure”
select * from title where title like '%adventure%'

-- 2. Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę
select member_no, fine_paid from loanhist 

-- 3. Napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy
-- adult.
select distinct city, state from adult ORDER BY city, state

-- 4. Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w
-- porządku alfabetycznym.
SELECT title FROM title ORDER BY title;

/*1. Napisz polecenie, które:
– wybiera numer członka biblioteki (member_no), isbn książki (isbn) i watrość
naliczonej kary (fine_assessed) z tablicy loanhist dla wszystkich wypożyczeń
dla których naliczono karę (wartość nie NULL w kolumnie fine_assessed)
– stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny
fine_assessed i  stwórz alias ‘double fine’ dla tej kolumny */

select distinct  member_no, isbn, fine_assessed, fine_assessed * 2 AS double_fine 
from loanhist where fine_assessed IS NOT NULL order by member_no

/*1. Napisz polecenie, które
– generuje pojedynczą kolumnę, która zawiera kolumny: firstname (imię
członka biblioteki), middleinitial (inicjał drugiego imienia) i lastname
(nazwisko) z tablicy member dla wszystkich członków biblioteki, którzy
nazywają się Anderson
– nazwij tak powstałą kolumnę email_name (użyj aliasu email_name dla
kolumny)
– zmodyfikuj polecenie, tak by zwróciło „listę proponowanych loginów e-mail”
utworzonych przez połączenie imienia członka biblioteki, z inicjałem
drugiego imienia i pierwszymi dwoma literami nazwiska (wszystko małymi
małymi literami).
– Wykorzystaj funkcję SUBSTRING do uzyskania części kolumny
znakowej oraz LOWER do zwrócenia wyniku małymi literami.
Wykorzystaj operator (+) do połączenia stringów. */

select LOWER(firstname + middleinitial + SUBSTRING(lastname, 1, 2)) 
AS email_name from member where lastname = 'Anderson' 

/* 1.Napisz polecenie, które wybiera title i title_no z tablicy title.
§ Wynikiem powinna być pojedyncza kolumna o formacie jak w przykładzie
poniżej:
The title is: Poems, title number 7
§ Czyli zapytanie powinno zwracać pojedynczą kolumnę w oparciu o
wyrażenie, które łączy 4 elementy:
stała znakowa ‘The title is:’
wartość kolumny title
stała znakowa ‘title number’
wartość kolumny title_no */

SELECT CONCAT('The title is: ', title, ', title number ', title_no) AS title_info FROM title;
