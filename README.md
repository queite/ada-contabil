<h1> Cenário </h1>

A Ada Contabilidade enfrenta um desafio operacional diário: os contadores precisam enviar arquivos manualmente para armazenamento e, em seguida, registrar no banco de dados a quantidade de linhas contidas nesses arquivos. Esse processo manual é ineficiente e propenso a erros.

Crie uma solução que automatize a arquitetura em todo o seu fluxo, se baseando em práticas DevOps para simplificar o fluxo de trabalho e garantir a confiabilidade do processo.

 <h1> Prazo </h1>

Serão aceitos os projetos enviados até o dia 09/12;

Os projetos devem ser entregues via e-mail: **thayse.frankenberger@gmail.com**

O título do e-mail deve ser seu nome completo;

No e-mail precisa estar disponível o link do seu repositório e o link que está disponível seu vídeo.

<h1>Requisitos: </h1>

- Código com a aplicação que envia os arquivos para o s3 (Linguagem de sua preferência)

- Código da arquitetura usando boto3 ou terraform para subir os recursos;

- Os códigos precisam estar no GitHub, usando as boas práticas já estudadas;

- A aplicação precisa gerar um arquivo de texto com um número aleatório de linhas;

- Esse arquivo precisa ser enviado para um s3 de forma automatizada;

- Usar S3, SNS, SQS, Lambda e Elasticache obrigatoriamente;

- No banco de dados é obrigatório que seja gravado o nome do arquivo e o número de linhas contido;

- Gravar um vídeo de até 5 minutos explicando a arquitetura e justificando suas escolhas.

 <h1> Opcional: </h1>

- Como você implementaria o monitoramento desse fluxo? Quais são os pontos criticos? Registre sua resposta na documentação do seu repositório no GitHub em uma seção de “Estratégia de monitoramento”.

<h1> Estratégia de monitoramento </h1>

Para implementar o monitoramento desse fluxo, é importante considerar os seguintes pontos críticos:

1. **Falhas no upload para o S3**: Monitorar se os arquivos estão sendo enviados corretamente para o S3. Isso pode ser feito utilizando logs e métricas do AWS CloudWatch.

2. **Processamento de mensagens no SQS**: Verificar se as mensagens estão sendo processadas corretamente e dentro do tempo esperado. Utilizar métricas do SQS e configurar alarmes no CloudWatch para detectar atrasos ou falhas.

3. **Execução das funções Lambda**: Monitorar a execução das funções Lambda, verificando se estão sendo executadas corretamente e dentro do tempo esperado. Utilizar logs e métricas do CloudWatch para isso.

4. **Disponibilidade do Elasticache**: Verificar se o Elasticache está disponível e funcionando corretamente. Utilizar métricas do CloudWatch e configurar alarmes para detectar problemas de disponibilidade.

5. **Banco de dados**: Monitorar a inserção de dados no banco de dados, verificando se os registros estão sendo inseridos corretamente e dentro do tempo esperado. Utilizar logs e métricas do banco de dados para isso.

6. **Alertas e notificações**: Configurar alertas e notificações para os pontos críticos mencionados acima, utilizando o AWS SNS para enviar notificações em caso de falhas ou problemas de desempenho.

Com essa estratégia de monitoramento, é possível garantir a confiabilidade e a eficiência do fluxo automatizado, detectando e corrigindo problemas de forma proativa.
