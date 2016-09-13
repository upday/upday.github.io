---
layout: post
title: "Handbook of manners: how to behave in a code review"
description: Some thoughts on code reviews and the way they usually are and they should be performed.
modified:
categories: blog
author: henning_gross
excerpt: Code reviews are a common practise for knowledge distribution, learning and increasing quality - but do we perform them i a way that actually creates value?
tags: [Mindset, Culture, Agile]
date: 2016-09-13T17:49:00-04:00
---

In most companies code reviews are part of the process today. In theory they help distributing knowledge, onboarding new people, increase learning and quality.

A code review, no matter if it is performed in a pairing manner or asynchronously is a situation in which one person inspects the work of another person.

This can lead to the assumption that the reviewer has to accept the changes the reviewee wants to introduce and put the reviewer in a position of power over the reviewee who has to seek for approval.

Agile development teams strive for a conception and identity in which everyone is equally important, equally worthy and hierarchies usually make no difference on functional matters (as long as the manager does not have to protect the business but thats another chapter).

So how does a code-review ideally look like?

Lets base on the assumption that every reviewer has the same intent - which is to convince the reviewee to follow the suggested changes (to improve the quality of the added code)?

When this is the main intent, different approaches to code reviews can only be different strategies to achieve the same goal.

The following strategies/behavioural advices can help to achieve this goal and at the same time improve the team spirit and culture.

# Consult. Dont preach.

The basic mindset in which an engineer should approach a code review for a change introduced by another engineer is the mindset of a consultant. Whatever you say or write: do it with caution. Sentences that start with "I would approach the problem this way..." or "I believe this way would be more efficient" are a good approach if you want to encourage the reviewee to accept your recommendations. Way better than "this solution is inappropriate" or "do it like this". Command-style comments are guaranteed to result in damage. Conflicts, drop of creativity and motivation, bad team spirit. Dont do it.
By the way: adding "please" to such a sentence doesnt help. You already clearly communicated a difference in status. You already switches your consultant-hat for something that is simply inappropriate in modern software development teams. The result will be a bad taste in the mouth at best.
By the way: the (probably correct) advice will now not be accepted full-heated. And team morale is damaged.

If the reviewer would have invested just a little more time and watched the way he communicated: the reviewee might have been very thankful and might have accepted all advise with a smile.

Your effort is well invested if you take a break from time to time and make sure your mindset is tuned, your communication style is respectful and reflects that you are a buddy who just wants to help.


# Do not enforce consensus.

Engineers often tend to forget that there is more than one valid opinion in a lot of cases. Not everything is determined to false and true.
So if the reviewer has communicated his opinion appropriate and was not able to convince the reviewee, the code review is the wrong forum to let discussion escalate and enforce consensus. If the code is robust and fulfills the requirements, let it pass the review and try to move the topic out of the situation. You may have tech meetings or other forums in which you can discuss the topic (ideally in general and not by specific example) with a broader audience.
Letting the topic lie for a week can also help. Often times you realize that consensus isnt important at all. That not only there are more valid opinions than yours. But also that your team maybe can afford to let both opinions stand.

# Do not point at rules but give explanations

Rules and processes kill creativity. You want to give as much freedom to everyone as possible without hurting someone else (thats part of the german constitution by the way ;)).
Developers develop processes and methods. They align on conventions. And other developers violate those. Often times even consceniously. How to handle those violations?
Often times now is the time when the reviewer changes from consultant to finger-pointing judge (and hangman) who points at the wiki in which he documented the rule three years ago (without ever discussing it properly). Usually the tone gets rough (catch some breath, adjust your mindset...).
This behaviour is bad because creative people have the healthy habit to question rules if they are in their way. If the result is that the rule does not create value (but supresses value-creation) in the case the engineer, striving to achieve a goal, will try to navigate around it. In such a case: question the rule, not the violator (in fact violating/questioning rules is a healthy habit).
So back to the situation. State your feedback like this: "at some point we decided to approach things like this like that because we were convinced thats better because of reason a and b. dont you agree? shall we re-evaluate?"
Usually the topic is done now. The reviewee will probably accept the suggestion because the reviewer acted in a consulting role and took the reviewee serious, asked for his opinion.
The reviewee will supposely not feel that the rule harms him so badly any more and follow it. Or a healthy discussion arises that in the end might change something for the better for the whole team.
As a general rule of thumb: do not define too many rules and processes. And in a review: start with understanding the requirements, thinking about potential solutions also from a high-level/architectural/design-perspective. How would you have solved the problem? Then look at the solution. Find real bugs. Only beginners focus on cosmetics (and usually miss real flaws).

# Treat cosmetics as cosmetics

Cosmetics are called cosmetics because they are not substantial. Bad formatting, uncomplete documentation, bad naming or other trivial things should be handled as what they are: cosmetics. Dont ignore them, good make-up can make a difference. But as a reviewer, double-check to make sure your attitude fits the importance of the advice. Nothing is as bad as bad vibes because of things that do not make a real difference in the end.

# Contribute but dont override

It is generally not a bad idea to fix small issues during the code review. You can still point the reviewee at the changes but it does not make sense to invest the time twice. If you can fix a spelling error on the fly - why not do it?
But dont change the design completely. Do not override the substance of what your reviewee wanted to do. Help him, dont control him.



I hope I helped you to gain another angle on code reviews or at least made you reflect your review-patterns and opinions and maybe even helped you to improve.

Best H