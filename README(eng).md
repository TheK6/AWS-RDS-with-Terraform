 # TAILSCALE VPN 

#### • Creating an Auth Key
#### • Installing Tailscale
#### • Configuring as Subnet Router
#### • Approve the Subnets
#### • Configuring the ACL
#### • Testing the VPN
</br>

## Creating an Auth Key
</br>
In your TAILSCALE account: </br></br>
Select <b>Settings</b> and then <b>Keys</b>.</br>

![Settings](https://i.imgur.com/fGiAIbc.png)

![Keys](https://i.imgur.com/WtNdyxu.png)

Select <b>Generate auth key</b>.</br>

![Gen Key](https://i.imgur.com/ixSsaEf.png)

In the Auth Key creation window, enable the options: <b>Reusable</b> and **Ephemeral** </br>

![Gen Key](https://i.imgur.com/irdTABc.png)

Select <b>Generate key</b>.</br>

![Gen Key](https://i.imgur.com/FHwvZ5o.png)

Copy the key and save it in a safe place. </br>

</br></br>

## Installing Tailscale </br>

In the machine you want to install Tailscale, run the commands below:</br>

```
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null</br>
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
   
sudo apt-get update && sudo apt-get install tailscale  
sudo tailscale up --auth-key="A-SUA-CHAVE-AQUI"

```
That's it, Tailscale should be ready now. 

</br></br>

## Configuring the Subnet Router
</br>
  
In the machine with Tailscale installed, run the commands below: 
```

  echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf</br>
  echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf</br>
  sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
  
```
And to configure the machine as Subnet Router: 


 ```
 sudo tailscale up --advertise-routes=<insira as suas subnets aqui>
 
 ```

That's it. Now to finish the process go back to the Tailscale interface.

So the auth key does not expire, go to **Machines**, then on the machine options (•••), select **Disable key expiry**

![Key expiry](https://i.imgur.com/qwLIExx.png)

</br></br>

## Approve the Subnets

Still in the area <b>Machines</b></br>
The subnets should be showing in the IP area of the subnet router machine (in light gray).</br>

![Subnets](https://i.imgur.com/sATHQVf.png)

Go in the options of the machine: the <b>•••</b> on the right side.</br>

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

Se você conectou então **FUNCIONOU!!!**</b> 

  
