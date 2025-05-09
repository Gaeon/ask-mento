from langchain.agents import initialize_agent, AgentType
from langchain_core.runnables import RunnablePassthrough
from langchain_community.chat_models import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from agent.tools import get_departments_tool, get_employees_tool
from typing import List, Dict, Any
import json
import re

def create_agent():
    # LLM 모델 설정
    llm = ChatOpenAI(model_name="gpt-4o-mini", temperature=0)
    
    # 단계별 체인 구성
    def get_department_info(inputs: Dict[str, Any]) -> Dict[str, Any]:
        """부서 정보를 조회하는 함수"""
        departments = get_departments_tool.func()
        return {"departments": departments, "query": inputs["input"]}
    
    def select_department(inputs: Dict[str, Any]) -> Dict[str, Any]:
        """적합한 부서를 선택하는 함수"""
        departments = inputs["departments"]
        query = inputs["query"]
        
        # 부서 선택 프롬프트
        prompt = ChatPromptTemplate.from_messages([
            ("system", """
            당신은 사내 질문을 적절한 부서에 라우팅하는 전문가입니다.
            주어진 질문과 부서 목록을 분석하여, 이 질문에 가장 적합한 부서들을 선택하세요.
            부서 정보에는 department_id, department, parent_department가 포함되어 있습니다.
            
            최대 3개의 관련 부서를 선택하고, 각 부서의 department_id를 쉼표로 구분하여 반환하세요.
            예: "1,3,5" 또는 "2,7" 또는 "4"
            
            만약 질문이 특정 부서에 국한되지 않고 모든 부서와 관련이 있다면, "0"을 반환하세요.
            이 경우 모든 부서의 직원들이 검색됩니다.
            
            다른 설명은 필요 없습니다.
            """),
            ("human", "질문: {query}\n\n부서 목록: {departments}")
        ])
        
        # 부서 선택 실행
        dept_selection = prompt.format_messages(query=query, departments=departments)
        dept_response = llm.invoke(dept_selection)
        
        # 선택된 부서 ID 추출 (쉼표로 구분된 숫자들)
        dept_ids = re.findall(r'\d+', dept_response.content)
        if not dept_ids:
            # 첫 번째 부서 ID를 기본값으로 사용
            dept_ids = [str(departments[0]["department_id"])] if departments else ["1"]
        
        return {
            "departments": departments,
            "query": query,
            "selected_dept_ids": dept_ids
        }
    
    def get_employees(inputs: Dict[str, Any]) -> Dict[str, Any]:
        """선택된 부서들의 직원 정보를 조회하는 함수"""
        dept_ids = inputs["selected_dept_ids"]
        all_employees = []
        
        # "0"이 포함되어 있으면 모든 부서의 직원 조회
        if "0" in dept_ids:
            # 모든 부서 ID 가져오기
            all_dept_ids = [str(dept["department_id"]) for dept in inputs["departments"]]
            for dept_id in all_dept_ids:
                employees = get_employees_tool.func(dept_id)
                # 부서 ID 정보 추가
                for emp in employees:
                    emp["department_id"] = dept_id
                all_employees.extend(employees)
        else:
            # 선택된 부서만 조회
            for dept_id in dept_ids:
                employees = get_employees_tool.func(dept_id)
                # 부서 ID 정보 추가
                for emp in employees:
                    emp["department_id"] = dept_id
                all_employees.extend(employees)
        
        return {
            "departments": inputs["departments"],
            "query": inputs["query"],
            "selected_dept_ids": dept_ids,
            "employees": all_employees
        }
    
    def select_top_employees(inputs: Dict[str, Any]) -> Dict[str, Any]:
        """최적의 답변자 3명을 선택하고 추천 이유를 포함하는 함수"""
        employees = inputs["employees"]
        query = inputs["query"]
        departments = inputs["departments"]
        
        # 직원이 3명 미만이면 모두 선택
        if len(employees) <= 3:
            top_employees = employees
        else:
            # 답변 수와 만족도를 기준으로 정렬
            sorted_employees = sorted(
                employees, 
                key=lambda e: (e.get("answer_count", 0) or 0) * (e.get("avg_satisfaction", 0) or 0), 
                reverse=True
            )
            top_employees = sorted_employees[:3]
        
        # 랜덤 동물 이름 목록
        animal_names = [
            "고양이", "강아지", "토끼", "여우", "사자", "호랑이", "팬더", "코알라", 
            "펭귄", "기린", "코끼리", "원숭이", "곰", "늑대", "다람쥐", "하마", 
            "악어", "독수리", "부엉이", "참새", "거북이", "고래", "돌고래", "상어"
        ]
        
        # 형용사 목록 추가
        adjectives = [
            "행복한", "똑똑한", "열정적인", "친절한", "용감한", "창의적인", "성실한", "활기찬",
            "차분한", "신중한", "재치있는", "꼼꼼한", "낙천적인", "진지한", "유쾌한", "부지런한",
            "현명한", "믿음직한", "정직한", "사려깊은", "명랑한", "온화한", "예리한", "헌신적인",
            "졸린",  "배고픈",   "빠른",  "씩씩한",  "야무진",  "수상한", "깐족대는"
        ]
        
        import random
        random.shuffle(animal_names)  # 동물 이름 섞기
        random.shuffle(adjectives)    # 형용사 섞기
        
        # 부서명 찾기 함수
        def find_department_name(dept_id):
            # 부서 ID가 0이면 "전체 부서"로 표시
            if str(dept_id) == "0":
                return "전체 부서"
                
            for dept in departments:
                if str(dept.get("department_id")) == str(dept_id):
                    return dept.get("department")
            return "미지정 부서"  # 부서를 찾지 못한 경우
        
        # 해시태그 생성을 위한 프롬프트
        hashtag_prompt = ChatPromptTemplate.from_messages([
            ("system", """
            당신은 직원 추천 시스템입니다. 각 직원이 특정 질문에 답변하기에 적합한 이유를 해시태그 형태로 작성해주세요.
            
            중요: 
            1. 정확히 3개의 해시태그를 생성하세요.
            2. 각 해시태그는 '#'으로 시작하고 띄어쓰기 없이 작성하세요.
            3. 직원의 경력, 입사 연도, 전문 분야, 답변 수, 만족도 등을 활용하세요.
            4. 질문 내용과 관련된 키워드도 포함하세요.
            5. 해시태그는 간결하고 명확하게 작성하세요.
            
            예시:
            - "#5년경력 #인사전문가 #규정숙지"
            - "#신입사원 #열정적 #빠른응답"
            - "#팀장경험 #다수답변 #높은만족도"
            
            출력 형식: "#태그1 #태그2 #태그3" (정확히 3개만 출력)
            """),
            ("human", "질문: {query}\n\n직원 정보: {employee}")
        ])
        
        # 최종 결과 형식 생성
        result = {}
        for i, emp in enumerate(top_employees, 1):
            # 해시태그 생성
            hashtag_messages = hashtag_prompt.format_messages(query=query, employee=emp)
            hashtag_response = llm.invoke(hashtag_messages)
            
            # 부서명 찾기 - 직원의 department_id 사용
            dept_name = find_department_name(emp.get("department_id"))
            
            # 익명화된 이름 생성 (부서명 + 형용사 + 동물)
            anonymous_name = f"{dept_name} {adjectives[i-1]} {animal_names[i-1]}"
            # 평균 답변 만족도 생성
            answer_count = emp.get("answer_count", 0)
            sum_satisfaction = emp.get("sum_satisfaction", 0)
            avg_satisfaction = sum_satisfaction / answer_count if answer_count > 0 else 0
            result[i] = {
                "user_id": emp.get("user_id"),
                "name": emp.get("name"),
                "anonymous_name": anonymous_name,
                "avg_statisfaction": avg_satisfaction,
                "추천 이유": hashtag_response.content
            }
        
        return {"recommendations": result}
        # 최종 user_id 리스트 생성
        user_ids = [emp.get("user_id") for emp in top_employees]
        
        return {"selected_user_ids": user_ids}
    
    # 전체 체인 구성
    chain = (
        RunnablePassthrough()
        .pipe(get_department_info)
        .pipe(select_department)
        .pipe(get_employees)
        .pipe(select_top_employees)
    )
    
    return chain

# 에이전트 생성
agent = create_agent()