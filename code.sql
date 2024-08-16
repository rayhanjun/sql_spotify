-- 2024 Spotify Musics Project by Rayhan Juniano

SELECT * 
FROM public.most_streamed_spotify_songs;


-- 10 Most Streamed Songs in 2024
SELECT "Track" , "Artist" , "Spotify Streams" 
FROM public.most_streamed_spotify_songs
ORDER BY "Spotify Streams" DESC
LIMIT 10;


-- Top 10 Artists by Total Streams
SELECT "Artist", 
       SUM(CAST(REPLACE(NULLIF("Spotify Streams", ''), ',', '') AS BIGINT)) AS "Total Streams"
FROM public.most_streamed_spotify_songs
WHERE "Spotify Streams" IS NOT NULL AND "Spotify Streams" != ''
GROUP BY "Artist"
ORDER BY "Total Streams" DESC
LIMIT 10;

-- Streaming Trends Over Time (since 1987)
SELECT DATE_TRUNC('month', TO_DATE("Release Date", 'MM/DD/YYYY')) AS "Month", 
       SUM(CAST(REPLACE(NULLIF("Spotify Streams", ''), ',', '') AS BIGINT)) AS "Monthly Streams"
FROM public.most_streamed_spotify_songs
GROUP BY DATE_TRUNC('month', TO_DATE("Release Date", 'MM/DD/YYYY'))
ORDER BY "Month";

-- Longevity of Top 10 Songs
WITH "Ranked Songs" AS (
    SELECT 
        "Track", 
        "Artist", 
        RANK() OVER (PARTITION BY "Track", "Artist" ORDER BY "Track") AS Rank,
        "Release Date"
    FROM public.most_streamed_spotify_songs
)
SELECT "Track", "Artist", COUNT(*) AS "Weeks On Chart"
FROM "Ranked Songs"
WHERE Rank <= 10
GROUP BY "Track", "Artist"
ORDER BY "Weeks On Chart" DESC;

-- Top 10 Months with the Highest Total Streams
SELECT DATE_TRUNC('month', TO_DATE("Release Date", 'MM/DD/YYYY')) AS "Month", 
       SUM(CAST(REPLACE(NULLIF("Spotify Streams", ''), ',', '') AS BIGINT)) AS "Monthly Streams"
FROM public.most_streamed_spotify_songs
GROUP BY DATE_TRUNC('month', TO_DATE("Release Date", 'MM/DD/YYYY'))
ORDER BY "Monthly Streams" DESC
LIMIT 10;
