---

## UC01 — Cadastrar Usuário
### Ator Principal: 
Visitante

### Objetivo: 
Criar uma nova conta para acessar as funcionalidades do sistema.

### Pré-condições: 
- O e-mail informado não deve estar cadastrado no sistema.

### Pós-condições: 
- Conta criada e usuário redirecionado para a tela de login.

### Fluxo Principal:

1. O visitante acessa a opção "Cadastrar".
2. O visitante insere nome, e-mail e define uma senha.
3. O sistema valida a unicidade do e-mail (RN04).
4. O sistema valida a complexidade da senha (RN01).
5. O sistema armazena os dados com hash de segurança e confirma o cadastro.

### Fluxos Alternativos:

-**A1 — E-mail já cadastrado:**
- O sistema exibe mensagem de erro e solicita outro e-mail.

-**A2 — Senha fraca:**
- O sistema alerta que a senha não atende aos requisitos da RN01.

### RF Relacionados: 
RF02

### RNF Relacionados: 
RNF03, RNF05

### RN Relacionadas: 
RN01, RN04

## UC02 — Recuperar Senha
### Ator Principal: 
Usuário (Cliente/Gestor)

### Objetivo: 
Redefinir a senha de acesso após esquecimento.

### Pré-condições: 
- Usuário possuir um e-mail válido cadastrado.

### Pós-condições: 
- Senha alterada e link de recuperação invalidado.

### Fluxo Principal:

1.O usuário clica em "Esqueceu a senha" e informa o e-mail.
2.O sistema envia um link único para o e-mail do usuário (RN02).
3.O usuário acessa o link e insere a nova senha conforme as regras de complexidade.
4.O sistema valida a nova senha, atualiza o banco e invalida o link (RN03).
5.O usuário é redirecionado para a tela de login.

### Fluxos Alternativos:

-**A1 — E-mail não encontrado:**
- O sistema informa que o e-mail não consta na base.

-**A2 — Link expirado ou já utilizado:**
- O sistema impede o acesso à tela de redefinição.

### RF Relacionados: 
RF03, RF04

### RNF Relacionados: 
RNF04

### RN Relacionadas:
RN01, RN02, RN03


## UC03 — Enviar Feedback e Avaliação
### Ator Principal: 
Cliente

### Objetivo: 
Avaliar a experiência de uso e enviar sugestões.

### Pré-condições: 
- Cliente autenticado no aplicativo.

### Pós-condições: 
- Feedback registrado e disponível para o Gestor.

### Fluxo Principal:

1. O cliente acessa a área de avaliação (máximo 3 cliques - RNF06).
2. O cliente escolhe uma nota/avaliação.
3. O cliente decide se deseja enviar de forma anônima ou identificada (RN08).
4. O cliente escreve o comentário e confirma o envio.

### RF Relacionados: 
RF05

### RNF Relacionados: 
RNF06

### RN Relacionadas: 
RN08

## UC04 — Abrir Chamado / Reclamação
### Ator Principal: 
Cliente

### Objetivo: 
Registrar um problema técnico ou reclamação detalhada.

### Pré-condições: 
- Cliente autenticado no aplicativo.

### Pós-condições: 
-Chamado registrado com status "Pendente" (RN07).

### Fluxo Principal:

1. O cliente acessa a central de atendimento.
2. O cliente preenche obrigatoriamente a "Descrição do ocorrido" (RN06).
3. O sistema registra o chamado com data, hora e status inicial.
4. O sistema gera um protocolo de confirmação.

### Fluxos Alternativos:

-**A1 — Descrição vazia:**
- O sistema impede o envio e alerta sobre a obrigatoriedade do campo (RN06).

### RF Relacionados: 
RF06

### RNF Relacionados: 
RNF06

### RN Relacionadas: 
RN06, RN07

---
### UC05 — Consultar Catálogo e Fichas Técnicas
Ator Principal: Usuário (Qualquer perfil)

### Objetivo: 
Visualizar detalhes dos produtos ou serviços oferecidos.

### Pré-condições:
- Nenhuma (ou autenticado, dependendo da regra de negócio).

### Pós-condições: 
- Informações técnicas exibidas na tela.

### Fluxo Principal:

1. O usuário acessa o menu de Catálogo.
2. O sistema lista os itens disponíveis.
3. O usuário seleciona um item específico.
4. O sistema carrega a ficha técnica detalhada em até 2 segundos (RNF01).

### RF Relacionados: 
RF07

### RNF Relacionados: 
RNF01

---

## UC06 — Gerenciar Dashboard e Chamados
### Ator Principal: 
Gestor / Administrador

### Objetivo: 
Monitorar métricas, feedbacks e gerir as demandas dos clientes.

### Pré-condições: 
- Usuário autenticado com perfil "Gestor" ou "Administrador" (RN05).

### Pós-condições: 
- Visualização atualizada das métricas e status dos chamados.

### Fluxo Principal:

1. O gestor acessa a tela de Dashboard.
2. O sistema exibe métricas de feedback e lista de chamados pendentes.
3. O gestor visualiza os detalhes dos chamados e feedbacks (identificados ou anônimos).
4. O gestor pode alterar o status de um chamado ou publicar avisos no Mural.

### Fluxos Alternativos:

-** A1 — Usuário comum tenta acessar:**
- O sistema bloqueia o acesso e exibe erro de permissão (RN05).

### RF Relacionados: 
RF08, RF09, RF10

### RNF Relacionados: 
RNF01

### RN Relacionadas: 
RN05, RN07, RN08
