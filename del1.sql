-- oppgave 1
select filmcharacter, count(filmcharacter) as freq
from filmcharacter
group BY filmcharacter having count(*) > 2000
order by freq desc;

-- oppgave 2
select country from filmcountry
group by country having count(country) = 1;

-- oppgave 3
select f.title, p.parttype, count(p.parttype) as antall 
from film as f 
inner join filmparticipation as p using (filmid) 
inner join filmitem as i using (filmid) 
group by f.title, i.filmtype, p.parttype  
having f.title like '%Lord of the Rings%' and i.filmtype like 'C'
order by antall desc; -- egeninnsats

--Oppgave 4
select title, prodyear from film 
join filmgenre as g using (filmid) JOIN filmgenre as fg using (filmid) 
where g.genre like 'Comedy' and fg.genre like 'Film-Noir';

--Oppgave 5
select maintitle, f.votes, f.rank from series as s 
join filmrating as f on (s.seriesid = f.filmid) 
where f.votes > 1000 order by f.rank desc limit 3;

--Oppgave 6

WITH f_character as (select * from film as f natural join filmparticipation as p 
join filmcharacter as c using(partid) where c.filmcharacter like '%Mr. Bean%') 
select f_char.title, count(l.language) from filmlanguage as l 
left join f_character as f_char on (l.filmid = f_char.filmid) 
group by f_char.title, f_char.filmcharacter, l.language;


--Oppgave 7
WITH kunCharacter AS(
  SELECT *
  FROM(
    SELECT filmcharacter, COUNT(filmcharacter) 
    FROM filmcharacter
    GROUP BY filmcharacter
    HAVING COUNT(filmcharacter) = 1
  )
  AS kunChar, filmcharacter AS filmChar
  WHERE kunChar.filmcharacter = filmChar.filmcharacter
)
SELECT (firstname  || '' || lastname) AS navn, COUNT(*) AS ant_filmer
FROM person
JOIN filmparticipation using (personid)
JOIN kunCharacter using (partid)
GROUP BY navn
HAVING COUNT(*) > 199
ORDER BY desc ant_filmer; -- egeninnsats


Select navn, masse, lysstyrke from stjerne where masse > 200 or lysstyrke > 10;

Select p.navn, p.masse from planet as p join stjerne using (sid) where p.navn like 'Tellus'
order by p.masse;

Select p.navn, p.masse from planet as p where p.sid = stjerne.sid and p.navn like 'Tellus';

select navn, masse from planet join stjerne using (sid) 
union
select navn, masse from planet where navn like 'Tellus';


update stjerne
set s.masse = s.masse * 0.45
from planet as p join stjerne as s using(oid)
where o.navn like 'BESS' and s.oppdaget < 1990;


select count(all), sum(all.masse)
from (
  select sid, masse from stjerne union
  select mid, masse from måne union
  select pid, masse from planet
) as all 
group by 

with temp as (
  select sid, navn from stjerne where masse > 400 union
  select mid, navn from måne where masse > 400 union
  select pid, navn from planet where masse > 400 
) select t.navn from planet join temp as t using (pid)
group by navn, pid, mid, sid having count(planet) > 10;


