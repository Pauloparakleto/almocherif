# ALMOCHERIF

Será um sistema para controle de almoxarifado com as seguintes funcionalidades:

- Cadastro de usuário (login e senha apenas)
- O sistema só poderá ser acessado com login e senha

## Funcionalidades:

- [x] CRUD de materiais: criar, listar, apagar, editar (nome do material)
- [x] Lista de materiais deve ter paginação a cada 10 itens
- [x] Filtro na lista de material pelo nome
- [x] Dar entrada no material (material e quantidade)
- [x] Retirar material (material e quantidade)
- [ ] Ao adicionar ou retirar material deve ser salvo um log de alterações informando qual o usuário responsável, material e quantidade retirada/adicionada
- [x] Tela de lista dos materiais (nome, quantidade (mesmo que 0)
- [ ] link para um log de entrada/retirada com as informações do log)


## Requisitos

- [x] Projeto deve ser feito utilizando rails 5+
- [x] Se um material já tiver qualquer registro de retirada ou entrada não permitir que o mesmo seja excluído
- [x] O nome de um material deve ser único
- [x] O saldo dos materiais não pode ser negativo
- [x] A retirada de materiais só pode ser feita entre 9h e 18h de segunda a sexta
- [ ] Um usuário não pode ser excluído
- [ ] A Raíz deve ser `/items`. Atualmente, precisa acessar `localhost:3000/items`. **Requisito acrescentado por mim**.
- [x] Pode utilizar qualquer Gem que achar necessário
- [x] Nome do material deve ser único

## Observações:

Enviar o endereço do Github com o código do projeto

# Start the Project in your own machine

## Clone it

1. Using SSH: `git clone git@github.com:Pauloparakleto/almocherif.git`


2. Using HTTPS: `git clone https://github.com/Pauloparakleto/almocherif.git`

## Bundle it

On terminal run: `bundle install`

## PostgreSQL Staff

[I don't have postgre locally](https://docs.microsoft.com/windows/wsl/tutorials/wsl-database). Follow the instruction
on the link and come back to the instructions bellow.

1. Rename the file `database.sample.yml` to `database.yml`
2. Set the password on the default area according to your password, mine is `12345`
3. Set the username on the default area to your role with privilege to create database.
   Mine is the default role. So I comment out the username line in order
   to postgre reach the name of my machine.
4. Start database server: `sudo service postgresql start`

## Connect Rails to the database

Run: `rails db:create db:migrate`

Optionally you might populate the database with initial data: `rails db:seed`.
However, you will not be able to test the create workflow since the delete action is not part of the
current release.

Any way, you may delete the data to restart the create workflow by running:
`rails db:drop db:create db:migrate`

## Run the server
Run: `rails webpacker:install`

Run: `rails server`

## Testing it

At least but also important, run the tests: `rspec`

If your integration test fails with webpack misses configuration warnings, run: `rails webpacker:install`


