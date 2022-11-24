-- "Bilgisayar Müh. Bölümündeki herbir dersin kaç kişi tarafından alındığı"

SELECT count(*), code
FROM take
WHERE code LIKE ‘BLM%’
GROUP BY code

-- "2012 girişli öğrenciler ve aldıkları dersler, öğrenci numaraları küçükten büyüğe sıralı"

SELECT code, id
FROM take
WHERE id LIKE ‘12%’
ORDER BY id

-- "2012 girişli öğrenciler ve aldıkları dersler, öğrenci numaraları büyükten küçüğe sıralı"

SELECT code, id
FROM take
WHERE id LIKE ‘12%’
ORDER BY id DESC, CODE ASC 

-- "2012 girişli öğrenciler arasında sadece 1 kişi tarafından alınan derslerin kodları ve dersi alan öğrencilerin id’leri"

SELECT code, id
FROM take
WHERE id LIKE ‘12%’
GROUP BYcode
HAVING count(*)=1

