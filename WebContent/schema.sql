create table users (
	u_id serial primary key,
	u_name varchar(70) unique not null check (u_name<>''),
	u_role char not null check (u_name<>''),
	u_age int not null,
	u_state char(2) not null check (u_state<>'')
);

create table categories (
	id serial primary key,
	name text unique not null check (name<>''),
	description text not null check (description<>'')
);

create table products (
	id serial primary key,
	name text not null check (name<>''),
	sku text unique not null check (sku<>''),
	price decimal(10,4) not null,
	category integer references categories(id)
);

create table purchases (
	id serial primary key,
	u_id int references users(u_id),
	price decimal (10,4) not null,
	summary text not null check (summary<>'')
);