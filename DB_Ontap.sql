create database QLBH_JV240408;
use QLBH_JV240408;
create table Customer(
	cID int auto_increment primary key,
    Name varchar(25),
    cAge tinyint
);

create table Orders(
	oID int auto_increment primary key,
    cID int,
    oDate datetime,
    oTotalPrice int,
    foreign key(cID) references Customer(cID)
);

create table Product(
	pID int auto_increment primary key,
    pName varchar(25),
    pPrice int
);

create table OrderDetail(
	oID int not null,
    pID int not null,
    odQTY int,
    primary key(oID,pID),
    foreign key(oID) references Orders(oID),
    foreign key(pID) references Product(pID)
);

-- data Customer
insert into Customer(Name,cAge) values
('Minh Quan',10),
('Ngoc Oanh',20),
('Hong Ha',50);

-- data Orders
insert into Orders(cID,oDate) values
(1,'2006-03-21'),
(2,'2006-03-23'),
(1,'2006-03-16');

-- Product
insert into Product(pName,pPrice) values
('May Giat',3),
('Tu Lanh',5),
('Dieu Hoa',7),
('Quat',1),
('Bep Dien',2);

-- data OrderDetail
insert into OrderDetail(oID,pID,odQTY) values
(1,1,3),
(1,3,7),
(1,4,2),
(2,1,1),
(3,1,8),
(2,5,4),
(2,3,3);

/*
2. Hiển thị các thông tin gồm oID,cID, oDate, oTotalPrice của tất cả các hóa đơn trong bảng Orders, 
danh sách phải sắp xếp theo thứ tự ngày tháng, hóa đơn mới hơn nằm trên như hình sau:*/
select * from Orders order by oDate desc;

/*3. Hiển thị tên và giá của các sản phẩm có giá cao nhất như sau:*/
select pName,pPrice from Product where pPrice = (select max(pPrice) from Product);

/*4. Hiển thị danh sách các khách hàng đã mua hàng, và danh sách sản phẩm được mua bởi các khách đó như sau:*/
select c.Name,p.pName from Customer c inner join Orders o on c.cID=o.cID inner join OrderDetail od on o.oID=od.oID inner join Product p 
on od.pID=p.pID;

/*5. Hiển thị tên những khách hàng không mua bất kỳ một sản phẩm nào như sau:*/
select Name from Customer where cID not in (select distinct cID from Orders);

/*6. Hiển thị chi tiết của từng hóa đơn như sau :*/
select o.oID,o.oDate,od.odQTY,p.pName,p.pPrice from Orders o inner join OrderDetail od on o.oID=od.oID inner join Product p on od.pID=p.pID;

/*7. Hiển thị mã hóa đơn, ngày bán và giá tiền của từng hóa đơn 
(giá một hóa đơn được tính bằng tổng giá bán của từng loại mặt hàng xuất hiện trong hóa đơn. Giá bán của từng loại được tính = odQTY*pPrice) như sau:*/
select o.oID,o.oDate,sum(od.odQTY*p.pPrice) as Total from Orders o inner join OrderDetail od on o.oID=od.oID  inner join Product p on od.pID=p.pID group by o.oID;

/*8. Tạo một view tên là Sales để hiển thị tổng doanh thu của siêu thị như sau: [2.5]*/
create or replace view Sales
as
select sum(od.odQTY*p.pPrice) as Sales from OrderDetail od inner join Product p on od.pID=p.pID;

/*9. Xóa tất cả các ràng buộc khóa ngoại, khóa chính của tất cả các bảng. [1.5]*/
show create table OrderDetail;

/*Chạy lệnh trên để lấy tên của khóa ngoại và khóa chính, sau đó thực hiện lệnh xóa theo tên*/
alter table OrderDetail drop constraint orderdetail_ibfk_1;
alter table OrderDetail drop constraint orderdetail_ibfk_2;
alter table OrderDetail drop PRIMARY KEY;

alter table Orders modify column oID int not null;
alter table Orders drop primary key;

show create table Orders;
alter table Orders drop constraint orders_ibfk_1;

alter table Product modify column pID int not null;
alter table Product drop primary key;

alter table Customer modify column cID int not null;
alter table Customer drop primary key;

/*10. Tạo một trigger tên là cusUpdate trên bảng Customer, sao cho khi sửa mã khách (cID) thì mã khách trong bảng Order cũng được sửa theo: . [2.5]*/
drop trigger if exists cusUpdate;
delimiter $$
create trigger cusUpdate 
after update on Customer 
for each row
begin
	update Orders set cID = new.cID;
end;
$$

/*11. Tạo một stored procedure tên là delProduct nhận vào 1 tham số là tên của một sản phẩm, 
strored procedure này sẽ xóa sản phẩm có tên được truyên vào thông qua tham số, và các thông tin liên quan đến sản phẩm đó ở trong bảng OrderDetail*/
delimiter $$
create procedure delProduct(
	pName_in varchar(25)
)
begin
	delete from OrderDetail where pID in (select pID from Product where pName = pName_in);
	delete from Product where pName = pName_in;
end;
$$


