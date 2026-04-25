const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();

sgMail.setApiKey(process.env.SENDGRID_API_KEY);

exports.sendPasswordRecoveryCode = functions.https.onCall(async (data, context) => {
  try {
    const { email } = data;

    if (!email) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Email é obrigatório'
      );
    }

    const normalizedEmail = email.toLowerCase().trim();

    // Verifica se o usuário existe no Firestore
    const querySnapshot = await admin
      .firestore()
      .collection('users')
      .where('email', '==', normalizedEmail)
      .limit(1)
      .get();

    if (querySnapshot.empty) {
      // Busca alternativa com email_lower
      const querySnapshot2 = await admin
        .firestore()
        .collection('users')
        .where('email_lower', '==', normalizedEmail)
        .limit(1)
        .get();

      if (querySnapshot2.empty) {
        throw new functions.https.HttpsError(
          'not-found',
          'Usuário não encontrado'
        );
      }
    }

    // Gera código de 5 dígitos
    const verificationCode = Math.floor(Math.random() * 100000)
      .toString()
      .padStart(5, '0');

    // Salva o código no Firestore com timestamp
    await admin.firestore().collection('password_recovery').add({
      email: normalizedEmail,
      code: verificationCode,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      expiresAt: admin.firestore.Timestamp.fromDate(
        new Date(Date.now() + 60 * 60 * 1000) // 1 hora
      ),
      used: false
    });

    // Prepara e envia o email via SendGrid
    const msg = {
      to: normalizedEmail,
      from: process.env.SENDGRID_FROM_EMAIL || 'noreply@copperfio.com.br',
      subject: 'Copperfio - Código de Recuperação de Senha',
      html: `
        <!DOCTYPE html>
        <html>
          <head>
            <meta charset="utf-8">
            <style>
              body { font-family: Arial, sans-serif; background-color: #f5f5f5; }
              .container { max-width: 600px; margin: 0 auto; background-color: #fff; padding: 20px; border-radius: 8px; }
              .header { background-color: #9C1818; color: white; padding: 20px; text-align: center; border-radius: 8px 8px 0 0; }
              .header h1 { margin: 0; font-size: 24px; }
              .content { padding: 30px 20px; }
              .code-box { background-color: #f0f0f0; border: 2px solid #9C1818; padding: 20px; text-align: center; border-radius: 8px; margin: 20px 0; }
              .code-box .code { font-size: 32px; font-weight: bold; color: #9C1818; letter-spacing: 5px; }
              .footer { background-color: #f5f5f5; padding: 20px; text-align: center; font-size: 12px; color: #666; }
            </style>
          </head>
          <body>
            <div class="container">
              <div class="header">
                <h1>🔐 Recuperação de Senha</h1>
              </div>
              <div class="content">
                <p>Olá,</p>
                <p>Você solicitou um código para recuperar sua senha na plataforma Copperfio.</p>
                <p>Use o código abaixo para recuperar o acesso à sua conta:</p>
                <div class="code-box">
                  <div class="code">${verificationCode}</div>
                </div>
                <p><strong>⏱️ Este código expira em 1 hora.</strong></p>
                <p>Se você não solicitou este código, ignore este email.</p>
                <hr>
                <p><strong>Dúvidas?</strong></p>
                <p>Entre em contato conosco: suporte@copperfio.com.br</p>
              </div>
              <div class="footer">
                <p>Copperfio - Fios e Cabos de Alumínio</p>
                <p>&copy; 2026 Todos os direitos reservados</p>
              </div>
            </div>
          </body>
        </html>
      `
    };

    await sgMail.send(msg);

    return {
      success: true,
      message: 'Código de recuperação enviado com sucesso',
      codeSent: true
    };
  } catch (error) {
    console.error('Erro ao enviar código de recuperação:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message || 'Erro ao enviar email'
    );
  }
});

exports.validatePasswordRecoveryCode = functions.https.onCall(async (data, context) => {
  try {
    const { email, code } = data;

    if (!email || !code) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Email e código são obrigatórios'
      );
    }

    const normalizedEmail = email.toLowerCase().trim();

    // Busca o código mais recente e válido
    const querySnapshot = await admin
      .firestore()
      .collection('password_recovery')
      .where('email', '==', normalizedEmail)
      .where('code', '==', code)
      .where('used', '==', false)
      .orderBy('createdAt', 'desc')
      .limit(1)
      .get();

    if (querySnapshot.empty) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Código inválido ou expirado'
      );
    }

    const docData = querySnapshot.docs[0];

    // Verifica se expirou
    if (docData.data().expiresAt.toDate() < new Date()) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Código expirado'
      );
    }

    // Marca como usado
    await docData.ref.update({ used: true });

    return {
      success: true,
      message: 'Código validado com sucesso'
    };
  } catch (error) {
    console.error('Erro ao validar código:', error);
    throw new functions.https.HttpsError(
      'internal',
      error.message || 'Erro ao validar código'
    );
  }
});
