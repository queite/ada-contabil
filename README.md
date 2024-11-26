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

# Fluxo da Solução
Gerar Arquivo de Texto: Uma aplicação gera um arquivo de texto com um número aleatório de linhas e o envia para um bucket do S3.

Notificar Via SNS: Ao enviar o arquivo para o S3, uma notificação é enviada para um tópico do SNS.

Processamento com SQS e Lambda: Um Lambda é acionado por uma fila do SQS que está inscrita no tópico SNS. O Lambda processa a mensagem, verifica o arquivo no S3 e grava as informações no ElastiCache.

## Como rodar
Clone
Instalação
AWS configure
Variáveis env
Script recursos
Script create_file.py
