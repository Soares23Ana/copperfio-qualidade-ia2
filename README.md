# 🚀 Sistema de Qualidade e Vendas - Copperfio

Este repositório contém o código-fonte e a documentação da ferramenta interna da equipe de Qualidade e Vendas da Copperfio. O sistema utiliza Inteligência Artificial para análise de sentimento, predição de risco de perda de clientes (Churn) e auditoria visual.

## 📌 Funcionalidades Principais

* **IA de Análise de Sentimento Multimodal (NLP):** Processa feedbacks em texto e áudio para identificar frustrações sutis.
* **IA Preditiva (Alerta de Churn):** Analisa o histórico de notas do cliente. Quedas bruscas na satisfação disparam alertas em tempo real no app do gestor.
* **Visão Computacional e OCR:** Validação de autenticidade através da leitura da etiqueta do lote/produto e detecção de avarias na embalagem pela câmera.
* **Auditoria e Segurança:** Geração de QR Codes únicos e validação de assinaturas digitais, tornando o fluxo 100% rastreável.

## 🔄 Fluxo do Usuário

1. **E-mail:** O cliente recebe um link único com QR Code/Assinatura digital.
2. **Web App (Cliente):** Abre o link no celular para responder a pesquisa (texto, áudio e foto do produto).
3. **Módulo de IA (Backend):** Processa o sentimento, extrai dados da imagem (OCR) e cruza o histórico de notas.
4. **Mobile App (Gestor):** Recebe o diagnóstico da IA. Se houver risco, um "Alerta Vermelho" em tempo real notifica a gestão.

## 📂 Estrutura do Projeto

* `/docs`: Documentação de arquitetura, fluxos e especificações de API.
* `/design`: Protótipos de tela (App Cliente, App Gestor) e templates de e-mail.
* `/src/backend`: API principal e microsserviços de IA (NLP, Visão Computacional, Predição).
* `/src/web_cliente`: Interface web responsiva para o cliente (coleta de dados).
* `/src/mobile_gestor`: Aplicativo nativo para o gestor (Dashboard e Alertas).
* `/tests`: Testes automatizados de IA, backend e interfaces.
