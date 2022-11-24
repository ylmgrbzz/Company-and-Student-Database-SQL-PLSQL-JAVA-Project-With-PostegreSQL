--  5 numaralı departmanda çalışan işçilerin ad,soyad bilgilerini listeleyen sorgu.

SELECT fname,lname
FROM employee
WHERE dno=5

-- “Sales” departmanının hangi şehirlerde ofisi olduğunu bulan sorgu.

SELECT dlocation
FROM department d, dept_locations dl
WHERE d.dnumber = dl.dnumber and dname='Sales'

-- “Atlanta” şehrinde yaşayan çalışanların ad,soyad ve çalıştığı departmanın ismini bulan sorgu.

SELECT fname, lname, dname
FROM employee, department
WHERE dno = dnumber and address like '%Atlanta%'

--  “OperatingSystems” projesinde çalışanların ad,soyad bilgilerini listeleyen sorgu.

SELECT fname,lname
FROM project, works_on, employee
WHERE pnumber=pno and essn=ssn and pname='OperatingSystems'

-- Kızının ismi ‘Alice’ olan çalışanların, çalıştıkları departmanların isimlerini bulan sorgu.

SELECT distinct dname
FROM dependent, employee, department
WHERE dependent_name='Alice' and relationship='Daughter' and essn=ssn and dno=dnumber

-- Maaşı 70.000’in üzerinde olan çalışanların çalıştıkları projelerin isimleri.

SELECT pname
FROM employee, works_on, project
WHERE ssn=essn and pno=pnumber and salary>70000

-- ‘Elizabeth’ isminde akrabası olan çalışanın yöneticisinin (supervisor) adını ve soyadını bulan SQL sorgusu.

SELECT e2.fname, e2.lname 
FROM employee e1, employee e2, dependent d WHERE d.dependent_name = 'Elizabeth'
		 AND d.essn = e1.ssn 
		AND e1.superssn = e2.ssn; 

-- 1 no’lu projede çalışan kişinin departman yöneticisinin çalıştığı tüm projelerin numaralarını listeleyen sorgu.

SELECT distinct w2.pno
FROM works_on w1,employee e, department d, works_on w2
WHERE w1.pno=1 and w1.essn=e.ssn and e.dno=d.dnumber and d.mgrssn=w2.essn

--”OperatingSystems” isimli projede ve “Software” departmanında çalışanların ad, soyad bilgileri.

SELECT fname, lname
FROM project, works_on, employee
WHERE pname='OperatingSystems' and pnumber=pno and essn=ssn

INTERSECT

SELECT fname, lname
FROM department, employee
WHERE dname='Software' and dnumber=dno

--  ”OperatingSystems” isimli projede veya “Software” departmanında çalışanların ad, soyad bilgileri.

SELECT fname, lname
FROM project, works_on, employee
WHERE pname='OperatingSystems' and pnumber=pno and essn=ssn

UNION

SELECT fname, lname
FROM department, employee
WHERE dname='Software' and dnumber=dno

-- ”OperatingSystems” isimli projede çalışıp, “Software” departmanında çalışmayanların ad, soyad bilgileri.

SELECT fname, lname
FROM project, works_on, employee
WHERE pname='OperatingSystems' and pnumber=pno and essn=ssn

EXCEPT

SELECT fname, lname
FROM department, employee
WHERE dname='Software' and dnumber=dno

CREATE view  maaslar as
SELECT fname, salary
FROM employee
WHERE salary between 20000 and 40000

-- Hiçbir departmanın veya hiçbir çalışanın yöneticisi olmayan çalışanların isimleri.

SELECT fname,lname
FROM employee e
WHERE NOT EXISTS (SELECT * FROM department WHERE mgrssn=ssn) 
	and NOT EXISTS (SELECT * FROM employee e2 WHERE e.ssn=e2.superssn  )

-- İsmi ‘John’ olan işçilerin çalıştıkları departmanların isimleri.
	
SELECT dname
FROM department 
WHERE dnumber IN (SELECT dno FROM employee WHERE fname='John')

--‘Sales’ departmanında kaç kişinin çalıştığı, en düşük, en yüksek, ortalama ve toplam maaş. 

SELECT COUNT(*),SUM(salary),MAX(salary),MIN(salary),AVG(salary)
FROM department, employee
WHERE dname='Sales' AND dnumber=dno

-- "8 numaralı departmanda çalışan işçilerin ortalama ve  toplam maaşları"

SELECT avg(salary) as otalama, 
sum(salary) as toplam 
FROM employee e
WHERE e.dno = 8

-- "«Middleware» projesinde kaç kişinin çalıştığını ve bu  çalışanların ortalama maaşları"

SELECT count(*) AS calisan_sayisi, 
avg(salary)
FROM employee e, works_on w, project p
WHERE e.snn = w.essn AND w.pno = p.pnumber AND p.pname = ‘Middleware'

-- "En genç çalışanın çalıştığı projelerin numaraları"

SELECT count(*) AS calisan_sayisi, avg(salary)
FROM employee e, works_on w, project p
WHERE e.snn = w.essn AND w.pno = p.pnumber AND p.pname = ‘Middleware"
