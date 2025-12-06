package com.devmobileii.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.devmobileii.backend.model.Cliente;

public interface ClienteRepository extends JpaRepository<Cliente, Long> {
    boolean existsByEmail(String email);
}
