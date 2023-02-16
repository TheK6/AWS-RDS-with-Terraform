 # TAILSCALE VPN 

#### • Criar uma chave auth
#### • Instalar o Tailscale
#### • Configurar o Subnet Router
#### • Autorizar as Subnets
#### • Configurar a ACL
#### • Testando a VPN
</br>

## Criar uma chave auth
</br>
Na sua conta TAILSCALE:</br>
Selecione <b>Settings</b> e depois <b>Keys</b>.</br>

![Settings](https://i.imgur.com/fGiAIbc.png)

![Keys](https://i.imgur.com/WtNdyxu.png)

Selecione <b>Generate auth key</b>.</br>

![Gen Key](https://i.imgur.com/ixSsaEf.png)

Na janela de criação de chave de autorização, habilite a opção: <b>Reusable</b> e **Ephemeral** </br>

![Gen Key](https://i.imgur.com/irdTABc.png)

Selecione <b>Generate key</b>.</br>

![Gen Key](https://i.imgur.com/FHwvZ5o.png)

Copie a chave criada e salve-a em algum lugar seguro.</br>

</br></br>

## Instalando o Tailscale </br>

Na maquina que você quer instalar o Tailscale, execute os comandos:</br>
```
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null</br>
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
   
sudo apt-get update && sudo apt-get install tailscale  
sudo tailscale up --auth-key="A-SUA-CHAVE-AQUI"

```
Pronto, o Tailscale deveria estar instalado.

</br></br>

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

Para que a chave não expire em até 90 dias. Volte em **Machines** e vá nas opções da maquina, e selecione **Disable key expiry**

![Key expiry](https://i.imgur.com/qwLIExx.png)

</br></br>

## Autorizar as Subnets

Vá na aba <b>Machines</b></br>
Na instância que é está fazendo o roteamento, as subnets devem aparecer abaixo do IP da instancia. (cinza claro).</br>

![Subnets](https://i.imgur.com/sATHQVf.png)

Selecione as opções da maquina: No lado direito clique em: <b>•••</b></br>

Selecione <b>Edit Route Settings</b></br>

![Route Settings](https://i.imgur.com/d9cX4Mo.png)

Clique em <b> Aprove all</b> 

![Approve Routes](https://i.imgur.com/ico6y2o.png)

Pronto. As subnets estão configuradas. Agora falta liberar pela ACL. 

</br></br>

## Configurar a ACL

Vá na aba <b>Access Controls</b></br>

![ACLs](https://i.imgur.com/to8UB7V.png)

Busque o CIDR block que a sua VPC está usando, busque a seção ***"Access Control Lists. acls:"*** </br>
Na seção <b>"src"</b> insira o CIDR block da sua VPC (e também qualquer grupo que você vai dar acesso)</br>

![src](https://i.imgur.com/Emc4AEw.png)

Na seção <b>"dst"</b> insira o CIDR block da sua VPC, depois ":" e depois um * </br>

![dst](https://i.imgur.com/mxcJcQG.png)

Clique em <b> SAVE</b> para salvar as mudanças. 

![save](https://i.imgur.com/Ik1qDLs.png)

Subnets Configuradas!

</br></br>

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

  
