package com.askmentor.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.askmentor.dto.AnswerRequest;
import com.askmentor.dto.SatisfactionRequest;
import com.askmentor.model.Answer;
import com.askmentor.repository.AnswerRepository;
import com.askmentor.service.AnswerService;
import com.askmentor.service.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/answers")
@Tag(name = "Answer API", description = "답변 관련 API")
public class AnswerController {

    private final AnswerService answerService;
    private final AnswerRepository answerRepository;
    private final UserService userService;

    public AnswerController(AnswerService answerService, AnswerRepository answerRepository, UserService userService) {
        this.answerService = answerService;
        this.answerRepository = answerRepository;
        this.userService = userService;
    }

    @Operation(summary = "사용자 답변 내역 조회", description = "특정 사용자의 모든 답변 목록을 조회합니다.")
    @GetMapping("/{user_id}")
    public List<Answer> getUserAnswers(
            @PathVariable int user_id) {
        return answerService.getUserAnswers(user_id);
    }

    @Operation(summary = "답변 등록", description = "특정 사용자의 질문에 대한 새로운 답변을 등록합니다.")
    @PostMapping("/{user_id}")
    public String createAnswer(
            @PathVariable int user_id,
            @RequestBody AnswerRequest request) {
        return answerService.createAnswer(user_id, request);
    }

    @Operation(summary = "특정 답변 상세 조회", description = "특정 답변의 상세 정보를 조회합니다.")
    @GetMapping("/detail/{answer_id}")
    public Answer getAnswerDetail(
            @PathVariable int answer_id) {
        return answerService.getAnswerDetail(answer_id);
    }

    @Operation(summary = "답변 평점 등록/수정", description = "특정 답변에 대한 만족도를 등록하거나 수정합니다.")
    @PatchMapping("/{answer_id}")
    public ResponseEntity<Map<String, String>> updateSatisfaction(
            @PathVariable int answer_id,
            @RequestBody SatisfactionRequest request) {
                Answer answer = answerRepository.findById(answer_id).orElseThrow();
                int userid = answer.getUserId();
        return ResponseEntity.ok(Map.of(
            "answer", answerService.updateSatisfaction(answer_id, request),
            "update", userService.updateSumSatisfaction(userid, request.getSatisfaction())
        )
        );
    }
}
