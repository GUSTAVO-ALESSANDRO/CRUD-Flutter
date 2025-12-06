package com.devmobileii.backend.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "produto")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Produto {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    private String nome;

    private String descricao;

    @Positive
    private Double preco;

    private LocalDateTime dataAtualizado = LocalDateTime.now();

    @PreUpdate
    public void preUpdate() {
        dataAtualizado = LocalDateTime.now();
    }

}
