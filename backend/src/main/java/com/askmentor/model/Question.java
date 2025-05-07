package com.askmentor.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Question")
public class Question {
    @Id
    @Column(name = "question_id")
    private int questionId;
    
    @Column(name = "user_id")
    private int userId;
    
    @Column(name = "question", length = 300)
    private String question;
    
    @Column(name = "timestamp")
    private LocalDateTime timestamp;
    
    @Column(name = "status")
    private Integer status;
}