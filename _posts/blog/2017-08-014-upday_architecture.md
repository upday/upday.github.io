---
layout: post
title: "Finding yourself in the world of backend architecture"
modified:
categories: blog
author: maria_fernandez_pajares
excerpt: Our journey through the world of backend architecture in a few words.
tags: [Architecture, Microservices, Backend]
image:
date: 2017-08-23T00:55:55+2
---

I have always wanted to write about our journey through the world of backend architectures. As a developer, you may have been facing problems related to this topic in your team or with your projects. 
You might even be aware of the magical and trendy solutions out there, but sometimes these don't perfectly fit your current needs. 

This topic has not been - and it is not yet - an easy one for us either, but after facing many problems we now find ourselves in the world of backend architecture.
Therefore I would like to share a few of our experiences and learnings in this area at upday.

### Conway's Law's reversion

In conferences I have attended I have heard references to what could be interpreted from [*Mel Conway's Law*](https://en.wikipedia.org/wiki/Conway%27s_law):

>A backend architecture is a reflection of the team setup.

and I totally agree with that but I also think that **with time it may become the other way around:**

>the architecture can end up shaping the team instead of the team shaping the architecture.

Let me dig more into the challenges we face this time around and how we managed to resolve them:

### Our firsts architectural steps

At *upday* we started with a small team of developers tasked with creating a robust solution to fulfill our client’s requirements of reliability and providing good quality content to our readers. 
As in most *startups*, everything started fast and in a rush. The solution we finally came up with consisted of two monolithic components written in *Java* and *Spring Boot*. 
Together they form the core of our system. But they were not the only ones. We also had other smaller components written in Ruby or Java, which took care of minor requirements.
When this setup worked properly and was production ready, we went live with it.

### When our architecture started to have flows

**When our company started growing, it was impossible to stick to only one big team of backend developers.** 

We started splitting our backend team into feature teams. This was not an optimal setup at that time, given these two big components had to be touched by each team every time a new feature was added.

**When you have something stable and working, it is scary to start rewriting it but it’s important to do so sooner rather than later to avoid getting to the point of no return.**

With this in mind, we started to step into the world of *microservices*, to make life easier for us developers (and of course more challenging, fun and efficient). 
For sure there’s a difference in adding one small field to a 50,000-lines-of-code monster and touching 1,000 different unit and integration tests, than doing the same in a small service. 
The reviewer will be the first one to be thankful for that.

### Where to draw the line on diversity of technology

Once living in this wonderful and interesting microservices world, **it was nice to have the opportunity to use new technologies** without being restricted to just the original ones. 
However, not everything is pink and full of rainbows in the microservices world. **You have to know when to stop** creating new microservices or adding more and more new technologies to your stack. 
Because your team - whose members could always change - has to continue maintaining and understanding this zoo of services and its underlying technologies. 

Like everything in life: **You have to find a balance.** Since everyone has different opinions, there is no one perfect solution. 
Also, something that is *en vogue* now may not be the *silver bullet* forever. 
It might be that the best approach for your team is having less services and only one single technology. 
Or it may be that applying different technologies and trying new ones is what the developers want to do, because they are hungry to learn and face new challenges. 
**Whatever the situation is, just don’t lose the focus on what your product really requires.**

### Our architecture today

As a team of young developers who strive for challenges, we have evolved into our current setup where we have better small services.
**But we never create a new microservice for the sake of creating a microservice**, only when there are reasons to go for a new one.
And this seems to work quite well for both, our developers and our product.

Our *Android* app we serve has two main parts: 

- the _Top News section_ (news everyone needs to know about) and the 
- _My News section_ (based on the user’s interests and their interactions with our app). 

We decided to keep these areas separated and independent, **basing their communication only on messaging**, as described in the **SCS** [*(Self Contained Systems)*](http://scs-architecture.org/) approach. 
So when there is any problem related with *Top News*, *My News* is not affected and the other way around. 

This is how our architecture looks like from a bird’s eyes view (very high level overview):

<img style="margin: auto; margin-left: 15%; margin-top: 10px;" src="/images/blog/upday_architecture/high-level_arch_overview.jpg"/><br/>

And here a more detailed overview of the (micro-) services - not always so *"super micro"* - developed with different technologies, composing the **Top News System**:

<img style="margin: auto; margin-left: 2%; margin-top: 10px;" src="/images/blog/upday_architecture/microservices_top_news_system.jpg"/><br/>

### Our learnings and conclusions so far

*… which are not universal truth and may not even last forever for us:*

- Although we have mastered Java 8 and Spring Boot technologies so far, **we might move to other technologies if they fit our requirements or problems better.** But this learning has a big BUT: 
  * we will only go for a new technology if more than one developer masters it, or in other words, the team gets involved and learns the new technology used in the project.

- Handling different types of data differs per service:
    
    -  for score-based querying of full text search, *Elasticsearch* comes handy
    -  for getting statistics of open rates for our content team, using *AWS Lambdas* and *DynamoDB* fits much better
    -  for simply storing articles with simple relational queries we use *Postgres*
 
- And now we are quite impressed by _Kotlin_. Our Android team is already starting to use it and perhaps we too start to implement future backend services with it. Of course after analysing and doing pro-cons
 of what it would mean for us developers and our product.

This was my/our story so far.

**Good luck on your own path through backend architecture!**
