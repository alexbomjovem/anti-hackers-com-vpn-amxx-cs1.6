## Plugin temporário contra hackers VPN

Quero disponibilizar alguns plugins contra esses hackers [VPN](https://pt.wikipedia.org/wiki/Rede_privada_virtual) 
que tomam ban e voltam 10 segundos depois miando o servidor. Tirei meu dia para fazer isso
e acredito que vai ajudar muitos donos de servidores temporariamente.


### Como funciona

Você instala no seu servidor e deixa ele rodando. O plugin só vai verificar os jogadores
enquanto o `Modo Quarentena` estiver `ativado`. Caso contrário, o plugin irá salvar os ids 
de todos cs piratas que entrarem no servidor pela primeira vez.


### Modo Quarentena

Uma vez que o `Modo Quarentena` esteja ativado, o plugin vai liberar os jogadores 
previamente salvos e os novos jogadores que conectarem a partir desse ponto ficarão 
sem permissão para usar armas até que algum administrador online liberem eles pelo menu.

Isso vai evitar que o jogador banido volte com VPN esvazie seu servidor.


### Comandos

Comando | Descrição
--------|-----------
/vpn | Abre o menu de configuração do plugin. (apenas para administradores com acesso `h`)


### Observações

* Esse plugin ignora jogadores steams
* O plugin limpa automaticamente os dados de jogadores que não conectaram nos últimos 30 dias
* Os dados do plugin ficará salvo no seguinte diretório:
    * `addons\amxmodx\data\file_vault\Anti-VPN`


### Instalação

O plugin pode ser instalado igualmente qualquer outro plugin.
Para mais detalhes sobre o plugin e o processo de instalação, por favor, assista esse vídeo:
* [Plugin Ban Quarentena contra hackers VPN](https://youtu.be/j-nDFCvLu58)
* Necessario o download  hackdetector contra speed  hackers.
*[download hackdetector ](https://drive.google.com/file/d/1de9KXYXjIVPjWqWBdSVUNOJZtHveFss2/view?usp=sharing)
