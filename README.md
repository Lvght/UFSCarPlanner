# UFSCar App

Este app se propõe a substituir o antigo UFSCar Planner, que deixou de funcionar recentemente. O aplicativo atualmente ofere os seguintes recursos:

- Visualização da agenda acadêmica, (incluindo horários, salas etc.) após login no SIGA.
- Cardápio do RU.
- Notícias coletadas do [site de notícias da UFSCar](https://www2.ufscar.br/noticias).

# Sistema de login
O login funciona **através de um WebView**. Um navegador (oculto para o usuário) é acionado programaticamente e navega por entre as páginas do SIGA extraindo as informações necessárias através do HTML da página. A rota traçada pelo App é a mesma que um usuário faria para consultar a tabela de matérias e então fazer logout. Esta rota pode ser consultada no código-fonte. O WebView usa Javascript para navegar entre as páginas.

## Possíveis problemas
Um pergunta é: o que aconteceria se o usuário fizesse login durante o período de confirmação de matrícula? No estado atual do projeto, ainda está pendente uma verificação quanto a esta questão. A mesma pergunta se aplica caso o SIGA faça alguma notificação importante ao aluno.

# Cardápio do RU
Em razão da pandêmia de Covid-19, o RU não está disponibilizando o seu cardápio como de costume.

# Problemas conhecidos

- Login nem sempre funciona.
- Tela branca ao abrir o app.
  - Isto é corrigido indo para outra aba. Isto deve ser corrigido em breve.
- Login às cegas.
  - O usuário precisa esperar uma quantidade muito grande de tempo para acessar o SIGA. Seria mais confortável se o progresso do login fosse exibido visualmente. Também não há qualquer indicação quando a senha está incorreta.
- Crashamento do WebView
  - O tratamento de erros do WebView precisa ser melhorado. Por vezes, ele não responde de maneira adequada.


# Autores

- Matheus Ramos de Carvalho, BCC 019
- Vinicius Quaresma da Luz, BCC 019
