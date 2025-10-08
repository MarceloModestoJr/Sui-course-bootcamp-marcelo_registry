# Marcelo Registry

Um registro global de projetos desenvolvido em Move para a blockchain **Sui**.

## 📖 Descrição
Este módulo permite que qualquer usuário:
- registre um novo projeto (título + link);
- atualize seu próprio projeto;
- liste todos os projetos registrados.

Cada registro é gravado on-chain com:
- ID incremental global;
- endereço do criador (owner);
- campos de título e link;
- timestamps de criação e atualização.

## ⚙️ Funções principais

### `init_registry(ctx: &mut TxContext)`
Inicializa o registro global (deve ser feito uma única vez).

### `register_project(title: String, link: String, clock: &Clock, ctx: &mut TxContext)`
Registra um novo projeto globalmente. Emite o evento `ProjectRegistered`.

### `update_project(project_id: u64, new_title: String, new_link: String, clock: &Clock, ctx: &mut TxContext)`
Permite ao dono do projeto atualizar título e link. Emite o evento `ProjectUpdated`.

### `list_projects()`
Retorna todos os projetos registrados.
