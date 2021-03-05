SELECT
	tea_learnerscenaioid_rel.*,
	`pivot_table`.*,
	(
		pivot_table.`Active Listening` + pivot_table.`Curiosity & Receptivity` + pivot_table.Empathy + pivot_table.`Physically present` + pivot_table.`Setting a positive tone and agenda shaping` + pivot_table.`Versatile & Trustful Conversations` + pivot_table.`Your virtual environment` 
	)/ 7 AS `Average skill value`,
	(
		pivot_table.`Active Listening` + pivot_table.`Curiosity & Receptivity` + pivot_table.Empathy + pivot_table.`Physically present` + pivot_table.`Setting a positive tone and agenda shaping` + pivot_table.`Versatile & Trustful Conversations` + pivot_table.`Your virtual environment` 
	) AS `Total skill score`,
	nlp_results.* 
FROM
	tea_learnerscenaioid_rel
	LEFT JOIN #convert rows to column from skill table as pivot_table
	(
	SELECT
		scenarioId,
		learnerScenarioId,
		sum( CASE `feedbackSkillId` WHEN "328527" THEN skillValue END ) AS "Your virtual environment",#convert rows to column and rename the column
		sum( CASE `feedbackSkillId` WHEN "223638" THEN skillValue END ) AS "Physically present",
		sum( CASE `feedbackSkillId` WHEN "328531" THEN skillValue END ) AS "Setting a positive tone and agenda shaping",
		sum( CASE `feedbackSkillId` WHEN "28841" THEN skillValue END ) AS "Active Listening",
		sum( CASE `feedbackSkillId` WHEN "328534" THEN skillValue END ) AS "Curiosity & Receptivity",
		sum( CASE `feedbackSkillId` WHEN "67204" THEN skillValue END ) AS "Empathy",
		sum( CASE `feedbackSkillId` WHEN "328537" THEN skillValue END ) AS "Versatile & Trustful Conversations" 
	FROM
		tea_skill_score 
	GROUP BY
		learnerScenarioId 
	) AS `pivot_table` ON tea_learnerscenaioid_rel.scenarioId = `pivot_table`.scenarioId 
	AND tea_learnerscenaioid_rel.learnerScenarioId = `pivot_table`.learnerScenarioId
	LEFT JOIN nlp_results ON tea_learnerscenaioid_rel.learnerScenarioId = nlp_results.learnersenarionid 
WHERE
	tea_learnerscenaioid_rel.scenarioId = 374703 #query for selected scenarioid
	
GROUP BY
	tea_learnerscenaioid_rel.learnerScenarioId;
