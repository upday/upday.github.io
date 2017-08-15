---
layout: post
title: "Finding Yourself in Backend Architectural World"
modified:
categories: blog
author: maria_fernandez_pajares
excerpt: Our journey through the world of backend architecture in a few words.
tags: [Architecture, Microservices, Backend]
image:
date: 2017-08-04T10:55:55+2
---

I have always wanted to write about our journey through the world of backend architecture and how it affected myself and our team setup. 

*Mel Conway* formulated his [law](https://en.wikipedia.org/wiki/Conway%27s_law) like this: 

>A backend architecture is a reflection of the team setup.

I have to admit he is not wrong. Actually he is mainly right. 
However, in my experience **over time it may become the other way around:** 

>The architecture shapes the teams instead of the teams shaping the architecture.

Let me explain how I came to this conclusion.

### Our firsts architectural steps

In *upday* we started with a small team of developers tasked with creating a robust solution to fulfill our client’s requirements of reliability and providing good quality content to our readers. 
As in most *startups*, we moved fast and in a rush. The solution we finally came up with consisted of two monolithic components written in *Java* and *Spring Boot*. 
Both of them together being the core of our system. We also had other smaller components written in *Ruby* or *Java*, that took care of minor requirements. 
When this setup worked properly and was production ready, we went live with it.

### When our architecture started to have flows

**When our company started growing, it was impossible to stick to only one big team of backend developers.** 

We split our backend team into feature teams. This was not an optimal setup, given these two big components that had to be touched by each team every time a new feature was added.

**When you have something stable and working, it is scary to start rewriting it but it’s important to do so sooner rather than later to avoid getting to the point of no return.**

With this in mind, we started to step into the world of *microservices*, to make life easier for us developers (and of course more challenging, fun and efficient). 
For sure there’s a difference in adding one small field to a 50,000-lines-of-code monster and touching 1,000 different unit and integration tests, than doing the same in a small service. 
The reviewer will be the first one to be thankful for that.

### Where to draw the technologies diversity line

Once living in this wonderful and interesting microservices world, **it was nice to have the opportunity to use new technologies** without being restricted to just the original ones. 
However, not everything is pink and full of rainbows with this approach. **You have to know when to stop** creating new microservices or adding more and more new technologies to your stack (just for the sake of it). 
Because your team - whose members could always change - has to continue maintaining and understanding this zoo of services and its underlying technologies. 

Like everything in life: **You have to find a balance.** Since everyone has different opinions, there is nothing like a perfect solution. 
Also, something that is *en vogue* now may not be the *silver bullet* forever. 
It might be that the best approach for your team is having less services and only one single technology. 
Or it may be that applying different technologies and trying new ones is what the developers want to do, because they are hungry to learn and to face new challenges. 
**Whatever the situation is, just don’t lose the focus on what your product really requires.**

### Our architecture today

As a team of young developers who strive for challenges, we have evolved into our current setup where we prefer having small services.
**But we never create a new microservice for the sake of creating a microservice.** There need to be good reasons to go for another one.
And this seems to work quite well for both, our developers and our product.

The *Android* app we serve has two main parts: 

- the _Top News section_ (news everyone needs to know about) and the 
- _My News section_ (based on the user’s interests and their interactions with our app). 

We decided to keep these areas separated and independent, **basing their communication only on messaging**, as described in the **SCS** *(Self Contained Systems)* approach. 
So when there is any problem related with *Top News*, *My News* is not affected and the other way around. 

This is how our architecture looks like from a bird’s eyes view (very high level overview):

<img style="margin: auto; margin-left: 15%; margin-top: 10px;" src="/images/blog/upday_architecture/high-level_arch_overview.jpg"/><br/>

And here a more detailed overview of the (micro-) services - not always so *"super micro"* - developed with different technologies, composing the **Top News System**:

<img style="margin: auto; margin-left: 2%; margin-top: 10px;" src="/images/blog/upday_architecture/microservices_top_news_system.jpg"/><br/>

### Our learnings and conclusions so far

*… which are not an universal truth and may not even for us last forever:*

- Although we have mastered *Java 8* and *Spring Boot* technologies better so far, **we might move to other technologies if they fit our requirements or problems better.

- Handling different type of data differs per service:
    
    -  for score-based querying of full text search, *Elasticsearch* comes handy
    -  for getting statistics of open rates for our content team, using *AWS Lambdas* and *DynamoDB* fits much better
    -  for simply storing articles with simple relational queries we use *Postgres*
 
- And now we are quite impressed by _Kotlin_. Our Android team is already starting to use it and perhaps we too start to implement future backend services with it.

This was my/our story so far.

**Good luck on your own path through backend architecture!**
