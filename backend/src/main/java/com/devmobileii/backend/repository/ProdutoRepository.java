package com.devmobileii.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.devmobileii.backend.model.Produto;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {}
