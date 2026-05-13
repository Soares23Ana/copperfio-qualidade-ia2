## REQUISITOS FUNCIONAIS (RF)

#### RF01 — Login
Permitir o acesso do usuário à sua conta através da autenticação via e-mail e senha.

#### RF02 — Cadastro de usuário
Permitir que novos usuários se cadastrem no aplicativo inserindo seus dados básicos e criando credenciais de acesso (email e senha mínima de 8 caracteres).

#### RF03 — Solicitação de recuperação de senha
Disponibilizar a opção "Esqueceu a senha", permitindo que o usuário informe seu e-mail para receber um link de recuperação válido por 24 horas.

#### RF04 — Redefinição de senha
Permitir que o usuário acesse um link seguro recebido por e-mail para criar e salvar uma nova senha de acesso.

#### RF05 — Detecção de papel do usuário
O sistema deve identificar se o usuário é cliente ou gestor e direcioná-lo para a interface apropriada após autenticação.

#### RF06 — Promoção para gestor
Permitir que um administrador promova um usuário para o papel de gestor através de validação de email corporativo.

#### RF07 — Logout
Permitir que o usuário se desconecte com segurança, limpando sessão e cache local.

#### RF08 — Envio de feedback e avaliação
Permitir que o cliente avalie sua experiência e envie comentários detalhados sobre um lote/batch específico com sugestões ou reclamações.

#### RF09 — Visualização de feedbacks (Gestor)
Permitir que o gestor visualize todos os feedbacks recebidos em tempo real, com filtros por status (todos, críticos, elogios e operacional) e ordenação por data.

#### RF10 — Detalhes do feedback
Permitir que o gestor abra e visualize detalhes completos de um feedback (mensagem, autor, email, lote relacionado, data/hora, anexos).

#### RF11 — Mudança de status de feedback
Permitir que o gestor altere o status de um feedback entre os estados válidos (novo → lido → em resolução → resolvido) com registro de histórico.

#### RF12 — Visualizar perfil
Permitir que o usuário visualize suas informações de perfil (nome, email, tipo de usuário, data de cadastro, foto).

#### RF13 — Editar perfil
Permitir que o usuário atualize informações do perfil (nome mínimo 3 caracteres, foto máximo 5MB) sem alterar email.

#### RF14 — Trocar tema (Claro/Escuro)
Permitir que o usuário escolha o tema da aplicação (claro ou escuro) com preferência salva em SharedPreferences e aplicada globalmente.

#### RF15 — Visualizar dashboard (Gestor)
Fornecer um painel de controle com métricas (dados mock/hardcoded): total de feedbacks, média de satisfação, chamados por status, tempo médio de resolução e gráficos de tendência.

#### RF16 — Formulário de chamados
Permitir que o cliente visualize formulário de criação de chamado com campos para lote, descrição, categoria e evidências (formulário não salva dados).

