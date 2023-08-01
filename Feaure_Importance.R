library(ggplot2)
data <- read.csv('top20.csv',header=T)
#,Feature,Importance
#0,gene1,0.030753833381823522
#1,gene2,0.026090413661674673

ggplot(data = data,
         aes(x = reorder(Feature, -Importance), y = Importance, fill = Feature)) +
           geom_bar(stat="identity") + labs(x = "Features", y = "Variable Importance") +   geom_text(aes(label = round(Importance, 4)), vjust=1.6, color="black", size=6)         +  theme_bw() +theme(legend.position = "none")+ theme(axis.title.y = element_text(size = 30)) + theme(axis.text.y = element_text(face="bold", color="black", size=30), axis.text.x = element_text(face="bold", color="black", angle=45, vjust=.8, hjust=.8, size=16))+ xlab(NULL)
