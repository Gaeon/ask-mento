package com.askmentor.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.askmentor.dto.QuestionRequest;
import com.askmentor.model.Answer;
import com.askmentor.model.Question;
import com.askmentor.repository.AnswerRepository;
import com.askmentor.repository.QuestionRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class QuestionServiceImpl implements QuestionService {
    
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;
    
    public QuestionServiceImpl(QuestionRepository questionRepository, AnswerRepository answerRepository) {
        this.questionRepository = questionRepository;
        this.answerRepository = answerRepository;
    }
    
    @Override
    public List<Question> getUserQuestions(int user_id) {
        return questionRepository.findByUserId(user_id);
    }
    
    @Override
    public String createQuestion(int user_id, QuestionRequest request) {
        Question question = new Question();
        question.setUserId(user_id);
        question.setQuestion(request.getQuestion());
        question.setTimestamp(LocalDateTime.now());
        question.setStatus(request.getStatus());
        questionRepository.save(question);
        
        // 벡터DB에 질문 저장
        try {
            ProcessBuilder pb = new ProcessBuilder("python3", 
                "/Users/gaeon/workspace/ask-mento/backend/src/main/resources/scripts/save_to_vector_db.py");
            pb.redirectErrorStream(true);
            Process process = pb.start();
            
            // Python 스크립트에 JSON 입력 전달
            BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(process.getOutputStream()));
            writer.write(new ObjectMapper().writeValueAsString(Map.of(
                "question_id", question.getQuestionId(),
                "question", request.getQuestion()
            )));
            writer.close();
            
            // 결과 읽기
            BufferedReader reader = new BufferedReader(
                new InputStreamReader(process.getInputStream()));
            String line;
            StringBuilder output = new StringBuilder();
            while ((line = reader.readLine()) != null) {
                output.append(line);
            }
            
            int exitCode = process.waitFor();
            if (exitCode != 0) {
                throw new RuntimeException("Python script execution failed");
            }
        } catch (Exception e) {
            throw new RuntimeException("Error saving question to vector DB", e);
        }
        
        return "질문 등록 성공";
    }
    
    @Override
    public Question getQuestionDetail(int question_id) {
        return questionRepository.findById(question_id).orElseThrow();
    }
    
    @Override
    public List<Answer> getAnswersByQuestionId(int question_id) {
        return answerRepository.findByQuestionId(question_id);
    }
    
    @Override
    public List<Map<String, String>> searchSimilarQuestions(Map<String, String> request) {
        try {
            System.out.println("\u001B[36m[검색 시작] 유사 질문 검색 프로세스 시작\u001B[0m");
            System.out.println("\u001B[33m[입력 데이터] " + new ObjectMapper().writeValueAsString(request) + "\u001B[0m");

            ProcessBuilder pb = new ProcessBuilder("python3", 
                    "/Users/gaeon/workspace/ask-mento/backend/src/main/resources/scripts/similarity_search.py");
            pb.redirectErrorStream(true);
            
            Process process = pb.start();
            try (
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));
                BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {

                System.out.println("\u001B[32m[프로세스 시작] Python 스크립트 실행 시작\u001B[0m");

                writer.write(new ObjectMapper().writeValueAsString(request));
                writer.flush();

                StringBuilder output = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    output.append(line);
                }

                int exitCode = process.waitFor();
                if (exitCode != 0) {
                    throw new RuntimeException("Python script execution failed");
                }

                System.out.println("\u001B[32m[스크립트 출력] " + output.toString() + "\u001B[0m");

                Map<String, Object> result = new ObjectMapper().readValue(output.toString(), new TypeReference<Map<String, Object>>() {});
                @SuppressWarnings("unchecked")
                List<String> similarQuestionIds = (List<String>) result.get("similar_question_ids");

                System.out.println("\u001B[36m[검색 완료] 유사 질문 " + similarQuestionIds.size() + "개 찾음\u001B[0m");

                return similarQuestionIds.stream()
                    .map(id -> Map.of("question_id", id))
                    .collect(java.util.stream.Collectors.toList());
            }
        } catch (Exception e) {
            throw new RuntimeException("Error processing similarity search", e);
        }
    }


}