 # TAILSCALE VPN 

### • Criar uma chave auth
### • Instalar o Tailscale
### • Configurar o Subnet Router
### • Autorizar as Subnets
### • Configurar a ACL
### • Testando a VPN
</br>

## Criar uma chave auth
</br>
Na sua conta TAILSCALE:</br>
Selecione <b>Settings</b> e depois <b>Keys</b>.</br>
![alt text](https://github.com/TheK6/AWS-RDS-with-Terraform/blob/main/tailgatesettings.png?raw=true)

Selecione <b>Generate auth key</b>.</br>
Na janela de criação de chave de autorização, habilite a opção: <b>Reusable</b></br>
Selecione <b>Generate key</b>.</br>
Copie a chave criada e salve-a em algum lugar seguro.</br>

## Instalando o Tailscale </br>

Na maquina que você quer instalar o Tailscale, execute os comandos:</br>
```
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null</br>
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
   
sudo apt-get update && sudo apt-get install tailscale  
sudo tailscale up --auth-key="A-SUA-CHAVE-AQUI"

```
Pronto, o Tailscale deveria estar instalado.

## Configurar o Subnet Router
</br>
  
Na maquina com Tailscale instalado, execute os comandos:
```

  echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf</br>
  echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf</br>
  sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
  
```
E para configurar como Roteador das subnets:


 ```
 sudo tailscale up --advertise-routes=<insira as suas subnets aqui>
 
 ```


Pronto, agora finalizar a configuração volte na GUI do Tailscale

## Autorizar as Subnets

Vá na aba <b>Machines</b></br>
Na instância que é está fazendo o roteamento, as subnets devem aparecer abaixo do IP da instancia. (cinza claro).</br>
Selecione as opções da maquina: No lado direito clique em: <b>•••</b></br>
Selecione <b>Edit Route Settings</b></br>
Clique em <b> Aprove all</b> 

Pronto. As subnets estão configuradas. Agora falta liberar pela ACL. 


## Configurar a ACL

Vá na aba <b>Access Controls</b></br>
Busque o CIDR block que a sua VPC está usando, busque a seção "Access Control Lists. acls:" </br>
Na seção <b>"src"</b> insira o CIDR block da sua VPC (e também qualquer grupo que você vai dar acesso)</br>
Na seção <b>"dst"</b> insira o CIDR block da sua VPC, depois ":" e depois um * </br>
Clique em <b> SAVE</b> para salvar as mudanças. 

Subnets Configuradas!


## Testando a VPN

Em uma máquina que não está configurada na rede, instale o Tailscale. 

Aceite as subnets que fazem parte da VPN:

```
 sudo tailscale up --advertise-routes=<insira as suas subnets aqui>
 
 ```

E depois:

```
sudo tailscale up --accept-routes

```

Pronto. Para validar que você pode as máquinas na private subnetes:

```
Tailscale ping <private subnet machine IP>

```

Se você conectou então <b> FUNCIONOU!!!</b> 

  
