# CRUD-Flutter

## Introdução
O projeto Mobile2 consiste no desenvolvimento de um aplicativo
mobile utilizando o framework Flutter, com o objetivo de demonstrar
na prática conceitos fundamentais de desenvolvimento de interfaces,
organização modular, consumo de APIs e boas práticas de programação.

## Objetivo do Projeto
O objetivo principal é implementar um aplicativo funcional que: -
Utilize Flutter/Dart como base tecnológica; - Aplique conceitos de
componentização e navegação; - Consuma dados através de um serviço de
API; - Siga uma estrutura clara e organizada.


## Funcionalidades
-   Tela Inicial
-   Módulo de Clientes (listagem + cadastro)
-   Módulo de Produtos (listagem + cadastro)
-   Serviço de API centralizado
-   Widgets reutilizáveis

##  Arquitetura do mobile

```
├── frontend/
│   └── lib/
│       ├── models/
│       │   ├── cliente.dart
│       │   └── produto.dart
│       │
│       ├── screens/
│       │   ├── clientes/
│       │   │   ├── cliente_form_screen.dart
│       │   │   └── cliente_list_screen.dart
│       │   │
│       │   ├── produtos/
│       │   │   ├── produto_form_screen.dart
│       │   │   └── produto_list_screen.dart
│       │   │
│       │   └── home_screen.dart
│       │
│       ├── services/
│       │   └── api_service.dart
│       │
│       ├── widgets/
│       │    └── app_header.dart
│       │
│       ├── main.dart
│       └── .env
│
└── pubspec.yaml
```

## Tecnologias
-   Flutter 3.x
-   Dart
-   Material Design

## Execução

### 1. Backend (Spring Boot)
- Acesse a pasta do backend:
  ```bash
  cd CRUD-Flutter/backend
  ```
- Execute o projeto:
  ```bash
  mvn spring-boot:run
  ```
- Após o backend estar rodando, execute o script SQL localizado em:
  ```
  CRUD-Flutter/backend/src/main/resources/data.sql
  ```

---

### 2. Frontend (Flutter)
- Acesse a pasta do frontend:
  ```bash
  cd CRUD-Flutter/frontend
  ```
- Instale as dependências:
  ```bash
  flutter pub get
  ```
- Execute o aplicativo:
  ```bash
  flutter run
  ```

---

**Importante:**  
- O backend deve estar rodando antes de iniciar o frontend.  
- O script `data.sql` deve ser executado para popular o banco de dados.  

## Considerações Finais
O projeto cumpre seu papel acadêmico ao demonstrar conceitos essenciais
do desenvolvimento mobile moderno.
