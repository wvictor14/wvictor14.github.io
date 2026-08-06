Scratch pad for this post

## Topic: LLM benchmarks for bioinformatics tasks

A number of benchmarks have been released

- BixBench | FutureHouse [2025 Mar 4 Blog Post](https://www.futurehouse.org/research/bixbench) | [2025 Feb 28 arXiv](https://arxiv.org/abs/2503.00096)
- BioMysteryBench | Anthropic [2026 Apr 29 Blog Post](https://www.anthropic.com/research/Evaluating-Claude-For-Bioinformatics-With-BioMysteryBench)
- CompBioBench | Genentech [2026 Apr 6 bioRxiv preprint](https://www.biorxiv.org/content/10.64898/2026.04.06.716850v1) | [Dataset](https://zenodo.org/records/19443186) | [HF](https://huggingface.co/spaces/Genentech/compbiobench-leaderboard-v1.)

Number of other bioformatics / science related benchmarks do exist, but none evaluate specifically on bioinformatics tasks like these do.

## Potential questions post can answer:

### How do these benchmarks compare to each other? Are they consistent?

### Why do we need benchmarks?

LLMs are evaluated using benchmarks for many different tasks: math, physics, biology, creative writing, programming, research, etc. 

Every time a new model is released, numbers will always show +x% improvement, what's behind that number though? And more importantly is it relevant for the tasks I care about? Not everyone needs a creativer writing llm for example, or an LLM that can code slick frontend css animations. On the other side, just because a model is really good at producing artwork in the style of famous artists, doesn't mean that it's going to be good at writing clean code. 


### What is a benchmark?

- BixBench addresses this opportunity for a real-world analytical research benchmark by providing a diverse set of 53 analytical scenarios with 296 guiding research questions, paired with heterogeneous input data.



Topic idea

- compare benchmarks, where they fall short
- summarize findings, digest it for readers


# Content draft

A number of benchmarks have been release -> 

They claim to evaluate LLMs in their ability to conduct bioinformatics tasks ->

They acknowledge the challenges due to many correct paths, no objective evaluation for many open-ended tasks, bioinformatics is a creative activity

This shows in their approach in their methodology differences - they take different approaches

They aren't comprehensive, they only evaluate claude and gpt, but leave out current SOTA models notable openweight ones like DeepSeek, and more recently Kimi.

So is AI going to replace me? Well I looked at a few questions from each of these and decided to see how I compare against each LLM's published result.

Go into tasks

## 