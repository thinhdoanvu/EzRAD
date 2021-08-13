#How to install necessary files:
#--------------------------------------------
# Install 4 Ubuntu
#    sudo add-apt-repository -y ppa:cran/ffmpeg-3
#    sudo apt-get update
#    sudo apt-get install -y libavfilter-dev
#    sudo apt-get install cargo
# Install 4 R
#    install.package("gifski")
#    install.package("av")
#    install.package("gganimate")
#--------------------------------------------
#Tutorial:
#https://gganimate.com/articles/gganimate.html
#--------------------------------------------
library(gifski)
library(av)
library(ggplot2)
library(gganimate)
library(dplyr)
#--------------------------------------------
vn_covid19 <- read.csv("~/Programs/Ranination/covid19_VN.csv")
vn_covid19_April <- filter(vn_covid19, Thang == 4)
vn_covid19_May <- filter(vn_covid19, Thang == 5)
vn_covid19_June <- filter(vn_covid19, Thang == 6)
vn_covid19_July <- filter(vn_covid19, Thang == 7)
vn_covid19_August <- filter(vn_covid19, Thang == 8)

#------------------------------------------------
#Data 4 April
vn_covid19_April_formatted <- vn_covid19_April %>%
  group_by(Date) %>%
  mutate(rank = rank(-Soluong),
         Value_lbl = paste0(" ",Soluong)) %>%
  group_by(Diaphuong) %>% 
  filter(rank <=10) %>%
  ungroup()

#------------------------------------------------
#Data 4 May
vn_covid19_May_formatted <- vn_covid19_May %>%
  group_by(Date) %>%
  mutate(rank = rank(-Soluong),
         Value_lbl = paste0(" ",Soluong)) %>%
  group_by(Diaphuong) %>% 
  filter(rank <=10) %>%
  ungroup()

#------------------------------------------------
#Data 4 June
vn_covid19_June_formatted <- vn_covid19_June %>%
  group_by(Date) %>%
  mutate(rank = rank(-Soluong),
         Value_lbl = paste0(" ",Soluong)) %>%
  group_by(Diaphuong) %>% 
  filter(rank <=10) %>%
  ungroup()
  
#------------------------------------------------
#Data 4 July
vn_covid19_July_formatted <- vn_covid19_July %>%
  group_by(Date) %>%
  mutate(rank = rank(-Soluong),
         Value_lbl = paste0(" ",Soluong)) %>%
  group_by(Diaphuong) %>% 
  filter(rank <=10) %>%
  ungroup()

#------------------------------------------------
#Data 4 August
vn_covid19_August_formatted <- vn_covid19_August %>%
  group_by(Date) %>%
  mutate(rank = rank(-Soluong),
         Value_lbl = paste0(" ",Soluong)) %>%
  group_by(Diaphuong) %>% 
  filter(rank <=10) %>%
  ungroup()

#------------------------------------------------
#Graphic 4 April
staticplot_4 = ggplot(vn_covid19_April_formatted , aes(rank, group = Diaphuong, 
                                        fill = as.factor(Diaphuong), color = as.factor(Diaphuong))) +
  geom_tile(aes(y = Soluong/2,
                height = Soluong,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(Diaphuong, " ")), vjust = 0.2, hjust = 1) +
  geom_text(aes(y=Soluong,label = Value_lbl, hjust=0)) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line( size=.1, color="grey" ),
        panel.grid.minor.x = element_line( size=.1, color="grey" ),
        plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
        plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
        plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
        plot.background=element_blank(),
        plot.margin = margin(2,2, 2, 4, "cm"))

#------------------------------------------------
#Graphic 4 May
staticplot_5 = ggplot(vn_covid19_May_formatted , aes(rank, group = Diaphuong, 
                                        fill = as.factor(Diaphuong), color = as.factor(Diaphuong))) +
  geom_tile(aes(y = Soluong/2,
                height = Soluong,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(Diaphuong, " ")), vjust = 0.2, hjust = 1) +
  geom_text(aes(y=Soluong,label = Value_lbl, hjust=0)) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line( size=.1, color="grey" ),
        panel.grid.minor.x = element_line( size=.1, color="grey" ),
        plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
        plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
        plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
        plot.background=element_blank(),
        plot.margin = margin(2,2, 2, 4, "cm"))

#------------------------------------------------
#Graphic 4 June
staticplot_6 = ggplot(vn_covid19_June_formatted , aes(rank, group = Diaphuong, 
                                        fill = as.factor(Diaphuong), color = as.factor(Diaphuong))) +
  geom_tile(aes(y = Soluong/2,
                height = Soluong,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(Diaphuong, " ")), vjust = 0.2, hjust = 1) +
  geom_text(aes(y=Soluong,label = Value_lbl, hjust=0)) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line( size=.1, color="grey" ),
        panel.grid.minor.x = element_line( size=.1, color="grey" ),
        plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
        plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
        plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
        plot.background=element_blank(),
        plot.margin = margin(2,2, 2, 4, "cm"))

#------------------------------------------------
#Graphic 4 July
staticplot_7 = ggplot(vn_covid19_July_formatted , aes(rank, group = Diaphuong, 
                                        fill = as.factor(Diaphuong), color = as.factor(Diaphuong))) +
  geom_tile(aes(y = Soluong/2,
                height = Soluong,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(Diaphuong, " ")), vjust = 0.2, hjust = 1) +
  geom_text(aes(y=Soluong,label = Value_lbl, hjust=0)) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line( size=.1, color="grey" ),
        panel.grid.minor.x = element_line( size=.1, color="grey" ),
        plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
        plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
        plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
        plot.background=element_blank(),
        plot.margin = margin(2,2, 2, 4, "cm"))

#------------------------------------------------
#Graphic 4 August
staticplot_8 = ggplot(vn_covid19_August_formatted , aes(rank, group = Diaphuong, 
                                        fill = as.factor(Diaphuong), color = as.factor(Diaphuong))) +
  geom_tile(aes(y = Soluong/2,
                height = Soluong,
                width = 0.9), alpha = 0.8, color = NA) +
  geom_text(aes(y = 0, label = paste(Diaphuong, " ")), vjust = 0.2, hjust = 1) +
  geom_text(aes(y=Soluong,label = Value_lbl, hjust=0)) +
  coord_flip(clip = "off", expand = FALSE) +
  scale_y_continuous(labels = scales::comma) +
  scale_x_reverse() +
  guides(color = FALSE, fill = FALSE) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.grid.major.x = element_line( size=.1, color="grey" ),
        panel.grid.minor.x = element_line( size=.1, color="grey" ),
        plot.title=element_text(size=25, hjust=0.5, face="bold", colour="grey", vjust=-1),
        plot.subtitle=element_text(size=18, hjust=0.5, face="italic", color="grey"),
        plot.caption =element_text(size=8, hjust=0.5, face="italic", color="grey"),
        plot.background=element_blank(),
        plot.margin = margin(2,2, 2, 4, "cm"))

#------------------------------------------------
#Animation 4 April
anim_4 = staticplot_4 + transition_states(Date, transition_length = 4, state_length = 1) +
  view_follow(fixed_x = TRUE)  +
  labs(title = 'Tong so ca den : {closest_state}',  
       subtitle  =  "   ",
       caption  = "Data Source: https://ncov.vncdc.gov.vn/viet-nam.html")

#------------------------------------------------
#Animation 4 May
anim_5 = staticplot_5 + transition_states(Date, transition_length = 4, state_length = 1) +
  view_follow(fixed_x = TRUE)  +
  labs(title = 'Tong so ca den : {closest_state}',  
       subtitle  =  "   ",
       caption  = "Data Source: https://ncov.vncdc.gov.vn/viet-nam.html")

#------------------------------------------------
#Animation 4 June
anim_6 = staticplot_6 + transition_states(Date, transition_length = 4, state_length = 1) +
  view_follow(fixed_x = TRUE)  +
  labs(title = 'Tong so ca den : {closest_state}',  
       subtitle  =  "   ",
       caption  = "Data Source: https://ncov.vncdc.gov.vn/viet-nam.html")
#------------------------------------------------
#Animation 4 July
anim_7 = staticplot_7 + transition_states(Date, transition_length = 4, state_length = 1) +
  view_follow(fixed_x = TRUE)  +
  labs(title = 'Tong so ca den : {closest_state}',  
       subtitle  =  "   ",
       caption  = "Data Source: https://ncov.vncdc.gov.vn/viet-nam.html")

#------------------------------------------------
#Animation 4 August
anim_8 = staticplot_8 + transition_states(Date, transition_length = 4, state_length = 1) +
  view_follow(fixed_x = TRUE)  +
  labs(title = 'Tong so ca den : {closest_state}',  
       subtitle  =  "   ",
       caption  = "Data Source: https://ncov.vncdc.gov.vn/viet-nam.html")

#Gif files
anim_4
anim_5
anim_6
anim_7
anim_8
#Save to gif files
