-- Create the database
CREATE DATABASE HumanitarianProgramDB;

-- Use the database
USE HumanitarianProgramDB;

create table  jurisdiction_hierarchy(
ID INT  PRIMARY KEY AUTO_INCREMENT,
jname varchar(30) unique not null,
jlevel varchar(20) not null check (jlevel IN ('County','Sub-County','Village')),
parent VARCHAR(30) NULL, FOREIGN KEY(parent) REFERENCES jurisdiction_hierarchy(jname) ON DELETE CASCADE
);

create table village_locations(
village_id INT primary key auto_increment,
village varchar(30) not null unique, foreign key(village) references jurisdiction_hierachy(jname) on delete cascade,
total_population int not null check(total_population>=0)
);

create table beneficiary_partner_data(
patner_id int primary key auto_increment,
patner varchar(30) not null, 
village varchar(30) not null, foreign key (village) references village_locations(village) on delete cascade,
beneficiaries int not null, check (beneficiaries >= 0),
beneficiary_type varchar(30) not null, check (beneficiary_type IN ('individuals', 'Households'))
);

USE HumanitarianProgramDB;

-- Drop in reverse dependency order if re-running
DROP TABLE IF EXISTS beneficiary_partner_data;
DROP TABLE IF EXISTS village_locations;
DROP TABLE IF EXISTS jurisdiction_hierarchy;

CREATE TABLE jurisdiction_hierarchy (
  ID INT PRIMARY KEY AUTO_INCREMENT,
  jname VARCHAR(30) UNIQUE NOT NULL,
  jlevel VARCHAR(20) NOT NULL CHECK (jlevel IN ('County', 'Sub-County', 'Village')),
  parent VARCHAR(30) NULL,
  FOREIGN KEY (parent) REFERENCES jurisdiction_hierarchy(jname) ON DELETE CASCADE
);

CREATE TABLE village_locations (
  village_id INT PRIMARY KEY AUTO_INCREMENT,
  village VARCHAR(30) NOT NULL UNIQUE,
  FOREIGN KEY (village) REFERENCES jurisdiction_hierarchy(jname) ON DELETE CASCADE,
  total_population INT NOT NULL CHECK (total_population >= 0)
);

CREATE TABLE beneficiary_partner_data (
  partner_id INT PRIMARY KEY AUTO_INCREMENT,
  partner VARCHAR(30) NOT NULL,
  village VARCHAR(30) NOT NULL,
  FOREIGN KEY (village) REFERENCES village_locations(village) ON DELETE CASCADE,
  beneficiaries INT NOT NULL CHECK (beneficiaries >= 0),
  beneficiary_type VARCHAR(30) NOT NULL CHECK (beneficiary_type IN ('Individual', 'Household', 'Group'))
);

INSERT INTO jurisdiction_hierarchy (id, jname, jlevel, parent) VALUES
(1,  'Nairobi',        'County',      NULL),
(2,  'Kiambu',         'County',      NULL),
(3,  'Mombasa',        'County',      NULL),
(4,  'Westlands',      'Sub-County',  'Nairobi'),
(5,  'Kasarani',       'Sub-County',  'Nairobi'),
(6,  'Lari',           'Sub-County',  'Kiambu'),
(7,  'Gatundu South',  'Sub-County',  'Kiambu'),
(8,  'Kisauni',        'Sub-County',  'Mombasa'),
(9,  'Likoni',         'Sub-County',  'Mombasa'),
(10, 'Parklands',      'Village',     'Westlands'),
(11, 'Kangemi',        'Village',     'Westlands'),
(12, 'Roysambu',       'Village',     'Kasarani'),
(13, 'Githurai',       'Village',     'Kasarani'),
(14, 'Kiamwangi',      'Village',     'Lari'),
(15, 'Lari Town',      'Village',     'Lari'),
(16, 'Kamwangi',       'Village',     'Gatundu South'),
(17, 'Kisauni Town',   'Village',     'Kisauni'),
(18, 'Mtopanga',       'Village',     'Kisauni'),
(19, 'Likoni Town',    'Village',     'Likoni'),
(20, 'Shika Adabu',    'Village',     'Likoni');

insert into village_locations (village_id, village, total_population) values
(1, 'Parklands', 15000),
(2, 'Kangemi', 18000),
(3, 'Roysambu', 13000),
(4, 'Githurai', 12500),
(5, 'Kiamwangi', 12800),
(6, 'Lari Town', 9485),
(7, 'Kamwangi', 5212),
(8, 'Kisauni Town', 20500),
(9, 'Mtopanga', 15500),
(10, 'Likoni Town', 12000),
(11, 'Shika Adabu', 9000);

insert into beneficiary_partner_data(partner_id, partner, village, beneficiaries, beneficiary_type) values
(1,  'IRC', 'Parklands', 1450, 'Individual'),
(2,  'NRC', 'Parklands', 50, 'Household'),
(3,  'SCI', 'Kangemi',  1123, 'Individual'),
(4,  'IMC', 'Kangemi', 1245, 'Individual'),
(5,  'CESVI', 'Roysambu', 5200, 'Individual'),
(6,  'IMC', 'Githurai', 70, 'Household'),
(7,  'IRC', 'Githurai', 2100, 'Individual'),
(8,  'SCI', 'Kiamwangi', 1800, 'Individual'),
(9,  'IMC', 'Lari Town', 1340, 'Individual'),
(10, 'CESVI', 'Kamwangi',  55, 'Household'),
(11, 'IRC', 'Kisauni Town', 4500, 'Individual'),
(12, 'SCI', 'Kisauni Town', 1670, 'Individual'),
(13, 'IMC', 'Mtopanga',1340, 'Individual'),
(14, 'CESVI', 'Likoni Town',  4090, 'Individual'),
(15, 'IRC', 'Shika Adabu',  2930, 'Individual'),
(16, 'SCI', 'Shika Adabu',  5200, 'Individual');


select * from village_locations;

 -- task 1
 
 select partner,
 sum(case
 when beneficiary_type = 'Household' then beneficiaries * 6
 else beneficiaries
 end) as total_individuals
 from beneficiary_partner_data
 group by partner
 order by total_individuals desc;
 
 
 -- task 2
 
 select partner, 
  count(distinct village) as villages_served
  from beneficiary_partner_data
  group by partner
  order by villages_served desc;
  
  -- task 3
  
  select village,
  avg(beneficiaries) as avg_beneficiaries
  from beneficiary_partner_data
  group by village
  order by avg_beneficiaries desc;
  
  -- task 4
  
  select partner, sum(case
   when beneficiary_type = 'Household' then beneficiaries * 6
 else beneficiaries
 end) as total_individuals
  from beneficiary_partner_data
  group by partner
  having total_individuals > 5000
  order by total_individuals desc;
  
  -- task 5
  
  select village, 
  count(distinct partner) as number_of_partners
  from beneficiary_partner_data
  group by village
  having number_of_partners >1
  order by number_of_partners desc;
  
  
  -- 2 JOINS AND COMBINED QUERIES
  
  select 
        vl.village,
        vl.total_population,
        sum(bpd.beneficiaries) as total_beneficiaries,
        round(sum(bpd.beneficiaries) / vl.total_population * 100,2) as coverage_percent
from village_locations vl
inner join beneficiary_partner_data bpd
     on vl.village = bpd.village
group by vl.village, vl.total_population
order by coverage_percent asc;

-- ## union

select vl.village, bpd.partner
from village_locations vl
left join beneficiary_partner_data bpd
     on vl.village = bpd.village
union
select village, 'no partner' as partner
from village_locations
where village not in(
     select distinct village from beneficiary_partner_data)
order by village;
  
  
-- sub query for villages
  
 SELECT vl.village,
    ROUND(SUM(bpd.beneficiaries) / vl.total_population * 100, 2) AS coverage_percent
FROM village_locations vl
INNER JOIN beneficiary_partner_data bpd 
    ON vl.village = bpd.village
GROUP BY vl.village, vl.total_population
HAVING coverage_percent > (
    SELECT AVG(village_coverage) FROM (
        SELECT SUM(b.beneficiaries) / v.total_population * 100 AS village_coverage
        FROM village_locations v
        JOIN beneficiary_partner_data b ON v.village = b.village
        GROUP BY v.village, v.total_population) AS avg_table
)ORDER BY coverage_percent DESC; 

-- sub query for partners 

SELECT partner,
    SUM(beneficiaries) AS total_beneficiaries
FROM beneficiary_partner_data
GROUP BY partner
HAVING total_beneficiaries> (
    SELECT AVG(partner_total)
    FROM(SELECT SUM(beneficiaries) AS partner_total
        FROM beneficiary_partner_data
        GROUP BY partner) AS avg_table
)ORDER BY total_beneficiaries DESC;

-- district level summary

WITH village_summary AS (SELECT vl.village,vl.total_population,
        SUM(bpd.beneficiaries) AS total_beneficiaries,
        ROUND(SUM(bpd.beneficiaries) / vl.total_population * 100, 2) AS coverage
    FROM village_locations vl
    JOIN beneficiary_partner_data bpd 
        ON vl.village = bpd.village
    GROUP BY vl.village, vl.total_population)
SELECT village, total_population, total_beneficiaries, coverage
FROM village_summary
ORDER BY coverage DESC;

-- ranking by coverage

WITH village_summary AS (
    SELECT vl.village,vl.total_population,
        SUM(bpd.beneficiaries) AS total_beneficiaries,
        ROUND(SUM(bpd.beneficiaries) / vl.total_population * 100, 2) AS coverage
    FROM village_locations vl
    JOIN beneficiary_partner_data bpd 
        ON vl.village = bpd.village
    GROUP BY vl.village, vl.total_population
    )
SELECT village,total_population,total_beneficiaries,coverage,
    RANK() OVER (ORDER BY coverage DESC) AS coverage_rank
FROM village_summary;

-- rankking partners

select partner,
sum(beneficiaries) as total_beneficiaries,
rank() over(order by sum(beneficiaries)desc) as partner_rank
from beneficiary_partner_data
group by partner;

-- ranking villages

select bpd.village, jh.parent as district,
sum(bpd.beneficiaries) as total_beneficiaries,
rank() over(
         partition by jh.parent
         order by sum(bpd.beneficiaries) desc
) as district_rank
from beneficiary_partner_data bpd
join jurisdiction_hierarchy jh
    on bpd.village = jh.jname
group by bpd.village, jh.parent;

-- ranking partner by district
		
WITH partner_district AS (
    SELECT bpd.partner,jh.parent AS district,
	SUM(bpd.beneficiaries) AS total_beneficiaries,
	ROW_NUMBER() OVER (
		PARTITION BY jh.parent 
		ORDER BY SUM(bpd.beneficiaries) DESC) AS row_num
    FROM beneficiary_partner_data bpd
    JOIN jurisdiction_hierarchy jh 
        ON bpd.village = jh.jname
    GROUP BY bpd.partner, jh.parent)
SELECT partner, district, total_beneficiaries
FROM partner_district
WHERE row_num = 1;

-- VIEWS

CREATE VIEW district_summary AS
SELECT jh.parent AS district,
    SUM(bpd.beneficiaries) AS total_beneficiaries,
    SUM(vl.total_population) AS total_population,
    ROUND(SUM(bpd.beneficiaries) / SUM(vl.total_population) * 100, 2) AS coverage,
    COUNT(DISTINCT bpd.partner) AS number_of_partners
FROM beneficiary_partner_data bpd
JOIN village_locations vl ON bpd.village = vl.village
JOIN jurisdiction_hierarchy jh ON bpd.village = jh.jname
GROUP BY jh.parent;

select * from district_summary;

CREATE VIEW partner_summary AS
SELECT bpd.partner,
    COUNT(DISTINCT bpd.village) AS villages_served,
    COUNT(DISTINCT jh.parent) AS districts_reached,
    SUM(bpd.beneficiaries) AS total_beneficiaries
FROM beneficiary_partner_data bpd
JOIN jurisdiction_hierarchy jh ON bpd.village = jh.jname
GROUP BY bpd.partner;

select * from partner_summary;

