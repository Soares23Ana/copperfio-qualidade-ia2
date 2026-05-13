## CASOS DE USO (UC)

#### UC01 — Cadastrar Usuário

**Ator Principal:** Visitante

**Objetivo:** Criar uma nova conta para acessar as funcionalidades do sistema.

**Pré-condições:** O e-mail informado não deve estar cadastrado no sistema.

**Pós-condições:** Conta criada e usuário redirecionado para a tela de login.

**Fluxo Principal:**
1. O visitante acessa a opção "Cadastrar".
2. O visitante insere nome, e-mail e define uma senha.
3. O sistema valida a unicidade do e-mail.
4. O sistema valida a complexidade da senha.
5. O sistema armazena os dados e confirma o cadastro.

**Fluxos Alternativos:**
- **A1 — E-mail já cadastrado:** O sistema exibe mensagem de erro e solicita outro e-mail.
- **A2 — Senha fraca:** O sistema alerta que a senha não atende aos requisitos da complexidade.

**RF Relacionados:** RF02  
**RNF Relacionados:** RNF01, RNF03  


<img width="1536" height="1024" alt="Copilot_20260512_220052" src="https://github.com/user-attachments/assets/1bcd4df2-69df-41de-be99-9a75c112ae48" />

---

#### UC02 — Recuperar Senha

**Ator Principal:** Usuário (Cliente/Gestor)

**Objetivo:** Redefinir a senha de acesso após esquecimento.

**Pré-condições:** Usuário possuir um e-mail válido cadastrado.

**Pós-condições:** Senha alterada e link de recuperação invalidado.

**Fluxo Principal:**
1. O usuário clica em "Esqueceu a senha" e informa o e-mail.
2. O sistema envia um link único para o e-mail do usuário (válido por 24 horas).
3. O usuário acessa o link e insere a nova senha conforme as regras de complexidade.
4. O sistema valida a nova senha, atualiza o banco e invalida o link.
5. O usuário é redirecionado para a tela de login.

**Fluxos Alternativos:**
- **A1 — E-mail não encontrado:** O sistema informa que o e-mail não consta na base.
- **A2 — Link expirado ou já utilizado:** O sistema impede o acesso à tela de redefinição.

**RF Relacionados:** RF03, RF04  
**RNF Relacionados:** RNF02  



<img width="1536" height="1024" alt="Copilot_20260512_220305" src="https://github.com/user-attachments/assets/9e30c0e3-c8a8-4bd8-a859-96e9d8f6d4ae" />


---

#### UC03 — Enviar Feedback e Avaliação

**Ator Principal:** Cliente

**Objetivo:** Avaliar a experiência de uso e enviar sugestões.

**Pré-condições:** Cliente autenticado no aplicativo.

**Pós-condições:** Feedback registrado e disponível para o Gestor.

**Fluxo Principal:**
1. O cliente acessa a área de avaliação.
2. O cliente escolhe uma nota/avaliação sobre seu lote.
3. O cliente escreve o comentário com sugestões ou reclamações (máximo 2000 caracteres).
4. O cliente confirma o envio.
5. O sistema salva o feedback em tempo real no Firebase.

**RF Relacionados:** RF08  



<img width="1536" height="1024" alt="Copilot_20260512_220538" src="https://github.com/user-attachments/assets/8de69260-688d-4f3a-8bcb-2c5305a056ac" />


---

#### UC04 — Visualizar Feedbacks (Gestor)

**Ator Principal:** Gestor

**Objetivo:** Monitorar feedbacks recebidos em tempo real.

**Pré-condições:** Gestor autenticado.

**Pós-condições:** Lista de feedbacks atualizada automaticamente.

**Fluxo Principal:**
1. O gestor acessa a tela de feedbacks.
2. O sistema exibe lista de feedbacks em tempo real via Firestore.
3. O gestor filtra por status (novo, lido, em resolução, resolvido).
4. O gestor abre detalhes completos de um feedback.
5. O gestor pode alterar o status do feedback.

**RF Relacionados:** RF09, RF10, RF11  


<img width="1536" height="1024" alt="Copilot_20260512_220807" src="https://github.com/user-attachments/assets/ac2f1d4c-7f11-478e-986b-667be97148b8" />

---

#### UC05 — Visualizar Dashboard

**Ator Principal:** Gestor

**Objetivo:** Ver métricas gerenciais do sistema.

**Pré-condições:** Gestor autenticado.

**Pós-condições:** Dashboard com métricas mock exibido.

**Fluxo Principal:**
1. O gestor acessa a tela de Dashboard.
2. O sistema exibe métricas hardcoded (feedbacks, satisfação, chamados).
3. O gestor visualiza gráficos e indicadores de performance.

**RF Relacionados:** RF15  



<img width="1536" height="1024" alt="Copilot_20260512_221000" src="https://github.com/user-attachments/assets/16fed8bd-ef5c-4e1d-bcbe-5a8d9031d1dd" />

---

#### UC06 — Formulário de Chamados

**Ator Principal:** Cliente

**Objetivo:** Visualizar e preencher formulário de criação de chamado.

**Pré-condições:** Cliente autenticado.

**Pós-condições:** Formulário exibido (dados não salvos no Firebase).

**Fluxo Principal:**
1. O cliente acessa a central de atendimento.
2. O cliente preenche lote, descrição, categoria e evidências.
3. O cliente confirma envio.
4. O sistema exibe confirmação mock (não salva dados).

**Fluxos Alternativos:**
- **A1 — Descrição vazia:** O sistema impede envio e alerta obrigatoriedade.

**RF Relacionados:** RF16  



<img width="1536" height="1024" alt="Copilot_20260512_221123" src="https://github.com/user-attachments/assets/f1ff10d8-c888-4df3-b1ef-7a7817f194fd" />


---

