show databases;
create database beer;
use beer;

create table beer (
row_numb int not null,
alcohol_content decimal(5,3),
International_bittering_units int,
beer_id int not null unique,
beer_name text not null,
style text not null,
brewery_id int not null,
ounces decimal(3,1) not null
);

show variables like '%secure%';

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\beers123.csv'
into table beer
fields terminated by ','
enclosed by ''
enclosed by '.'
lines terminated by '\r\n'
starting by ''
ignore 1 lines;

select * from beer order by row_numb;

create table brewery (
brewery_id int not null unique,
brewery_name text not null,
city text not null,
state text not null
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\breweries.csv'
into table brewery
fields terminated by ','
enclosed by ''
enclosed by '.'
lines terminated by '\r\n'
starting by ''
ignore 1 lines;

select * from brewery order by brewery_id;

select beer_id,
br.brewery_id,
alcohol_content,
International_bittering_units,
beer_name,
style,
ounces,
bw.brewery_name,
bw.city,
bw.state,
rank() over(Partition by br.brewery_id order by br.alcohol_content) as alcohol_rank,
avg(International_bittering_units) over(Partition by br.brewery_id) as avg_bitter,
count(br.brewery_id) over(Partition by br.brewery_id)
from beer as br
left join brewery as bw
on br.brewery_id = bw.brewery_id
order by br.brewery_id;

create table uscity(
city text,
state_id text,
state_name text,
latitude decimal(15,5),
longitude decimal(15,5)
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\uscities.csv'
into table uscity
fields terminated by ','
enclosed by ''
enclosed by '.'
lines terminated by '\r\n'
starting by ''
ignore 1 lines;

select * from uscity; 

with A as(select beer_id,
br.brewery_id,
alcohol_content,
International_bittering_units,
beer_name,
style,
ounces,
bw.brewery_name,
bw.city,
bw.state,
rank() over(Partition by br.brewery_id order by br.alcohol_content) as alcohol_rank,
avg(International_bittering_units) over(Partition by br.brewery_id) as avg_bitter,
count(br.brewery_id) over(Partition by br.brewery_id) as count_beer_product
from beer as br
left join brewery as bw
on br.brewery_id = bw.brewery_id
order by br.brewery_id)

select
distinct A.beer_id,
A.brewery_id,
A.alcohol_content,
A.International_bittering_units,
A.beer_name,
A.style,
A.ounces,
A.brewery_name,
A.city,
A.state,
A.alcohol_rank,
A.avg_bitter,
A.count_beer_product,
uc.latitude,
uc.longitude
from A
left join uscity as uc
on A.city = uc.city 
and A.state = concat(' ',uc.state_id)
order by brewery_id;

select brewery_id,
latitude,
longitude
from brewery
left join uscity
on concat(brewery.state,brewery.city) = concat(uscity.state_id,uscity.city);

select brewery_id,
latitude,
longitude
from brewery
left join uscity
on brewery.city = uscity.city
and brewery.state = concat(' ',uscity.state_id)