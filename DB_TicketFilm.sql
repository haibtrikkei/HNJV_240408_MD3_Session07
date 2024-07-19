create database TicketFilm;
use TicketFilm;
create table tblPhim (
	PhimID int auto_increment primary key,
    Ten_phim varchar(30),
    Loai_phim varchar(25),
    Thoi_gian int
);

create table tblPhong(
	PhongID int auto_increment primary key,
    Ten_phong varchar(20),
    Trang_thai tinyint
);

create table tblGhe(
	GheID int auto_increment primary key,
    PhongID int,
    So_ghe varchar(10),
    constraint FK_tblGhe_PhongID foreign key(PhongID) references tblPhong(PhongID)
);

create table tblVe(
	PhimID int not null,
    GheID int not null,
    Ngay_chieu datetime,
    Trang_thai varchar(20),
    primary key(PhimID,GheID),
    constraint FK_tblVe_PhongID foreign key(PhimID) references tblPhim(PhimID),
    constraint FK_tblVe_GheID foreign key(GheID) references tblGhe(GheID)
);

-- 
insert into tblPhim(Ten_phim,Loai_phim,Thoi_gian) values
('Em bé Hà Nội','Tâm lý',90),
('Nhiệm vụ bất khả thi','Hành động',100),
('Dị Nhân','Viễn Tưởng',90),
('Cuốn theo chiều gió','Tình cảm',120);

--
insert into tblPhong(Ten_phong,Trang_thai) values
('Phòng chiếu 1',1),
('Phòng chiếu 2',1),
('Phòng chiếu 3',0);

--
insert into tblGhe(PhongID,So_ghe) values
(1,'A3'),
(1,'B5'),
(2,'A7'),
(2,'D1'),
(3,'T2');

--
insert into tblVe(PhimId,GheId,Ngay_chieu,Trang_thai) values
(1,1,'2008-10-20','Đã bán'),
(1,3,'2008-11-20','Đã bán'),
(1,4,'2008-12-23','Đã bán'),
(2,1,'2009-02-14','Đã bán'),
(3,1,'2009-02-14','Đã bán'),
(2,5,'2009-03-08','Chưa bán'),
(2,3,'2009-03-08','Chưa bán');

/*2. Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)*/
select * from tblPhim order by  Thoi_gian asc;

/*3. Hiển thị Ten_phim có thời gian chiếu dài nhất*/
select * from tblPhim where Thoi_gian = (select max(Thoi_gian) from tblPhim);

/*4. Hiển thị Ten_Phim có thời gian chiếu ngắn nhất*/
select * from tblPhim where Thoi_gian = (select min(Thoi_gian) from tblPhim);

/*5. Hiển thị danh sách So_Ghe mà bắt đầu bằng chữ ‘A’ */
select * from tblGhe where So_ghe like 'A%';

/*6. Sửa cột Trang_thai của bảng tblPhong sang kiểu nvarchar(25)*/
alter table tblPhong modify column Trang_thai varchar(25);

/*
7. Cập nhật giá trị cột Trang_thai của bảng tblPhong theo các luật sau:

Nếu Trang_thai=0 thì gán Trang_thai=’Đang sửa’

Nếu Trang_thai=1 thì gán Trang_thai=’Đang sử dụng’

Nếu Trang_thai=null thì gán Trang_thai=’Unknow’

Sau đó hiển thị bảng tblPhong (Yêu cầu dùng procedure để hiển thị đồng thời sau khi update)
*/
delimiter $$
create procedure Question7()
begin
	update tblPhong set Trang_thai = case 
    when Trang_thai = 0 then 'Đang sửa'
    when Trang_thai = 1 then 'Đang sử dụng'
    when Trang_thai = null then 'Unknown'
    end;
	select * from tblPhong;
end;
$$

call Question7();

/* **8. Hiển thị danh sách tên phim mà có độ dài >15 và < 25 ký tự ** */
select * from tblPhim where char_length(Ten_phim) between 15 and 25;

/*9. Hiển thị Ten_Phong và Trang_Thai trong bảng tblPhong trong 1 cột với tiêu đề ‘Trạng thái phòng chiếu’*/
select concat(Ten_phong,"_",Trang_thai) as 'Trạng thái phòng chiếu' from tblPhong;

/*10. Tạo view có tên tblRank với các cột sau: STT(thứ hạng sắp xếp theo Ten_Phim), TenPhim, Thoi_gian*/
select rank() over(order by Ten_phim asc) as STT, Ten_phim,Thoi_gian from tblPhim;

/*
11. Trong bảng tblPhim :

Thêm trường Mo_ta kiểu nvarchar(max)

Cập nhật trường Mo_ta: thêm chuỗi “Đây là bộ phim thể loại ” + nội dung trường LoaiPhim

Hiển thị bảng tblPhim sau khi cập nhật

Cập nhật trường Mo_ta: thay chuỗi “bộ phim” thành chuỗi “film” (Dùng replace)

Hiển thị bảng tblPhim sau khi cập nhật
*/
alter table tblPhim add Mo_ta varchar(255);
update tblPhim set Mo_ta = concat('Đây là bộ phim thể loại ',Loai_phim);
select * from tblPhim;
update tblPhim set Mo_ta = replace(Mo_ta,'bộ phim','film');
select * from tblPhim;

/*12. Xóa tất cả các khóa ngoại trong các bảng trên.*/
alter table tblVe drop constraint FK_tblVe_PhongID;
alter table tblVe drop constraint FK_tblVe_GheID;
alter table tblGhe drop constraint FK_tblGhe_PhongID;

/*13. Xóa dữ liệu ở bảng tblGhe*/
delete from tblGhe;

/*14. Hiển thị ngày giờ hiện chiếu và ngày giờ chiếu cộng thêm 5000 phút trong bảng tblVe*/
select PhimID,GheID,Ngay_chieu,date_add(Ngay_chieu,interval 5000 minute) as Ngay_gio_chieu,Trang_thai from tblVe;



