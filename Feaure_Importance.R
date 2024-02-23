library(ggplot2)
data <- read.csv('top20.csv',header=T)
#,Feature,Importance
#0,gene1,0.030753833381823522
#1,gene2,0.026090413661674673

ggplot(data = data,
         aes(x = reorder(Feature, -Importance), y = Importance, fill = Feature)) +
           geom_bar(stat="identity") + labs(x = "Features", y = "Variable Importance") +   geom_text(aes(label = round(Importance, 4)), vjust=1.6, color="black", size=6)         +  theme_bw() +theme(legend.position = "none")+ theme(axis.title.y = element_text(size = 30)) + theme(axis.text.y = element_text(face="bold", color="black", size=30), axis.text.x = element_text(face="bold", color="black", angle=45, vjust=.8, hjust=.8, size=16))+ xlab(NULL)



STEP2_ChIPseeker <- function(){
        library(ChIPseeker)
        library(org.Hs.eg.db)
        library(TxDb.Hsapiens.UCSC.hg38.knownGene)
        txdb = TxDb.Hsapiens.UCSC.hg38.knownGene

        bed = read.table("input.bed", header=T)
        #head(bed)
        # chr   start     end
        #1 chr1  205339  205340

        peaks.gr = makeGRangesFromDataFrame(bed, keep.extra.columns=TRUE)
        peakAnno  = annotatePeak(peaks.gr,tssRegion=c(-3000,3000), TxDb=txdb, annoDb="org.Hs.eg.db")
        plotAnnoPie(peakAnno,cex =1.1) #legend size
        peak.anno = as.data.frame(peakAnno)
        write.table(peak.anno, file='anno.txt',row.names=FALSE,quote=FALSE,sep='\t')
}
