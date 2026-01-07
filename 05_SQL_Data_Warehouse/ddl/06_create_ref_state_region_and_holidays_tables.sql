CREATE SCHEMA ref;
GO

/* =========================================================
   ref.state_region_map
   ========================================================= */
IF OBJECT_ID ('ref.state_region_map', 'U') IS NOT NULL
	DROP TABLE ref.state_region_map;
GO

CREATE TABLE ref.state_region_map (
	state_code   CHAR(2)        NOT NULL PRIMARY KEY,
    state_name   NVARCHAR(50)  NOT NULL,
    region_name  NVARCHAR(50)   NOT NULL
);
GO

INSERT INTO ref.state_region_map (state_code, state_name, region_name) VALUES
('AC', N'Acre',                   N'Norte'),
('AL', N'Alagoas',                N'Nordeste'),
('AM', N'Amazonas',               N'Norte'),
('AP', N'Amapá',                  N'Norte'),
('BA', N'Bahia',                  N'Nordeste'),
('CE', N'Ceará',                  N'Nordeste'),
('DF', N'Distrito Federal',       N'Centro-Oeste'),
('ES', N'Espírito Santo',         N'Sudeste'),
('GO', N'Goiás',                  N'Centro-Oeste'),
('MA', N'Maranhão',               N'Nordeste'),
('MG', N'Minas Gerais',           N'Sudeste'),
('MS', N'Mato Grosso do Sul',     N'Centro-Oeste'),
('MT', N'Mato Grosso',            N'Centro-Oeste'),
('PA', N'Pará',                   N'Norte'),
('PB', N'Paraíba',                N'Nordeste'),
('PE', N'Pernambuco',             N'Nordeste'),
('PI', N'Piauí',                  N'Nordeste'),
('PR', N'Paraná',                 N'Sul'),
('RJ', N'Rio de Janeiro',         N'Sudeste'),
('RN', N'Rio Grande do Norte',    N'Nordeste'),
('RO', N'Rondônia',               N'Norte'),
('RR', N'Roraima',                N'Norte'),
('RS', N'Rio Grande do Sul',      N'Sul'),
('SC', N'Santa Catarina',         N'Sul'),
('SE', N'Sergipe',                N'Nordeste'),
('SP', N'São Paulo',              N'Sudeste'),
('TO', N'Tocantins',              N'Norte');
GO


/* =========================================================
   ref.holidays
   ========================================================= */

IF OBJECT_ID('ref.holidays', 'U') IS NOT NULL
    DROP TABLE ref.holidays;
GO

CREATE TABLE ref.holidays (
    holiday_date DATE        NOT NULL PRIMARY KEY,
    holiday_name NVARCHAR(200) NOT NULL,
    is_holiday   BIT         NOT NULL DEFAULT(1)
);
GO

INSERT INTO ref.holidays (holiday_date, holiday_name, is_holiday)
VALUES
    -- 2016
    ('2016-01-01', N'New Year''s Day', 1),
    ('2016-02-08', N'Carnival Monday', 1),
    ('2016-02-09', N'Carnival Tuesday', 1),
    ('2016-02-10', N'Carnival End / Ash Wednesday', 1),
    ('2016-03-25', N'Good Friday', 1),
    ('2016-03-27', N'Easter Sunday', 1),
    ('2016-04-21', N'Tiradentes Day', 1),
    ('2016-05-01', N'Labor Day', 1),
    ('2016-05-26', N'Corpus Christi', 1),
    ('2016-09-07', N'Independence Day', 1),
    ('2016-10-12', N'Our Lady Aparecida / Children''s Day', 1),
    ('2016-11-02', N'All Souls'' Day', 1),
    ('2016-11-15', N'Republic Proclamation Day', 1),
    ('2016-11-25', N'Black Friday', 1),
    ('2016-12-25', N'Christmas Day', 1),

    -- 2017
    ('2017-01-01', N'New Year''s Day', 1),
    ('2017-02-27', N'Carnival Monday', 1),
    ('2017-02-28', N'Carnival Tuesday', 1),
    ('2017-03-01', N'Carnival End / Ash Wednesday', 1),
    ('2017-04-14', N'Good Friday', 1),
    ('2017-04-16', N'Easter Sunday', 1),
    ('2017-04-21', N'Tiradentes Day', 1),
    ('2017-05-01', N'Labor Day', 1),
    ('2017-06-15', N'Corpus Christi', 1),
    ('2017-09-07', N'Independence Day', 1),
    ('2017-10-12', N'Our Lady Aparecida / Children''s Day', 1),
    ('2017-11-02', N'All Souls'' Day', 1),
    ('2017-11-15', N'Republic Proclamation Day', 1),
    ('2017-11-24', N'Black Friday', 1),
    ('2017-12-25', N'Christmas Day', 1),

    -- 2018
    ('2018-01-01', N'New Year''s Day', 1),
    ('2018-02-12', N'Carnival Monday', 1),
    ('2018-02-13', N'Carnival Tuesday', 1),
    ('2018-02-14', N'Carnival End / Ash Wednesday', 1),
    ('2018-03-30', N'Good Friday', 1),
    ('2018-04-01', N'Easter Sunday', 1),
    ('2018-04-21', N'Tiradentes Day', 1),
    ('2018-05-01', N'Labor Day', 1),
    ('2018-05-31', N'Corpus Christi', 1),
    ('2018-09-07', N'Independence Day', 1),
    ('2018-10-12', N'Our Lady Aparecida / Children''s Day', 1),
    ('2018-11-02', N'All Souls'' Day', 1),
    ('2018-11-15', N'Republic Proclamation Day', 1),
    ('2018-11-23', N'Black Friday', 1),
    ('2018-12-25', N'Christmas Day', 1);
GO
