# memo

Ferramenta simples para armazenar lembretes usando SQLite como uma key-value store .

<b>key</b> - Chave primária da tabela, usada para identificar unicamente os lembretes.

<b>value</b> - informação armazenada sob uma chave <b>key</b>

#### memo get <b>key</b>
  Tenta obter o valor com a <b>key</b>. Se o valor existe, ele é imprimido no terminal e colocado no clipboard do sistema. (Só testado no windows)


#### memo put <b>key</b> <b>value</b> [-h] 
  Tenta criar um novo lembrete <b>value</b> com a chave <b>key</b>. O parâmetro opcional -h pode ser usado para que o valor jamais seja impresso no terminal nas chamadas de <b>get</b> e <b>ls</b>.
  

#### memo del <b>key</b>
  Tenta deletar o valor com a <b>key</b>.
  
#### memo ls
  Imprime todos os lembretes (que não foram escondidos com -h) no terminal.
  
  
### Banco de Dados
  Em sql/DDL.sql encontra-se o necessário para gerar o banco de dados usado pelo programa.
  
### TODO

- [ ] Adicionar autorização no banco de dados.
- [ ] Criar arquivo de configuração para a conexão com o banco de dados.
- [ ] Usar biblioteca para o parsing de comandos.
- [ ] Mais features?
