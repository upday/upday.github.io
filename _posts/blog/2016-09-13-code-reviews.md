---
layout: post
title: "Handbook Of Manners: How To Behave In A Code Review"
description: Some thoughts on code reviews and the way they usually are and they should be performed.
modified:
categories: blog
author: henning_gross
excerpt: Code reviews are a common practise for knowledge distribution, learning and increasing quality - but do we perform them in a way that actually creates value?
tags: [Mindset, Culture, Agile, XP]
date: 2016-09-13T17:49:00-04:00
---

In most companies __code reviews__ are part of the __process__ today. In theory they help distributing knowledge, onboarding new people, increasing learning and quality.


A code review, no matter if it is performed in a pairing manner or asynchronously is a situation in which one person __inspects__ the work of another person.


This can lead to the __assumption__ that the reviewer has to accept the changes the reviewee wants to introduce and put the reviewer in a position of power over the reviewee who has to __seek for approval__.


__Agile development teams__ strive for a conception and identity in which everyone is __equally__ important, equally __worthy__ and hierarchies usually make __no difference__ on functional matters (as long as the manager does not have to protect the business but that's another story).


So how does a code-review ideally look like?


Let's base on the assumption that every reviewer has the same intent - which is to __convince__ the reviewee to follow the suggested changes (to improve the quality of the added code).


When this is the main __intent__, different approaches to code reviews can only be different __strategies__ to achieve the same goal.


The following strategies/behavioural advices can help to achieve this goal and at the same time improve the team spirit and culture.


## Consult - Don't Preach

The basic mindset in which an engineer should approach a code review for a change introduced by another engineer is the mindset of a __consultant__. Whatever you say or write: do it with caution. Sentences that start with _I would approach the problem this way..._ or _I believe this way would be more efficient_ are a good approach if you want to encourage the reviewee to accept your recommendations. Way better than _This solution is inappropriate!_ or _Do it like this!_. Command-style comments are guaranteed to result in damage, conflicts, decreased creativity and motivation and bad team spirit. Don't do it.

By the way: using _please_ to soften a a harsh sentence does not help. You already clearly communicated a difference in status. You already switched your consultant-hat for something that is simply inappropriate in modern software development teams. The result will be a bad taste in the mouth at best.

Even more, given as a command, even if correct, the advice won't be accepted wholeheartedly and the team morale is damaged.


If the reviewer would have invested just a little more time and watched the way he communicated: the reviewee might have been very thankful and might have accepted all advise with a smile.


The effort is well invested if one takes a break from time to time and makes sure the mindset is tuned, communication style is respectful and reflects the intention to help.


## Don't Enforce Consensus

Engineers often tend to forget that there is more than one valid opinion in a lot of cases. __Not everything is determined to false and true__.

So if the reviewer has communicated his opinion appropriate and was not able to convince the reviewee, the code review is the wrong forum to let discussion escalate and enforce consensus. If the code is robust and fulfills the requirements, let it pass the review and try to move the topic out of the situation. You may have tech meetings or other forums in which you can discuss the topic (ideally in general and __not__ by specific example) with a broader audience.

Letting the topic lie for a week can also help. Often times you realize that consensus __isn't important at all__. That not only there are more valid opinions than yours. But also that your team maybe can afford to __let both opinions stand__.

## Don't Point At Rules - Give Explanations

Rules and processes kill __creativity__. You want to give as much freedom to everyone as possible without hurting someone else (that's part of the German Constitution by the way ;)).

Developers develop processes and methods. They align on conventions. And other developers violate those. Often times even conscientiously. How to handle those violations?

Often times now is the time when the reviewer changes from consultant to finger-pointing judge (and hangman) who points at the wiki in which he documented the rule three years ago (without ever discussing it properly). Usually the tone gets rough. _Catch some breath, adjust your mindset..._.

This behaviour is bad because creative people have the habit to question rules if they are in their way. If the result is that the rule does not create value (but supresses value-creation) in the case the engineer, striving to achieve a goal, will try to navigate around it. In such a case: __question the rule__, not the violator. In fact violating/questioning rules is a __healthy habit__.

Feedback should be stated like this: _At some point we decided to approach things like this like that because we were convinced that's better because of reason X and Y. Don't you agree? Shall we re-evaluate?_

Usually the topic is done now. The reviewee will probably accept the suggestion because the reviewer acted in a consulting role and took the reviewee serious, asked for his opinion.

The reviewee will supposely not feel that the rule harms him so badly any more and follow it. Or a healthy discussion arises that in the end might change something for the better for the whole team.

As a general rule of thumb: __do not define too many rules and processes__. And in a review: start with understanding the requirements, think about potential solutions also from a high-level/architectural/design-perspective. __How would you have solved the problem?__ Then look at the solution. __Find real bugs__. Only beginners focus on cosmetics (and usually miss real flaws).

## Cosmetics Are Cosmetics

Cosmetics are called cosmetics because they are __not substantial__. Bad formatting, incomplete documentation, bad naming or other trivial things should be handled as what they are: cosmetics. Don't ignore them, __good make-up can make a difference__. But as a reviewer, double-check to make sure your attitude fits the importance of the advice. Nothing is worse than bad vibes because of things that do not have a real impact.

## Don't Override - Contribute

It is generally not a bad idea to fix small issues during the code review. You can still point the reviewee at the changes but it does not make sense to invest the time twice. If you can fix a spelling error on the fly - why not do it?

But don't change the design completely. Do not override the __substance__ of what your reviewee wanted to do. Help him, don't control him.


## Summing up

It is all about your __mindset__ and __team dynamics__. People need to resist the urge to use the power they have in a review situation. Teams need to come to a state in which __openness__ and __transparency__ are worshipped as __virtues__. Into a state in which being asked for a review is a compliment that everyone is happy to take. A state in which everyone treats the others weaknesses as valuable as their strengths and actually wants to get better together. You do not need a book of behaviour. You do not need strict rules for a review. What you need is  respect for others and some emotional intelligence to anticipate how they will __feel__ reading or listening to your review comments.