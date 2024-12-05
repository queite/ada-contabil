# Aplicação de serviços AWS com Terraform

Este projeto cria um fluxo de trabalho para geração de um arquivo, seu armazenamento no S3 e salvamento de algumas de suas informações em banco.
Para mais detalher veja a [descrição detalhada]](Chalenge.md)

# Fluxo da Solução
- Gera um arquivo
- Envio do arquivo para um bucket do S3
- Criação de objetos no S3 ativam uma função lambda
- Função lambda envia notificação ao SNS
- SNS envia mensagem para uma fila SQS
- SQS ativa lambda que grava dados no RDS

# Ferramentas
- Terraform
- Python
- Boto3
- Lambda
- RDS
- S3
- SNS
- SQS

## Como rodar
Clone o repositório:
```
git clone git@github.com:queite/ada-contabil.git
```
Instalação:
- Na raiz do projeto digite:
```
pip install -r requirements.txt
```
AWS configure:
- Certifique-se de estar conectado a AWS com as credencias corretas.
- Para conectar use i CLI da AWS e rode:
```
aws configure
```
Entre na pasta do terraform:
```
cd enviroment/dev
```
Execute o terraform
```
terraform init
terraform apply
```
Após conclusão crie o .env:
- Para isso acesse a pasta utils e rode o comando abaixo no terminal
```
python update_env.py
```
*Isso criará o arquivo de variáveis de ambiente*<br>

Rode o script na raiz do projeto
```
python create_file.py
```
