# 🧠 Ask-Mento
![logo](https://github.com/user-attachments/assets/fe2d4d98-e47f-43fa-adf2-832d4d35b2bb)

> **AI 기반 멘토링 지원 플랫폼**  
> 사용자의 질문을 분석하고 도메인 지식을 기반으로 답변을 제공하는 지능형 에이전트 시스템입니다.

---

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

## 🧠 AI 에이전트 기능

- 질문 텍스트를 기반으로 context를 추론
- 관련 문서를 DB 또는 벡터DB에서 검색 (Chroma)
- 도메인 기반 답변 생성 (LLM 기반)
- RAG(Retrieval-Augmented Generation) 구성

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
