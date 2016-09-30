# Consulta de Viagens

Aplicação JEE com exemplo de JAAS gerenciado pelo Wildfly 8

### Banco de dados

* MySQL 5.5

### Server

* WildFly 8
* HornetQ 2.4 (middleware mensageria)

# Configuração do ambiente

* Banco de dados

```
CREATE SCHEMA IF NOT EXISTS `jaasdb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `jaasdb` ;

CREATE  TABLE IF NOT EXISTS `jaasdb`.`SystemRole` (
  `name` VARCHAR(200) NOT NULL ,
  PRIMARY KEY (`name`) )
ENGINE = InnoDB;

CREATE  TABLE IF NOT EXISTS `jaasdb`.`SystemUser` (
  `email` VARCHAR(45) NOT NULL ,
  `password` VARCHAR(45) NULL ,
  `SystemRole_name` VARCHAR(200) NOT NULL ,
  PRIMARY KEY (`email`) ,
  INDEX `fk_SystemUser_SystemRole_idx` (`SystemRole_name` ASC) ,
  CONSTRAINT `fk_SystemUser_SystemRole`
    FOREIGN KEY (`SystemRole_name` )
    REFERENCES `jaasdb`.`SystemRole` (`name` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

insert into `jaasdb`.`SystemRole` (`name`) values ('ADMIN');
insert into `jaasdb`.`SystemUser` (`email`, `password`, `SystemRole_name`) values ('r.marini.ds@gmail.com','jZae727K08KaOmKSgOaGzww/XVqGr/PKEgIMkjrcbJI=','ADMIN');

```
Obs. O password (base64/SHA-256) pode ser gerado na classe PassGenerator do projeto.

* standalone-full.xml

Data Source

```
				<datasource jndi-name="java:jboss/datasources/jndiRoMariniDs" pool-name="jndiRoMariniDs" enabled="true">
                    <connection-url>jdbc:mysql://localhost:3306/jaasdb</connection-url>
                    <driver>mysql</driver>
                    <security>
                        <user-name>root</user-name>
                    </security>
                </datasource>

```

JAAS Configuration

```
				<security-domain name="jaas-romarini" cache-type="default">
                    <authentication>
                        <login-module code="Database" flag="required">
                            <module-option name="dsJndiName" value="java:jboss/datasources/jndiRoMariniDs"/>
                            <module-option name="principalsQuery" value="select password from SystemUser where e-mail=?"/>
                            <module-option name="rolesQuery" value="select name,'Roles' from SystemRole as sr inner join SystemUser as su on sr.name = su.SystemRole_name and su.email = ?"/>
                            <module-option name="hashAlgorithm" value="SHA-256"/>
                            <module-option name="hashEncoding" value="base64"/>
                        </login-module>
                    </authentication>
                </security-domain>
```

o Wildfly oferece varias implementacoes da interface LoginModule, no exemplo é usado database.

Database – org.jboss.security.auth.spi.DatabaseServerLoginModule 
Ldap– org.jboss.security.auth.spi.LdapLoginModule 
Simple – org.jboss.security.auth.spi.SimpleServerLoginModule 
PropertiesUsers – org.jboss.security.auth.spi.PropertiesUsersLoginModule 

https://docs.jboss.org/ author/display/WFLY8/Security+subsystem+configuration 

O atributo flag indica que o usuário deverá passar por esse módulo para acessar o restante da aplicação, garantindo a segurança do sistema. 