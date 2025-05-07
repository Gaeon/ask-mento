package com.askmentor.controller;

import java.util.List;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.askmentor.dto.QuestionRequest;
import com.askmentor.dto.QuestionWithAnswerResponse;
import com.askmentor.model.Answer;
import com.askmentor.model.Question;
import com.askmentor.service.QuestionService;


@RestController
@RequestMapping("/api/questions")
public class QuestionController {

	private final QuestionService questionService;
	
	public QuestionController(QuestionService questionService) {
		this.questionService = questionService;
	}

	@GetMapping("/{user_id}")
	public ResponseEntity<List<Question>> getUserQuestions(@PathVariable int user_id) {
		List<Question> questions = questionService.getUserQuestions(user_id);
		return ResponseEntity.ok(questions);
	}

	@PostMapping("/{user_id}")
	public ResponseEntity<String> createQuestion(@PathVariable int user_id, @RequestBody QuestionRequest request) {
		String result = questionService.createQuestion(user_id, request);
		return ResponseEntity.ok(result);
	}

	@GetMapping("/{question_id}")
	public ResponseEntity<QuestionWithAnswerResponse> getQuestionDetail(@PathVariable int question_id) {
		Question question = questionService.getQuestionDetail(question_id);
		List<Answer> answers = questionService.getAnswersByQuestionId(question_id);

		return ResponseEntity.ok(new QuestionWithAnswerResponse(question, answers));
	}
}