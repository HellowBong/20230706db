# 별칭 Alias
# 컬럼이나 테이블명을 다른 이름으로 표현하고자 할때 사용

# 컬럼 혹은 테이블명이 길거나, 더 의미있는 이름을 부여하고 싶거나
# 다른 테이블간의 연결을 할때, 혹은 같은 테이블을 여러 번 참조할때

USE human_resource;

SELECT 업소명 AS 가게명
FROM bbq AS 치킨사업테이블;

DROP TABLE employee;

CREATE TABLE department (
	department_name VARCHAR(100) NOT NULL UNIQUE,
	department_tel_number VARCHAR(15) NOT NULL UNIQUE,
    department_address TEXT NOT NULL,
    PRIMARY KEY (department_name)
);

CREATE TABLE employee (
	employee_number VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(10) NOT NULL,
    address TEXT NOT NULL,
    department_name VARCHAR(100),
    PRIMARY KEY (employee_number),
    FOREIGN KEY (department_name) REFERENCES department (department_name)
);

INSERT INTO department
VALUES ('기획부','051-111-1111','부산광역시');
INSERT INTO department
VALUES ('영업부','051-222-1111','부산광역시');
INSERT INTO department
VALUES ('연구소','051-333-1111','부산광역시');
INSERT INTO department
VALUES ('인사부','051-444-1111','부산광역시');
INSERT INTO department
VALUES ('개발부','051-555-1111','부산광역시');
INSERT INTO department
VALUES ('재무부','051-666-1111','부산광역시');

INSERT INTO employee
VALUES ('3015','양희정','부산광역시','인사부');
INSERT INTO employee
VALUES ('3032','여상길','부산광역시','연구소');
INSERT INTO employee
VALUES ('3076','김경훈','부산광역시','영업부');
INSERT INTO employee
VALUES ('1687','조창석','부산광역시','개발부');
INSERT INTO employee
VALUES ('3103','유정봉','부산광역시','기획부');
INSERT INTO employee
VALUES ('3110','이수광','부산광역시','인사부');
INSERT INTO employee
VALUES ('3133','박진우','부산광역시','연구소');
INSERT INTO employee
VALUES ('3138','이수경','부산광역시','기획부');
INSERT INTO employee
VALUES ('3141','이지훈','부산광역시','영업부');
INSERT INTO employee
VALUES ('3151','최지선','부산광역시','개발부');
INSERT INTO employee
VALUES ('2894','정아린','부산광역시',null);
INSERT INTO employee
VALUES ('2939','김정민','부산광역시','연구소');
INSERT INTO employee
VALUES ('2375','김유정','부산광역시','기획부');
INSERT INTO employee
VALUES ('2861','정이제','부산광역시','개발부');
INSERT INTO employee
VALUES ('3263','이소진','부산광역시',null);
INSERT INTO employee
VALUES ('0000','서지훈','부산광역시',null);



# JOIN - 두 개 이상의 테이블을 조합하여 검색 결과를 얻고자 할때 사용
# INNER, LEFT, RIGHT, FULL

# INNER JOIN - 첫 번째 테이블과 두 번째 테이블의 데이터 중
#              조건에 일치하는 데이터만 조합
# SELECT 컬럼명, ...
# FROM 첫번째테이블 INNER JOIN 두번째테이블 ON 조건;

SELECT E.employee_number AS '사원번호',
E.name AS '사원이름',
D.department_name AS '부서이름',
D.department_tel_number AS '전화번호'
FROM department AS D INNER JOIN employee AS E
ON D.department_name = E.department_name;

# LEFT JOIN - 첫 번째 테이블에 있는 모든 데이터와 두 번째 테이블에서
#             조건에 부합하는 데이터만을 조합
# SELECT 컬럼명, ...
# FROM 첫번째테이블 LEFT JOIN 두번째테이블 ON 조건;

SELECT *
FROM department AS D
LEFT JOIN employee AS E
ON D.department_name = E.department_name;

# RIGHT JOIN - 두 번째 테이블에 있는 모든 데이터와 첫 번째 테이블에서
#              조건에 부합하는 데이터만을 조합
# SELECT 컬럼명, ...
# FROM 첫번째테이블 RIGHT JOIN 두번째테이블 ON 조건;

SELECT *
FROM department AS D
RIGHT JOIN employee AS E
ON D.department_name = E.department_name;

# 서브쿼리 - 쿼리 내부에 또 다른 쿼리가 작성되어있는 쿼리
# WHERE, FROM, SELECT 위치에 사용 가능

# WHERE 절에서의 서브쿼리 사용
# employee_number가 3138인 사원의 부서명, 부서전화번호, 부서주소를 조회하라
SELECT *
FROM department
WHERE department_name = (
	SELECT department_name
    FROM employee
    WHERE employee_number = 3138
);

# address가 부산광역시인 사원의 부서명, 부서전화번호, 부서주소를 조회하라
SELECT * FROM department
WHERE department_name IN (
	SELECT department_name
	FROM employee
	WHERE address = '부산광역시'
);

# FROM 절에서의 서브쿼리 사용
# address가 '부산'을 포함하는 사원 중에서 부서가 null인 사원 전체 컬럼을 조회
SELECT *
FROM (
	SELECT *
	FROM employee
	WHERE address LIKE '%부산%'
) AS T
WHERE department_name IS NULL;

SELECT *
FROM department AS D
INNER JOIN (
	SELECT *
    FROM employee
    WHERE name LIKE '%정%'
) AS E
ON D.department_name = E.department_name;

# SELECT 절에서의 서브쿼리 사용
SELECT department_name, (SELECT name FROM employee WHERE employee_number = 3138)
FROM department;

# 집계함수 - 테이블에서 집계결과를 나타내주는 함수 (SELECT절에서 사용)

# COUNT - 레코드의 개수를 출력
SELECT count(*) FROM employee;
SELECT * FROM employee;

SELECT count(department_name) FROM employee;
SELECT count(*) FROM employee WHERE department_name = '기획부';

# SUM - 해당 컬럼의 합계
SELECT sum(경도) FROM bbq;
SELECT sum(경도) FROM bbq WHERE 업소명 = '교촌치킨';

# AVG - 해당 컬럼의 평균
SELECT avg(경도) FROM bbq;

# MIN - 해당 컬럼의 최소값
# MAX - 해당 컬럼의 최대값
SELECT min(위도), max(위도) FROM bbq;

# BBQ 관련된 업소명을 모두 'BBQ치킨'로 변경
# BHC 관련된 업소명을 모두 'BHC치킨'로 변경

UPDATE bbq SET 업소명 = 'BBQ치킨' WHERE 업소명 LIKE '%BBQ%' OR 업소명 LIKE '%비비큐%';
UPDATE bbq SET 업소명 = 'BHC치킨' WHERE 업소명 LIKE '%BHC%' OR 업소명 LIKE '%B.H.C%';

SELECT * FROM bbq WHERE 업소명 IN('BBQ치킨','BHC치킨','교촌치킨')
ORDER BY 업소명;

# GROUP BY - 조회된 결과에서 하나 이상의 레코드를 기준으로 그룹화하는 쿼리
SELECT 업소명, count(*) FROM bbq
WHERE 업소명 IN('BBQ치킨','BHC치킨','교촌치킨')
GROUP BY 업소명;

# HAVING - GROUP BY의 결과에서 필터링하고자 할 때 사용 가능
SELECT 업소명, count(*) AS 수 FROM bbq
GROUP BY 업소명
HAVING 위도 >= 129;

# INDEX - 테이블에서 원하는 컬럼의 데이터를 빠르게 찾을 수 있도록 하는 스키마
# CREATE INDEX 인덱스명 ON 테이블명 (컬럼, ...);
CREATE INDEX bbq_업소명_idx ON bbq (업소명);
CREATE INDEX bbq_위치_idx ON bbq (위도, 경도);

SELECT * FROM bbq
WHERE 업소명 = 'BBQ치킨';




SELECT * FROM department;
SELECT * FROM employee;

