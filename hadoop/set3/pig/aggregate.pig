--- --------------------------------------------------------------------------------------------------------------------------------------------
---
--- Init and Register the necessary jars
---
--- --------------------------------------------------------------------------------------------------------------------------------------------
set default_parallel 200;
register '/opt/maged/pig-jars/*.jar'
register '/home/gijs/lib/adsafe-pigudfs.jar'
--- --------------------------------------------------------------------------------------------------------------------------------------------




--- --------------------------------------------------------------------------------------------------------------------------------------------
---
--- Pull data
--- 
--- --------------------------------------------------------------------------------------------------------------------------------------------
data = LOAD '/user/gijs/d4d/set3/records' USING PigStorage(',') AS (userid: chararray, timestamp: chararray, arrid: int);
meta = LOAD '/user/gijs/d4d/set3/indicators' USING PigStorage(',') AS (userid: chararray, 
	activedays_all: float,
	durationofcalls_call_mean: float,
	durationofcalls_call_median: float,
	durationofcalls_call_std: float,
	entropyofcontacts_call: float,
	entropyofcontacts_text: float,
	entropyplaces_all: float,
	interactionspercontact_call_mean: float,
	interactionspercontact_call_median: float,
	interactionspercontact_call_std: float,
	interactionspercontact_text_mean: float,
	interactionspercontact_text_median: float,
	interactionspercontact_text_std: float,
	interevents_call_mean: float,
	interevents_call_median: float,
	interevents_call_std: float,
	interevents_text_mean: float,
	interevents_text_median: float,
	interevents_text_std: float,
	numberofcontacts_call: float,
	numberofcontacts_text: float,
	numberofinteractions_call: float,
	numberofinteractions_text: float,
	numberofplaces_all: float,
	percentageinitiatedconversation_all: float,
	percentathome_all: float,
	percentnocturnal_call: float,
	percentnocturnal_text: float,
	radiusofgyration_all: float,
	responsedelaytext_all_mean: float,
	responsedelaytext_all_median: float,
	responsedelaytext_all_std: float,
	responseratetext_all: float);
--- --------------------------------------------------------------------------------------------------------------------------------------------




-- --- --------------------------------------------------------------------------------------------------------------------------------------------
-- --- 
-- --- Pre-process 1
-- ---
-- --- --------------------------------------------------------------------------------------------------------------------------------------------
data = FOREACH data GENERATE
	userid AS userid,
	ToDate('1970-01-01 00:00:00','yyyy-MM-dd HH:mm:ss') AS bt,
	ToDate(timestamp,'yyyy-MM-dd HH:mm:ss') AS dt,
	(int) com.adsafe.pigudfs.geolocation.ISOToDayOfWeek(SUBSTRING(timestamp,0,10)) AS weekday: int,
	(int)SUBSTRING(timestamp,11,13) AS hour: int,
	arrid AS arrid;
-- --- --------------------------------------------------------------------------------------------------------------------------------------------




-- --- --------------------------------------------------------------------------------------------------------------------------------------------
-- --- 
-- --- Pre-process 1
-- ---
-- --- --------------------------------------------------------------------------------------------------------------------------------------------
data = FOREACH data GENERATE
	userid AS userid,
	MilliSecondsBetween(dt,bt) AS timestamp: long,
	GetMonth(dt) AS month: int,
	GetWeek(dt) AS week: int,
	weekday AS weekday: int,
	hour AS hour: int,
	arrid AS arrid: int;
-- --- --------------------------------------------------------------------------------------------------------------------------------------------




--- --------------------------------------------------------------------------------------------------------------------------------------------
---
--- Group by User
---
--- --------------------------------------------------------------------------------------------------------------------------------------------
grouped = GROUP data BY userid;
users = FOREACH grouped 
	{
	sorted = ORDER data BY timestamp;
	GENERATE 
		group AS userid,
		sorted.(timestamp,month,week,weekday,hour,arrid) AS eventbag;
	};
--- --------------------------------------------------------------------------------------------------------------------------------------------




--- --------------------------------------------------------------------------------------------------------------------------------------------
---
--- Find Arr Movement
---
--- --------------------------------------------------------------------------------------------------------------------------------------------
users = FOREACH users GENERATE 
	userid AS userid,
	eventbag AS eventbag,
	com.adsafe.pigudfs.util.RemoveRepeats(eventbag) AS uniquePairs;
--- --------------------------------------------------------------------------------------------------------------------------------------------




--- --------------------------------------------------------------------------------------------------------------------------------------------
---
--- Count number of Elements
---
--- --------------------------------------------------------------------------------------------------------------------------------------------
users = FOREACH users GENERATE
	userid AS userid,
	uniquePairs AS uniquePairs,
	SIZE(uniquePairs) AS nElements;
users = FILTER users BY nElements > 0;
--- --------------------------------------------------------------------------------------------------------------------------------------------




--- --------------------------------------------------------------------------------------------------------------------------------------------
---
--- Flatten Back
---
--- --------------------------------------------------------------------------------------------------------------------------------------------
total = FOREACH users GENERATE userid, FLATTEN(uniquePairs) AS transitions;
--- --------------------------------------------------------------------------------------------------------------------------------------------




-- --- --------------------------------------------------------------------------------------------------------------------------------------------
-- ---
-- --- Join with meta
-- ---
-- --- --------------------------------------------------------------------------------------------------------------------------------------------
-- total = FOREACH (JOIN total BY userid LEFT OUTER, meta BY userid) GENERATE 
-- 	total::userid AS userid,
-- 	total::transitions AS transitions,
-- 	meta::activedays_all AS activedays_all,
-- 	meta::durationofcalls_call_mean AS durationofcalls_call_mean,
-- 	meta::durationofcalls_call_median AS durationofcalls_call_median,
-- 	meta::durationofcalls_call_std AS durationofcalls_call_std,
-- 	meta::entropyofcontacts_call AS entropyofcontacts_call,
-- 	meta::entropyofcontacts_text AS entropyofcontacts_text,
-- 	meta::entropyplaces_all AS entropyplaces_all,
-- 	meta::interactionspercontact_call_mean AS interactionspercontact_call_mean,
-- 	meta::interactionspercontact_call_median AS interactionspercontact_call_median,
-- 	meta::interactionspercontact_call_std AS interactionspercontact_call_std,
-- 	meta::interactionspercontact_text_mean AS interactionspercontact_text_mean,
-- 	meta::interactionspercontact_text_median AS interactionspercontact_text_median,
-- 	meta::interactionspercontact_text_std AS interactionspercontact_text_std,
-- 	meta::interevents_call_mean AS interevents_call_mean,
-- 	meta::interevents_call_median AS interevents_call_median,
-- 	meta::interevents_call_std AS interevents_call_std,
-- 	meta::interevents_text_mean AS interevents_text_mean,
-- 	meta::interevents_text_median AS interevents_text_median,
-- 	meta::interevents_text_std AS interevents_text_std,
-- 	meta::numberofcontacts_call AS numberofcontacts_call,
-- 	meta::numberofcontacts_text AS numberofcontacts_text,
-- 	meta::numberofinteractions_call AS numberofinteractions_call,
-- 	meta::numberofinteractions_text AS numberofinteractions_text,
-- 	meta::numberofplaces_all AS numberofplaces_all,
-- 	meta::percentageinitiatedconversation_all AS percentageinitiatedconversation_all,
-- 	meta::percentathome_all AS percentathome_all,
-- 	meta::percentnocturnal_call AS percentnocturnal_call,
-- 	meta::percentnocturnal_text AS percentnocturnal_text,
-- 	meta::radiusofgyration_all AS radiusofgyration_all,
-- 	meta::responsedelaytext_all_mean AS responsedelaytext_all_mean,
-- 	meta::responsedelaytext_all_median AS responsedelaytext_all_median,
-- 	meta::responsedelaytext_all_std AS responsedelaytext_all_std,
-- 	meta::responseratetext_all AS responseratetext_all;
-- --- --------------------------------------------------------------------------------------------------------------------------------------------




--- --------------------------------------------------------------------------------------------------------------------------------------------
---
---  Store
---
--- --------------------------------------------------------------------------------------------------------------------------------------------
RMF d4d/set3/total
STORE total INTO 'd4d/set3/total' USING PigStorage('\t', '-schema');
--- --------------------------------------------------------------------------------------------------------------------------------------------