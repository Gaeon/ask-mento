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
  timestamp     TIMESTAMP,
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
-- Top-level CEO
INSERT INTO departments VALUES (1, 'SK㈜ C&C CEO', NULL);

-- 1차 부서
INSERT INTO departments VALUES (2, 'AT서비스부문', 1);
INSERT INTO departments VALUES (3, 'AT/DT사업부문', 1);
INSERT INTO departments VALUES (4, '하이테크사업부문', 1);
INSERT INTO departments VALUES (5, '제조/글로벌사업부문', 1);
INSERT INTO departments VALUES (6, '금융/전략사업부문', 1);
INSERT INTO departments VALUES (7, '엔터프라이즈서비스부문', 1);
INSERT INTO departments VALUES (8, '경영지원부문', 1);
INSERT INTO departments VALUES (9, '인사팀', 1);

-- AT서비스부문 하위
INSERT INTO departments VALUES (10, 'AI Tech Lab', 2);
INSERT INTO departments VALUES (11, 'Data Analytics Center', 2);
INSERT INTO departments VALUES (12, '플랫폼기술팀', 2);
INSERT INTO departments VALUES (13, 'B2B AI 서비스팀', 2);
INSERT INTO departments VALUES (14, 'B2C AI 서비스팀', 2);

-- AT/DT사업부문 하위
INSERT INTO departments VALUES (15, '그룹사 디지털전환 담당', 3);
INSERT INTO departments VALUES (16, 'AI 전략기획팀', 3);
INSERT INTO departments VALUES (17, 'DT 컨설팅팀', 3);
INSERT INTO departments VALUES (18, '대외 AI 확산 추진팀', 3);

-- 하이테크사업부문 하위
INSERT INTO departments VALUES (19, '반도체 IT서비스팀', 4);
INSERT INTO departments VALUES (20, '공정지원팀', 4);
INSERT INTO departments VALUES (21, '소재계열 고객지원팀', 4);

-- 제조/글로벌사업부문 하위
INSERT INTO departments VALUES (22, '글로벌 비즈니스개발팀', 5);
INSERT INTO departments VALUES (23, '제조 시스템 딜리버리팀', 5);
INSERT INTO departments VALUES (24, '스마트팩토리 솔루션팀', 5);

-- 금융/전략사업부문 하위
INSERT INTO departments VALUES (25, '금융IT기획팀', 6);
INSERT INTO departments VALUES (26, '전략산업 솔루션팀', 6);
INSERT INTO departments VALUES (27, '유통·물류IT지원팀', 6);

-- 엔터프라이즈서비스부문 하위
INSERT INTO departments VALUES (28, 'ERP 운영팀', 7);
INSERT INTO departments VALUES (29, 'IT 인프라팀', 7);
INSERT INTO departments VALUES (30, '클라우드서비스팀', 7);

-- 경영지원부문 하위
INSERT INTO departments VALUES (31, '전략기획팀', 8);
INSERT INTO departments VALUES (32, '재무/회계팀', 8);
INSERT INTO departments VALUES (33, 'IR팀', 8);
INSERT INTO departments VALUES (34, '홍보팀', 8);

-- 인사팀 하위
INSERT INTO departments VALUES (35, '인사기획팀', 9);
INSERT INTO departments VALUES (36, '채용/배치팀', 9);
INSERT INTO departments VALUES (37, '보상/평가팀', 9);
INSERT INTO departments VALUES (38, '인재육성팀', 9);
INSERT INTO departments VALUES (39, '조직문화팀', 9);

-- users 초기 데이터 입력
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100001, 34, '정하나', '100001', 0, 0, 0, '2019-05-08');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100002, 34, '최민지', '100002', 0, 0, 0, '2022-05-01');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100003, 11, '임수민', '100003', 0, 0, 0, '2019-10-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100004, 24, '한은우', '100004', 0, 0, 0, '2021-05-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100005, 6, '한지원', '100005', 0, 0, 0, '2021-10-18');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100006, 6, '정준호', '100006', 0, 0, 0, '2017-03-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100007, 17, '김현우', '100007', 0, 0, 0, '2023-07-10');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100008, 34, '최수민', '100008', 0, 0, 0, '2018-09-18');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100009, 22, '강태영', '100009', 0, 0, 0, '2023-08-19');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100010, 28, '이준호', '100010', 0, 0, 0, '2022-01-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100011, 5, '김서진', '100011', 0, 0, 0, '2020-08-01');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100012, 8, '강서진', '100012', 0, 0, 0, '2020-07-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100013, 7, '강민지', '100013', 0, 0, 0, '2020-07-02');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100014, 10, '김현우', '100014', 0, 0, 0, '2020-08-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100015, 11, '한서진', '100015', 0, 0, 0, '2020-01-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100016, 23, '김현우', '100016', 0, 0, 0, '2024-07-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100017, 15, '최하나', '100017', 0, 0, 0, '2017-02-13');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100018, 23, '강태영', '100018', 0, 0, 0, '2019-01-07');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100019, 35, '임민지', '100019', 0, 0, 0, '2023-11-22');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100020, 32, '한태영', '100020', 0, 0, 0, '2024-07-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100021, 14, '박은우', '100021', 0, 0, 0, '2022-12-01');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100022, 2, '윤은우', '100022', 0, 0, 0, '2022-03-13');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100023, 6, '장서진', '100023', 0, 0, 0, '2022-04-27');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100024, 26, '장하나', '100024', 0, 0, 0, '2021-04-25');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100025, 15, '김하나', '100025', 0, 0, 0, '2021-08-18');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100026, 33, '최태영', '100026', 0, 0, 0, '2022-05-24');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100027, 4, '최태영', '100027', 0, 0, 0, '2023-08-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100028, 30, '최지수', '100028', 0, 0, 0, '2017-10-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100029, 14, '이수민', '100029', 0, 0, 0, '2021-08-03');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100030, 21, '정태영', '100030', 0, 0, 0, '2023-01-05');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100031, 17, '박준호', '100031', 0, 0, 0, '2022-10-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100032, 3, '임지수', '100032', 0, 0, 0, '2019-02-28');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100033, 32, '임은우', '100033', 0, 0, 0, '2023-04-19');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100034, 35, '강지원', '100034', 0, 0, 0, '2021-02-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100035, 13, '강민지', '100035', 0, 0, 0, '2022-04-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100036, 39, '최은우', '100036', 0, 0, 0, '2024-07-01');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100037, 5, '김하나', '100037', 0, 0, 0, '2017-04-03');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100038, 10, '최서진', '100038', 0, 0, 0, '2022-05-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100039, 2, '이서진', '100039', 0, 0, 0, '2020-12-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100040, 8, '박민지', '100040', 0, 0, 0, '2025-02-22');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100041, 29, '최현우', '100041', 0, 0, 0, '2024-09-17');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100042, 12, '박지수', '100042', 0, 0, 0, '2022-08-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100043, 5, '장태영', '100043', 0, 0, 0, '2023-06-27');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100044, 20, '박서진', '100044', 0, 0, 0, '2017-05-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100045, 38, '김지원', '100045', 0, 0, 0, '2019-05-03');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100046, 14, '최민지', '100046', 0, 0, 0, '2022-10-22');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100047, 13, '강수민', '100047', 0, 0, 0, '2018-06-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100048, 18, '정준호', '100048', 0, 0, 0, '2018-06-17');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100049, 4, '한수민', '100049', 0, 0, 0, '2024-04-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100050, 13, '정수민', '100050', 0, 0, 0, '2023-11-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100051, 18, '임서진', '100051', 0, 0, 0, '2021-02-12');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100052, 5, '정지수', '100052', 0, 0, 0, '2019-10-27');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100053, 16, '김민지', '100053', 0, 0, 0, '2022-05-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100054, 33, '박지수', '100054', 0, 0, 0, '2020-04-15');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100055, 3, '정지원', '100055', 0, 0, 0, '2020-03-12');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100056, 18, '강서진', '100056', 0, 0, 0, '2024-04-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100057, 24, '강은우', '100057', 0, 0, 0, '2021-03-20');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100058, 2, '윤하나', '100058', 0, 0, 0, '2021-02-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100059, 3, '장지수', '100059', 0, 0, 0, '2022-08-28');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100060, 21, '강준호', '100060', 0, 0, 0, '2020-02-19');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100061, 34, '최수민', '100061', 0, 0, 0, '2022-10-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100062, 32, '장수민', '100062', 0, 0, 0, '2023-07-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100063, 18, '윤태영', '100063', 0, 0, 0, '2025-11-19');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100064, 35, '윤태영', '100064', 0, 0, 0, '2023-03-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100065, 3, '이준호', '100065', 0, 0, 0, '2022-10-10');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100066, 12, '한민지', '100066', 0, 0, 0, '2020-04-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100067, 29, '한수민', '100067', 0, 0, 0, '2019-11-13');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100068, 3, '박서진', '100068', 0, 0, 0, '2023-07-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100069, 29, '정지원', '100069', 0, 0, 0, '2017-05-03');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100070, 21, '정지수', '100070', 0, 0, 0, '2017-01-12');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100071, 24, '박준호', '100071', 0, 0, 0, '2020-10-17');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100072, 35, '윤수민', '100072', 0, 0, 0, '2025-12-20');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100073, 10, '최수민', '100073', 0, 0, 0, '2024-06-07');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100074, 2, '장지수', '100074', 0, 0, 0, '2024-06-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100075, 25, '윤태영', '100075', 0, 0, 0, '2017-09-24');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100076, 26, '박태영', '100076', 0, 0, 0, '2019-08-27');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100077, 23, '최수민', '100077', 0, 0, 0, '2025-02-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100078, 38, '이민지', '100078', 0, 0, 0, '2024-06-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100079, 20, '한준호', '100079', 0, 0, 0, '2022-02-28');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100080, 1, '임수민', '100080', 0, 0, 0, '2020-04-24');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100081, 28, '장지원', '100081', 0, 0, 0, '2018-12-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100082, 21, '박지원', '100082', 0, 0, 0, '2019-05-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100083, 13, '정태영', '100083', 0, 0, 0, '2021-08-12');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100084, 30, '한하나', '100084', 0, 0, 0, '2019-04-28');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100085, 22, '박지수', '100085', 0, 0, 0, '2025-06-01');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100086, 32, '정태영', '100086', 0, 0, 0, '2023-08-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100087, 2, '이태영', '100087', 0, 0, 0, '2021-09-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100088, 3, '윤서진', '100088', 0, 0, 0, '2021-05-22');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100089, 37, '김수민', '100089', 0, 0, 0, '2022-04-27');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100090, 5, '임수민', '100090', 0, 0, 0, '2025-12-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100091, 16, '한민지', '100091', 0, 0, 0, '2018-08-05');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100092, 2, '최지원', '100092', 0, 0, 0, '2017-12-10');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100093, 29, '김서진', '100093', 0, 0, 0, '2022-09-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100094, 9, '최하나', '100094', 0, 0, 0, '2021-12-28');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100095, 24, '윤하나', '100095', 0, 0, 0, '2022-06-25');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100096, 6, '박서진', '100096', 0, 0, 0, '2025-06-08');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100097, 24, '이태영', '100097', 0, 0, 0, '2025-03-12');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100098, 7, '윤민지', '100098', 0, 0, 0, '2019-05-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100099, 2, '강수민', '100099', 0, 0, 0, '2022-05-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100100, 11, '정지수', '100100', 0, 0, 0, '2022-05-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100101, 39, '임민지', '100101', 0, 0, 0, '2023-02-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100102, 16, '최민지', '100102', 0, 0, 0, '2022-04-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100103, 30, '임현우', '100103', 0, 0, 0, '2021-10-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100104, 18, '윤현우', '100104', 0, 0, 0, '2020-03-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100105, 31, '김준호', '100105', 0, 0, 0, '2017-07-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100106, 34, '최현우', '100106', 0, 0, 0, '2017-10-10');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100107, 1, '장서진', '100107', 0, 0, 0, '2023-07-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100108, 24, '윤현우', '100108', 0, 0, 0, '2023-05-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100109, 37, '이은우', '100109', 0, 0, 0, '2025-10-15');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100110, 34, '윤지수', '100110', 0, 0, 0, '2023-01-08');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100111, 5, '박민지', '100111', 0, 0, 0, '2023-11-17');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100112, 22, '한민지', '100112', 0, 0, 0, '2021-08-25');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100113, 29, '이준호', '100113', 0, 0, 0, '2020-05-05');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100114, 8, '한서진', '100114', 0, 0, 0, '2017-02-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100115, 22, '이준호', '100115', 0, 0, 0, '2017-03-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100116, 32, '윤준호', '100116', 0, 0, 0, '2020-04-25');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100117, 39, '임준호', '100117', 0, 0, 0, '2022-12-10');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100118, 17, '윤민지', '100118', 0, 0, 0, '2017-04-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100119, 23, '최수민', '100119', 0, 0, 0, '2017-01-10');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100120, 30, '장은우', '100120', 0, 0, 0, '2018-03-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100121, 32, '이지원', '100121', 0, 0, 0, '2023-07-18');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100122, 17, '장준호', '100122', 0, 0, 0, '2023-06-19');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100123, 13, '윤현우', '100123', 0, 0, 0, '2017-05-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100124, 10, '임은우', '100124', 0, 0, 0, '2020-11-24');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100125, 11, '임수민', '100125', 0, 0, 0, '2018-06-05');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100126, 3, '장수민', '100126', 0, 0, 0, '2024-06-20');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100127, 13, '윤지원', '100127', 0, 0, 0, '2023-10-01');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100128, 20, '윤하나', '100128', 0, 0, 0, '2024-10-26');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100129, 29, '한수민', '100129', 0, 0, 0, '2025-11-25');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100130, 32, '장은우', '100130', 0, 0, 0, '2025-01-20');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100131, 36, '임지수', '100131', 0, 0, 0, '2021-08-15');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100132, 22, '장민지', '100132', 0, 0, 0, '2021-06-04');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100133, 5, '윤하나', '100133', 0, 0, 0, '2017-06-18');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100134, 3, '강하나', '100134', 0, 0, 0, '2020-07-16');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100135, 13, '한은우', '100135', 0, 0, 0, '2017-09-08');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100136, 14, '이서진', '100136', 0, 0, 0, '2023-08-05');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100137, 24, '최하나', '100137', 0, 0, 0, '2019-05-17');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100138, 4, '최준호', '100138', 0, 0, 0, '2018-01-07');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100139, 23, '김태영', '100139', 0, 0, 0, '2017-06-18');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100140, 1, '윤민지', '100140', 0, 0, 0, '2024-07-02');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100141, 39, '최준호', '100141', 0, 0, 0, '2019-04-19');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100142, 26, '한지수', '100142', 0, 0, 0, '2022-10-01');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100143, 2, '최현우', '100143', 0, 0, 0, '2018-03-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100144, 26, '장민지', '100144', 0, 0, 0, '2017-05-21');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100145, 4, '박수민', '100145', 0, 0, 0, '2019-03-13');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100146, 35, '정서진', '100146', 0, 0, 0, '2021-07-06');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100147, 31, '김하나', '100147', 0, 0, 0, '2020-11-11');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100148, 3, '김서진', '100148', 0, 0, 0, '2018-05-14');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100149, 33, '김지원', '100149', 0, 0, 0, '2020-12-23');
INSERT INTO users (user_id, department_id, name, password, question_count, answer_count, sum_satisfaction, join_year) VALUES (100150, 36, '정수민', '100150', 0, 0, 0, '2023-07-12');
