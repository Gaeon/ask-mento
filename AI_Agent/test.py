import os
import sys
from dotenv import load_dotenv

# 경로 설정
sys.path.insert(0, "c:\\Users\\Administrator\\Documents\\ask-mento\\ask-mento\\AI_Agent")

# 환경 변수 로드
load_dotenv()

# 에이전트 임포트
from agent.agent import agent

def test_agent(query: str):
    """에이전트 테스트 함수"""
    try:
        print(f"질문: {query}")
        response = agent.invoke({"input": query})
        
        print("\n추천 답변자:")
        for rank, info in response["recommendations"].items():
            print(f"\n{rank}위: {info['anonymous_name']}")  # 익명화된 이름 출력
            print(f"  실제 이름: {info['name']} (ID: {info['user_id']})")
            print(f"  평균 만족도: {info['avg_statisfaction']}")
            print(f"  추천 이유: {info['추천 이유']}")
        
        return response["recommendations"]
    except Exception as e:
        print(f"에러 발생: {str(e)}")
        return None

# 테스트 실행
if __name__ == "__main__":
    test_agent("당일 반차는 언제까지 말씀드려야 하나요?")