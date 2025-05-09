from langchain.tools import Tool
from agent.database import SessionLocal
from sqlalchemy import text

def get_departments():
    """MariaDB에서 모든 부서/팀 정보를 조회합니다."""
    with SessionLocal() as db:
        query = text("SELECT department_id, department, parent_department FROM departments")
        rows = db.execute(query).fetchall()
        
        result = []
        for row in rows:
            # 행을 딕셔너리로 변환 (키-값 쌍으로 명시적 변환)
            row_dict = {
                "department_id": row[0],
                "department": row[1],
                "parent_department": row[2]
            }
            result.append(row_dict)
        return result

def get_employees_by_department(department_id: str):
    """특정 부서/팀에 속한 직원 정보를 조회합니다."""
    with SessionLocal() as db:
        query = text("""
            SELECT user_id, name, answer_count, sum_satisfaction, join_year 
            FROM users 
            WHERE department_id = :dept_id
            ORDER BY join_year DESC
        """)
        rows = db.execute(query, {"dept_id": department_id}).fetchall()
        
        result = []
        for row in rows:
            # 답변 수가 0인 경우 평균 만족도 값 처리
            if row[2] != 0:
                avg_satisfaction = row[3]/row[2]
            else: avg_satisfaction = 0
            
            row_dict = {
                "user_id": row[0],
                "name": row[1],
                "answer_count": row[2],
                "avg_satisfaction": avg_satisfaction,
                "join_year": row[4]
            }
            result.append(row_dict)
        return result


# 도구 정의
get_departments_tool = Tool.from_function(
    func=get_departments,
    name="get_departments",
    description="회사의 모든 부서와 팀 정보를 조회합니다."
)

get_employees_tool = Tool.from_function(
    func=get_employees_by_department,
    name="get_employees_by_department",
    description="특정 부서 ID를 입력받아 해당 부서에 속한 직원 정보를 조회합니다."
)

