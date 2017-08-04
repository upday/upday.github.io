---
layout: post
title: "Finding yourself in backend architectural world"
modified:
categories: blog
author: maria_fernandez_pajares
excerpt: Our journey through the world of backend architecture in a few words.
tags: [architecture, microservices, backend]
image:
date: 2017-08-04T10:55:55+2
---

I have always wanted to write about our journey through the world of backend architectures. As Mel Conway’s well predicted with his Conway’s law: a backend architecture is a reflection of the team setup. I have to admit he is not wrong at all. Actually he is mainly right. However, I think that with the time it may become the other way around whereby the architecture shapes the team instead of the team shaping the architecture.

### Our firsts architectural steps

For us, it started with a small team of developers tasked with creating a robust solution to fulfill our client’s requirements of reliability and providing good quality content to our readers. So as in each and every startup, everything started fast and in a rush. Consequently, the best solution finally consisted of two monolithic components written in Java and Spring Boot. Both of them being at the core of our system. They were not the only ones. We also had other smaller components written in Ruby or Java, which took care of other requirements. When these worked properly and were production ready, we went live with them.

### When our architecture started to have flows
> - However, when our company started growing, it was impossible to stick to only one big team of backend developers. 

We started splitting our backend team into feature teams. This was not a useful setup at that time, given these two big components that had to be touched by each team every time a new feature was added.

> - When you have something stable and working, it is scary to start rewriting it but it’s important to start sooner rather than later to avoid getting to the point of no return.

With this in mind, we started to step into the microservices world, to make life for us developers easier (and of course more challenging, fun and efficient). For sure there’s a difference in adding one small field to a 50,000-lines-of-code monster and touching 1,000 different unit and integration tests, than doing the same in a small service. The reviewer will be the first one to be thankful for that.

### Where to draw the technologies diversity line
Once living in this wonderful and interesting microservices world, it was nice to have the opportunity to use new technologies without being restricted to just the original services. However, not everything is pink and full of rainbows in the microservices world. You have to know when to stop creating new microservices or adding more and more new technologies to your stack. Because your team - for which members could always change - has to continue maintaining and understanding this zoo of services and underlying technologies. 

Like everything in life: you have to find a balance. Since everyone has different opinions, there is no one perfect solution. Also, something that is en vogue now may not be the perfect solution forever. It might be that the best approach for your team is having less services and one single technology. Or it may be that applying different technologies and trying new ones is what the developers want to do, because they are hungry to learn and face new challenges. Whatever the situation, just don’t underestimate what your product really requires.

### Our architecture today's perfect solution
As a team of young developers who strive for challenges, we have evolved into our current setup where we have better small services but never create a microservice for the sake of creating a microservice only when there are reasons to go for a new one, and as it seems to work quite well for both our developers and our product.

Our Android app has two main parts: the _Top News section_ (news everyone needs to know about) and the _My News section_ (based on the user’s interests and their interactions with our app). We decided to keep them separated and independent, basing their communication only through messaging, taking this decision from the **SCS** (Self Contained Systems). So when there is any problem related with _Top News_, _My News_ is not affected and the other way around. This is how currently our architecture from a bird’s eye view (very high level overview) looks like:

<img style="margin: auto; margin-left: 15%; margin-top: 10px;" src="/images/blog/upday_architecture/high-level_arch_overview.jpg"/><br/>

And here is an overview of the components (microservices) developed with different technologies being part of **Top News System**:

<img style="margin: auto; margin-left: 2%; margin-top: 10px;" src="/images/blog/upday_architecture/microservices_top_news_system.jpg"/><br/>


### Our learning and conclusions so far

… which are not a universal truth and may not even last for us forever.

- Although we have mastered Java 8 and Spring boot technologies better, we might move to other technologies if they fit our requirements or problems better.

- Handling different type of data differs per service:
    
    -  for score-based querying of full text search, Elasticsearch comes handy
    -  for getting statistics of open rates for our content team, using AWS Lambdas and DynamoDB fits much better
    -  for simply storing articles without simple relational queries we use Postgres.
 
- And now we are quite impressed by Kotlin. Our Android team is already starting to use it and perhaps we too start to implement future backend services with it.

Good luck on your own path through backend architecture!
