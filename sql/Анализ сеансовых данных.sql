use romantsov_test
go
/*
SELECT TOP 10
 s.[process],
 s.[period],
 s.[ClientID],
 u.[Usr],
 SUM(c.[Mem]) AS Mem
FROM
 [dbo].[call] AS c
 INNER JOIN [dbo].[scall] AS s
 ON s.[period] = c.[period]
 AND s.CallID = c.CallID
 LEFT OUTER JOIN (SELECT DISTINCT process, ClientID, [Usr] FROM [dbo].[usr]) AS u
 ON u.process = s.process
 AND u.ClientID = s.ClientID
GROUP BY
 s.[process],
 s.[period],
 s.[ClientID],
 u.[Usr]
ORDER BY
 Mem Desc
 */
 
 SELECT
 s.[process],
 s.[period],
 s.[ClientID],
 c.[Mem],
 c.CallID
FROM
 [dbo].[call] AS c
 INNER JOIN [dbo].[scall] AS s
 ON s.[period] = c.[period]
 AND s.CallID = c.CallID
 AND s.[period] = '19062717' 
 AND s.[ClientID] = 467
 AND s.[process] = 'rphost_10052'
ORDER BY
 [Mem] DESC