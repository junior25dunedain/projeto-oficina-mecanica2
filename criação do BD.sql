-- criando esquema do e-commerce
drop database Oficina;
create database Oficina;
use Oficina;

-- criando tabelas 

create table ordem_serviço(
	id_OS int auto_increment primary key,
    numero_serviço char(9) not null,
    valor float not null,
    status_ser enum('Pronto','em andamento','Atrasado') default 'em andamento',
    data_emissao date not null,
    data_termino date not null
);

create table execução_da_os(
	idExecução_OS_cliente int,
    execucao_idOrdem_serviço int,
    ordem_do_cliente enum('Prossiga','em espera','Rejeitado') default 'em espera',
    primary key(idExecução_OS_cliente),
    constraint fk_execucao_idOrdem_serviço foreign key(execucao_idOrdem_serviço) references ordem_serviço(id_OS)
); 


create table cliente(
	id_cliente int not null auto_increment primary key,
    nome varchar(35) not null,
    quantidade_veiculo int default 1,
    OS_idExecução int,
    constraint fk_cliente_idExecução foreign key(OS_idExecução) references execução_da_os(idExecução_OS_cliente)
);
desc cliente;


create table veiculo(
	id_veiculo int auto_increment primary key,
    modelo varchar(25) not null,
    fabricante varchar(25) not null,
    tipo_combustivel enum('Gasolina','Flex','Disel','Alcool') default 'Gasolina',
    ano date not null,
    veiculo_idcliente int,
    constraint fk_veiculo_idcliente foreign key(veiculo_idcliente) references cliente(id_cliente)
);

create table mecanicos(
	id_mecanicos int auto_increment primary key,
    nome varchar(20) not null,
    codigo char(9) not null,
    especialidade varchar(45), 
    mecanicos_idOrdem_serviço int,
	mecanicos_idExecução_OS int,
    constraint fk_mecanicos_idOrdem_serviço foreign key(mecanicos_idOrdem_serviço) references ordem_serviço(id_OS)
			on update cascade,
	constraint fk_mecanicos_idExecução_OS foreign key(mecanicos_idExecução_OS) references execução_da_os(idExecução_OS_cliente)
			
);

create table veiculo_mecanico(
	Veiculo_idVeiculo int,
    Mecânicos_idMecânicos int, 
    primary key(Veiculo_idVeiculo,Mecânicos_idMecânicos),
    constraint fk_Veiculo_idVeiculo foreign key(Veiculo_idVeiculo) references veiculo(id_veiculo) on update cascade,
    constraint fk_Mecânicos_idMecânicos foreign key(Mecânicos_idMecânicos) references mecanicos(id_mecanicos) on update cascade
);

create table pecas(
	id_pecas int auto_increment primary key,
    descricao_peca varchar(200) not null,
    valor_peca float,
    quantidade int default 1

);

create table Relação_Peças_Ordem_serviço(
	Peças_idPecas int,
    Ordem_serviço_idOrdem_serviço int,
	primary key(Peças_idPecas,Ordem_serviço_idOrdem_serviço),
    constraint fk_Peças_idPecas foreign key(Peças_idPecas) references pecas(id_pecas) on update cascade,
    constraint fk_Ordem_serviço_idOrdem_serviço foreign key(Ordem_serviço_idOrdem_serviço) references ordem_serviço(id_OS) on update cascade
);


create table servicos(
	id_servicos int auto_increment primary key,
    descricao_ser varchar(100) not null,
    valor_ser float,
    quantidade int default 1

);

create table Relação_serviço_OS(
	Serviços_idServiços int,
    Ordem_serviço_idOrdem_serviço int,
	primary key(Serviços_idServiços,Ordem_serviço_idOrdem_serviço),
    constraint fk_Serviços_idServiços foreign key(Serviços_idServiços) references servicos(id_servicos) on update cascade,
    constraint fk_Ordem_serviço_idOrdem_serviço2 foreign key(Ordem_serviço_idOrdem_serviço) references ordem_serviço(id_OS) on update cascade
);


create table maodeobra(
	id_maodeobra int auto_increment primary key,
    custo_hora float,
    quantidade int default 1

);

create table Consulta_maodeobra(
	maodeobra_idmaodeobra int,
    Ordem_serviço_idOrdem_serviço int,
	primary key(maodeobra_idmaodeobra,Ordem_serviço_idOrdem_serviço),
    constraint fk_maodeobra_idmaodeobra foreign key(maodeobra_idmaodeobra) references maodeobra(id_maodeobra) on update cascade,
    constraint fk_Ordem_serviço_idOrdem_serviço3 foreign key(Ordem_serviço_idOrdem_serviço) references ordem_serviço(id_OS) on update cascade
);


show tables;