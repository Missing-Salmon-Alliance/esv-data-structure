# Connect to neo4j graph database using api via neo4r tools
# source variables from secrets.R file (not shared to github, sorry! Checkout neo4j and spin up your own graph! ;)

neo_con <- neo4j_api$new(url = paste("http://",NEO4J_HOST,":",NEO4J_PORT,sep = ""),
                         user = NEO4J_USER,
                         password = NEO4J_PASSWD)


#return distinct node labels (Check connection)
call_neo4j("CALL db.labels();",neo_con)

#return distinct relationship types
call_neo4j("CALL db.relationshipTypes();",neo_con)
