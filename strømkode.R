library(chron)

forbruk = data.frame(read.csv("08_strom.csv", sep = ";"), stringsAsFactors=FALSE)
forbruk_tid <- data.frame(lapply(forbruk[1], as.character), stringsAsFactors=FALSE)
forbruk_verdi <- data.frame(lapply(forbruk[3], as.double))
forbruk = data.frame(fra = forbruk_tid, verdi = forbruk_verdi)
colnames(forbruk) = c("fra", "verdi")


dtparts = t(as.data.frame(strsplit(forbruk$fra, ' ')))
row.names(dtparts) = NULL
dates = as.chron(dtparts[,1], '%d.%m.%Y')
times = as.chron(dtparts[,2], '%H:%M')
thetimes = as.chron(forbruk$fra, "%d.%m.%Y %H:%M")

forbruk = cbind(dtparts, forbruk_verdi)
colnames(forbruk) = c("dato", "tid", "verdi")

library(ggplot2)
ggplot(forbruk, aes(x = dato, y = verdi))+
  geom_col(aes(fill = tid))+
  theme(axis.text.x = element_text(angle = 90))
