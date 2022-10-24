---
title: "rgpt3: Making requests from R to the GPT-3 API"
tags:
- r
- natural language processing
- "gpt-3"
- text generation
- embeddings
date: "4 October 2022"
output: pdf_document
authors:
- name: Bennett Kleinberg
  orcid: "0000-0003-1658-9086"
  affiliation: 1, 2
bibliography: paper.bib
affiliations:
- name: Department of Methodology and Statistics, Tilburg University, The Netherlands
  index: 1
- name: Department of Security and Crime Science, University College London, UK
  index: 2
---

# Summary

The past decade has seen leap advancements in the field of Natural Language Processing (NLP, i.e., using computational methods to study human language). Of particular importance are generative language models which - among standard NLP tasks such as text classification - are able to produce text data that are often indistinguishable from human-written text. The most prominent language model is GPT-3 (short for: Generative Pre-trained Transformer 3) developed by Open AI and released to the public in 2021 [@brown2020language]. While these models offer an exciting potential for the study of human language at scale, models such as GPT-3 were also met with controversy [@bender2021dangers]. Part of the criticism stems from the opaque nature of the model and the potential biases it may hence propagate in generated text data. As a consequence, there is a need to understand the model and its limitations so researchers can use it in a responsible and informed manner. This package makes it possible to use the GPT-3 model from the R programming language, thereby opening access to this tool to the R community and enabling more researchers to use and test the powerful GPT-3 model.


# Statement of need

The GPT-3 model has pushed the boundaries the language abilities of artificially intelligent systems. Many tasks that were deemed unrealistic or too difficult for computational models are now solvable. 

GPT-3 changes how we do research
and what NLP/AI can do
van der maas


powerful tool with many promises and dangers
bias
bias
bias

binz
stevenson
miotto


need to understand the system
 researchers have recently started to study GPT-3 in a "machine behaviour" [@rahwan2019machine] approach 
need to use it
need to have R access on it
current barrier to using it


Especially the performances of the model on tasks originating from Psychology show the enormous potential of large language models. For example, when asked to formulate creative use cases of everyday objects (e.g., a fork), the GPT-3 model produced alternative uses of the objects that were rated of higher utility but lower originality and surprise compared to creative use cases produced by human participants [@STEVENSON]. Others found that the GPT-3 model shows verbal behaviour similar to humans on cognitive tasks so much so that the model made the same intuitive mistakes that are observed in humans [@binz2022using]. Aside from these efforts to understand how the model _thinks_, others started to study the model in the same way as psychological research is studying human participants. Asked to fill-in a standard personality questionnaire, the GPT-3 model showed as response pattern comparable with human samples [@miotto_who_2022]. The same paper also showed that the model reports to hold values 



mention on the API key issue
no need to run python in the background

Since the model has been released to the public under the Open AI API, the official libraries to interact with the model are limited to python and node.js and community libraries do not yet include access to the model via R. Since a large part of the social and behavioural science research community are using R, this package is intended to widen the access to the GPT-3 model direct from R.

# Open research questions

temperature

# Examples

The `rgpt3` package allows users to interact via R with the GPT-3 API to perform the two core functionalities: i) prompting the model for text completions and ii) obtaining embeddings representations from text input.


requests
(what they are)
(how they are used)
(why they are controversial)

embeddings
(brief example)



# References
