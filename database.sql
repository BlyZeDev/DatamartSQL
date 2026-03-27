create database if not exists bookstore character set utf8mb4 collate utf8mb4_unicode_ci;
use bookstore;

-- Datenbankstruktur

create table if not exists Genre(
    Id bigint unsigned not null primary key auto_increment,
    Name varchar(100) not null
);

create table if not exists Author(
    Id bigint unsigned not null primary key auto_increment,
    FirstName varchar(100) not null,
    LastName varchar(100) not null
);

create table if not exists Language(
    Code varchar(3) not null primary key,
    Name varchar(100) not null
);

create table if not exists Publisher(
    Id bigint unsigned not null primary key auto_increment,
    Name varchar(255) not null
);

create table if not exists Address(
    Id bigint unsigned not null primary key auto_increment,
    Street varchar(255) not null,
    Postcode char(5) not null,
    City varchar(100) not null,
    Country varchar(100) not null
);

create table if not exists Location(
    Id bigint unsigned not null primary key auto_increment,
    Latitude decimal(9,6) not null,
    Longitude decimal(9,6) not null,
    Address_Id bigint unsigned not null,

    foreign key(Address_Id) references Address(Id)
    on delete cascade
    on update cascade
);

create table if not exists Book(
    Id bigint unsigned not null primary key auto_increment,
    Isbn char(13) not null unique,
    Title varchar(255) not null,
    ReleaseDate date not null,
    Publisher_Id bigint unsigned not null,
    Language_Code varchar(3) not null,

    foreign key(Publisher_Id) references Publisher(Id)
    on delete cascade
    on update cascade,
    foreign key(Language_Code) references Language(Code)
    on delete cascade
    on update cascade
);

create table if not exists User(
    Id bigint unsigned not null primary key auto_increment,
    Email varchar(255) not null unique,
    FirstName varchar(100) not null,
    LastName varchar(100) not null,
    PhoneNumber varchar(50) not null,
    JoinedDate date not null
);

create table if not exists Bookcopy(
    Id bigint unsigned not null primary key auto_increment,
    Book_Id bigint unsigned not null,
    User_Id bigint unsigned not null,
    Location_Id bigint unsigned not null,
    `Condition` varchar(50) not null,

    foreign key(Book_Id) references Book(Id)
    on delete cascade
    on update cascade,
    foreign key(User_Id) references User(Id)
    on delete cascade
    on update cascade,
    foreign key(Location_Id) references Location(Id)
    on delete cascade
    on update cascade
);

create table if not exists DeliveryOption(
    Id bigint unsigned not null primary key auto_increment,
    Bookcopy_Id bigint unsigned not null,
    IsDeliveryPossible boolean not null,

    foreign key(Bookcopy_Id) references Bookcopy(Id)
    on delete cascade
    on update cascade
);

create table if not exists Availability(
    Id bigint unsigned not null primary key auto_increment,
    Bookcopy_Id bigint unsigned not null,
    MaxDays int unsigned not null,

    foreign key(Bookcopy_Id) references Bookcopy(Id)
    on delete cascade
    on update cascade
);

create table if not exists Lending(
    Id bigint unsigned not null primary key auto_increment,
    Bookcopy_Id bigint unsigned not null,
    User_Id bigint unsigned not null,
    StartDate date not null,
    EndDate date not null,

    foreign key(Bookcopy_Id) references Bookcopy(Id)
    on delete cascade
    on update cascade,
    foreign key(User_Id) references User(Id)
    on delete cascade
    on update cascade,

    check(EndDate >= StartDate)
);

create table if not exists Rating(
    Id bigint unsigned not null primary key auto_increment,
    Book_Id bigint unsigned not null,
    User_Id bigint unsigned not null,
    Stars tinyint unsigned not null,
    Comment text not null,

    foreign key(Book_Id) references Book(Id)
    on delete cascade
    on update cascade,
    foreign key(User_Id) references User(Id)
    on delete cascade
    on update cascade,

    check(Stars between 1 and 5)
);

create table if not exists BookAuthor(
    Id bigint unsigned not null primary key auto_increment,
    Book_Id bigint unsigned not null,
    Author_Id bigint unsigned not null,

    foreign key(Book_Id) references Book(Id)
    on delete cascade
    on update cascade,
    foreign key(Author_Id) references Author(Id)
    on delete cascade
    on update cascade
);

create table if not exists BookGenre(
    Id bigint unsigned not null primary key auto_increment,
    Book_Id bigint unsigned not null,
    Genre_Id bigint unsigned not null,

    foreign key(Book_Id) references Book(Id)
    on delete cascade
    on update cascade,
    foreign key(Genre_Id) references Genre(Id)
    on delete cascade
    on update cascade
);

create index idx_book_title on Book(Title);
create index idx_user_email on User(Email);

-- Testdatensätze
insert into Language values
('DE','Deutsch'),
('EN','English'),
('FR','Français'),
('ES','Español'),
('IT','Italiano'),
('NL','Nederlands'),
('PL','Polski'),
('PT','Português'),
('SE','Svenska'),
('DK','Dansk');

insert into Genre(Name) values
('Fantasy'),
('Science Fiction'),
('Romance'),
('Thriller'),
('Horror'),
('Drama'),
('Biography'),
('History'),
('Programming'),
('Philosophy');

insert into Author(FirstName, LastName) values
('J.K.','Rowling'),
('George','Orwell'),
('Stephen','King'),
('Jane','Austen'),
('Yuval Noah','Harari'),
('Robert','Martin'),
('J.R.R.','Tolkien'),
('Dan','Brown'),
('Isaac','Asimov'),
('Friedrich','Nietzsche');

insert into Publisher(Name) values
('Penguin'),
('HarperCollins'),
('Springer'),
('OReilly'),
('Random House'),
('Klett'),
('Reclam'),
('C.H. Beck'),
('Pearson'),
('Bloomsbury');

insert into Book(Isbn, Title, ReleaseDate, Publisher_Id, Language_Code) values
('9780747532743','Harry Potter','1997-06-26',10,'EN'),
('9780451524935','1984','1949-06-08',1,'EN'),
('9780307743657','The Shining','1977-01-28',5,'EN'),
('9780141439518','Pride and Prejudice','1813-01-28',1,'EN'),
('9780062316097','Sapiens','2011-01-01',2,'EN'),
('9780132350884','Clean Code','2008-08-01',4,'EN'),
('9780261103573','The Hobbit','1937-09-21',10,'EN'),
('9780307474278','Da Vinci Code','2003-03-18',5,'EN'),
('9780553293357','Foundation','1951-01-01',1,'EN'),
('9783150094068','Also sprach Zarathustra','1883-01-01',7,'DE');

insert into User(Email, FirstName, LastName, PhoneNumber, JoinedDate) values
('anna@test.de','Anna','Schmidt','0151123456','2023-01-10'),
('max@test.de','Max','Müller','0151987654','2023-02-12'),
('lisa@test.de','Lisa','Becker','0151456789','2023-03-14'),
('tom@test.de','Tom','Wagner','0151876543','2023-04-01'),
('sara@test.de','Sara','Fischer','0151345678','2023-05-20'),
('paul@test.de','Paul','Weber','0151765432','2023-06-11'),
('emma@test.de','Emma','Klein','0151654321','2023-07-22'),
('noah@test.de','Noah','Wolf','0151432198','2023-08-13'),
('mia@test.de','Mia','Schneider','0151987123','2023-09-30'),
('leon@test.de','Leon','Richter','0151123987','2023-10-05');

insert into Address(Street, Postcode, City, Country) values
('Hauptstr. 1','10115','Berlin','Germany'),
('Bahnhofstr. 2','80331','München','Germany'),
('Marktplatz 3','20095','Hamburg','Germany'),
('Ringstr. 4','50667','Köln','Germany'),
('Goethestr. 5','60311','Frankfurt','Germany'),
('Lindenweg 6','70173','Stuttgart','Germany'),
('Schulstr. 7','40213','Düsseldorf','Germany'),
('Parkallee 8','28195','Bremen','Germany'),
('Seestr. 9','01067','Dresden','Germany'),
('Wiesenweg 10','90402','Nürnberg','Germany');

insert into Location(Latitude, Longitude, Address_Id) values
(52.5200,13.4050,1),
(48.1351,11.5820,2),
(53.5511,9.9937,3),
(50.9375,6.9603,4),
(50.1109,8.6821,5),
(48.7758,9.1829,6),
(51.2277,6.7735,7),
(53.0793,8.8017,8),
(51.0504,13.7373,9),
(49.4521,11.0767,10);

insert into Bookcopy(Book_Id, User_Id, Location_Id, `Condition`) values
(1,1,1,'Sehr gut'),
(2,2,2,'Gut'),
(3,3,3,'Akzeptabel'),
(4,4,4,'Sehr gut'),
(5,5,5,'Neu'),
(6,6,6,'Gut'),
(7,7,7,'Sehr gut'),
(8,8,8,'Gut'),
(9,9,9,'Akzeptabel'),
(10,10,10,'Sehr gut');

insert into DeliveryOption(Bookcopy_Id, IsDeliveryPossible) values
(1,true),(2,false),(3,true),(4,true),(5,false),
(6,true),(7,false),(8,true),(9,true),(10,false);

insert into Availability(Bookcopy_Id, MaxDays) values
(1,14),(2,7),(3,21),(4,14),(5,30),
(6,10),(7,14),(8,7),(9,21),(10,14);

insert into Lending(Bookcopy_Id, User_Id, StartDate, EndDate) values
(1,2,'2024-01-01','2024-01-14'),
(2,3,'2024-02-01','2024-02-07'),
(3,4,'2024-03-01','2024-03-21'),
(4,5,'2024-04-01','2024-04-14'),
(5,6,'2024-05-01','2024-05-30'),
(6,7,'2024-06-01','2024-06-10'),
(7,8,'2024-07-01','2024-07-14'),
(8,9,'2024-08-01','2024-08-07'),
(9,10,'2024-09-01','2024-09-21'),
(10,1,'2024-10-01','2024-10-14');

insert into Rating(Book_Id, User_Id, Stars, Comment) values
(1,2,5,'Tolles Buch'),
(2,3,4,'Sehr spannend'),
(3,4,4,'Gruselig und gut'),
(4,5,5,'Klassiker'),
(5,6,5,'Sehr informativ'),
(6,7,5,'Pflichtlektüre'),
(7,8,4,'Abenteuerlich'),
(8,9,3,'Unterhaltsam'),
(9,10,5,'SciFi Meisterwerk'),
(10,1,4,'Philosophisch');

insert into BookAuthor(Book_Id, Author_Id) values
(1,1),(2,2),(3,3),(4,4),(5,5),
(6,6),(7,7),(8,8),(9,9),(10,10);

insert into BookGenre(Book_Id, Genre_Id) values
(1,1),(2,2),(3,5),(4,3),(5,8),
(6,9),(7,1),(8,4),(9,2),(10,10);

-- Testfall: Benutzer leiht ein Buch aus und bewertet es anschließend

-- 1. Buch prüfen
select id, title
from book
where title = 'Harry Potter';

-- 2. Exemplar prüfen
select id, book_id, user_id
from bookcopy
where book_id = 1;

-- 3. Benutzer prüfen
select id, firstname, lastname
from user
where firstname = 'Max' and lastname = 'Müller';

-- 4. Ausleihe durchführen
insert into lending (bookcopy_id, user_id, startdate, enddate)
values (1, 2, curdate(), date_add(curdate(), interval 14 day));

-- 5. Ausleihe überprüfen
select l.id, b.title, u.firstname, u.lastname, l.startdate, l.enddate
from lending l
join bookcopy bc on l.bookcopy_id = bc.id
join book b on bc.book_id = b.id
join user u on l.user_id = u.id
where u.id = 2;

-- 6. Buch bewerten
insert into rating (book_id, user_id, stars, comment)
values (1, 2, 5, 'Fantastisches Buch!');

-- 7. Bewertung anzeigen
select b.title, u.firstname, r.stars, r.comment
from rating r
join book b on r.book_id = b.id
join user u on r.user_id = u.id
where b.id = 1;

-- 8. Durchschnittsbewertung berechnen
select b.title, round(avg(r.stars), 2) as averagerating
from rating r
join book b on r.book_id = b.id
where b.id = 1
group by b.title;