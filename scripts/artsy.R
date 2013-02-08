#################################
#
# R-DAX-logo
#
# NB: do not run this script individually. Run ../main.R instead
#
################################


# >>> Visualize GARCH(1,1)
    min_yr  <- as.numeric(format(as.Date(graph_data["Date"]$Date[1]),"%Y"))
    max_yr  <- as.numeric(format(as.Date(graph_data["Date"]$Date[m]),"%Y"))
    yrs     <- (max_yr-min_yr+1)
    uvar    <- sqrt(var(index["Returns"]$Returns))
    uCL     <- mean(index["Returns"]$Returns)-uvar*qnorm(0.975)
    oCL     <- mean(index["Returns"]$Returns)+uvar*qnorm(0.975)

    p_garch <- ggplot(graph_data,aes(x=Periods)) 
    
    # -> Confidence intervals
    p_garch <- p_garch + geom_ribbon(aes(ymin=uCI, ymax=oCI), alpha=0.25)
    p_garch <- p_garch + geom_line(aes(y=uCI),colour=ggcolors2[4],alpha=0.75)
    p_garch <- p_garch + geom_line(aes(y=oCI),colour=ggcolors2[4],alpha=0.75)
    p_garch <- p_garch + geom_abline(intercept=uCL,slope=0,colour="red",size=1.25,alpha=0.25)
    p_garch <- p_garch + geom_abline(intercept=oCL,slope=0,colour="red",size=1.25,alpha=0.25)
    # --

    # -> Returns and outliers
    p_garch <- p_garch + geom_line(aes(y=Returns,colour=Return_type))
    p_garch <- p_garch + geom_point(data=graph_data_outside,aes(y=Returns,size=abs(Returns)),colour=ggcolors2[4])+
                         geom_point(data=graph_data_outside,aes(y=Returns,size=4),colour=ggcolors2[5])
    # --

    # -> Theme and visuals
    p_garch <- p_garch+theme_bw()+ggtitle(paste("GARCH(1,1)\n",yahoo_index,"first differences (from",min_yr,"to",max_yr,")"))+
               xlab("Years")+ylab("Returns")+
    theme(         
         legend.position = "none",
         plot.title = element_text(size=12, face="bold"),            
         axis.title = element_text(face="bold",size=12),
         legend.key = element_rect(colour = 'white', fill = 'white', size = 2.5, linetype=0)
    )
    p_garch <- p_garch + scale_colour_manual(values = ggcolors) + scale_fill_manual(values = ggcolors2)+
               scale_x_continuous(breaks=seq(from=0,to=m,by=ceiling(m/yrs)),labels=c(min_yr:max_yr))
    # --

    png(paste("output/GARCH_",yahoo_index,".png",sep=""),width = 800, height = 450, units = "px")
    p_garch    
    dev.off()


# <<<





