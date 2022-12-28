# getPurpleairApiHistory
R function to download historical data from PurpleAir sensors in the new API

## Usage
```R
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
| `sensorIndex` | List all *new or modified* files |
| `apiReadKey` | Show file differences that **haven't been** staged |
| `startTimeStamp` | Show file differences that **haven't been** staged |
| `endTimeStamp` | Show file differences that **haven't been** staged |
| `average` | Show file differences that **haven't been** staged |
| `fields` | Show file differences that **haven't been** staged |

## Value

## References
[PurpleAir API](https://api.purpleair.com/)

## Examples

### For a single sensor
```R
getPurpleairApiHistory(
    sensorIndex="31105",  
    apiReadKey="43664AA0-305B-11ED-B5AA-42010A800010",
    startTimeStamp="2022-12-26 00:00:00",
    endTimeStamp="2022-12-26 23:59:59",
    average="10"
    fields=c("pm2.5_atm, pm2.5_atm_a, pm2.5_atm_b")
)
```

### For multiple sensors
```R
getPurpleairApiHistory(
    sensorIndex=c("31105","31105","57177"),  
    apiReadKey="43664AA0-305B-11ED-B5AA-42010A800010",
    startTimeStamp="2022-12-26 00:00:00",
    endTimeStamp="2022-12-26 23:59:59",
    average="10"
    fields=c("pm2.5_atm, pm2.5_atm_a, pm2.5_atm_b")
)
```
