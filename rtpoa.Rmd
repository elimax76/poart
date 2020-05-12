---
title: "Rt POA"
author: "Elizandro Max Borba"
date: "12 de maio de 2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(dplyr)
library(xts)
library(dygraphs)
```

## Número reprodutivo efetivo em Porto ALegre

Caçlculando usando o número de infectados conforme dados divulgados em  <https://prefeitura.poa.br/coronavirus>.


```{r all, echo=FALSE, warning=FALSE}
#poa
infectados=c(1,1,1,2,3,3,5,8,10,17,22,29,50,61,66,73,74,82,91,92,91,97,99,114,125,136,162,179,187,185,186,194,195,183,181,186,194,185,188,171,172,187,189,190,198,209,204,206,208,190,185,184,189,187,170,178,185,186,191,194,186,167,159,178,191,179,192,215)
sdis=dgamma(0:14,4) #serial interval distribution of covid-19
library(EpiEstim)
res <- estimate_R(incid = infectados,
method = "non_parametric_si",
config = make_config(list(si_distr = sdis)))
ini=as.Date('2020-03-05') #poa
dur=length(res$R$t_end)
data <- data.frame(
  time= seq(from=ini, to=ini+dur-1,by=1),
  trend=res$R$`Mean(R)`, 
  max=res$R$`Quantile.0.95(R)`, 
  min=res$R$`Quantile.0.05(R)`
)
data=data[which(data$time>as.Date('2020-03-15')),] #poa,rs
# switch to xts format
datats <- xts(x = data[,-1], order.by = data$time)

# Plot
p <- dygraph(datats) %>% dySeries(c("min", "trend", "max"))
p
```
