package com.devmobileii.backend.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import com.devmobileii.backend.model.Cliente;
import com.devmobileii.backend.repository.ClienteRepository;

import java.nio.file.*;
import java.util.List;
import java.util.Optional;

@Service
public class ClienteService {

    private final ClienteRepository repo;
    private final Path uploadDir = Paths.get("uploads");

    public ClienteService(ClienteRepository repo) throws Exception {
        this.repo = repo;
        if (!Files.exists(uploadDir)) Files.createDirectories(uploadDir);
    }

    public List<Cliente> listar() { return repo.findAll(); }

    public Optional<Cliente> buscar(Long id) { return repo.findById(id); }

    public Cliente salvar(Cliente c) { return repo.save(c); }

    public Cliente salvarComFoto(Cliente c, MultipartFile foto) throws Exception {
        if (foto != null && !foto.isEmpty()) {
            String filename = System.currentTimeMillis() + "_" + Path.of(foto.getOriginalFilename()).getFileName();
            Path dest = uploadDir.resolve(filename);
            Files.copy(foto.getInputStream(), dest, StandardCopyOption.REPLACE_EXISTING);
            c.setFoto("/uploads/" + filename);
        }
        return repo.save(c);
    }

    public Cliente atualizar(Long id, Cliente dados) {
        Cliente exist = repo.findById(id).orElseThrow(() -> new RuntimeException("Cliente não encontrado"));
        exist.setNome(dados.getNome());
        exist.setSobrenome(dados.getSobrenome());
        exist.setEmail(dados.getEmail());
        exist.setIdade(dados.getIdade());
        if (dados.getFoto() != null) exist.setFoto(dados.getFoto());
        return repo.save(exist);
    }

    public void remover(Long id) { repo.deleteById(id); }
}
