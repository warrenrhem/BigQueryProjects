SELECT
  CONCAT (pitcherFirstName, ' ', pitcherLastName) AS PitcherName,
  COUNT(*),
  FROM
  `mlb-season-pitch-by-pitch.2016mlb.pitchbypitch_regseason`
GROUP BY 1
ORDER BY
  2 DESC