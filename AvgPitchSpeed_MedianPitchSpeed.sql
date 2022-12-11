WITH
dataset AS (
SELECT 
  *
FROM
  `mlb-season-pitch-by-pitch.2016mlb.pitchbypitch_regseason`
WHERE pitchspeed > 60 #This number was selected to remove the zeroes and smaller entries that are not relevant for the analysis and aggregations
AND pitchTypeDescription IN ("Fastball", "Changeup", "Slider", "Curveball") #The pitch types selected are the four highest thrown by count
),
median_pitch_speed AS (
SELECT
  DISTINCT pitchTypeDescription AS pitch_type,
  PERCENTILE_DISC(pitchSpeed, 0.5) OVER (PARTITION BY pitchtype) AS median #This window function is to determine the median pitch speed for the top four pitches thrown
FROM
  dataset
ORDER BY
  median DESC
),
average_pitch_speed AS (
SELECT
  DISTINCT pitchTypeDescription AS pitch_type,
  AVG(pitchspeed) AS average
FROM
  dataset
GROUP BY
  pitch_type
)
SELECT
  median_pitch_speed.pitch_type AS pitch_type,
  median_pitch_speed.median AS median,
  ROUND (average_pitch_speed.average, 2) AS avg_pitch_speed
FROM
  median_pitch_speed
JOIN
  average_pitch_speed
ON
  median_pitch_speed.pitch_type = average_pitch_speed.pitch_type