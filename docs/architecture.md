# Arquitetura do Sistema Copperfio

Este documento descreve a arquitetura do aplicativo Flutter para o sistema de qualidade Copperfio.

## Camadas do sistema

### 1. Apresentação (Front-end)
- Aplicativo Flutter mobile.
- Estrutura em `lib/features/` por módulos:
  - `auth/` — telas de login, cadastro, recuperação de senha.
  - `home/` — telas iniciais de cliente e gestor.
  - `chamados/` — criação, lista e detalhes de chamados.
  - `dashboard/` — painéis, gráficos e alertas para gestor.
  - `chat/` — conversas e histórico de mensagens.
  - `profile/` — perfil e informações do usuário.
- UI responsiva e tema claro/escuro usando `provider`.

### 2. Dados e serviços
- `lib/data/` contém modelos e repositórios de dados.
- `lib/services/` contém integração com Firebase:
  - `AuthService` para autenticação de usuários.
  - `FirestoreService` para leitura e gravação de feedbacks, chamados e contagens.
  - `NotificationService` para notificações locais.
- `lib/core/` contém provedores de estado e tema.

### 3. Backend
- O backend é o Firebase:
  - `Firebase Auth` para login, cadastro e recuperação de senha.
  - `Cloud Firestore` para persistência de dados em tempo real.
  - `Firebase Storage` para upload de imagens de feedback.
- O app usa `firebase_options.dart` para configuração das plataformas.

## Fluxo principal
1. O usuário abre o app e vê a `SplashIntroPage`.
2. O app inicializa o Firebase e notificação.
3. O usuário faz login ou cadastro.
4. Conforme o tipo de usuário:
   - cliente acessa catálogo, feedback, chat e chamados;
   - gestor acessa dashboard, alertas, feedbacks e gestão de chamados.

## Tecnologias
- Flutter
- Provider
- Firebase Auth
- Cloud Firestore
- Firebase Storage
- Flutter Local Notifications
- fl_chart
- shared_preferences
