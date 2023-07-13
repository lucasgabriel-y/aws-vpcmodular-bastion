# Terraform AWS


## Descrição
Este projeto construído em Terraform provisiona uma infraestrutura na AWS para comunicação privada entre duas VPCs, utilizando um Transit Gateway. Além disso, o projeto inclui recursos como um Bastion Host, uma instância EC2 escalonada por um Auto Scaling Group (ASG), um ELB protegido por um WAF, instâncias EC2 em uma subnet privada, um NAT Gateway para roteamento de tráfego de saída e notificações via SNS.

### Recursos provisionados:

**Transit Gateway**: Duas VPCs são associadas a um Transit Gateway para permitir comunicação privada entre elas. O Transit Gateway atua como um ponto centralizado para o tráfego entre as VPCs, simplificando a conectividade e reduzindo a complexidade da rede.

**Bastion Host**: Implantação de um Bastion Host na primeira VPC, localizada em uma subnet pública e acessível via SSH. O Bastion Host permite acesso seguro às instâncias EC2 na segunda VPC.

**NAT Gateway**: Um NAT Gateway está implantado em uma subnet pública para rotear o tráfego de saída das instâncias EC2 para a internet.

**VPCs**: Duas VPCs estão associadas ao Transit Gateway para comunicação privada entre elas.

**Subnets**: As instâncias EC2 das segunda VPC estão em subnets privadas para maior segurança localizadas em zonas de disponibilidade distintas.

**EC2**: Uma instância EC2 escalonada por um Auto Scaling Group (ASG) na segunda VPC. O ASG notifica via SNS quando ocorre escalonamento ou desligamento de instâncias.

**ELB**: O ASG está localizado atrás de um ELB (Elastic Load Balancer) para distribuir o tráfego de entrada entre as instâncias EC2. O ELB é protegido por um WAF que limita o acesso à rede por IPs.

**SNS**: O sistema notifica via SNS (Simple Notification Service) sempre que ocorrer um escalonamento ou desligamento de instâncias EC2.

**WAF**: O ELB é protegido por um WAF (Web Application Firewall) que faz a limitação do acesso à rede por IPs. O WAF é configurado para filtrar e bloquear tráfego malicioso ou indesejado, garantindo a segurança da aplicação.

### Utilização:
* Execute o comando **terraform init** para inicializar o Terraform;
* Execute o comando **terraform plan** para visualizar as mudanças propostas pela configuração do Terraform;
* Execute o comando **terraform apply** para criar a infraestrutura na AWS.

### Próximos passos:
* Adiconar um bucket S3 para o armazenamento do conteúdo estático
* Criar o recurso de VPN para prover mais segurança no acesso entre o Engenheiro DevOps e o Bastion Host 

![AWS](https://i.ibb.co/446h5jy/aws-vpcmodular-bastion-drawio-3.png)
