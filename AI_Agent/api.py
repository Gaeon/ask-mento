from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from agent.agent import agent
import uvicorn
import traceback

# FastAPI 앱 생성
app = FastAPI(title="Ask Mento API", description="사내 질문에 답변할 최적의 멘토를 추천하는 API")

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 실제 배포 시에는 특정 도메인으로 제한하는 것이 좋습니다
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 요청 모델 정의
class QuestionRequest(BaseModel):
    question: str

@app.post("/api/recommend-mentors")
async def recommend_mentors(request: QuestionRequest):
    """질문을 받아 적합한 멘토를 추천하는 API"""
    try:
        if not request.question:
            raise HTTPException(status_code=400, detail="질문이 비어있습니다.")
        
        # 에이전트 호출
        response = agent.invoke({"input": request.question})
        
        # 프론트엔드에 맞게 데이터 변환
        mentors = []
        for rank, info in response["recommendations"].items():
            mentors.append({
                "id": info["user_id"],
                "team": info["anonymous_name"],
                "experience": info.get("experience", 3),  # 기본값 설정
                "domain": info.get("department_id", ""),
                "tags": info["추천 이유"]  # 해시태그 형태의 추천 이유
            })
        
        return {"mentors": mentors}
    
    except Exception as e:
        print(traceback.format_exc())
        raise HTTPException(status_code=500, detail=f"서버 오류: {str(e)}")

# 서버 실행
if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=5000, reload=True)