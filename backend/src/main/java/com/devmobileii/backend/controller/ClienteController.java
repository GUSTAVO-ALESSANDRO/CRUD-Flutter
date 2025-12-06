package com.devmobileii.backend.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.devmobileii.backend.model.Cliente;
import com.devmobileii.backend.service.ClienteService;

import java.util.List;

@RestController
@RequestMapping("/clientes")
@CrossOrigin(origins = "*")
public class ClienteController {

    private final ClienteService service;
    public ClienteController(ClienteService service){ this.service = service; }

    @GetMapping
    public List<Cliente> listar(){ return service.listar(); }

    @GetMapping("/{id}")
    public ResponseEntity<Cliente> buscar(@PathVariable Long id){
        return service.buscar(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
    }

    // Multipart: campos como form-data
    @PostMapping(consumes = {"multipart/form-data"})
    public ResponseEntity<Cliente> criarComFoto(@RequestPart("cliente") @Validated Cliente cliente,
                                                @RequestPart(value="foto", required=false) MultipartFile foto) throws Exception {
        Cliente salvo = service.salvarComFoto(cliente, foto);
        return ResponseEntity.status(201).body(salvo);
    }

    // JSON fallback (sem foto)
    @PostMapping(consumes = {"application/json"})
    public ResponseEntity<Cliente> criar(@RequestBody @Validated Cliente cliente){
        Cliente salvo = service.salvar(cliente);
        return ResponseEntity.status(201).body(salvo);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Cliente> atualizar(@PathVariable Long id, @RequestBody @Validated Cliente cliente){
        Cliente att = service.atualizar(id, cliente);
        return ResponseEntity.ok(att);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id){
        service.remover(id);
        return ResponseEntity.noContent().build();
    }
}
