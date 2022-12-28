#' @getPurpleairApiHistory

#' R function to download historical data from PurpleAir sensors in the newer API.

#' @Usage

#' getPurpleairApiHistory(
#'     sensorIndex,  
#'     apiReadKey,
#'     startTimeStamp,
#'     endTimeStamp,
#'     average,
#'     fields
#' )

#' @Arguments
#' Argment 	Description
#' sensorIndex 	The sensor index found in the url (?select=sensor_index) of a selected sensor in the purpleair maps purpleair map.
#' apiReadKey 	PurpleAir API read key with access to historical data. See PurpleAir Community website for more information.
#' startTimeStamp 	The beginning date in the format "YYYY-MM-DD HH:mm:ss".
#' endTimeStamp 	The end date in the format "YYYY-MM-DD" HH:mm:ss.
#' average 	The desired average in minutes, one of the following: "0" (real-time), "10", "30", "60", "360" (6 hour), "1440" (1 day).
#' fields 	The "Fields" parameter specifies which 'sensor data fields' to include in the response.

#' @Value
#' Dataframe of PurpleAir history data of a single sensor or multiple sensors.

#' @References
#' PurpleAir API.

#' @Examples
#' @For a single sensor

#' getPurpleairApiHistory(
#'     sensorIndex="31105",  
#'     apiReadKey="43664AA0-305B-11ED-B5AA-42010A800010",
#'     startTimeStamp="2022-12-26 00:00:00",
#'     endTimeStamp="2022-12-26 23:59:59",
#'     average="10"
#'     fields=c("pm2.5_atm, pm2.5_atm_a, pm2.5_atm_b")
#' )

#' @For multiple sensors

#' getPurpleairApiHistory(
#'     sensorIndex=c("31105","31105","57177"),  
#'     apiReadKey="43664AA0-305B-11ED-B5AA-42010A800010",
#'     startTimeStamp="2022-12-26 00:00:00",
#'     endTimeStamp="2022-12-26 23:59:59",
#'     average="10"
#'     fields=c("pm2.5_atm, pm2.5_atm_a, pm2.5_atm_b")
#' )

getPurpleairApiHistory <- function(
    sensorIndex=NULL,  
    apiReadKey=NULL,
    startTimeStamp=NULL,
    endTimeStamp=NULL,
    average = NULL,
    fields = NULL
) {
  # Load packages
  if (!require('httr')) {
    install.packages('httr')
    library(httr)
  }
  if (!require('jsonlite')) {
    install.packages('jsonlite')
    library(jsonlite)
  }
  if (!require('tidyverse')) {
    install.packages('tidyverse')
    library(tidyverse)
  }
  if (!require('lubridate')) {
    install.packages('lubridate')
    library(lubridate)
  }
  if (!require('httpcode')) {
    install.packages('httpcode')
    library(httpcode)
  }
  if (!require('tcltk')) {
    install.packages('tcltk')
    library(tcltk)
  }
  
  # Validate parameters
  if ( is.null(sensorIndex) ) {
    stop("sensorIndex not defined!")
  }
  if ( is.null(apiReadKey) ) {
    stop("apiReadKey not defined!")
  }
  if ( is.null(startTimeStamp) ) {
    stop("startTimeStamp not defined!")
  }
  if ( is.null(endTimeStamp) ) {
    stop("endTimeStamp not defined!")
  }
  if ( is.null(average) ) {
    stop("average not defined!")
  }
  if ( is.null(fields) ) {
    stop("fields not defined!")
  }
  
  # Set Time Stamp
  t_dif <- as.POSIXct(endTimeStamp) - as.POSIXct(startTimeStamp)

  if (t_dif < as.difftime(48, units = 'hours') ) {
    start_timestamps <- as.POSIXct(startTimeStamp)
  
    end_timestamps   <- as.POSIXct(endTimeStamp) 
  } else {
    start_timestamps <- seq(from=as.POSIXct(startTimeStamp)
                          ,to=as.POSIXct(endTimeStamp),by="2 days")
  
    end_timestamps   <- seq(from=as.POSIXct(startTimeStamp) + as.difftime(172799, units = 'secs')
                          ,to=as.POSIXct(endTimeStamp),by="2 days")

    if(length(start_timestamps) != length(end_timestamps)) {
      end_timestamps   <- c(end_timestamps, as.POSIXct(endTimeStamp))
    }
  }

  # Set variables for fill missing dates
  if (average == "10") {
    dif <- as.difftime(10, units = 'mins')
    
    other_df <- data.frame(time_stamp = seq(from = lubridate::parse_date_time(format(as.POSIXlt(startTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                        ,orders = "b d Y H:M:S")
                                      ,to = lubridate::parse_date_time(format(as.POSIXlt(endTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                       ,orders = "b d Y H:M:S")
                                      ,by = dif))
  } else if (average == "30") {
    dif <- as.difftime(30, units = 'mins')
    
    other_df <- data.frame(time_stamp = seq(from = lubridate::parse_date_time(format(as.POSIXlt(startTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                        ,orders = "b d Y H:M:S")
                                      ,to = lubridate::parse_date_time(format(as.POSIXlt(endTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                       ,orders = "b d Y H:M:S")
                                      ,by = dif))
  } else if (average == "60") {
    dif <- as.difftime(60, units = 'mins')
    
    other_df <- data.frame(time_stamp = seq(from = lubridate::parse_date_time(format(as.POSIXlt(startTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                        ,orders = "b d Y H:M:S")
                                      ,to = lubridate::parse_date_time(format(as.POSIXlt(endTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                       ,orders = "b d Y H:M:S")
                                      ,by = dif))
  } else if (average == "360") {
    dif <- as.difftime(360, units = 'mins')
    
    other_df <- data.frame(time_stamp = seq(from = lubridate::parse_date_time(format(as.POSIXlt(startTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                        ,orders = "b d Y H:M:S")
                                      ,to = lubridate::parse_date_time(format(as.POSIXlt(endTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                       ,orders = "b d Y H:M:S")
                                      ,by = dif))
  } else if (average == "1440") {
    dif <- as.difftime(1440, units = 'mins')
    
    other_df <- data.frame(time_stamp = seq(from = lubridate::parse_date_time(format(as.POSIXlt(startTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                        ,orders = "b d Y H:M:S")
                                      ,to = lubridate::parse_date_time(format(as.POSIXlt(endTimeStamp), "%b %d %Y %H:%M:%S"),tz=Sys.timezone()
                                                                       ,orders = "b d Y H:M:S")
                                      ,by = dif))
  }
  
  # Loop for multiples requests in PurpleAir API
  if ( length(sensorIndex) > 1 ) {
    # Loop objects
    r     <- data.frame()
    r_for <- data.frame()
    
    n     <- length(sensorIndex)
    
    pb <- tkProgressBar(title = "Progress bar",      # Window title
                        label = "Percentage completed", # Window label
                        min = 0,      # Minimum value of the bar
                        max = n, # Maximum value of the bar
                        initial = 0,  # Initial value of the bar
                        width = 300)  # Width of the window
    
    for (i in 1:length(sensorIndex)) {
      URLbase <- paste0('https://api.purpleair.com/v1/sensors/',sensorIndex[i], '/history') 
      
      for (j in 1:length(start_timestamps)) {
        # Set variables
        queryList = list(
          start_timestamp = as.character(as.integer(as.POSIXct(start_timestamps[j], "America/Bogota"))),
          end_timestamp = as.character(as.integer(as.POSIXct(end_timestamps[j], "America/Bogota"))),
          average = average,
          fields = fields)
        
        # GET PurpleAir sensor history data
        r_temp <- httr::GET(
          URLbase,
          query = queryList,
          config = add_headers("X-API-Key" = Read_Key)
        )
        
        # Error response
        if ( httr::http_error(r_temp) ) {  # web service failed to respond
          
          status_code <- httr::status_code(r_temp)
          
          err_msg <- sprintf(
            "web service error %s from:\n  %s\n\n%s",
            status_code,
            webserviceUrl,
            httpcode::http_code(status_code)$explanation
          )
          
          if ( logger.isInitialized() ) {
            logger.error("Web service failed to respond: %s", webserviceUrl)
            logger.error(err_msg)
          }
          
          stop(err_msg)
          
        }
        
        # Structurized data in form of R vectors and lists
        r_parsed <- fromJSON(content(r_temp, as="text"))
        
        # Data frame from JSON data
        r_dataframe <- as.data.frame(r_parsed$data)
        
        if (length(r_dataframe) == 0) {
          rm(r_dataframe)
          r_dataframe <- data.frame(matrix(ncol = length(r_parsed$fields), nrow = 1))
          names(r_dataframe) <- r_parsed$fields
          r_dataframe$time_stamp <- as.character(as.integer(as.POSIXct(start_timestamps[j], "America/Bogota")))
        }else{
          names(r_dataframe) <- r_parsed$fields
        }
        r_dataframe
        
        # Convert datetime format
        r_dataframe$time_stamp <- as.integer(r_dataframe$time_stamp)
        r_dataframe$time_stamp <- as.POSIXlt(r_dataframe$time_stamp, origin="1970-01-01",  tz='America/Bogota')
        
        # Fill missing dates
        if (average != "0") {
          other_df$time_stamp <- as.POSIXlt(other_df$time_stamp)
          r_dataframe                   <- dplyr::full_join(other_df, r_dataframe)
        }
        
        ## Order by date
        r_dataframe <- r_dataframe[order(r_dataframe$time_stamp),]
        
        r_for <- rbind(r_for, r_dataframe)
        
      }
      
      # Add basic information
      if (nrow(r_for) != 0) {
        r_for$sensor_id   <- sensor_id_list[i]
      }
      
      # Set final request data frame
      r <- rbind(r, r_for)
      r_for <- data.frame()
      
      # Monitoring progress
      pctg <- paste(round(i/n *100, 0), "% completed")
      setTkProgressBar(pb, i, label = pctg)
    }
    
    close(pb) # Close progress bar
    
  } else {
    # Loop objects
    URLbase <- paste0('https://api.purpleair.com/v1/sensors/',sensorIndex,'/history') 
    r     <- data.frame()
    r_for <- data.frame()
    
    n     <- length(start_timestamps)
    
    pb <- tkProgressBar(title = "Progress bar",      # Window title
                        label = "Percentage completed", # Window label
                        min = 0,      # Minimum value of the bar
                        max = n, # Maximum value of the bar
                        initial = 0,  # Initial value of the bar
                        width = 300)  # Width of the window
    
    for (j in 1:length(start_timestamps)) {
      # Set variables
      queryList = list(
        start_timestamp = as.character(as.integer(as.POSIXct(start_timestamps[j], "America/Bogota"))),
        end_timestamp = as.character(as.integer(as.POSIXct(end_timestamps[j], "America/Bogota"))),
        average = average,
        fields = fields)
      
      # GET PurpleAir sensor history data
      r_temp <- httr::GET(
        URLbase,
        query = queryList,
        config = add_headers("X-API-Key" = Read_Key)
      )
      
      # Error response
      if ( httr::http_error(r_temp) ) {  # web service failed to respond
        
        status_code <- httr::status_code(r_temp)
        
        err_msg <- sprintf(
          "web service error %s from:\n  %s\n\n%s",
          status_code,
          webserviceUrl,
          httpcode::http_code(status_code)$explanation
        )
        
        if ( logger.isInitialized() ) {
          logger.error("Web service failed to respond: %s", webserviceUrl)
          logger.error(err_msg)
        }
        
        stop(err_msg)
        
      }
      
      # Structurized data in form of R vectors and lists
      r_parsed <- fromJSON(content(r_temp, as="text"))
      
      # Data frame from JSON data
      r_dataframe <- as.data.frame(r_parsed$data)
      
      if (length(r_dataframe) == 0) {
        rm(r_dataframe)
        r_dataframe <- as.data.frame(data.frame(matrix(ncol = length(r_parsed$fields), nrow = 1)))
        names(r_dataframe) <- r_parsed$fields
        r_dataframe$time_stamp <- as.integer(as.POSIXct(start_timestamps[j], "America/Bogota"))
      }else{
        names(r_dataframe) <- r_parsed$fields
      }
      
      ## Convert datetime format
      r_dataframe$time_stamp <- as.integer(r_dataframe$time_stamp)
      r_dataframe$time_stamp <- as.POSIXlt(r_dataframe$time_stamp, origin="1970-01-01",  tz='America/Bogota')
      
      # Fill missing dates
      if (average != "0") {
        other_df$time_stamp <- as.POSIXlt(other_df$time_stamp)
        r_dataframe                   <- dplyr::full_join(other_df, r_dataframe)
      }
      
      ## Order by date
      r_dataframe <- r_dataframe[order(r_dataframe$time_stamp),]
      
      r_for <- rbind(r_for, r_dataframe)
      
      # Monitoring progress
      pctg <- paste(round(j/n *100, 0), "% completed")
      setTkProgressBar(pb, j, label = pctg)
      
    }
    
    close(pb) # Close progress bar
    
    # Add basic information
    if (nrow(r_for) != 0) {
      r_for$sensor_id   <- sensorIndex
    }
    
    # Set final request data frame
    r <- r_for
    
  }
  
  return(r)
  
}