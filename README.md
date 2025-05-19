# 🧠 Ask-Mento (사내 지식인 AI 에이전트)
![logo](https://github.com/user-attachments/assets/fe2d4d98-e47f-43fa-adf2-832d4d35b2bb)

> 익명 질문 → 유사 Q&A 추천 + 사내 멘토 매칭 + AI 자동 응답까지  
> 사내 구성원 누구나 편하게 질문하고, 빠르게 전문적인 답변을 받을 수 있는 AI 기반 지식공유 플랫폼

---

## 🪄 프로젝트 개요

| 항목       | 내용                                                         |
|------------|--------------------------------------------------------------|
| 주제       | AI 서비스 개발 미니 프로젝트                                 |
| 기간       | 2025.05.07 ~ 2025.05.09                                       |
| 개발 인원   | 3명                                                          |

---

## 🧩 서비스 시나리오

### ❓ 사용자는
- 익명으로 사내 시스템에서 질문을 작성합니다
- 작성 즉시 유사한 Q&A가 먼저 추천됩니다 (기존 질문 메모리 기반)
- 질문자는 추천된 멘토 후보(사내 직원) 중 한 명을 선택해 질문을 전송할 수 있습니다

### 🤖 시스템은
- 질문자의 **직급**과 **질문 주제**를 기반으로, **직급이 더 높은 전문가**를 자동 매칭합니다
- 이전 유사 질문의 Q&A를 우선적으로 추천하고, 없을 경우 RAG 기반 AI가 자동 응답을 생성합니다

---

## 🔧 주요 기능 및 구성

### ✅ 프론트엔드
- 📱 모바일 최적화된 뷰
- 🔍 구글/네이버 지식인 스타일 검색 UI
- 🧾 본인 질문·답변 내역 확인 (네비게이션)

### ✅ 백엔드
- Java Spring Boot 기반
- RESTful API + Swagger 문서 제공

### ✅ AI Agent
- Langchain 기반 멘토링 에이전트
- RAG 기반 사내 매뉴얼 자동 응답
- 멘토 매칭 + 유사 질문 추천 기능 포함

### ✅ 데이터베이스
- 사내 직원 테이블: `이름`, `직급`
- 질문/답변 내역 저장 테이블
- ChromaDB를 통한 유사도 기반 RAG 검색

## 📁 프로젝트 구조
```bash
.
├── AI_Agent            # Langchain 기반 AI 멘토링 에이전트 (Python)
│   ├── agent/          # Agent 로직 및 도구 모듈
│   ├── api.py          # FastAPI 기반 API 서버
│   ├── test.py         # Agent 테스트 코드
│   ├── pyproject.toml  # Poetry 환경 설정
│   └── requirements-mini.txt
├── backend             # Java Spring Boot 백엔드
│   ├── pom.xml
│   └── src/
├── frontend            # Vue 3 + Vite 프론트엔드
│   ├── src/
│   └── vite.config.js
├── chroma_db/          # ChromaDB (벡터 DB 저장소)
├── db-init/init.sql    # MariaDB 초기 스키마
├── docker-compose.yml  # 전체 시스템 도커 구성
├── ask_mentor.yaml     # OpenAPI 명세
└── README.md
```
---

## ⚙️ 주요 기술 스택

| 영역         | 기술                              |
|--------------|-------------------------------------|
| AI Agent     | Python, Langchain, FastAPI, ChromaDB |
| Backend      | Java 17, Spring Boot, JPA, MariaDB  |
| Frontend     | Vue.js 3, Vite      |
| DevOps       | Docker, Docker Compose, K8s (설정 포함) |

---

## 🧬 ERD

![ask-mentor](https://github.com/user-attachments/assets/6048e735-b08b-4d86-8bf0-687a1f34bee7)

---

## 🐳 실행 방법 (개발 환경 기준)

```bash
# 1. 백엔드 빌드 (Spring Boot)
cd backend
./mvnw clean install

# 2. 프론트엔드 실행
cd frontend
npm install
npm run dev

# 3. AI Agent 실행
cd AI_Agent
poetry install
poetry run uvicorn api:app --reload

# 4. 전체 컨테이너 실행 (옵션)
docker-compose up --build
```
![image](https://github.com/user-attachments/assets/333797b9-15c2-4223-b63c-a8ce58f57821)
