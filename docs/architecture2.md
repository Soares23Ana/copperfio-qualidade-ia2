# Arquitetura do Sistema e Microsserviços de IA

Este documento descreve a topologia do sistema de Qualidade e Vendas da Copperfio. O sistema é dividido em três camadas principais: Front-end (Interfaces), Back-end (Core API) e os Serviços de IA.

## 1. Interfaces (Front-end)
* **Web Cliente:** Aplicação leve em HTML5/JS (React ou Next.js) acedida via link único de e-mail. Tem acesso à API do navegador para capturar áudio (WebRTC) e fotos (Câmera).
* **Mobile Gestor:** Aplicação nativa para iOS/Android. Conecta-se via WebSockets para receber *Push Notifications* (Alertas Vermelhos) em tempo real.

## 2. API Principal (Back-end Core)
Desenvolvida em Node.js ou Python (FastAPI). É responsável por:
* Validar a autenticidade do link (QR Code / Assinatura Digital).
* Receber o *payload* do cliente (Texto, Áudio, Foto).
* Orquestrar as chamadas para os microsserviços de IA.
* Guardar o resultado de forma rastreável e auditável na base de dados.

## 3. Microsserviços de IA (Processamento Descentralizado)
Para garantir performance, cada IA atua como um serviço independente:

### A. Módulo de Sentimento (NLP & Speech-to-Text)
* **Entrada:** Texto livre ou ficheiro de áudio.
* **Processamento:** Transcreve o áudio para texto. De seguida, o modelo de NLP analisa o tom (ex: sarcasmo, frustração subtil) que não é refletido numa nota numérica.
* **Saída:** *Score* de sentimento (0.0 a 1.0) e *tags* de emoção.

### B. Módulo de Visão Computacional (OCR & Qualidade)
* **Entrada:** Fotografia tirada pelo cliente.
* **Processamento:** Extrai o número de série da etiqueta (OCR) e utiliza um modelo treinado para detetar anomalias (ex: caixas amassadas, fios danificados).
* **Saída:** Lote identificado e status de integridade visual (Passou/Falhou).

### C. Módulo Preditivo (Risco de Churn)
* **Entrada:** Nota atual + Score de Sentimento + Histórico do Cliente.
* **Processamento:** Modelo de *Machine Learning* compara a variação do padrão (ex: Cliente que dava 10, deu 7 e o NLP detetou frustração).
* **Saída:** Sinalizador de Risco (Verde, Amarelo, Vermelho). Se Vermelho, dispara o Webhook para o App do Gestor.
