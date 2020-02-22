spda <- function(df){
  numericCols <- unlist(lapply(df, is.numeric))
  df_numeric <- df[ , numericCols]
  
  correlation_results <- data.frame(Variable_One = character(),
                                    Variable_Two = character(),
                                    Corr_Coeff_Original = numeric(),
                                    N_Original = numeric())
  
  n_orig <- nrow(df)
  
  for(i in 1:ncol(df_numeric)){
    for(j in 1:ncol(df_numeric)){
      
      if(i != j & i < j){
        
        if(length(df_numeric[,i]) >= 10){
          t <- cor.test(df_numeric[,i], df_numeric[,j])
          if(!is.na(t$p.value)){
            if(t$p.value < 0.05){cor_i_j<-cor(df_numeric[,i], df_numeric[,j])}else{cor_i_j<-NA}
          } else{cor_i_j<-NA}
        } else{cor_i_j<-NA}
        
        
        correlation_results <- rbind(correlation_results, data.frame(
          Variable_One = names(df)[i],
          Variable_Two = names(df)[j], 
          Corr_Coeff_Original = cor_i_j,
          N_Original = n_orig
        ))
      }
    }
  }
  
  factorCols <- unlist(lapply(df, is.factor))
  df_factor <- data.frame(df[ , factorCols])
  colnames(df_factor) <- names(df)[factorCols]
  
  correlation_results_group <- data.frame(Variable_One = character(), 
                                          Variable_Two = character(),
                                          Variable_Group = character(),
                                          Variable_Level = character(),
                                          Corr_Coeff_Group = numeric(),
                                          N_Group = numeric())
  
  # For each factor variable, for each level
  for(g in 1:ncol(df_factor)){
    for(l in 1:length(levels(df_factor[,g]))){
      
      vargroup <- names(df_factor)[g]
      level <- levels(df_factor[,g])[l]
      
      for(i in 1:ncol(df_numeric)){
        for(j in 1:ncol(df_numeric)){
          
          var1 <- names(df_numeric)[i]
          var2 <- names(df_numeric)[j]
          
          if(i != j & i < j){
            
            vec <- df[vargroup][,1] == level
            sub_df <- df[vec,]
            n <- nrow(sub_df)
            
            if(length(sub_df[var1][,1]) >= 10){
              t <- cor.test(sub_df[var1][,1], sub_df[var2][,1])
              if(!is.na(t$p.value)){
                if(t$p.value < 0.05){cor_i_j<-cor(sub_df[var1][,1], sub_df[var2][,1])}else{cor_i_j<-NA}
              } else {cor_i_j<-NA}
            } else {cor_i_j<-NA}
            
            correlation_results_group <- rbind(correlation_results_group, data.frame(Variable_One = var1, 
                                                                                     Variable_Two = var2,
                                                                                     Variable_Group = vargroup,
                                                                                     Variable_Level = level,
                                                                                     Corr_Coeff_Group = cor_i_j,
                                                                                     N_Group = n))
          }
        }
      }
    }
  }
  
  correlation_totals <- merge(correlation_results, correlation_results_group,  by=c("Variable_One","Variable_Two"))
  
  r_to_z <- function(r){return(5*(log(1+abs(r))-log(1-abs(r))))}
  
  correlation_totals$Corr_Coeff_Original_Z <- r_to_z(correlation_totals$Corr_Coeff_Original)
  correlation_totals$Corr_Coeff_Group_Z <- r_to_z(correlation_totals$Corr_Coeff_Group)
  
  correlation_totals$z_observed = (correlation_totals$Corr_Coeff_Original_Z - correlation_totals$Corr_Coeff_Group_Z)/sqrt(1/(correlation_totals$N_Original - 3)+1/(correlation_totals$N_Group - 3))
  

  
  return(correlation_totals)
  
  
}

spda(iris)
