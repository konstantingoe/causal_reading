# Comparative Analysis of Causality Papers

This document provides a comparison of selected papers in the field of causality.

## Paper 1: [Finding Alignments Between Interpretable Causal Variables and Distributed Neural Representations](https://proceedings.mlr.press/v236/geiger24a/geiger24a.pdf)

### Brief summary

- Interpretable symbolic algorithms may be used to faithfully explain a complex neural network
model. For that, the concept of *causal abstractions* is utilized. Causal abstraction specifies exactly when a **high-level causal model** can be seen as
an abstract characterization of some **low-level causal model**. Interchange intervention training (IIT) objectives are minimized when a **high-level causal model**
is an abstraction of a neural network under a given alignment. The paper uses IIT objectives to learn an alignment between a high-level (acyclic) causal model and a deep learning model.
Causal abstraction analysis asks whether a low-level model (e.g. neural network) implements a high-level algorithm (causal model) relative to an alignment of variables between the two models.


## Paper 2: [Fundamental Properties of Causal Entropy and Information Gain](https://proceedings.mlr.press/v236/simoes24a/simoes24a.pdf)

### Brief summary


- The paper engages in a mathematical study of the properties of (conditional) causal entropy and (conditional) causal information.

    The classical entropy of a random variable is the average level of *information*, *surprise*, or *uncertainty* inherent to the variable's possible outcomes:
    $$ H_{X \sim p}(X) = - \sum_{x \in \mathcal{X}} p(x) \log p(x),$$
    where in the paper base $2$ of the log is assumed which gives the unit of bits (or "Shannons").

    Conditional entropy quantifies the amount of information needed to describe the outcome of a random variable $Y given that the value of another random variable $X$ is known, i.e. $H(Y\mid~X)$ is the expected value w.r.t. $p_X$ of the entropy $H(Y \mid X = x) = H_{Y \sim P_{Y\mid X}}(Y)$ where
    $$ H(Y\mid X) = E_{x \sim p_X} [H(Y \mid X = x)].$$

- The causal entropy of $Y$ for $X$ is the entropy of $Y$ that is left, on average, after one *atomically* intervenes on X. Causal entropy is the average uncertainty one has
about $Y$ if one sets $X$ to $x$ with probability $p_{X'}(x)$, where $X'$ is a new auxiliary variable with the same range as $X$ but independent of all other variables, including $X$.

- Causal information gain extends mutual information/information gain to the causal context.
While mutual information between two variables $X$ and $Y$ is the average reduction in uncertainty
about $Y$ if one observes the value of $X$, the causal information gain of $Y$ for
$X$ is the average decrease in the entropy of $Y$ after one atomically intervenes on $X$ (folowing an intervention protocol $X'$).

## Paper 3 [Functional Bayesian networks for discovering causality from multivariate functional data](https://onlinelibrary.wiley.com/doi/epdf/10.1111/biom.13922)

### Brief summary

Functional LiNGAM assumption in the infinite sum expansion.