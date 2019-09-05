-- TSQL script for the Java regex sample on Windows

EXEC sp_configure 'external scripts enabled', 1
RECONFIGURE WITH OVERRIDE
GO

CREATE DATABASE javatest
GO
USE javatest
GO

CREATE TABLE testdata (
    id int NOT NULL,
    "text" nvarchar(100) NOT NULL
)
GO

-- Insert data into test table
INSERT INTO testdata(id, "text") VALUES (1, 'This sentence contains java')
INSERT INTO testdata(id, "text") VALUES (2, 'This sentence does not')
INSERT INTO testdata(id, "text") VALUES (3, 'I love Java!')
GO

--CTP 3.0: Make sure you create a .zip file from the javaextension.dll file saved here: [SQL Server install path]\MSSQL\Binn\javaextension.dll
-- You might need to set read permisisons for SQLRUserGroup and ALL APPLICATION PACKAGES, depending on where you save the .zip file
CREATE EXTERNAL LANGUAGE Java
FROM
(CONTENT = N'[Path to .zip file]\java-lang-extension.zip', FILE_NAME = 'javaextension.dll',
ENVIRONMENT_VARIABLES = N'{"JRE_HOME":"<path to JRE>"}' );
GO

--The extension jar is also saved under a predefined path as part of the sql server installation
--Win path: <SQL Server installation directory>\MSSQL\Binn\mssql-java-lang-extension.jar
CREATE EXTERNAL LIBRARY sdk
FROM (CONTENT = '<SQL Server installation directory>\MSSQL\Binn\mssql-java-lang-extension.jar')
WITH (LANGUAGE = 'Java');

--Create external library for the sample jar (including the RegexSample class you compiled)
CREATE EXTERNAL LIBRARY regex
FROM (CONTENT = '<path>\regex.jar')
WITH (LANGUAGE = 'Java');
GO

/*
Instead of giving a path to create the external library "regex" above, you can also use the following to quickly test this sample without having to compile classes and produce a .jar file

CREATE EXTERNAL LIBRARY regex 

FROM (CONTENT = 0x504B03041400080808005DA59C4E000000000000000000000000090004004D4554412D494E462FFECA00000300504B0708000000000200000000000000504B03041400080808005DA59C4E000000000000000000000000140000004D4554412D494E462F4D414E49464553542E4D46F34DCCCB4C4B2D2ED10D4B2D2ACECCCFB35230D433E0E5722E4A4D2C494DD175AA040958E819C41B191A2A68F8172526E7A42A38E71715E417259600D56BF272F1720100504B0708F43BEC934400000045000000504B03040A00000800005DA59C4E00000000000000000000000004000000706B672F504B0304140008080800268A9C4E00000000000000000000000015000000706B672F526567657853616D706C652E636C617373C557F97713D715FE9E257BA4E149B64584510CC9401A5B96175148682A535A639BA0E2052C6316A74DC7D2B33D581A8999916B92967421499774A51BDDA0E912DAA6292420439C90A54D734E7EEC2FFD53724E7B4ED3FB4696235B4ACE6973727A6CDF79EFBEBBBFEFDE19BFF5EF176F03B80F7F53D180A30A26FCD88B94824915C7302537C72539A11239A9C28B53924CFBF0908ACFE0B30A1E56F139E85266C68F34320A848A561CF561563EE724995761E0B48205156D382A4D6555EC444E6E4D49F292142439E383B509361C498A0A16A5E0E77D589276CEFAF088744FC61F55F005B9FCA20FE7E4F33149BEA4E0CB3E7C45451FBE2AF7E77D785C3E9F90313EA9E26BF8BA826F3078C552C162888C9CD617F578D131B2714BCC89A5F811DD718465F63334ED334CC3D9CFE089764D91C6603E23189A470C538C157333C29AD467B2C451C49248171D5A5D888EA4F3B978CE485B793B3FEBC4ED33595B588BC28A4B3759DD240F8E306D236FC68F5846CE708C4531A43BBA2D9CFEAA50C8C782C81CD2EDF951BDD0DFF541AC3204528E9E5E20436EBC943D5DAD826F2A784AC1B7E8F6E852147C9BC19F32E64CDD295A94C9AD0F25937DE503A91D4F399661CEF55771C6674E8BB4D3BFFF03E74B3246467744D22C141D86131FD2AD1026CEFD5FCB440134A6E7457A81211CADD5E93AC5A0A6F2452B2D0E1A12A82D1312E1293D57C88A3E29CEF1712418FE8B1C06666CC7D2D34EEA4C36E5CA0C578E86DD26C85B1CDFC1771912FF7B5D147C8FE3FBB8C0F103FC90E347927C1A87397E8C9F705CC44F09AA6EAF0E530B1390397E869F53761B0BA0E0171CBFC4258E8FE1010597397E85A719DA36CA1D281AD98CA0611072AD6A7232085B8696D0387E8DDF70FC161714FC8EE3195C61B863E3B58D18B6C3318A318EDFE30F1C7FC4B31C7FC2731C7FC6558E6B789E818F171D42A346B8D413D46E1C2FE03AC70D94185ADF8D28693A1403157119CFD1C8490E9543B8C9E0D3A6F46C5124348686E41043D055A2BAC627CF1684CD710B2F92C624D59563052F71BC8CDB0C3BAB6C67B3624ECF0E5873C59C309DE1A5B42838942543D4ED14ADA05B7A4ED0F4D33AD7EADBA919B666E61D6D365F3433123057385E91C11D3E6652A5088A22A319AEBE4D60CCE93DAB4FCD9ECF17B3196D4668BAA945936393C30F0E4FF4686353031383870626B4BCA5AD2EBB385EC56B1CAFE32F0AFECAF106AED3A02D2CCCC5AB105BB9B9DA7EA18A4C2719364FD7F600C3966A25DB49527A3AC19461AB5845EC1A84A78465BBF56064ADF95D5B8359DDB669CECF09678C0A44088876D573B5BD62D12DE72A9A5DE5B25AA89ED25D15A532406AB538B925580CE6B3C51CC5D6184D76C96C9B895D365239D9224FEAB9F090284347B4768874D5B2D69579DD2B912A404D5D7047496FBD79F33EEFD2EAE63C6B3B224751E5E5700E97958CBC1C03A6CC48E839F9F2D50B056166DED7536D0F93A2CFC9975904883AA6298982DC65CDF7189A34549545D969E3B3E5928ED474A72CA99EC96C305029294D5DAF6D3C22DCEF06BA28C5C90F58967E96DA2C3A5D47BE0E8F2E3DBB0EABED6B71D40099849579DD1EA3BE773D4AF7A6BB598FD235D33ECADE1D250CDBD6A7B7B194AD9464195CA3C2D1E5E4A20FA668B2B668C96452D68D937C15527DD1E47472FA943C69A693F5606DA3C3FAD50F125ACB52833472288FC01A434E3A4A8FA29675CDE90E0D1AAACE9EEA6B189CD7AD94385314665AD481E46859A91ECC472BF6BCB38699C10EFA466DA00F639A2EF205422B2FADE98549B49F7643C467F4DC165B068B796FC0130B794B68BC81A6CA42B9E6EAEF23BA058D440364A3197EB42044DFB2ED44193E81FD64892C3674A0894EC1FA63DD3DCBF0757B4AF08F75932935E18D786FEF6DEC096D2A81BF8A40A2291669BA89E00D343F8F9615B49E5C4628B4B9843B224D444A0897B065056DC4DE9A502A0B9F67AF3FEC0F373E8DDE58C41BF6EF5E46E422DA234A6FD8DF77137796D07E3CE2734FE4F2BC9F3DF3CEDF23BE12B649BD97D4841AF6BF4CCE37911005B2FD7844A110EF4A70CFDE008511BA9B9C46F82DD02BEA2286236A3820773B180DF79D25DC335E15EA4764A824D057C2BDA10EB9D9140EEC5E0BFD7C805C2FAFC04BC29D896024E80945150F398B4582DE5077CBDBAB6B4F446525F4105306D41B095EA52237B8053F87BBDDB237612B3822D88C3B69B50DF7603B7AE8EC20FD53314EBB13E8C00C3A61228A47D1852768FF147A710171CA62172E630FAEE07E5C2538BC4030582108BC4120F807F631BA3CA66080B56090B5638875E220DB8507D90348E293E4FD181ADFC13454059F22310507140C2A24A76058C141FA25FCC4FE2985FA107C6FA1324321C3C0BF701887DC2493F4479F4565EC50C81EFA0146CB1879138115F49D0CC597B1EB95EE123E4A975EE6EC763954BE3DCA25EC90E8DAD3C22FA1ADBC7AFB72B5D8B5B56AEE848FE81841779C2A9922E84EE25EAADD2E9CC4019CC2081E72336E8467736BC76A8423F4475F45ABFD12A39D8C3018BB8E660AE9BED19E12EE7F76AD4354B7DB1E26173A71C65D0B47FE03504B070818FB506F490700009D0E0000504B0304140008080800028A9C4E00000000000000000000000014000000706B672F526567657853616D706C652E6A617661C5566D4FDB4810FE8EC47F98F2813A17CB857E6C48A5288D684E107A492E3A0921B4D84BB2C55EBBDE75809EF8EF9D7D89EDB51D2AA193CE1FF2E29D796676E699978C840F644D217B580F0E0F0E0F5892A5B984304D828485792AD27B19881FB1A0F996E6C177B22531E16BFA2429172CE5C1B79C254CB22DFD422411540EDE8031BA133227A15CFC88175A66B23B9A3CD1B090695EA12AEDA0902C0E2E187FA0D15722369724DB2F70C184EC3E15722A694EF6C0E7143D0CFED051C98ABB988510C6440898AB830549B29882BE4324E0F737807F0F0F009F2C675B22297C23128D7344C8726D431F1A3B350B5E6FA7A89E0F1F6041659181DC28DB190D258DA00C24A061F5ED03E191F556A650080AF7E801E35921F5515A48F5333229ABF0A975B6F47E650061088BBF2E1693F96A32BFFD73B41ADD5E8C66E7B7937F9693D9627A35BB5D9D0EDA285365CFD262AC9C9991842254933281F6345853A904BC5E07D49576F8ED582FE6CB897253D51AA35EEB4007CE078770670B9933BEF6E1EAEE3BA6E1336424278968A66B456216A97CAB8C990468418AC9173A17E66598C645C241841B9A900A616BD575283DEB87B554B2463D8CCBEB1BFC9C22198706530561CAE558237B27F5B01ADFB5023A585047C71C5AB5D3BA1A1A813C7D1CA705FE1896CA414CF95A6E1C7F0C08E8229A20C551DC33EF7AC67D65C93B2ACF8FDCAC6B055B220136928C612994C2EED517CF42D224404E07585C5CC6DCE26A1C2A14813FC111F4610F00A64935035D2B02C9669255AB914AB46A2967185A84CB3F2B4113754E1FBB041C42D7CE4D38B47E9984068415F15AFE4E901885A21525E146E5A43AC54AF754A218C29D0CF0EBACCC19FEEBF71D86EAACDE8387B40B1FBC5D42AFD94DAF25A61E73D5804491A7A9A604079D62961946B2426D08BF547F5F1A6CB6F19F5774AB5005FB49BD4EFE47A65120796D30D57B17E9A6AB0E54386953D79EB6D59D548C538E6D576ACEC4983448EF77DC3145AD7945F29C3C8B4AB1BA8C4C47EACC735D706F579F5515F1988D8A4A495C93706BDD16ED34D27CF85DE15C55ACFFE4D4E4E3064B103C26830D11331C395E9B22B5F05F6B9337AA4BC8806BF1004DE83B3752B7CF95E91753B51DA87D3CD05046C20D9D156A724DBFEDF7077B2867328953BC0865B3FE9D19D99A0E56D070A679DAB8AB91556561FAEB25954459F04E7CC00B1FF96601C16529583E67C88EE96C39399FCC7D400127AD7B914E116989016F63CD56A3F9F8EBA806D605571B197E3DF63EF0228EBB5D7047860FAF7139C70506F71EA35C8D67773BDAA62C6A0CBFFF722A8F55BBD33B91CA74735834E774AD96B055EE195F301C9A00358B426E90799A1BD338A66B128FF27591502E274F21CD24DA43AABB06E17D09FC1E98009E4A74B6E09153914DFA2EEB3BA1B9825927406CD2228EE08E02911053824DEAE3AE39F9E0951C5B2CE7D3D979CFBD6FB91798F4EA26885BE9197C7CD355FFE69D3EFA1DBEF29A6B3BEE02E6CCFEECBD1A0D9362B921B2B67AD92D4BAA72C0965CC5EBD52BABEAC19E0AEF867BAA138E8FDB43B013E5B40B6577B5E363D8A3336CE994F16877E1FF390B9DF57C97A6C83B0E66CFB0CBA1C42EE5787F49240AE490603355E51824E685A725BBBA4812DC331ED5D7FC975F504B07085D9994BBAE040000D20E0000504B010214001400080808005DA59C4E0000000002000000000000000900040000000000000000000000000000004D4554412D494E462FFECA0000504B010214001400080808005DA59C4EF43BEC93440000004500000014000000000000000000000000003D0000004D4554412D494E462F4D414E49464553542E4D46504B01020A000A00000800005DA59C4E0000000000000000000000000400000000000000000000000000C3000000706B672F504B01021400140008080800268A9C4E18FB506F490700009D0E00001500000000000000000000000000E5000000706B672F526567657853616D706C652E636C617373504B01021400140008080800028A9C4E5D9994BBAE040000D20E0000140000000000000000000000000071080000706B672F526567657853616D706C652E6A617661504B0506000000000500050034010000610D00000000)

WITH (LANGUAGE = 'Java')

GO
*/

CREATE OR ALTER PROCEDURE [dbo].[java_regex] @expr nvarchar(200), @query nvarchar(400)
AS
BEGIN
--Call the Java program by giving the package.className in @script
--The method invoked in the Java code is always the "execute" method
EXEC sp_execute_external_script
  @language = N'Java'
, @script = N'pkg.RegexSample'
, @input_data_1 = @query
, @params = N'@regexExpr nvarchar(200)'
, @regexExpr = @expr
with result sets ((ID int, text nvarchar(100)));
END
GO

--Now execute the above stored procedure and provide the regular expression and an input query
EXECUTE [dbo].[java_regex] N'[Jj]ava', N'SELECT id, text FROM testdata'
GO
