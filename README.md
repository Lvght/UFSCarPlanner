# UFSCar App

**ESTE PROJETO NÃO POSSUI QUALQUER VÍNCULO COM A UNIVERSIDADE**.

Este app se propõe a substituir o antigo UFSCar Planner, que deixou de funcionar recentemente. O aplicativo atualmente ofere os seguintes recursos:

- Visualização da agenda acadêmica, (incluindo horários, salas etc.) após login no SIGA.
- Cardápio do RU.
- Notícias coletadas do [site de notícias da UFSCar](https://www2.ufscar.br/noticias).

# Sistema de login
O login funciona **através de um WebView**. Um navegador (oculto para o usuário) é acionado programaticamente e navega por entre as páginas do SIGA extraindo as informações necessárias através do HTML da página. A rota traçada pelo App é a mesma que um usuário faria em seu navegador para consultar a tabela de matérias e então fazer logout. O WebView usa Javascript para navegar entre as páginas.

# Informações coletadas
O aplicativo coletará as seguintes informações do usuário caso este opte por fazer login:

- Nome completo
- IRA
- Lista de matérias cursadas

Os dados são salvos localmente em um arquivo.

# Possíveis problemas
Um pergunta é: **o que aconteceria se o usuário fizesse login durante o período de confirmação de matrícula?** No estado atual do projeto, ainda está pendente uma verificação quanto a esta questão. A mesma pergunta se aplica caso o SIGA faça alguma notificação importante ao aluno.

# Cardápio do RU
Em razão da pandêmia de Covid-19, o RU não está disponibilizando o seu cardápio como de costume.

# Autores

- Matheus Ramos de Carvalho, BCC 019
- Vinicius Quaresma da Luz, BCC 019
