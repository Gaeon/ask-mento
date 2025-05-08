package com.askmentor.service;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.nio.file.Paths;

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
    public String createQuestion(int userId, QuestionRequest request) {
        // 1. DB에 질문 저장
        Question question = new Question();
        question.setUserId(userId);
        question.setQuestion(request.getQuestion());
        question.setTimestamp(LocalDateTime.now());
        question.setStatus(request.getStatus());
        questionRepository.save(question);

        System.out.println("😁😁😁   " + question.getQuestionId() + request.getQuestion());

        // 2. 벡터 DB 저장을 위한 Python 실행
        try {
            // 절대 경로 기준으로 Python 스크립트 경로 설정
            String scriptPath = Paths.get("backend", "src", "main", "resources", "scripts", "save_to_vector_db.py")
                         .toAbsolutePath()
                         .toString();

            ProcessBuilder pb = new ProcessBuilder("python3", scriptPath);
            pb.redirectErrorStream(false); // stdout/stderr 분리해서 받기

            Process process = pb.start();

            // JSON 데이터 Python으로 전달
            try (BufferedWriter writer = new BufferedWriter(
                    new OutputStreamWriter(process.getOutputStream()))) {
                String jsonInput = new ObjectMapper().writeValueAsString(Map.of(
                    "question_id", question.getQuestionId(),
                    "question", request.getQuestion()
                ));
                System.out.println("😁😁😁   " + question.getQuestionId() + request.getQuestion());
                writer.write(jsonInput);
                writer.flush();
            }

            // Python stdout
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("[Python STDOUT] " + line);
                }
            }

            // Python stderr
            StringBuilder errorOutput = new StringBuilder();
            try (BufferedReader errorReader = new BufferedReader(
                    new InputStreamReader(process.getErrorStream()))) {
                String line;
                while ((line = errorReader.readLine()) != null) {
                    System.err.println("[Python STDERR] " + line);
                    errorOutput.append(line).append("\n");
                }
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                throw new RuntimeException("Python script execution failed:\n" + errorOutput);
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
            String inputQuestion = request.get("question");
            if (inputQuestion == null || inputQuestion.isBlank()) {
                throw new IllegalArgumentException("질문 내용이 비어 있습니다.");
            }

            // ✅ Python 스크립트 경로 (절대 경로 사용)
            String scriptPath = Paths.get("backend", "src", "main", "resources", "scripts", "similarity_search.py")
                                    .toAbsolutePath()
                                    .toString();

            ProcessBuilder pb = new ProcessBuilder("python3", scriptPath);
            Process process = pb.start();

            // ✅ 입력 JSON 전달
            try (
                BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(process.getOutputStream()));
                BufferedReader stdout = new BufferedReader(new InputStreamReader(process.getInputStream()));
                BufferedReader stderr = new BufferedReader(new InputStreamReader(process.getErrorStream()))
            ) {
                // JSON 포맷으로 질문 보내기
                String inputJson = new ObjectMapper().writeValueAsString(Map.of("question", inputQuestion));
                writer.write(inputJson);
                writer.flush();
                writer.close();

                // ✅ stdout 읽기
                StringBuilder output = new StringBuilder();
                String line;
                while ((line = stdout.readLine()) != null) {
                    System.out.println("[Python STDOUT] " + line);
                    output.append(line);
                }

                // ✅ stderr 로그 확인 (실패 시 원인 추적)
                StringBuilder errorLog = new StringBuilder();
                while ((line = stderr.readLine()) != null) {
                    System.err.println("[Python STDERR] " + line);
                    errorLog.append(line).append("\n");
                }

                int exitCode = process.waitFor();
                if (exitCode != 0) {
                    throw new RuntimeException("Python script failed:\n" + errorLog);
                }

                // ✅ 결과 파싱
                Map<String, Object> result = new ObjectMapper().readValue(
                    output.toString(),
                    new TypeReference<Map<String, Object>>() {}
                );

                @SuppressWarnings("unchecked")
                List<String> similarIds = (List<String>) result.get("similar_question_ids");

                return similarIds.stream()
                        .map(id -> Map.of("question_id", id))
                        .collect(Collectors.toList());
            }

        } catch (Exception e) {
            throw new RuntimeException("Error during similarity search", e);
        }
    }


}