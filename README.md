== Futural internweb

== Kvalitetskontroll

För repot gäller följande:

==== master

Master är den senaste släppta versionen. Release manager ansvarar för att 
skjuta till master, andra utvecklare lämnar master ifred.

Om man vill uppmärksamma release mgr. på att kod behöver skjutas till
master kan man använda pull requests här på github.

Vår huvudserver heroku/karnevalist följer master.

=== develop

Develop är den senaste utvecklingsversionen. Alla utvecklare får skjuta till
develop, med vissa förbehåll.

*Kod i develop ska klara sina tester*. Undvik att skjuta kod till develop som 
failar sina tester, håll den koden i en egen bransch eller lokalt tills den 
lever upp till kraven.

Om du skriver ny kod till appen så ansvarar du för att skriva tester för att 
dokumentera förväntat beteende. Om du hittar en bugg i någon annans kod så
hjälper det att skriva tester som den failar pga. av ovan sagda bugg.

Vår utvecklingsserver heroku/karnevalist-stage följer develop. Dock heter 
branschen master på den servern. För att skjuta till stage används sålunda:

    git push stage develop:master

=== Övriga branscher 

Här råder fri hopp och lek.

