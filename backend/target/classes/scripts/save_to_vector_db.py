import sys
import json
from sentence_transformers import SentenceTransformer
import chromadb

# 전역 모델 변수
model = SentenceTransformer('sentence-transformers/all-MiniLM-L6-v2')


def main():
	# 입력 데이터 읽기
	data = json.loads(sys.stdin.read())
	question_id = data['question_id']
	question = data['question']

	print(question_id, question)

	# 임베딩 생성
	embedding = model.encode(question).tolist()

	# ChromaDB에 저장
	client = chromadb.PersistentClient(path="chroma_db")
	collection = client.get_or_create_collection(name="questions")

	collection.add(
		embeddings=[embedding],
		ids=[str(question_id)]
	)

	# 결과 반환
	print(json.dumps({"status": "success", "message": "Question saved to vector DB"}))

if __name__ == "__main__":
	main()