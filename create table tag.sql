create table tag
(
  id serial primary key,
  title varchar(30) not null,
  color varchar(100) not null
);

create table gender
(
 code serial primary key,
 name varchar(10) null,
);

create table client
(
  id serial primary key,
  firstName varchar(50) not null,
  lastName varchar(50) not null,
  patronymic varchar(50) null,
  birthday date null,
  registrationDate datetime not null,
  email varchar(255) null,
  phone varchar(20) not null,
  genderCode varchar(1) references gender(code),
  photoPath varchar(1000) null
);

create table tagOfClient
(
 clientId int references client(id),
 tagId int references tag(id)
);

create table service
(
 id serial primary key,
 title varchar(50) not null,
 cost decimal(19,4) not null,
 durationInSeconds int not null,
 description varchar(2000) null,
 discount double null,
 mainImagePath varchar(1000) null,  
);

create table servicePhoto
(
 id serial primary key,
 serviceID int references service(id),
 photoPath VARCHAR(1000) NOT null
);

create table manufacturer
(
 id serial primary key,
 name VARCHAR(100) NOT NULL,
 startDate date not null
);

create table product
(
 id serial primary key,
 title varchar(100) not null,
 cost decimal(19,4) not null,
 description varchar(2000) null,
 mainImagePath varchar(1000) null,
 isActive int not null,
 manufacturerId int references manufacturer(id)
);

create table productPhoto
(
 id serial primary key,
 productId int references product(id),
 photoPath VARCHAR(1000) NOT NULL
);

create table attachedProduct
(
 mainProductId int references product(id),
 attachedProductId int references product(id),
 primary key(mainProductId, attachedProductId)
);

create table clientService
(
 id serial primary key,
 clientId int references client(id),
 serviceId int references service(id),
 startTime datetime(6) NOT NULL,
 comment varchar(2000) null,
);

create table documentByService
(
 id serial primary key,
 clientServiceId int references clientService(id),
 documentPath VARCHAR(1000) references service(id),
);

create table productSale
(
 id serial primary key,
 saleDate datetime(6) NOT NULL,
 productId int references product(id),
 quantity INT NOT NULL,
 clientServiceId int references clientService(id)
);