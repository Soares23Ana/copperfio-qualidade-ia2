# Requisitos Não funcionais (ENF)

### RNF01 — Tempo de resposta
As telas principais (como login, carregamento do catálogo e dashboard) devem responder e carregar em até 2 segundos.


### RNF02 — Disponibilidade
O sistema deve possuir alta estabilidade, estando disponível e operante 99,5% do tempo mensal.


### RNF03 — Segurança de dados
As senhas de todos os usuários devem ser armazenadas no banco de dados utilizando algoritmos de hashing fortes (como bcrypt ou Argon2).


### RNF04 — Desempenho de envio de e-mails
O envio do e-mail para recuperação de senha deve ser disparado pelo sistema em, no máximo, 1 minuto após a solicitação do usuário.


### RNF05 — Compatibilidade e Responsividade
O aplicativo deve funcionar perfeitamente e ter sua interface adaptada para os sistemas operacionais Android e iOS.


### RNF06 — Usabilidade (Acessibilidade da central)
O caminho para abrir um chamado ou enviar um feedback não deve exigir mais do que 3 cliques a partir da tela inicial do usuário, garantindo uma boa experiência.
