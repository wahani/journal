---
layout: post
title: "6.1.1"
author: "Sebastian"
categories:
bibliography: 
output: wahaniMiscs:::pdf_memo
---



# Barplot simple

## Preparing data

{% highlight r %}
ipsos <- read.csv2("data/alle_daten/ipsos.csv")
ipsos <- ipsos[order(ipsos$Wert),]
ipsos$Land <- ordered(ipsos$Land, ipsos$Land)
ipsos$textFamily <- ifelse(ipsos$Land %in% c("Deutschland","Brasilien"), 
                          "Lato Black", "Lato Light")
ipsos$labels <- paste0(ipsos$Land, ifelse(ipsos$Wert < 10, "     ", "  "),
                                   ipsos$Wert)
rect <- data.frame(ymin = seq(0, 80, 20), 
           ymax = seq(20, 100, 20),
           xmin = 0.5, xmax = 16.5,
           colour = rep(c(grDevices::rgb(191,239,255,80,maxColorValue=255),
                          grDevices::rgb(191,239,255,120,maxColorValue=255)), 
                        length.out = 5))
{% endhighlight %}

## barplot layers


{% highlight r %}
library(ggplot2)
ggBar <- ggplot(ipsos) + 
  geom_bar(aes(x = Land, y = Wert), stat = "identity", fill = "grey") + 
  scale_y_continuous(breaks = seq(0, 100, 20), limits = c(0, 100), expand = c(0, 0)) + 
  scale_x_discrete(labels = ipsos$labels) +
  geom_rect(data = rect, 
            mapping = aes(ymin = ymin, ymax = ymax, 
                          xmin = xmin, xmax = xmax),
                          fill = rect$colour) +
  geom_bar(aes(x = Land, y = ifelse(Land %in% c("Brasilien", "Deutschland"), Wert, NA)), 
           stat = "identity", fill = rgb(255,0,210,maxColorValue=255)) + 
  theme_minimal() +
  labs(y = "Quelle: www.ipsos-na.com, Design: Stefan Fichtel, ixtract", 
       x = NULL,
       title = "'Ich glaube fest an Gott oder ein höheres Wesen'\n...sagten 2010 in:") + 
  geom_hline(aes(yintercept = 45), colour = "skyblue3") +
  coord_flip()

ggBar + theme(panel.grid.minor = element_blank(), 
              panel.grid.major = element_blank(),
              axis.ticks = element_blank(), 
              axis.text.y = element_text(
                family = ipsos$textFamily),
              axis.title.x = element_text(
                hjust = 1,
                vjust = 0,
                size = 9),
              plot.title = element_text(
                family = "Lato Black", 
                hjust = -0.7,
                vjust = 1),
              text = element_text(family = "Lato Light"))
{% endhighlight %}



{% highlight text %}
## Warning: Removed 14 rows containing missing values (position_stack).
{% endhighlight %}

<img src="/images/images/2015-02-07-Datendesign-Barplot-simple/unnamed-chunk-3-1.png" title="center" alt="center" width="100%" />




{% highlight r %}
# weitere Elemente


text(41,20.5,"Durchschnitt",adj=1,xpd=T,cex=0.65,font=3)
text(44,20.5,"45",adj=1,xpd=T,cex=0.65,family="Lato",font=4)
text(100,20.5,"Alle Angaben in Prozent",adj=1,xpd=T,cex=0.65,font=3)
mtext(c(0,20,40,60,80,100),at=c(0,20,40,60,80,100),1,line=0,cex=0.80)

# Betitelung

mtext("'Ich glaube fest an Gott oder ein höheres Wesen'",3,line=1.3,adj=0,cex=1.2,family="Lato Black",outer=T)
mtext("...sagten 2010 in:",3,line=-0.4,adj=0,cex=0.9,outer=T)
mtext("Quelle: www.ipsos-na.com, Design: Stefan Fichtel, ixtract",1,line=1,adj=1.0,cex=0.65,outer=T,font=3)
{% endhighlight %}

