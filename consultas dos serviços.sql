-- inserindo os dados
use oficina;

insert into ordem_serviço(numero_serviço, valor, status_ser, data_emissao, data_termino) values
		(102000214,350.00,default,'2021-05-15','2021-05-18'),
        (114200321,500.00,default,'2021-05-17','2021-05-20'),
        (114200323,1000.00,'Pronto','2021-06-15','2021-06-21'),
        (178359200,845.00,default,'2021-05-15','2021-05-18'),
        (190114147,687.00,'Atrasado','2022-08-05','2022-08-28');

insert into execução_da_os(idExecução_OS_cliente, execucao_idOrdem_serviço, ordem_do_cliente) values
			(1,1,'Prossiga'),
            (2,2,'Prossiga'),
            (3,3,'em espera'),
            (4,4,'Rejeitado'),
            (5,5,'em espera');


insert into cliente(nome, quantidade_veiculo, OS_idExecução) values
	('Paulo',default,1),
    ('Ana',default,2),
    ('Antonio',default,3),
    ('Pedro',2,4),
    ('Julia',default,5);

select * from cliente;


insert into veiculo(modelo, fabricante, tipo_combustivel, ano, veiculo_idcliente) values
		('Cruze','Chevrolet','Flex','2022-06-01',11),
        ('Cruze','Ford','Flex','2020-03-01',13),
        ('Versa','Nissan',default,'2022-01-01',12),
        ('Cronos','Fiat','Flex','2021-10-01',14),
        ('PAJERO FULL','MITSUBISHI ','Disel','2023-01-01',15);

select * from execução_da_os;

insert into mecanicos(nome, codigo, especialidade, mecanicos_idOrdem_serviço,mecanicos_idExecução_OS) values
		('Roberto','000100020','injeção eletrônica',2,2),
        ('Tales','000100040','Pneus',1,1),
        ('Helena','000100030','Motor',3,3),
        ('Luiz','000100010','escapamento',5,5),
        ('Bruno','000100090','pintura e desing',4,4);
 
 select * from mecanicos;
 
insert into veiculo_mecanico(Veiculo_idVeiculo, Mecânicos_idMecânicos) values
		(6,1),
        (9,2),
        (8,3),
        (7,4),
        (10,5);

insert into pecas(descricao_peca, valor_peca, quantidade) values
		('Vela de ignição',700,default),
        ('Pneu',250,16),
        ('cano de escapo',80,8),
        ('retrovisor',150,20),
        ('Oleo 50',150,10),
        ('caixa de cambio',260,3),
        ('kit bico e valvula',150,default);

select * from ordem_serviço;

insert into Relação_Peças_Ordem_serviço(Peças_idPecas, Ordem_serviço_idOrdem_serviço) values
		(3,3),
        (1,1),
        (5,5),
        (4,4),
        (2,2);
        
insert into servicos(descricao_ser, valor_ser, quantidade) values
		('trocar pneu',100,default),
        ('consertar motor',550,default),
        ('trocar o oleo',120,default),
        ('pintar o veiculo',300,default),
        ('Revisão elétrica',320,default);

select * from ordem_serviço;

insert into Relação_serviço_OS(Serviços_idServiços, Ordem_serviço_idOrdem_serviço) values
			(1,1),
            (2,2),
            (3,3),
            (4,4),
            (5,5);
            
insert into maodeobra( custo_hora, quantidade) values
		(50.50,default),
        (36.50,default),
        (45.50,default),
        (80.50,default),
        (100.00,default);


select * from maodeobra;
insert into Consulta_maodeobra(maodeobra_idmaodeobra,Ordem_serviço_idOrdem_serviço) values
		(1,1),
		(2,2),
        (3,3),
        (4,4),
        (5,5);
        
-- Queries para consultar dados 

-- verificando o mecanico com o maior valor de mão de obra
select nome as nome_mecanico,especialidade,max(custo_hora) as custo_mao_obra from maodeobra as ma inner join Consulta_maodeobra as cm inner join
			(select * from ordem_serviço as os inner join mecanicos as mec on os.id_OS = mec.mecanicos_idOrdem_serviço) as t
            on cm.Ordem_serviço_idOrdem_serviço = t.id_OS;

-- serviço mais barata da oficina
select descricao_ser, min(valor_ser)*1.1 from servicos;

-- consultando os serviços finalizados em 2021
select distinct numero_serviço, valor as Custo_R$, data_termino as data_finalização_do_serviço from ordem_serviço where data_termino like '2021%';

-- analisando os serviços com custos maiores que 400 
select numero_serviço,status_ser as Situação_serviço,valor as custo_serviço,ordem_do_cliente from ordem_serviço as os inner join execução_da_os as eos on eos.execucao_idOrdem_serviço = os.id_OS 
where (os.status_ser = 'Pronto' or os.status_ser = 'em andamento') and os.valor > 400 order by numero_serviço;

-- verificando todas as peças ofertadas pela oficina 
select descricao_peca from pecas;

-- consulta dos serviços dos clientes 
select nome as nome_cliente, concat(modelo,' ',fabricante,', ','o combustivel é ',tipo_combustivel) as carro_cliente,ano as ano_fabricação,concat('O Serviço custa R$',valor) as serviços ,ordem_do_cliente,status_ser as Situação_serviço, data_emissao 
from cliente as c inner join veiculo as v on v.veiculo_idcliente = c.id_cliente inner join
	(select * from ordem_serviço as os inner join execução_da_os as eos on eos.execucao_idOrdem_serviço = os.id_OS) as b
	on c.OS_idExecução = b.idExecução_OS_cliente group by ano having status_ser not in ('Atrasado') order by ano;



    
            