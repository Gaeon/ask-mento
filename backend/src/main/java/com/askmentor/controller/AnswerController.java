package com.askmentor.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.askmentor.dto.AnswerRequest;
import com.askmentor.dto.SatisfactionRequest;
import com.askmentor.model.Answer;
import com.askmentor.service.AnswerService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.parameters.RequestBody;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/answers")
@Tag(name = "Answer API", description = "답변 관련 API")
public class AnswerController {

    private final AnswerService answerService;

    public AnswerController(AnswerService answerService) {
        this.answerService = answerService;
    }

    @Operation(summary = "사용자의 모든 답변 조회", description = "특정 사용자의 모든 답변 목록을 조회합니다.")
    @ApiResponse(responseCode = "200", description = "조회 성공", content = @Content(mediaType = "application/json"))
    @GetMapping("/{user_id}")
    public List<Answer> getUserAnswers(
            @Parameter(description = "사용자 ID", example = "1")
            @PathVariable int user_id) {
        return answerService.getUserAnswers(user_id);
    }

    @Operation(summary = "답변 등록", description = "특정 사용자의 질문에 대한 새로운 답변을 등록합니다.")
    @ApiResponse(responseCode = "200", description = "등록 성공", content = @Content(mediaType = "text/plain"))
    @PostMapping("/{user_id}")
    public String createAnswer(
            @Parameter(description = "사용자 ID", example = "1")
            @PathVariable int user_id,
            @io.swagger.v3.oas.annotations.parameters.RequestBody(
                description = "등록할 답변 정보",
                required = true,
                content = @Content(schema = @Schema(implementation = AnswerRequest.class))
            )
            @RequestBody AnswerRequest request) {
        return answerService.createAnswer(user_id, request);
    }

    @Operation(summary = "답변 상세 조회", description = "특정 답변의 상세 정보를 조회합니다.")
    @ApiResponse(responseCode = "200", description = "조회 성공", content = @Content(mediaType = "application/json"))
    @GetMapping("/detail/{answer_id}")
    public Answer getAnswerDetail(
            @Parameter(description = "답변 ID", example = "100")
            @PathVariable int answer_id) {
        return answerService.getAnswerDetail(answer_id);
    }

    @Operation(summary = "만족도 등록/수정", description = "특정 답변에 대한 만족도를 등록하거나 수정합니다.")
    @ApiResponse(responseCode = "200", description = "수정 성공", content = @Content(mediaType = "text/plain"))
    @PatchMapping("/{answer_id}")
    public String updateSatisfaction(
            @Parameter(description = "답변 ID", example = "100")
            @PathVariable int answer_id,
            @io.swagger.v3.oas.annotations.parameters.RequestBody(
                description = "수정할 만족도 정보",
                required = true,
                content = @Content(schema = @Schema(implementation = SatisfactionRequest.class))
            )
            @RequestBody SatisfactionRequest request) {
        return answerService.updateSatisfaction(answer_id, request);
    }
}
