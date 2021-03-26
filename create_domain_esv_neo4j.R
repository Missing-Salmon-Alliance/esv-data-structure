###################
# ESV's have been drafted and matched to domains
# They exist in an excel spreadsheet, this script will import them and make the domain relationships
##################

# Read in XL
esvData <- readxl::read_xlsx('./ESV_Summary.xlsx', skip = 1)
esvData

####
# Build new Domains and ESV nodes
####

# Codify esv's
esvData$code <- paste('esv',1:61, sep = '')

# subset out ESV's for use as ESV node creation source
esvNodes <- esvData[,c('Variable','Group','code')]
esvNodes$description <- '' # TODO Write Some descriptions!

# rename columns to fit schema
names(esvNodes) <- c('esvTitle','esvCategory','esvLabel','esvDescription') # note change Group to Category


# Extract domain names for domain node creation source
domainNodes <- names(esvData[,c(3:10)])
tempTibble <- tibble(domainNodes)
tempTibble$code <- paste('dom',1:8, sep = '') # Codify
tempTibble$description <- '' # TODO write some descriptions!
tempTibble$environment <- c('Freshwater','Freshwater','Freshwater','Marine','Marine','Marine','Marine','Marine') # useful categorisation
names(tempTibble) <- c('domainTitle','domainLabel','domainDescription','domainEnvironment') # rename columns to fit schema
domainNodes <- tempTibble # pass to final tibble

####
# Start on relationship creation
####

# replace domain names with codes in esvData
names(esvData) <- c('Variable','Group',paste('dom',1:8, sep = ''),'code')

# Replace NA and x with 0 and 1 to make adjacency matrix
esvData[esvData == 'x'] <- '1'
esvData <- tidyr::replace_na(esvData, as.list(setNames(rep(0,9),names(esvData[,c(3:10)]))))


# create adjacency matrix with rows being codified ESV and columns being codified domains
esvAdjMatrix <- as.matrix(esvData[,c(3:10)])
rownames(esvAdjMatrix) <- esvData$code

# Create edgelist from adjacency matrix
esvEdgelist <- reshape2::melt(esvAdjMatrix) %>% filter(value == '1')

####
# Pass nodes lists and edgelists in to the graph
####

# Create Domain Nodes
for(x in 1:nrow(domainNodes)){
  query <- paste("CREATE (:Domain{domainLabel:'",domainNodes[x,]$domainLabel,
                 "',domainTitle:'",domainNodes[x,]$domainTitle,
                 "',domainDescription:'",domainNodes[x,]$domainDescription,
                 "',domainEnvironment:'",domainNodes[x,]$domainEnvironment,
                 "'})", sep = '')
  print(query)
  call_neo4j(query,neo_con,type = 'row',include_stats = TRUE)
}

# Create ESV Nodes
for(x in 1:nrow(esvNodes)){
  query <- paste("CREATE (:EssentialSalmonVariable{esvLabel:'",esvNodes[x,]$esvLabel,
                 "',esvTitle:'",esvNodes[x,]$esvTitle,
                 "',esvDescription:'",esvNodes[x,]$esvDescription,
                 "',esvCategory:'",esvNodes[x,]$esvCategory,
                 "'})", sep = '')
  print(query)
  call_neo4j(query,neo_con,type = 'row',include_stats = TRUE)
}


# Create relationships

for(x in 1:nrow(esvEdgelist)){
  query <- paste("MATCH (n:EssentialSalmonVariable{esvLabel:'",esvEdgelist[x,]$Var1,"'}),(m:Domain{domainLabel:'",esvEdgelist[x,]$Var2,"'}) CREATE (n)-[:HAS_DOMAIN]->(m);",sep = "")
  #print(query)
  call_neo4j(query,neo_con,type = 'row',include_stats = TRUE)
}


# Demo calls
call_neo4j("MATCH (n:EssentialSalmonVariable) RETURN n;", neo_con, type = "row")
call_neo4j("MATCH (n:Domain) RETURN n;", neo_con, type = "row")


G <- igraph::graph_from_edgelist(as.matrix(esvEdgelist[,c(1,2)]))
visIgraph(G)
