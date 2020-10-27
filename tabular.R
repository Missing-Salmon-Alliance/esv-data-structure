# Tabular Format

#ESV Structure #
# # #

#NOTES:
# Start with Domain level, identify what are the Prey, Predator, Competitor... then what are the Biological Control, Physical Controls
# OR
# Start with domain, expand out to physical controls, expand out to primary effects on subjects, hook in secondary effects from prey, competitor, predator to salmon
# align to conceptual diagram
# 
# Separation from salmon and the remaining related variables
# 

domain <- c("River Rearing Juvenile",
            "River Migration Smolt",
            "Estuary Migration Smolt",
            "Coastal Migration Post-smolt",
            "Continental-shelf Migration Post-smolt",
            "Ocean Feeding Near-mature",
            "Ocean Migration Mature",
            "Coastal Migration Mature",
            "Estuary Migration Mature",
            "River Migration Mature",
            "River Spawning Mature")
controls <- c("Physical Controls", "Biological Controls")
timestep <- c("Immediate", "Prior") # also apply Primary/Secondary effect level within
location <- c("Local", "Remote")
affects <- c("Salmon", "Prey", "Competitor", "Predator")
response <- c("Metrics")
level <- c("Individual", "Population")

# # # These are Responses to the environment, so should come last
metrics <- c("date",
             "location",
             "body length",
             "sex",
             "body weight",
             "abundance index",
             "indicators of health/condition",
             "age",
             "origin",
             "gape size",
             "diet index",
             "swim speed",
             "maturation status",
             "energy reserves index")

# # #
physicalControls <- c("date",
                      "location",
                      "water temperature",
                      "salinity",
                      "surface current strength",
                      "nutrients",
                      "chlorophyll a",
                      "secondary production index",
                      "water clarity index",
                      "surface current direction",
                      "spring flood index",
                      "winter air temperature",
                      "winter water temperature",
                      "alkalinity",
                      "altitude",
                      "stream order")
