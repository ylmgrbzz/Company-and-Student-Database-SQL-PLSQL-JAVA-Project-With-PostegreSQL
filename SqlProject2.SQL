-- "8 numaralı departmanda çalışan işçilerin ortalama ve  toplam maaşları"

SELECT avg(salary) as otalama, 
sum(salary) as toplam 
FROM employee e
WHERE e.dno = 8

--‘Sales’ departmanında kaç kişinin çalıştığı, en düşük, en yüksek, ortalama ve toplam maaş. 

SELECT COUNT(*),SUM(salary),MAX(salary),MIN(salary),AVG(salary)
FROM department, employee
WHERE dname='Sales' AND dnumber=dno

-- "«Middleware» projesinde kaç kişinin çalıştığını ve bu  çalışanların ortalama maaşları"

SELECT count(*) AS calisan_sayisi, 
avg(salary)
FROM employee e, works_on w, project p
WHERE e.snn = w.essn AND w.pno = p.pnumber AND p.pname = 'Middleware'

-- "En genç çalışanın çalıştığı projelerin numaralarI"

SELECT pno
FROM employee, works_on
WHERE ssn=essn AND bdate IN (SELECT MAX(bdate) FROM employee) 

--  "Project tablosunu dnum kolonuna göre gruplandırılması  ve herbir departmanda kaç tane proje olduğu"

SELECT pno
FROM employee, works_on
WHERE ssn=essn AND bdate IN (SELECT MAX(bdate)
FROM employee)

-- "Her bir projede çalışanların ortalama maaşın ve  proje ismine göre alfabetik olarak sıralanması"

SELECT pname, avg(salary)
FROM employee e, works_on w, project p
WHERE e.ssn = w.essn AND
w.pno = p.pnumber
GROUP BY pname
ORDER BY pname

-- "Her bir departmanda her bir cinsiyetten kaçar işçi olduğu ve bu işçilerin ortalama maaşları"

SELECT dno, sex,count(*), avg(salary)
FROM employee
GROUP BY dno, sex

-- "Ortalama maaşın 40000’den fazla olduğu departmanların numaraları"

SELECT dno
FROM employee
GROUP BY dno
HAVING avg(salary)>40000

-- "5 numaralı departman dışındaki departmanlar arasından, ortalama maaşı 40000$’dan fazla olan departmanların numaraları ve bu departmandaki ortalama maaşlar"

SELECT dno AS departman_no, 
avg(salary) AS ortalama_maas
FROM employee
GROUP BY dno
HAVING avg(salary) > 40000 
AND dno<>5

-- "En çok maaşı alan işçinin ismini ve soyismini gösteren sorgu"

SELECT fname, lname
FROM employee 
ORDER BY salary DESC
LIMIT 1

-- Veya

SELECT fname, lname
FROM employee 
WHERE salary = (SELECT max(salary) FROM employee)

-- "Yöneticisi olmayan kişiler"

SELECT ssn, superssn
FROM employee
WHERE superssn IS NULL 
