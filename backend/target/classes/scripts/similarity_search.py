import sys
import json
from sentence_transformers import SentenceTransformer
import chromadb

def check_db_connection():
    try:
        client = chromadb.PersistentClient(path="./chroma_db")
        client.heartbeat()  # ChromaDB 연결 상태 확인
        return {"status": "connected"}
    except Exception as e:
        return {"status": "disconnected", "error": str(e)}

def main():
    # 입력 받기
    print("[LOG] 데이터 입력 완료", file=sys.stderr)
    input_query = sys.stdin.read()
    query_data = json.loads(input_query)
    query_text = query_data['query']
    print("[LOG] 입력 데이터 파싱 완료", file=sys.stderr)
    
    # 모델 로드 (SentenceTransformer 사용)
    print("[LOG] 모델 로드 시작", file=sys.stderr)
    model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')
    print("[LOG] 모델 로드 완료", file=sys.stderr)
    
    # Chroma DB 연결
    print("[LOG] ChromaDB 연결 시도", file=sys.stderr)
    chroma_client = chromadb.PersistentClient(path="chroma_db")
    collection = chroma_client.get_or_create_collection(name="questions")
    print("[LOG] ChromaDB 연결 성공", file=sys.stderr)
    
    # 질문 임베딩 생성
    print("[LOG] 질문 임베딩 생성 시작", file=sys.stderr)
    query_vector = model.encode(query_text).tolist()
    print("[LOG] 질문 임베딩 생성 완료", file=sys.stderr)
    
    # 유사도 검색 (상위 5개 결과)
    print("[LOG] 유사도 검색 실행", file=sys.stderr)
    result = collection.query(
        query_embeddings=[query_vector],
        n_results=5
    )
    print(f"[LOG] 검색 결과: {result['ids']}", file=sys.stderr)

    # 결과 처리
    similar_questions = []
    if result['ids']:
        similar_questions = result['ids'][0]

    return similar_questions

if __name__ == "__main__":
    try:
        if len(sys.argv) > 1 and sys.argv[1] == "--check":
            result = check_db_connection()
            print(json.dumps(result, ensure_ascii=False))
            sys.exit(0)
        else:
            result = main()
            print(json.dumps(result, ensure_ascii=False))
    except Exception as e:
        print(json.dumps({"error": str(e)}, ensure_ascii=False))
        sys.exit(1)
