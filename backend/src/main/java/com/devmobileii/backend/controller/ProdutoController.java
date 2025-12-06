package com.devmobileii.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.devmobileii.backend.model.Produto;
import com.devmobileii.backend.service.ProdutoService;

import java.util.List;

@RestController
@RequestMapping("/produtos")
@CrossOrigin(origins = "*")
public class ProdutoController {
    private final ProdutoService service;
    public ProdutoController(ProdutoService s){ this.service = s; }

    @GetMapping public List<Produto> listar(){ return service.listar(); }
    @GetMapping("/{id}") public ResponseEntity<Produto> buscar(@PathVariable Long id){ return service.listar().stream().filter(p->p.getId().equals(id)).findFirst().map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build()); }
    @PostMapping public ResponseEntity<Produto> criar(@RequestBody Produto p){ return ResponseEntity.status(201).body(service.salvar(p)); }
    @PutMapping("/{id}") public ResponseEntity<Produto> atualizar(@PathVariable Long id, @RequestBody Produto p){ return ResponseEntity.ok(service.atualizar(id,p)); }
    @DeleteMapping("/{id}") public ResponseEntity<Void> deletar(@PathVariable Long id){ service.remover(id); return ResponseEntity.noContent().build(); }
}
