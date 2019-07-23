# Generating correlated data with mvrnorm() from the MASS library
library(MASS)

# Sample Means
mu <- c(10,700)

# Define our covariance matrix
Sigma <- matrix(c(1,25,25,1155), nrow=2, ncol=2)

# create both variables with 100 samples
set.seed(9)
vars <- mvrnorm(n=200, mu=mu, Sigma=Sigma)

# Examine the data and the correlation
head(vars)
cor(vars)
plot(vars)

df <- data.frame(Index = vars[,1], ROI = vars[,2], Group = "Meets Assumptions")

cor.test(df$Index, df$ROI)

set.seed(9)
df <- rbind(df,data.frame(
  Index = rnorm(500, 10, 2),
  ROI = rnorm(500, 700, 100),
  Group = "Does Not Meet Assumptions"
))

cor.test(df$Index, df$ROI)

# All data
df %>%
  ggplot(aes(x = Index, y = ROI)) +
  geom_point(size = 4, pch = 21, color = "black", alpha = 0.2, fill = "lightblue2")+
  scale_y_continuous(name = "ROI\n(In the Thousands)", labels = scales::dollar)+
  scale_x_continuous(name = "Involvement Index", breaks = seq(3,16,1))+
  geom_smooth(method = 'lm', fill = "lightblue", color = "blue3")+
  ggtitle(paste0("Correlation Coefficient: ",round(cor(df$Index,df$ROI),4)))+
  theme_minimal()+
  theme(plot.title = element_text(family = "serif",face = "bold", size = 18),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(family = "serif",face = "bold", size = 14),
        axis.title.y = element_text(family = "serif",face = "bold", size = 14),
        legend.background = element_rect(colour = "black"),
        legend.title = element_text(face = "bold"),
        legend.position = c(0.25,0.6))

# Assumptions Met
df %>%
  filter(Group == 'Meets Assumptions') %>%
  ggplot(aes(x = Index, y = ROI)) +
  geom_point(size = 4, pch = 21, color = "black", alpha = 0.2, fill = "lightblue2")+
  scale_y_continuous(name = "ROI\n(In the Thousands)", labels = scales::dollar)+
  scale_x_continuous(name = "Involvement Index", breaks = seq(3,16,1))+
  geom_smooth(method = 'lm', fill = "lightblue", color = "blue3")+
  ggtitle(paste0("Correlation Coefficient: ",round(cor(df$Index[df$Group == 'Meets Assumptions'],df$ROI[df$Group == 'Meets Assumptions']),4)))+
  theme_minimal()+
  theme(plot.title = element_text(family = "serif",face = "bold", size = 18),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(family = "serif",face = "bold", size = 14),
        axis.title.y = element_text(family = "serif",face = "bold", size = 14),
        legend.background = element_rect(colour = "black"),
        legend.title = element_text(face = "bold"),
        legend.position = c(0.25,0.6))

# Combined plot
df %>%
  ggplot(aes(x = Index, y = ROI, fill = Group)) +
  geom_point(size = 4, pch = 21, color = "black", alpha = 0.25)+
  scale_fill_manual(values = c("blue2", "white"))+
  scale_x_continuous(name = "Involvement Index", breaks = seq(3,16,1)) +
  scale_y_continuous(name = "ROI in Thousands", labels = scales::dollar)+
  theme_minimal()+
  theme(plot.title = element_text(family = "serif",face = "bold", size = 18),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        axis.title.x = element_text(family = "serif",face = "bold", size = 14),
        axis.title.y = element_text(family = "serif",face = "bold", size = 14),
        legend.background = element_rect(colour = "black"),
        legend.text = element_text(family = "serif",face = "bold", size = 12),
        legend.title = element_blank(),
        legend.position = c(0.2,0.8))
