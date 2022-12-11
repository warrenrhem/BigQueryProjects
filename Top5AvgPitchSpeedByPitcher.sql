WITH
#In the future I want to perform an exploratory analysis to determine the number of pitches thrown by each pitcher



dataset AS (
SELECT 
  *
FROM
  `mlb-season-pitch-by-pitch.2016mlb.pitchbypitch_regseason`
WHERE pitchspeed > 60
AND pitchTypeDescription IN ("Fastball", "Changeup", "Slider", "Curveball") #The pitch types selected are the four highest thrown by count
),
average_pitch_speed AS (
SELECT
  *, 
  RANK() OVER (PARTITION BY pitch_type ORDER BY average desc) AS speed_rank #I used this window function to rank the pitchers with the hardest speed average for the selected pitches
FROM (

              SELECT
                DISTINCT pitchTypeDescription AS pitch_type,
                CONCAT (pitcherFirstName, " ", PitcherLastName) AS pitcher_name,
                AVG(pitchspeed) AS average
              FROM
                dataset
              GROUP BY
                pitch_type,
                pitcher_name
              ORDER BY
                pitch_type,
                average DESC
)

)
SELECT
  *
FROM
  average_pitch_speed
WHERE
  speed_rank < 6