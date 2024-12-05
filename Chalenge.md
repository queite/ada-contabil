<h1> Cenário </h1>

A Ada Contabilidade enfrenta um desafio operacional diário: os contadores precisam enviar arquivos manualmente para armazenamento e, em seguida, registrar no banco de dados a quantidade de linhas contidas nesses arquivos. Esse processo manual é ineficiente e propenso a erros.

Crie uma solução que automatize a arquitetura em todo o seu fluxo, se baseando em práticas DevOps para simplificar o fluxo de trabalho e garantir a confiabilidade do processo.

<h1>Requisitos: </h1>

- Código com a aplicação que envia os arquivos para o s3 (Linguagem de sua preferência)

- Código da arquitetura usando boto3 ou terraform para subir os recursos;

- Os códigos precisam estar no GitHub, usando as boas práticas já estudadas;

- A aplicação precisa gerar um arquivo de texto com um número aleatório de linhas;

- Esse arquivo precisa ser enviado para um s3 de forma automatizada;

- Usar S3, SNS, SQS e Lambda obrigatoriamente;

- No banco de dados é obrigatório que seja gravado o nome do arquivo e o número de linhas contido.