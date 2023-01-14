-- PL/SQL Queries

-- Girdi olarak verilen 2 sayının toplamını bulan fonksiyon ve parametreler= (22,63)
CREATE FUNCTION ornek1 (num1 NUMERIC, num2 NUMERIC)
RETURNS numeric AS '
DECLARE
toplam NUMERIC;
BEGIN
toplam :=num1+num2;
RETURN toplam;
END;
' LANGUAGE plpgsql;

-- Adı verilen bir departmandaki çalışanların ortalama maaşını bulan fonksiyon.

CREATE or REPLACE FUNCTION ornek2 (depname department.dname%type)
RETURNS real AS '
DECLARE
maas NUMERIC;
BEGIN
SELECT AVG(salary) INTO maas
FROM employee e, department d
WHERE e.dno = d.dnumber AND

d.dname = depname;
RETURN maas;

END;
' LANGUAGE plpgsql;

-- Departman tablosundaki minimum ve maksimum departman numarasını 
-- min_deptno ve max_deptno değişkenlerine atan fonksiyon.

CREATE FUNCTION ornek3 (OUT min_deptno department.dnumber%type,

OUT max_deptno department.dnumber%type)

AS '
BEGIN

SELECT MIN(dnumber), MAX(dnumber) INTO min_deptno, max_deptno
FROM department;
END;
' LANGUAGE 'plpgsql';

--6 no’lu departmanda çalışanların sayısı.

CREATE OR REPLACE FUNCTION ornek(OUT calisan_sayisi NUMERIC)
AS '
BEGIN

SELECT count(*) into calisan_sayisi
FROM employee
WHERE dno=6;

END;
' LANGUAGE plpgsql;

-- 6 no’lu departmanda çalışanların sayısı 10’dan azsa departmandaki tüm
-- çalışanların maaşına %5 zam yapılması.

CREATE FUNCTION ornek4 ()
RETURNS void AS '
DECLARE
num_worker NUMERIC(3) := 0;
BEGIN
SELECT COUNT(*) INTO num_worker
FROM employee
WHERE dno = 6

IF (num_worker < 10) THEN
UPDATE employee
SET salary = salary*1.05
WHERE dno=6;
END IF;
END;
' LANGUAGE 'plpgsql';

-- Verilen bir sayıyı 1 arttıran fonksiyon.

CREATE FUNCTION increment(t INTEGER)
RETURNS INTEGER AS ‘
BEGIN
RETURN t + 1;
END;
‘ LANGUAGE plpgsql;

-- İsmi verilen bir departmanda çalışanların ortalama maaşı, verilen bir değerden düşük
-- ve o departmandaki kadın çalışanların maaşlarının toplamı verilen bir limitin
-- üstündeyse, o departmanda 1’den fazla projede çalışanların maaşlarına yine verilen bir
-- oranda zam yapan fonksiyon.

CREATE OR REPLACE FUNCTION kosullu_zam_yap(bolum_ismi department.dname%TYPE, ort_maas real,
f_top_maas employee.salary%TYPE, zam_orani real) RETURNS VOID AS '
DECLARE

ger_ort_maas real;
kadin_maaslari integer;
bolum_no department.dnumber%TYPE;

BEGIN

SELECT dnumber INTO bolum_no FROM department WHERE dname = bolum_ismi;
SELECT AVG(salary) INTO ger_ort_maas FROM employee WHERE dno = bolum_no;
SELECT SUM(salary) INTO kadin_maaslari FROM employee WHERE dno = bolum_no AND sex = ‘’F’’;
IF ger_ort_maas < ort_maas AND kadin_maaslari > f_top_maas THEN
UPDATE employee SET salary = salary*zam_orani/100 + salary WHERE ssn IN (SELECT essn

FROM employee, works_on WHERE

ssn = essn AND dno = bolum_no GROUP BY essn HAVING COUNT(*) > 1);
END IF;

END;
'LANGUAGE plpgsql;

-- SSN'i parametre olarak verilen çalışanın ismi, çalıştığı departmanın ismi ve maaşı ekrana yazdıran PL/pgSQL bloğu.

CREATE or REPLACE FUNCTION ornek2 (eno employee.ssn%type)
RETURNS yeni_tur AS $$
DECLARE
bilgi yeni_tur;
BEGIN
SELECT fname, dname, salary INTO bilgi
FROM employee e, department d
WHERE e.dno = d.dnumber AND
e.ssn = eno;

RAISE NOTICE 'Calisan ismi: %, departmanin ismi: %, maasi: % TLdir. ',
bilgi.isim, bilgi.dep_isim, bilgi.maas ;

RETURN bilgi;
END;
$$ LANGUAGE 'plpgsql';

--  Ssn vererek fonksiyonu çağırılması.

SELECT ornek2('123456789');

DROP FUNCTION ornek2 (employee.ssn%type);

-- Numarası verilen bir departmandaki çalışanların isimlerini bulan  fonksiyon. 

CREATE or REPLACE FUNCTION ornek3 (dnum NUMERIC)
RETURNS void AS $$
DECLARE
yeni_cur CURSOR FOR SELECT fname, lname
FROM employee
WHERE dno = dnum;

BEGIN
FOR satir IN yeni_cur LOOP
RAISE INFO 'Employee name is % %', satir .fname, satir .lname;
END LOOP;
END;
$$ LANGUAGE 'plpgsql';

-- Fonksiyonun çağrılması.

SELECT ornek3(6);
DROP FUNCTION ornek3(numeric);

-- Departman numarası verilen bir departmandaki çalışanların toplam maaşı bulan fonksiyon.

CREATE FUNCTION ornek4 (dnum NUMERIC)
RETURNS NUMERIC AS $$
DECLARE
toplam_maas NUMERIC;
curs CURSOR FOR SELECT salary FROM employee WHERE dno = dnum;
BEGIN
toplam_maas := 0;
FOR satir IN curs LOOP
toplam_maas := toplam_maas + satir.salary;
END LOOP;
RETURN toplam_maas;
END;
$$ LANGUAGE 'plpgsql';

(SELECT sum(salary) FROM employee WHERE dno = X;)
CREATE OR REPLACE FUNCTION dep_sum_salary(dnum numeric, OUT sum_sal numeric)
AS '
DECLARE

emp_cursor CURSOR FOR SELECT salary FROM employee WHERE dno = dnum;

BEGIN

sum_sal := 0;
FOR emp_record IN emp_cursor LOOP
sum_sal := sum_sal + emp_record.salary;
END LOOP;

END;
' LANGUAGE 'plpgsql'; 

-- Numarası verilen bir projede çalışanların maaşları verilen bir değere tam bölünebiliyorsa, 
-- o kişilerin ad, soyad ve maaş bilgilerini HAVING fonksiyonu kullanmadan listeleyen ve geri döndüren fonksiyon.

CREATE TYPE calisan AS (isim varchar(15), soyisim varchar(15), maas integer);
CREATE OR REPLACE FUNCTION calisan_listele(pnum project.pnumber%TYPE, bolen integer)
RETURNS calisan[] AS '
DECLARE

emp_cursor CURSOR FOR SELECT fname, lname, salary FROM employee, works_on WHERE ssn = essn AND pno = pnum;

cal calisan[];
i integer;
BEGIN
i := 1;
FOR emp_record IN emp_cursor LOOP
IF emp_record.salary % bolen = 0 THEN
cal[i] = emp_record;
i := i + 1;
END IF;
END LOOP;
RETURN cal;
END;
' LANGUAGE 'plpgsql';

--Sadece tatil günleri dışında ve mesai saatleri içinde employee tablosuna insert yapılmasına izin veren trigger.

CREATE TRIGGER t_ornek6
BEFORE INSERT
ON employee
FOR EACH ROW EXECUTE PROCEDURE trig_fonk_ornek6();


CREATE FUNCTION trig_fonk_ornek6()
RETURNS TRIGGER AS $$
BEGIN
IF ( to_char(now(), 'DY') in ('SAT', 'SUN') OR to_char(now(), 'HH24') not between '08' and '18') THEN
RAISE EXCEPTION 'Sadece mesai günlerinde ve mesai saatlerinde insert yapabilirsiniz.'’ ;
RETURN null;
ELSE
RETURN new;
END IF;

END;
$$ LANGUAGE 'plpgsql';

-- Tetiklenmesi:

INSERT INTO employee VALUES('Vlademir', 'S', 'Putin', '666666666', '1952-10-07', '8975
Rusya', 'M', '125000', '333445555', '5');

-- Düşürülmesi:
-- Önce:
DROP TRIGGER t_ornek6 on employee;

-- Sonra:

DROP FUNCTION trig_fonk_ornek6();


-- Departman tablosunda dnumber kolonundaki değer değişince employee tablosunda
-- da dno’nun aynı şekilde değişmesini sağlayan trigger. (Öncelikle departman
-- tablosundaki yabancı anahtar olma kısıtlarını kaldırmalıyız. Department
-- tablosundaki ‘dnumber’ sütununa referans veren 3 tablo bulunmaktadır)

ALTER TABLE project DROP CONSTRAINT project_dnum_fkey;
ALTER TABLE dept_locations DROP CONSTRAINT dept_locations_dnumber_fkey;
ALTER TABLE employee DROP CONSTRAINT foreign_key_const;

CREATE TRIGGER t_ornek7
AFTER UPDATE
ON department
FOR EACH ROW EXECUTE PROCEDURE trig_fonk_ornek7();

CREATE FUNCTION trig_fonk_ornek7()
RETURNS TRIGGER AS $$
BEGIN

UPDATE employee
SET dno = new.dnumber
WHERE dno = old.dnumber;

RETURN new;
END;
$$ LANGUAGE 'plpgsql';

-- Tetiklenmesi:

UPDATE department
SET dnumber = 2
WHERE dnumber = 5;

-- Maaş inişine ve %10’dan fazla maaş artışına izin vermeyen trigger.

CREATE TRIGGER t_ornek8
BEFORE UPDATE
ON employee
FOR EACH ROW EXECUTE PROCEDURE trig_fonk_ornek8();

CREATE FUNCTION trig_fonk_ornek8()
RETURNS TRIGGER AS $$
BEGIN
IF( old.salary > new.salary OR new.salary>1.1*old.salary) THEN
RAISE EXCEPTION 'Maasi dusuremezsiniz ve %%10dan fazla zam yapamazsınız.';
RETURN old;
ELSE
RETURN new;
END IF;
END;
$$ LANGUAGE 'plpgsql';

-- Tetiklenmesi:
UPDATE employee SET salary = salary*1.12;

-- Düşürülmesi:
-- Önce:

DROP TRIGGER t_ornek8 ON employee;

-- Sonra:

DROP FUNCTION trig_fonk_ornek8();

-- Departman tablonuza salary ile aynı tipte total_salary kolonu eklenmes,. Employee
-- tablosunda maaş sütununda değişiklik olduğunda department tablosundaki
-- total_salary kolonunda gerekli güncellemeyi yapacak trigger.

ALTER TABLE department ADD COLUMN total_salary INTEGER default 0;

UPDATE department
SET total_salary = (SELECT SUM(salary) FROM employee WHERE dno = dnumber);

CREATE TRIGGER t_ornek9
AFTER INSERT or UPDATE or DELETE
ON employee
FOR EACH ROW EXECUTE PROCEDURE trig_fonk_ornek9();

CREATE FUNCTION trig_fonk_ornek9()
RETURNS TRIGGER AS $$
BEGIN
IF (TG_OP = 'DELETE') THEN
update department
set total_salary=total_salary-old.salary
where dnumber=old.dno;
ELSIF (TG_OP = 'UPDATE') THEN
update department
set total_salary=total_salary-old.salary+new.salary
where dnumber=old.dno;

ELSE
update department
set total_salary=total_salary+new.salary
where dnumber=new.dno;

END IF;
RETURN new;
END;
$$ LANGUAGE 'plpgsql';

-- Tetiklenmesi 1:

INSERT INTO employee VALUES('Vlademir', 'S', 'Putin', '666666667',
'1952-10-07', '8975 Rusya', 'M', '100000000', '333445555', '1');

-- Tetiklenmesi 2:

UPDATE employee SET salary = salary*1.07 WHERE dno = 1;

-- Tetiklenmesi 3:

DELETE FROM employee WHERE ssn = '111111103';