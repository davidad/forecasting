## `forecasting` (project currently dormant)


This represents a thoroughly incomplete project I worked on a bit towards the end of 2012 but that dropped off the bottom of my stack a while ago. I may rescue it at some point.

> *Note from March 20, 2014:*
> It looks like `binary_heap.lua` is a stub which needs to be finished and `zdd.lua` (intended to implement zero-suppressed decision diagrams) isn't written at all. The rest of the program looks to be in decent shape, but, of course, it's never actually been *run* since key components are missing, so I'm sure a lot of debugging would be necessary in addition to supplying those libraries. Oh, and by the way, this code is meant to be run with [LuaJIT](http://luajit.org/).

Some of my notes are reproduced below. `wbe.lua` is also a good place to look, though I only got about 25% done writing it.

* * *

thinking in terms of probabilistic inference...

what I want to do is establish a state space for humanity w.r.t WBE,
at any given point in time, the state may involve multiple technologies serving the same purpose but making different tradeoffs, like block-face EM vs. ATLUM. so what we're really making looks sort of like a class hierarchy...

the aim of this subproject would be to produce a program that can run Monte Carlo simulations to answer questions like "what's the posterior distribution of the date of the first successful human upload"

I also want to be able to automatically identify useful milestones, which are defined as milestones such that:
* we have a decent prediction of when they will happen
* knowing that they did happen on schedule, or why they didn't, would improve certainties for the rest of the process

* * *

Scientific uncertainties are time-invariant random variables. Technological
uncertainties are time-dependent random variables, which may also depend upon
scientific uncertainties. Outcomes are deterministic functions of scientific
and technoloigcal uncertainties.

Relations between technologies are expressed here as one of two types: "any"
or "all."

An "any" relationship represents a choice between several possible
methodologies, where exactly one must be used to satisfy the dependency, and
the best can be chosen at any given point.

An "all" relationship represents a signal flow or requirement set, all of
which must be met and the worst of which becomes a bottleneck or limiting
factor.
