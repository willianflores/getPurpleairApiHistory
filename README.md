# getPurpleairApiHistory

R function to download historical data from PurpleAir sensors in the newer API.

## Usage
```r
getPurpleairApiHistory(
    sensorIndex,  
    apiReadKey,
    startTimeStamp,
    endTimeStamp,
    average,
    fields
)
```

## Arguments
| Argment | Description |
| --- | --- |
| `sensorIndex` | The sensor index or list of sensor index. Sensor index is found in the url (`?select=sensor_index`) of a selected sensor in the [purpleair map](https://map.purpleair.com/1/mPM25/a10/p31536000/cC4?select=3968#10.91/-10.0081/-67.8154). |
| `apiReadKey` | PurpleAir API read key with access to historical data. See [PurpleAir Community](https://community.purpleair.com/t/historical-api-endpoints-are-now-restricted/1557) website for more information. |
| `startTimeStamp` | The beginning date in the format `"YYYY-MM-DD HH:mm:ss"`. |
| `endTimeStamp` | The end date in the format `"YYYY-MM-DD" HH:mm:ss`. |
| `average` | The desired average in minutes, one of the following: `"0"` (real-time), `"10"`, `"30"`, `"60"`, `"360"` (6 hour), `"1440"`  (1 day).  |
| `fields` | The `"Fields"` parameter specifies which 'sensor data fields' to include in the response. |

## Value
Dataframe of PurpleAir history data of a single sensor or multiple sensors.

## References
[PurpleAir API](https://api.purpleair.com/).

## Examples

### For a single sensor
```r
getPurpleairApiHistory(
    sensorIndex    = "31105",  
    apiReadKey     = "43664AA0-305B-11ED-B5AA-42010A800010",
    startTimeStamp = "2022-12-26 00:00:00",
    endTimeStamp   = "2022-12-26 23:59:59",
    average        = "10"
    fields         = c("pm2.5_atm, pm2.5_atm_a, pm2.5_atm_b")
)
```

### For multiple sensors
```r
getPurpleairApiHistory(
    sensorIndex    = c("31105","31105","57177"),  
    apiReadKey     = "43664AA0-305B-11ED-B5AA-42010A800010",
    startTimeStamp = "2022-12-26 00:00:00",
    endTimeStamp   = "2022-12-26 23:59:59",
    average        = "10"
    fields         = c("pm2.5_atm, pm2.5_atm_a, pm2.5_atm_b")
)
```
