Regras de Negócio (RN)
RN01 — Complexidade de senha
Tanto no cadastro quanto na redefinição, a senha criada pelo usuário deve conter no mínimo 8 caracteres, incluindo pelo menos uma letra maiúscula, um número e um caractere especial (ex: @, #, !).

RN02 — Validade do token de recuperação
O link de redefinição de senha enviado para o e-mail do usuário (somente ele tera acesso)  logo depois da senha definida ele ira voltar para a pagina de login

RN03 — Uso único do link de recuperação
Após o usuário redefinir a senha com sucesso, o link utilizado perde a validade imediatamente, não podendo ser reaproveitado.

RN04 — Unicidade de e-mail
O sistema não deve permitir a criação de mais de uma conta utilizando o mesmo endereço de e-mail. O e-mail é o identificador único de cada usuário.

RN05 — Restrição de acesso ao Dashboard
Apenas usuários autenticados com o nível de permissão "Gestor" ou "Administrador" podem visualizar a tela do dashboard, métricas de feedback e acessar os chamados dos clientes. 

RN06 — Obrigatoriedade na abertura de chamados
Para que um chamado/reclamação seja enviado com sucesso, o campo "Descrição do ocorrido" é de preenchimento obrigatório garantindo que o gestor tenha contexto suficiente para resolver o problema.

RN07 — Status inicial de chamados
Todo chamado ou reclamação enviado pelo cliente deve ser registrado no banco de dados e aparecer no dashboard do gestor com o status automático inicial de "Pendente" (ou "Em Aberto").

RN08 — Anonimato no Feedback (Opcional para o usuário)
Ao avaliar a experiência, o cliente deve ter a opção de enviar o feedback para opinar sobre o produto, com o gestor tendo acesso ao nome de quem enviou
