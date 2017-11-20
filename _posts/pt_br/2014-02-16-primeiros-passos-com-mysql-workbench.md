---
layout: post
title:  "Primeiros passos com o MySQL Workbench"
date:   2014-02-16 12:00:00 -0300
categories: mysql workbench
permalink: blog/mysql/primeiros-passos-com-mysql-workbench
lang: pt_br
---
# Entenda rápido como começar com o MySQL Workbench

Hoje em dia, utilizo bastante o MySQL Workbench para manter a estrutura de meus BDs, ao invés do phpmyadmin. Eu prefiro, pois tenho um ambiente visual e facilidade em visualizar as alterações.

Para exemplificar, vou criar algo bem simples, mas que explora as vantagens que quero mostrar. Imagine que sua empresa possua franquias, e essas franquias possuam funcionários e clientes, e precisamos respeitar o seguinte:

* Ao desligar uma franquia, descadastramos junto seus funcionários;
* Ao desligar uma franquia, mantêmos seus clientes cadastrados.

Podemos resolver isso com a programação no server side, mas conseguimos resolver isso mais fácil pelo MySQL, e com mais segurança (pois já temos restrições bem testadas no BD).

## Antes de começar

Tenha ele instalado: [Link para download](http://dev.mysql.com/downloads/tools/workbench/)

Estou utilizando a versão 6.0.

## Iniciando um projeto

Vamos começar criando uma conexão com o Banco de Dados, e então criando um database de teste.
(Obs.: Você pode [pular esse passo](#criando-um-modelo), se já tiver criado um database para isso)

Clique no sinal de "+" no começo da janela.

![Tela inicial do MySQL Workbench]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-inicio_1.png" | absolute_url }})

Em seguida, ele vai perguntar as informações de conexão. Se for o padrão localhost, você vai precisar preencher apenas um nome para essa conexão (no meu caso, chamei de localhost mesmo). Ele deve pedir a senha também (se você ainda não tiver armazenado).

![Conexão MySQL Workbench]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-conexao.png" | absolute_url }})

E por fim, vamos criar um novo database:

![MySQL Workbench novo DB]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-new-db_1.png" | absolute_url }})

Clique no primeiro desenho (new schema), em seguida preencha o nome de seu database (chamei de test_wb) e por fim clique em apply.

Se você estiver com dúvida do motivo de estar usando schema, ao invés de database, eles são a mesma coisa. O MySQL não faz distinção entre eles (veja mais em [http://stackoverflow.com/questions/11618277/difference-between-schema-database-in-mysql](http://stackoverflow.com/questions/11618277/difference-between-schema-database-in-mysql) )

## Criando um modelo

Feche a aba dessa conexão para voltar a página inicial. Clique no + para criar um novo modelo.

![MySQL Workbench novo model]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-new-model_1.png" | absolute_url }})

O programa vai abrir uma nova aba com um modelo sem nenhum informação.

Para o nosso exercício, precisamos de 3 tabelas (franquia, funcionario, cliente). Vamos criá-las clicando em "Add table", e então renomeando-as.

![MySQL Workbench new table]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-new-table.png" | absolute_url }})

E então crie as colunas com as informações relevantes. Nesse exercício, vou apenas ter o id e nome para cada.

![MySQL Workbench new column]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-new-column_1.png" | absolute_url }})

Crie um diagrama novo. Com ele, nós vamos visualizar graficamente os relacionamentos da tabela.

![MySQL Workbench add diagram]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-add-diagram.png" | absolute_url }})

## Trabalhando com o diagrama

Nesse momento, temos um diagrama vazio.

Usando o catálogo, e arrastando as tabelas que acabamos de criar, teremos o seguinte esquema (sem nenhum relacionamento).

![MySQL Workbench add diagram]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-blank-diagram.png" | absolute_url }})

À partir de agora, veremos a grande vantagem do MySQL workbench. Use as ferramentas para criar os relacionamentos.

Use a primeira 1:n, e então clique em cliente e depois em franquia. Com isso, você criou o primeiro relacionamento, em que cliente se relaciona com franquia através de uma coluna (no caso, chamada de "franquia_idfranquia").

Agora use a segunda 1:n, e então clique em funcionário e depois em franquia. Agora, criamos outro relacionamento, porém esse identifica o funcionário como se fosse dessa franquia em específico.

Além disso, eu prefiro fazer outras coisas. Edita as colunas da seguinte forma:

![MySQL Workbench edit columns]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-edited-columns.png" | absolute_url }})

Eu fiz isso dessa forma, pois quero habilitar o NULL apenas para o cliente (pois tenho a intenção de haver cliente sem empresa), e não tenho a necessidade de que franquia_idfranquia seja identificador do funcionário.

Se estamos no mesmo passo, seu novo diagrama deve ser semelhante ao seguinte:

![MySQL Workbench edit columns]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-diagram-complete.png" | absolute_url }})

## Configurando os relacionamentos

Estamos no final. Selecione a tabela de clientes, e a aba de Foreign Keys. Em Foreign Key Options, deixe CASCADE para Update e SET NULL para Delete.

![MySQL Workbench foreign key]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-fk-cliente.png" | absolute_url }})

Com isso, você diz para o BD que ao atualizarmos franquia, ele vai atualizar os clientes também. Porém, ao apagá-lo, você vai deixar os clientes com franquia desconhecida (franquia = NULL). É possível encontrá-los depois com uma query simples:

```mysql
SELECT * FROM  `cliente` WHERE franquia_idfranquia IS NULL
```

E por fim, configurar funcionario com CASCADE para ambos.

![MySQL Workbench foreign key]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-fk-funcionario.png" | absolute_url }})

Com isso, ao atualizar ou apagar a franquia, você fará o mesmo com seus funcionários.

## Deploy

Está pronto. Precisamos apenas colocar isso no BD.

Salve (ctrl + S). Exporte (Database -> Synchronize Model ou então ctrl + shift + Z).

Nessa nova janela, clique em Next, depois Next novamente. E então escolha o database (estou utilizando test_db, que criei no começo do tutorial), e clique em Override Target.

![MySQL Workbench sync]({{"/assets/posts/2014-02-16-primeiros-passos-com-mysql-workbench/mysql-workbench-sync_2.png" | absolute_url }})

Por fim, clique em todos os Next e Execute. Está pronto. Você configurou corretamente seu BD para necessidade do exercício.

## Como funciona

Agora, vou inserir alguns exemplos:

Inserir informação

```mysql
INSERT INTO  `test_wb`.`franquia` (`idfranquia` ,`nome`)VALUES (NULL ,  'franquia');
INSERT INTO  `test_wb`.`cliente` (`idcliente` ,`nome` ,`franquia_idfranquia`)VALUES (NULL ,  'meu cliente',  '1');
INSERT INTO  `test_wb`.`funcionario` (`idfuncionario` ,`nome` ,`franquia_idfranquia`)VALUES (NULL ,  'funcionário da franquia',  '1');
```

Atualizar franquia

```mysql
UPDATE  `test_wb`.`franquia` SET  `idfranquia` =  '2' WHERE  `franquia`.`idfranquia` =1;
Após essa operação, é atualizado cliente e funcionário com id de franquia=2.
```

Apagar franquia

```mysql
DELETE FROM `test_wb`.`franquia` WHERE `franquia`.`idfranquia` = 4
Após essa operação, todos os funcionários da franquia são apagados, mas mantemos os clientes (para que alguém os passe para outra franquia).
```

## Cuidado

Na primeira vez que mexi com o MySQL Workbench, errei bastante em definir uma ação em On Delete como SET NULL, mas não deixei o campo permitir NULL. Com isso, dava erro ao sincronizar ambos, e não informava qual o erro. Levei um bom tempo para descobrir onde era a falha.

## Conclusão

Hoje em dia, utilizo bastante o MySQL em meus projetos PHP para criar e manter esses relacionamentos. Acho muito mais fácil do que escrever os códigos no phpmyadmin. O phpmyadmin eu utilizo para pequenas operações (como visualizar, editar e apagar dados), mas isso também é possível fazer com o Workbench.

Mas sugiro a todos que utilizem as ferramentas do MySQL. Ele é muito poderoso para usarmos tão pouco dele.
