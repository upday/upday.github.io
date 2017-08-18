---
layout: post
title: "A Journey Towards a Custom Data Warehouse Solution<br/> Part 2: We Need a Storage"
description: 
modified:
categories: blog
author: robert_bordo
excerpt: We would like to share our second part towards a custom data warehouse solution. This time it's all about selecting a proper storage.
tags: [Data, DWH, Data Warehouse, Big Data, Data Platform, Data Lake, Storage, Redshift, S3, Snowflake]
image:
date: 2017-07-18T00:39:55-04:00
---

> In the beginning we created a cluster. And the cluster was without form, and void; and nulls were upon the face of the storage.

As we learned in [part 1 of our series](../dwh-part1_getting_started), a data warehouse consists of several components. 
The key component is the storage. All the others group around it. But how can one draw a decision which storage solution to take? What is out there anyway? 

## Preface

In a perfect world there would be only one kind of storage that fits all the needs of current DWH development and analysis. 
But since we are not living in that kind of place, we have several options. And its number increases, the deeper one dives into the topic. 
There seem to be solutions for every use case you can think of.

That might be a good starting point. What is our most common use case? What are we going to store? And how would we like to access our data in the end?

Our major source is a massive amount of log data coming from our [app](https://play.google.com/store/apps/details?id=de.axelspringer.yana). 
Everything the user does (e.g swiping through articles, selecting categories, leaving the app) is tracked, 
enriched with metadata (e.g. the user’s location, app version, article identifier) and stored by a third-party service in big, semi-structured log files. 
Having only this source, a time series database like 
[Graphite](github.com/­graphite-project/­graphite-web)
or 
[InfluxDB](www.influxdata.com/­time-series-platform/­influxdb) 
could do the job. 
But also having slow changing master data, like user profiles, article metadata and maybe even historized data, this solution would be too limited to satisfy all our current and future needs as well. 

Another thing that comes to my mind is how the data will be accessed by our final consumer (namely: Business Intelligence). 
Usually they use tools like 
[Jasper Reports](https://en.wikipedia.org/wiki/JasperReports)
or 
[Tableau](https://en.wikipedia.org/wiki/Tableau_Software)
for generating reports. 
For analyses we have to pre-aggregate the data to make queries more performant and translate raw information into a digestible format.

What else is on the market?


| Storage | good at | bad at | Example |
|-------|--------|---------|---------|
| **S3/Flat Files** | scalability, easy to use, data lake | querying | S3 |
| **Time Series DB** | handling time series data | non time series data | Graphite |
| **Relational DB** | referential integrity, transactions | semi-structured data | Postgres |
| **Key Value Store** | semi-structured data, speed | complex queries | DynamoDB |
| **Document Store** | schema free | aggregating | Elasticsearch |
| **Wide Column Store** | storing large number of dynamic columns | | Hadoop |
| **Graph Database** | processing of graph structures | indexing | Neo4J |
| **Object Database** | storing objects | speed | Versant|

<br/>
And there are even more. An extensive list can be found [here](http://nosql-database.org/).

## The Given One - S3

Something I forgot to mention is, we store all (semi-structured) data we receive from different sources to S3 first. 
S3 serves as our [Data Lake](https://en.wikipedia.org/wiki/Data_lake). This enables us to only load relevant data selectively to our main storage without losing information, 
because we could re-load each information afterwards. This reduces costs (S3 is cheap, our main storage is not) and 
[Amazon Athena](https://aws.amazon.com/de/athena/) even enables to query data in S3 directly.

## The Candidate - AWS Redshift

Most of our infrastructure is hosted on Amazon Web Services (AWS). It would be handy to stay on this well known ground. 
There must be something out there. And it is indeed. [Redshift](<https://aws.amazon.com/redshift>) is Amazon’s “data warehouse as a service” solution. 

On Redshift's homepage you can read:

_Amazon Redshift is a fast, fully managed data warehouse that makes it simple and cost-effective to analyze all your data using standard SQL and your existing Business Intelligence (BI) tools._

Basically it is a column oriented database with good support for analytical functions. It is able to handle Petabytes of structured data by massively parallel query execution. Sounds good. 
Fulfills our requirements. Why not giving it a chance?

__Pros:__

* (unlimited) scalability
* good support for analytical functions
* accessible like any other database
* good integration in AWS infrastructure (S3, AWS Lambdas, etc.)
* good support to import data from S3

__Cons:__

* Costly (depending on the type and number of nodes used)
* steep learning curve in order to boost performance
* maybe training necessary (or even consultancy)
* no native support for semi-structured data
* database administration is complex (column compression, distribution, vacuumization, …)

## The Opponent - Snowflake

Redshift is not the only data warehouse as a service candidate. [Snowflake](https://www.snowflake.net/) is another one. 
To be honest, we evaluated Snowflake a while ago. 
A lot has changed since then, but let’s stick to the data we collected sometime in 2016.

On Snowflake's homepage you can read:

_From zero to Petabytes, our elastic data warehouse architecture scales to any volume of data painlessly and inexpensively. 
No more painful decisions about what data you can afford to keep._

__Pros:__

* storage is cheap (maybe) -> see cons
* native support for semi-structured data
* (unlimited) scalability
* good integration into AWS infrastructure (S3, AWS Lambdas, etc.)
* database administration is done automatically

__Cons:__

* nontransparent pricing policy
* missing information about tooling (ETL)

Snowflake created a database layer on top of S3 (a little bit like Amazon Athena did later). Unfortunately it wasn’t easy to thoroughly test Snowflake at that time. 
Consequently we did not investigate further. Maybe we would handle this issue differently today.

## Finally

**We decided for Redshift in the end.** I have to admit it hasn't been a too unbiased process, because more or less we wanted to try Redshift anyway. 

**Starting with Redshift is easy, but getting satisfying results, especially if the amount of data increases, takes longer.** 
Execution time and costs increase. You have to understand how Redshift works under the hood and you need to tune your tables accordingly. 
Also its maintenance is not a piece of cake. We will share our findings in a later post.

## Summary

**Selecting a proper storage for a data warehouse is tough.** And it’s not at the same time. At the end of the day **you, as a data engineer, manage data, not a database**. 
Data goes into the storage and is being retrieved again. Make sure both ways are comfortable. You, as a data engineer, are able to load data into the storage easily. 
Your customer, usually some BI person, can fetch data quickly and is happy. Data maintenance should not be too complex as well. And all aggregations in between should also work smoothly. 

__Questions you should ask:__

* How does my infrastructure look like so far?
* What are my sources?
* How is my source data structured?
* How much data do I expect to store?
* Do I need unlimited scalability?
* What tools (BI) need to access my data?
* How much can I spend on it?
* How complicated is the maintenance? 
* Do we have capacity and knowledge to master this technology? 
* Do we need training?


And there's nothing wrong with having more than one storage. I mean, a storage is not Highlander in the end.


