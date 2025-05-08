# # check.py
# import chromadb

# client = chromadb.PersistentClient(path="chroma_db")
# collection = client.get_collection("questions")

# print("📌 저장된 문서 수:", collection.count())
# print("📌 저장된 ID 목록:", collection.get()['ids'])

# check.py 수정 버전
import chromadb

client = chromadb.PersistentClient(path="/Users/gaeon/workspace/ask-mento/backend/src/chroma_db")
collection = client.get_collection("questions")

print("📌 저장된 문서 수:", collection.count())
print("📌 저장된 ID 목록:", collection.get()['ids'])
print("📌 저장된 임베딩 수:", len(collection.get()['embeddings']))