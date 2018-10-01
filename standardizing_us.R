###############################################################
### Standardizing US States to Their 2-Letter Abbreviations ###
###############################################################

Mess2Abbr <- function(str, proxy = FALSE, proxyPath = NULL){
  require(dplyr)
  require(rvest)
  
  url <- "https://offices.net/misspelled-state-names.htm"
  
  # When dealing with a proxy
  if(proxy){
    download.file(url, destfile = proxyPath)
    content <- read_html(proxyPath) 
    misspells <- content %>%
      html_nodes(xpath='//*[@id="main"]/div[1]/table[1]') %>%
      html_table() %>%
      data.frame
  } 
  else{  
    misspells <- url %>%
      html() %>%
      html_nodes(xpath='//*[@id="main"]/div[1]/table[1]') %>%
      html_table() %>%
      data.frame
  }
  
  colnames(misspells) <- c("State", "Misspelling")
  misspells <- misspells %>%
    filter(nchar(State) > 1)
  
  misspells <- misspells %>%
    mutate(Misspelling = gsub("Commonly misspelled as ","",Misspelling))
  
  misspells <- misspells %>%
    mutate(Misspelling2 = gsub(" ","",toupper(Misspelling)),
           State2 = gsub(" ","",toupper(State)))
  
  for(i in 1:nrow(misspells)){
    misspells$Abbr[i] <- state.abb[grep(misspells$State[i], http://state.name)]
  }
  
  misspells1 <- misspells %>%
    mutate(State = State2) %>%
    select(State, Abbr)
  
  misspells2 <- misspells %>%
    mutate(State = Misspelling2) %>%
    select(State, Abbr)
  
  all <- rbind(misspells1,misspells2)
  
  # Fixing Wisconsin Error on Site
  all <- all %>%
    mutate(Abbr = case_when(State == "WISCONSON"~"WI", TRUE ~ Abbr))
  
  # Adding in any that are missing
  usStates <- data.frame(State = http://state.name, Abbr = state.abb)
  usStates <- usStates %>%
    mutate(State = gsub(" ","",toupper(State)))
  
  all <- rbind(all,usStates)
  all <-unique(all)
  
  # Now checking our string
  str <- as.character(str)
  str <- toupper(str)
  str <- gsub(" ", "", str, fixed = TRUE)
  
  # Output
  all %>% filter(State == str) %>% select(Abbr) %>% as.character
  
}

# Regular
Mess2Abbr("Wisconsin", proxy = TRUE, proxyPath = "http://C://Users//jwayland//Desktop//misspells.html")

# Misspelled
Mess2Abbr("Wisconson", proxy = TRUE, proxyPath = "http://C://Users//jwayland//Desktop//misspells.html")

# Case Sensitivity
Mess2Abbr("wISconsin", proxy = TRUE, proxyPath = "http://C://Users//jwayland//Desktop//misspells.html")