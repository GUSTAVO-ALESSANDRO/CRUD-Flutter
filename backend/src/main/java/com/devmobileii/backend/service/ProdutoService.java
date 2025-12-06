package com.devmobileii.backend.service;

import org.springframework.stereotype.Service;
import com.devmobileii.backend.model.Produto;
import com.devmobileii.backend.repository.ProdutoRepository;

import java.util.List;

@Service
public class ProdutoService {
    private final ProdutoRepository repo;
    public ProdutoService(ProdutoRepository repo){ this.repo = repo; }

    public List<Produto> listar(){ return repo.findAll(); }
    public Produto salvar(Produto p){ return repo.save(p); }
    public Produto atualizar(Long id, Produto p){
        Produto ex = repo.findById(id).orElseThrow();
        ex.setNome(p.getNome());
        ex.setDescricao(p.getDescricao());
        ex.setPreco(p.getPreco());
        return repo.save(ex);
    }
    public void remover(Long id){ repo.deleteById(id); }
}
