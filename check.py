# # check.py
# import chromadb

# client = chromadb.PersistentClient(path="chroma_db")
# collection = client.get_collection("questions")

# print("📌 저장된 문서 수:", collection.count())
# print("📌 저장된 ID 목록:", collection.get()['ids'])

# check.py 수정 버전
import chromadb

# 현재 디렉토리 기준 ./chroma_db 에 있는 DB에 연결
client = chromadb.PersistentClient(path="chroma_db")
collection = client.get_collection("questions")

# 문서 수 확인
print("📌 저장된 문서 수:", collection.count())

# ID 및 임베딩 포함해서 가져오기
result = collection.get(include=["embeddings"])

print("📌 저장된 ID 목록:", result["ids"])
print("📌 저장된 임베딩 수:", len(result["embeddings"]))