---
layout: post
title: "Handbook Of Manners: How To Behave In A Code Review"
description: Some thoughts on code reviews and the way they usually are and how they should be performed.
modified:
categories: blog
author: henning_gross
excerpt: Code reviews are a common practice for knowledge distribution, learning and increasing quality - but do we perform them in a way that actually creates value?
tags: [Mindset, Culture, Agile, XP]
date: 2016-09-13T17:49:00-04:00
---

In most companies __code reviews__ are part of the __process__ today. In theory they help to distribute knowledge, onboard new people and improve learning and quality.


A code review, no matter if it is performed in a pairing manner or asynchronously, is a situation in which one person __inspects__ the work of another person.


This can lead to the __assumption__ that the reviewer has to accept the changes the author wants to introduce and put the reviewer in a position of power over the author who has to __seek approval__.


__Agile development teams__ strive for an identity in which everyone is __equally__ important, equally __worthy__ and in which hierarchies typically make __no difference__ on functional matters (as long as the manager doesn't have to protect the business, but that's another story).


So what does an ideal code review look like?


Let's start with the assumption that every reviewer has the same intent - which is to __convince__ the author to follow the suggested changes (to improve the quality of the contributed code).


When this is the main __intent__, different approaches to code reviews can only be different __strategies__ to achieve the same goal.


The following advice can help to achieve this goal and at the same time improve the team spirit and culture.


## Consult - Don't Preach

The basic mindset in which an engineer should approach a code review for a change introduced by another engineer is the mindset of a __consultant__. Whatever you say or write; do it with caution. Sentences that start with _I would approach the problem this way..._ or _I believe this way would be more efficient_ are a good approach if you want to encourage the author to accept your recommendations. Way better than _This solution is inappropriate!_ or _Do it like this!_. Command-like comments are guaranteed to result in damage, conflicts, decreased creativity and motivation and bad team spirit. Don't do it.

By the way, using _please_ to soften a harsh sentence doesn't help. You already clearly communicated a difference in status. You have already switched your consultant "hat" for something that's simply inappropriate in modern software development teams. The result will be a bad taste in the mouth at best.

Even more, given as a command, even if correct, the advice won't be accepted wholeheartedly and the team morale is damaged.


If the reviewer had invested just a little more time and watched the way they communicated: the author might have been very thankful and might have accepted all advice with a smile.


The effort is well invested if one takes a break from time to time and makes sure the mindset is tuned, communication style is respectful and reflects the intention to help.


## Don't Enforce Consensus

Engineers often tend to forget that there is more than one valid opinion in a lot of cases. __Not everything is determined to false and true__.

So if the reviewer has communicated their opinion appropriately and was not able to convince the author, the code review is the wrong forum to let discussion escalate and enforce consensus. If the code is robust and fulfills the requirements, let it pass the review and discuss the matter in an appropriate format. You may have tech meetings or other forums in which you can discuss the topic (ideally in general and __not__ by specific example) with a broader audience.

Letting the topic lie for a week can also help. Often times you realize that consensus __isn't important at all__. That not only there are more valid opinions than yours. But also that your team maybe can afford to __let both opinions stand__.

## Don't Point At Rules - Give Explanations

Rules and processes kill __creativity__. You want to give as much freedom to everyone as possible without hurting someone else (that's part of the German constitution by the way [Article 2.1 _Every person shall have the right to free development ... insofar as he does not violate the rights of others ..._]).

Developers construct processes and methods. They align on conventions. Sometimes other developers violate them; often even deliberately. How to handle those violations?

Often when the reviewer changes from consultant to finger-pointing judge (and hangman) who points at the wiki in which he documented the rule three years ago (without ever discussing it properly); the tone gets rough. _Catch some breath, adjust your mindset..._.

This behavior is bad because creative people have the habit to question rules if they are in their way. If the result is that the rule doesn't create value (but suppresses value-creation) the engineer, striving to achieve a goal, will try to navigate around it. In that case: __question the rule__, not the violator. In fact questioning and violating rules is a __healthy habit__.

Feedback should be stated like this: _At some point we decided to approach things like this like that because we were convinced that's better because of reason X and Y. Don't you agree? Shall we re-evaluate?_

Usually the matter then resolves itself. The author will probably accept the suggestion because the reviewer acted in a consulting role and took the author seriously by asking for his opinion.

The author will likely feel not so pained by the rule, and decide to follow it. If not, a healthy discussion arises that might change something for the better for the whole team.

As a general rule of thumb: __do not define too many rules and processes__. In a review: start with understanding the requirements, think about potential solutions also from a high-level, architectural and design-perspective. __How would you have solved the problem?__ Then look at the solution. __Find real bugs__. Only beginners focus on cosmetics (and usually miss real flaws).

## Cosmetics are cosmetics

Cosmetics are called cosmetics because they are __not substantial__. Bad formatting, incomplete documentation, bad naming or other trivial things should be handled as what they are: cosmetics. Don't ignore them, __good make-up can make a difference__. But as a reviewer, double-check to make sure your attitude fits the importance of the advice. Nothing is worse than bad vibes because of things that do not have a real impact.

## Don't Override - Contribute

It is generally a good idea for the reviewer to fix small issues during the code review. You can still point the author at the changes, but it doesn't make sense to invest the time twice. If you can fix a spelling error on the fly - why not do it?

But don't change the design completely. Do not override the __substance__ of what your author wanted to do. Help the author, don't control the author.


## Don't Only Focus On The Bad Things

Try to emphasize good things about the code under review. One of the developers from my team, Peter Tackage, recently stated: _If I give compliments to someone's implementation then it can lessen the unwanted negative or criticizing aspects of a review. Something like: 'nice solution' or 'neat' when merited, can reinforce a positive mindset in reviews and communicate to the author that the reviewer is truly interested in solving the problem, rather than simply solving the problem their way_ - and I agree.
Sometimes that's a cultural thing. Germans, like me, for instance tend to focus on problems. Maybe that is even an european issue while people from the USA are well-trained in praising other peoples sweet spots.
In communication- and management-trainings people learn about the burger-strategy. If you want to criticize someone, wrap it in two nice things. Whereas I resent tactical/manipulative behavior there is a point of truth in this. If you try to see the good, talking about the bad has a completely different taste.

## And The Author...

This text has focused on the reviewer's behavior until now. Of course there is another book to be written about the author and their behavior.
About how to handle and accept critical feedback; not only about how to give such.

In general you can adopt everything said; try to trust the reviewer, assume positive intent.

Be aware of the fact that written word always strongly underlies interpretation.

Be aware of social, cultural and language barriers.

As a single, simple and practical piece of advice: structure your code, comments and commits in a way that helps the reviewer understand what you are doing.


## Summing up

It is all about your __mindset__ and __team dynamics__. People need to resist the urge to use the power they have in a review situation. Teams need to come to a state in which __openness__ and __transparency__ are worshipped as __virtues__. Into a state in which being asked to be perform a review is seen as a compliment from the author. Who trusts you by exposing their work and asking for comments and contribution. A state in which everyone treats the others' weaknesses as being as valuable as their strengths and where everyone actually wants to get better together. You do not need a book of behavior. You do not need strict rules for a review. What you need is respect for others and some emotional intelligence to anticipate how they will __feel__ reading or listening to your review comments.