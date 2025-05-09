-- DROP DATABASE IF EXISTS ask_mento_docker_test;

-- create database ask_mento_docker_test;
-- use ask_mento_docker_test;


CREATE TABLE IF NOT EXISTS departments ( 
  department_id     INT NOT NULL AUTO_INCREMENT,
  department        VARCHAR(20),
  parent_department INT,
  PRIMARY KEY (department_id),
  KEY idx_parent_department (parent_department),
  CONSTRAINT fk_parent_department
    FOREIGN KEY (parent_department)
    REFERENCES departments(department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS users (
  user_id          INT NOT NULL AUTO_INCREMENT,
  department_id    INT,
  name             VARCHAR(10),
  password         VARCHAR(20),
  question_count   INT DEFAULT 0,
  answer_count     INT DEFAULT 0,
  sum_satisfaction FLOAT,
  join_year        DATE,
  PRIMARY KEY (user_id),
  KEY idx_user_department (department_id),
  CONSTRAINT fk_user_department
    FOREIGN KEY (department_id)
    REFERENCES departments(department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS questions (
  question_id    INT NOT NULL AUTO_INCREMENT,
  user_id        INT NOT NULL,
  question_text  VARCHAR(300),
  timestamp      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status         INT,
  PRIMARY KEY (question_id),
  KEY idx_question_user (user_id),
  CONSTRAINT fk_question_user
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS answers (
  answer_id     INT NOT NULL AUTO_INCREMENT,
  question_id   INT NOT NULL,
  user_id       INT NOT NULL,
  answer_text   TEXT,
  timestamp     TIMESTAMP NULL DEFAULT NULL,
  satisfaction  INT,
  PRIMARY KEY (answer_id),
  KEY idx_answer_question (question_id),
  KEY idx_answer_user     (user_id),
  CONSTRAINT fk_answer_question
    FOREIGN KEY (question_id)
    REFERENCES questions(question_id),
  CONSTRAINT fk_answer_user
    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Departments 초기 데이터 입력

-- 1) 도메인 레벨 부서 삽입 (department_id는 명시)
INSERT INTO departments (department_id, parent_department, department)
VALUES
  (1, NULL, 'Executive'),
  (2, NULL, 'HR'),
  (3, NULL, '통신도메인'),
  (4, NULL, '마케팅도메인'),
  (5, NULL, '금융도메인'),
  (6, NULL, '제조도메인');

-- 2) AUTO_INCREMENT 설정 (초기화 시점에만 1회)
ALTER TABLE departments
  MODIFY COLUMN department_id INT NOT NULL AUTO_INCREMENT;

-- 3) 각 도메인 아래 팀 부서 삽입 (department_id 생략 = AUTO_INCREMENT)
-- 팀 삽입 (도메인별 하위 부서)
INSERT INTO departments (parent_department, department)
SELECT d.department_id, t.team
FROM departments d
JOIN (
  SELECT '개발팀' AS team UNION ALL
  SELECT 'AI팀' UNION ALL
  SELECT '인프라팀'
) AS t
WHERE d.department IN ('통신도메인', '마케팅도메인', '금융도메인', '제조도메인');

-- AUTO_INCREMENT 수동 설정 (하드코딩)
ALTER TABLE departments AUTO_INCREMENT = 25;


-- users

-- 1) 한 번에 user_id, department_id, name, password, join_year 만 채워넣기
INSERT INTO users (`user_id`,`department_id`,`name`,`password`,`join_year`)
SELECT
  d.new_id,
  COALESCE(t.department_id, dm.department_id) AS department_id,
  d.name,
  CAST(d.new_id AS CHAR)             AS password,
  d.join_year
FROM (
  SELECT 1 AS new_id,'Executive' AS domain,NULL     AS team,'박준형' AS name,'2010-01-01' AS join_year UNION ALL
  SELECT 2,'HR',     NULL,'최혜정','2015-01-01'        UNION ALL
  SELECT 3,'HR',     NULL,'이민우','2016-01-01'        UNION ALL
  SELECT 4,'HR',     NULL,'서예린','2017-01-01'        UNION ALL
  SELECT 5,'HR',     NULL,'정하늘','2018-01-01'        UNION ALL
  SELECT 6,'HR',     NULL,'조윤지','2019-01-01'        UNION ALL
  SELECT 7,'HR',     NULL,'한상민','2020-01-01'        UNION ALL
  SELECT 8,'HR',     NULL,'장세은','2021-01-01'        UNION ALL
  SELECT 9,'HR',     NULL,'김도영','2022-01-01'        UNION ALL
  SELECT 10,'HR',    NULL,'박소민','2023-01-01'        UNION ALL
  SELECT 11,'통신도메인','개발팀','김가언','2014-01-01' UNION ALL
  SELECT 12,'통신도메인','개발팀','강민석','2015-01-01' UNION ALL
  SELECT 13,'통신도메인','개발팀','김지수','2018-01-01' UNION ALL
  SELECT 14,'통신도메인','개발팀','이호준','2019-01-01' UNION ALL
  SELECT 15,'통신도메인','AI팀',  '오지훈','2020-01-01' UNION ALL
  SELECT 16,'통신도메인','AI팀',  '윤지원','2021-01-01' UNION ALL
  SELECT 17,'통신도메인','AI팀',  '김도현','2022-01-01' UNION ALL
  SELECT 18,'통신도메인','인프라팀','박연수','2023-01-01' UNION ALL
  SELECT 19,'통신도메인','인프라팀','송하율','2023-06-01' UNION ALL
  SELECT 20,'통신도메인','인프라팀','최시완','2023-06-01' UNION ALL
  SELECT 21,'마케팅도메인','개발팀','이영희','2014-01-01' UNION ALL
  SELECT 22,'마케팅도메인','개발팀','박성훈','2015-01-01' UNION ALL
  SELECT 23,'마케팅도메인','개발팀','서영록','2018-01-01' UNION ALL
  SELECT 24,'마케팅도메인','개발팀','김도현','2020-01-01' UNION ALL
  SELECT 25,'마케팅도메인','AI팀',  '박소연','2020-01-01' UNION ALL
  SELECT 26,'마케팅도메인','AI팀',  '최형석','2021-01-01' UNION ALL
  SELECT 27,'마케팅도메인','AI팀',  '이수빈','2022-01-01' UNION ALL
  SELECT 28,'마케팅도메인','인프라팀','조민지','2023-01-01' UNION ALL
  SELECT 29,'마케팅도메인','인프라팀','강현우','2023-06-01' UNION ALL
  SELECT 30,'마케팅도메인','인프라팀','문채원','2023-06-01' UNION ALL
  SELECT 31,'금융도메인','개발팀','유소영','2014-01-01' UNION ALL
  SELECT 32,'금융도메인','개발팀','김태영','2015-01-01' UNION ALL
  SELECT 33,'금융도메인','개발팀','이수빈','2016-01-01' UNION ALL
  SELECT 34,'금융도메인','개발팀','박지호','2018-01-01' UNION ALL
  SELECT 35,'금융도메인','AI팀',  '윤한결','2019-01-01' UNION ALL
  SELECT 36,'금융도메인','AI팀',  '최지우','2020-01-01' UNION ALL
  SELECT 37,'금융도메인','AI팀',  '정유진','2021-01-01' UNION ALL
  SELECT 38,'금융도메인','인프라팀','조영민','2022-01-01' UNION ALL
  SELECT 39,'금융도메인','인프라팀','김수정','2023-01-01' UNION ALL
  SELECT 40,'금융도메인','인프라팀','이준서','2023-06-01' UNION ALL
  SELECT 41,'제조도메인','개발팀','박윤아','2014-01-01' UNION ALL
  SELECT 42,'제조도메인','개발팀','조성우','2015-01-01' UNION ALL
  SELECT 43,'제조도메인','개발팀','김현우','2016-01-01' UNION ALL
  SELECT 44,'제조도메인','개발팀','이지은','2017-01-01' UNION ALL
  SELECT 45,'제조도메인','AI팀',  '박성훈','2018-01-01' UNION ALL
  SELECT 46,'제조도메인','AI팀',  '정민지','2019-01-01' UNION ALL
  SELECT 47,'제조도메인','AI팀',  '홍서연','2020-01-01' UNION ALL
  SELECT 48,'제조도메인','인프라팀','윤동혁','2021-01-01' UNION ALL
  SELECT 49,'제조도메인','인프라팀','백지현','2022-01-01' UNION ALL
  SELECT 50,'제조도메인','인프라팀','강소영','2023-01-01'
) AS d
JOIN `departments` AS dm
  ON dm.`department` = d.domain
  AND dm.`parent_department` IS NULL
LEFT JOIN `departments` AS t
  ON t.`department` = d.team
  AND t.`parent_department` = dm.`department_id`;



-- INSERT INTO questions (question_id, user_id, question_text, timestamp, status)
-- VALUES
-- (1, 1, '회의실 예약은 어떻게 하나요?', '2024-02-01 09:00:00', 0),
-- (2, 2, '복사기 종이가 자주 걸려요. 해결 방법이 있을까요?', '2024-02-03 10:15:00', 1),
-- (3, 3, '점심시간은 몇 시부터인가요?', '2024-02-05 12:00:00', 1),
-- (4, 4, '사원증을 잃어버렸을 때 어떻게 하나요?', '2024-02-07 08:30:00', 0),
-- (5, 5, '회의록은 어디에 저장하나요?', '2024-02-08 11:20:00', 1),
-- (6, 6, '사내 와이파이 비밀번호를 알고 싶어요.', '2024-02-09 14:10:00', 0);


-- INSERT INTO answers (answer_id, question_id, user_id, answer_text, timestamp, satisfaction)
-- VALUES
-- (1, 1, 1, '회의실은 구글 캘린더에서 부서별로 예약할 수 있어요.', '2024-02-01 10:00:00', 4),
-- (2, 2, 2, '종이가 걸릴 땐 내부 용지함을 열어서 종이를 빼주세요!', '2024-02-03 11:00:00', 5),
-- (3, 3, 3, '보통 12시부터 1시까지예요. 부서마다 조금 달라요.', '2024-02-05 12:15:00', 3),
-- (4, 4, 4, '총무팀에 문의하면 바로 재발급 도와줘요.', '2024-02-07 09:00:00', 5),
-- (5, 5, 5, '회의록은 부서별 공유 폴더에 저장하고 있어요.', '2024-02-08 12:00:00', 4),
-- (6, 6, 6, '비밀번호는 회사 인트라넷 공지사항에 있어요.', '2024-02-09 14:30:00', 5);
