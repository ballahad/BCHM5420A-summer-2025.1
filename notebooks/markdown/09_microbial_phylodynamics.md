# Microbial Phylodynamics

2025-06-04

This lesson explores how evolutionary patterns in microbes are modelled and combined with metadata to make informative discoveries. Phylogenomics attempts to use genomic information to reconstruct the evolutionary history and relationships of organisms. When phylogenetics is combined with epidemiology you can begin to model infection dynamics - Phylodynamics. We will go out on a limb and branch out from our previous bioinformatic analyses - let's leaf through it!

## Table of Contents

[Trees](#trees)<br>
[Anatomy of a Tree](#anatomy-of-a-tree)<br>
[Types of Trees](#)<br>
[Phylogenetic Analysis](#phylogenetic-analysis)<br>
[Phylogenetic Inference Methods](#phylogenetic-inference-methods)<br>
[Bayes Theorem](#bayes-theorem)<br>
[BEAST](#beast)<br>
[BEAST Workshop](#beast-workshop)<br>
[Applied Phylodynamics](#applied-phylodynamics)<br>
[Phylodynamic Visualization](#phylodynamic-visualization)<br>
[Recap](#recap)<br>


## Trees

<img src="../../images/speech.png" width=65>

Describe a tree. What comes to mind when you envision one? 

You may have mentioned:

- roots
- trunk
- leaves
- branches
- seeds 
- growth 

It is a structure borrowed to represent what we observe in molecular bioinformatics (phylogenetic trees), computer science (abstract syntax trees, decision trees), linguistics (constituency trees), mathematics (spanning trees, Steiner trees), chemistry (structural similarity trees), and neuroscience (neural circuits). These tree models parallel natural trees well in many ways - commonalities include distance among members, shared ancestry of some sort, and forward/ upward growth from root to leaves. Tree structures are also referred to broadly as ***dendrograms*** from the Greek δένδρον (déndron) - tree - and γράμμα (grámma) - drawing. 

<img src="../../images/09_darwin_tree.png" width=450>
<div style="font-size: 12px">
Scribblings from Darwin's notebook pondering relatedness of organisms in 1837.
</div>


## Anatomy of a Tree

Here is the skeloton of a basic tree annotated with terminology of its various elements. *Tips* are contemporary species or *taxon* which are located at the *leaves* of the tree. Phylogenetic trees have *branches* connected by *nodes* - *terminal nodes* are also know as *external nodes* or *tips*, while other nodes are *internal* and represent the ancestor of subsequent nodes. In *divergence* phylogenies, branch lengths encode the number of substitutions per genomic site per year. For example, a longer branch means more nucleotide substitutions have occurred in the same genome in the same amount of time. Taxa descending from a common ancestor are termed a *clade*. A clade with more than 2 species, or a *multifurcation* instead of the usual *bifurcation*, means lineages diverged simultaneously or there is insufficient data to resolve the order of divergence. The *topology* is the overall branching pattern of the tree. 

<img src="../../images/09_tree_terminology.png" width=800>


```python

```

## Types of Tree

### Cladogram

A cladogram shows the relationship among organisms while ignoring branch length. As you can see, branch lengths are the same and do not provide information on the amount of sequence change that has occurred. For example, a cladogram may be used to group organisms based on an observed trait like wing size but does *not* comment on *evolutionary history*. The branch lengths are arbitrarily chosen and otherwise meaningless.

<img src="../../images/09_clado_vs_phylo.png" wdith=700>


### Phylogram

In a phylogram or phylogenetic tree, the branches hold meaning. The length corresponds to either the sequence divergence or time that has elapsed since speciation. Phylograms are a type of dendrogram (tree) and comment on evolutionary history of related organisms. The type of information encoded in the branch lengths of a phylogram distinguish it into two categories: divergence and time trees.

### Divergence

By building phylogenetic trees, we are building a *hypothesis* of common ancestry. It is important to remember a phylogenetic tree is an *estimate* of molecular *history*, since we were not there, we are clustering together sequences with similar mutations in order to infer *how* the genotype of an organism we currently observe came to be. In other words, we are hypothesizing the order of descent of a given genome. Traditionally, phylogenetic trees are scaled by mutations normalized by gene/genome length and unit time (usually year). The reason tips are also called terminal nodes, is because the difference (branch length) between inferred common ancestor and itself is 0 - they are the same! Phylogenies show the relative nucleotide divergence among collected sequences. The branch lengths are measured using the provided scale to inform the distance of one taxon from another, distance from the most recent common ancestor (MRCA) shared by two clades, or how different a sequence is from the MRCA of all taxa in the tree - the *root*. Genetic divergence phylogenies estimate ***how*** a genome evolved.

<img src="../../images/speech.png" width=65>

Take a look at the tree below: 

- What does it tell you about species `E`? 
- What would happen to the tree if another sequence called `G` was introduced that had both yellow and green mutations?
- Could the green mutations have occurred after the orange mutations?
- Is it possible that `B` was sampled *before* `C`? If so, how?

<img src="../../images/09_msa_and_tree.png" width = 700>


<br>
<br>
<img src="../../images/lightbulb.png" width=70>

Notice how a key assumption is that more mutations = more recent, which may not always be true. Remember, we do not have information on time in the above tree, other than present vs. past.


### Time

As soon as the timing of genomic divergence from parent to offspring sequences is estimated, we have a ***timetree***. This type of tree is also known as a ***chronogram***. Notice the x-axis specifies date in the example below - the phylogeny is *time-scaled*. We are using information on time, such as collection date or a dated fossil to calibrate the tree, to estimate *when* divergence occurs. Time-scaled phylogenies estimate ***when*** a genome evolved.

<img src="../../images/09_sars-cov-2_pandemic.gif" width=900>
<div style="font-size: 12px">
Timetree of the SARS-CoV-2 Pandemic and associated geographical distribution of lineages.
</div>



### Rooted

Just like a real tree, the root is where all branches and leaves originated from. A root is the most recent common ancestor (MRCA) of sequences in a given dataset. Adding a root to a phylogenetic tree adds direction. A tree cannot grow without its roots! We are hypothesizing that the direction of growth/ evolution is from the root to tips when we include one. Stated differently, adding a root says nodes closer to it are ancestors of nodes farther from it. Normally, the little nubbin represents the root, but just because it is not visually evident it does not mean it is not there! A phylogenetic tree can be ***rooted*** in multiple ways:

 - **midpoint:** this strategy calculates the tip to tip distances, finds the two longest branches, then places the root halfway between them. Midpoint rooting assumes that the two most divergent species (ie. longest tip to tip distance) evolved at equal rates and that the tree can therefore be "folded in half" to represent the evolutionary starting point. This can come in handy if an outgroup is unknown, as is often the case for newly discovered organisms.

 - **outgroup:** one of the most popular rooting methods which uses a sequence that we know to be more divergent (but not too divergent) from the dataset than sequences within the dataset are to each other. If the outgroup sequence(s) are too divergent it may cause complications in aligning. For example, a good choice of outgroup to *Treponema pallidum* spp. *pallidum* that causes syphilis might be *Treponema pallidum* spp. *endemicum* that causes bejel.
 
 - **molecular clock rooting:** This method assumes constant evolutionary rate (ie. strict molecular clock) across taxa and plots sequences as (x,y) coordinates, where x is time and y is genetic divergence from that tip/ point to a candidate root. The phylogeny starts as unrooted and candidate roots are tested. The root sequence that produces a scatter that best fits a linear trend is selected. The slope = molecular clock rate or ***evolutionary rate***. This linear relationship between nucleotide divergence and time is called "clock-like behaviour". If a dataset of sequences appears to follow a linear trend it means mutations are periodically appearing (tick tock) and the dataset exhibits ***temporal signal***.


 <img src="../../images/09_molecular_clock.png" width = 900 height = 400> 

### Unrooted

An unrooted tree does not make any inferences about which sequence is ancestral to the dataset and is more interested in the relationships *among* them. Just like a real tree without roots, we can still get information about the leaves on branch A compared to branch B, but we may not know if branch B originated from branch A. Unrooted trees do not estimate a shared ancestor nor do they suggest direction of inheritance. A tree can only grow with roots! 

<img src="../../images/09_root_vs_unroot.png" wdith=500>
<div style="font-size: 12px">
For example, in the unrooted tree (right) we can see that eukaryotes and archaea are different but we cannot say which originated first unlike the rooted tree (left) which shows archaea as basal to eukaryotes.
</div>


## Phylogenetic Analysis

Fundamentally, the construction of a phylogenetic tree involves 3 steps:

1. Multiple Sequence Alignment (MSA) 
1. Build tree 
1. Assess reliability of tree

### Multiple Sequence Alignments

You may have heard of pairwise alignment of two sequences at a time (Smith-Waterman & Needleman-Wunsch algorithms). As the name suggests, MSA extends this to align several at a time. The most popular algorithm is ***progressive*** alignment, which repeatedly pairwise aligns sequences in order of decreasing similarity. More specifically:

1. Global pairwise alignments (Needleman-Wunsch) of all sequences
2. Align two most similar sequences
3. Then: 
    <br> option a) Align next 2 most similar sequences together
    <br> option b) Align a sequence with group of aligned sequences 
    <br> option c) Align group of aligned sequences with another group

until all sequences are aligned together. The term MSA is used interchangeably to refer to the *process* and *resulting fasta file*. 
Progressive alignment tools include `MUSCLE`, `MAFFT`, `T-Coffee`, `Mauve`, and `Clustal Omega`. 

The ***quality*** of your MSA is crucial to the quality of the tree generated. Garbage in = garbage out. It is highly recommended that you visually check the alignment, as automated checks like genome completeness still do not tell you *where* gaps are located and there may be misaligned sequences which are obvious upon inspection. Another consideration is duplicate sequences in an alignment. It is important not to simply discard duplicates - consider that there may be a reason a particlar genotype is more prevalent in a population and that you may be artificially adjusting/ skewing the evolutionary process. For example, if duplicate sequences are a result of an accidental double download (remove) versus sampled from two disparate geographical regions and timepoints (keep). 

### Outputs

Phylogenetic trees are commonly represented as:

- **NEXUS:** #NEXUS Begin trees; Tree tree1 = (A:0.1,B:0.2,(C:0.3,D:0.4):0.5); End;
- **Newick:** (A:0.1,B:0.2,(C:0.3,D:0.4):0.5); 
- **JSON:** {"name":"root","branch_length":null,"children":[{"name":"A","branch_length":0.1},{"name":"B","branch_length":0.2},{"branch_length":0.5,"children":[{"name":"C","branch_length":0.3},{"name":"D","branch_length":0.4}]}]}

Newick is most popular and usually has file extensions like \*.nwk, \*.newick, or \*.tree. It can encode branch length information, node support, and node names.

Next, let's look at the different methods to infer a phylogenetic tree and the software that implement them.

## Phylogenetic Inference Methods

| Feature                  | Maximum Parsimony (MP)       | Neighbor Joining (NJ)     | Maximum Likelihood (ML)    | Bayesian Inference (BI)     |
|--------------------------|----------------------|----------------------------|-----------------------------|------------------------------|
| Best tree                | Tree with smallest evolutionary changes to describe sequences in dataset    | Iteratively joined pairs of taxa/ clusters that minimize total branch lengths            | The tree topology, branch lengths, & evolutionary model that maximizes probability of observing sequences in dataset. ie. the tree model that most likely results in observing the sequences in dataset - highest likelihood score          | Estimates the probability distribution over trees by combining prior beliefs with the likelihood of the observed data using Bayes’ theorem. ie. most probable tree(s) identified by integrating over possible trees and model parameters using Bayes’ theorem, based on prior information and data likelihood           |
| Data type                | Aligned characters    | Distance matrix            | Aligned characters          | Aligned characters           |
| Uses substitution model? | No                 | (in distance step)       | Yes                      | Yes                        |
| Branch lengths           | Not estimated      | Yes                     | Yes                      | Yes (with uncertainty)     |
| Statistical support      | Bootstraps | Bootstraps              | Bootstraps              | Posterior probabilities   |
| Can estimate divergence times? | No         | No                      | Not directly             | Yes                        |
| Speed                    | Fast               | Very fast              | Moderate to slow         | Slowest (MCMC sampling)  |
| Best for                 | Simple or small datasets | Quick surveys         | Robust phylogenetics        | Full uncertainty modeling    |
| Tools                 | `MPBoot` `PHYLIP` `PAUP`| `DecentTree` `NINJA`       | `IQ-TREE` `RAxML-NG` `FastTree` `PHYML` `PHYLIP`     | `MrBayes` `BEAST`    |

 ### Assessing Reliability

Since we said a phylogenetic tree is a hypothesis of evolutionary history, we want to quantify our confidence in the divergence/ timing that we observe in one. Is the organization of taxa, branch lengths, and way nucleotides are evolving (tree model) we selected significantly better than other tree models? In phylogenetics, ***bootstrapping*** is a type of statistical technique called resampling that is used to sample random sites (with replacement) from the MSA. This process is repeated n times ("number of bootstraps") and trees are generated from these "perturbed" MSAs. A consensus tree is generated from n trees and each branch is assigned a support value. The support value or ***bootstrap value*** in the consensus tree is the proportion of bootstrapped trees that also have a particular branch. For example, a branch with a bootstrap value of 90 means that 90% of trees contain that branch, so we a fairly confident that the placement of this branch in the consensus tree is reliable.

<img src="../../images/09_bootstrapping.png" width=600>

## Bayes' Theorem

The key takeaway from ***Bayes' Theorem*** is that you approximate the probability of observing an event *given* some *prior* knowledge. You keep updating your hypothesis as you obtain more information that will affect the posterior probability.

<img src="../../images/09_bayes_theorem.png" width = 500> 

The numerator can be rephrased as "the probability of observing A AND B". For example, what is the probability of Jessica having coffee given that it is a Monday? This can be calculated as the probability that Jessica is having coffee AND that it is a Monday, normalized by the probability it is a Monday. (The answer is 100%).

### Bayes' Theorem in Phylogenetics

Normally, we use maximum likelihood estimates (ie. which tree model best fits your multiple sequence alignment, then choose model that maximizes the probability of observing given dataset). This approach is somewhat ignorant to additional information, like rates of mutation across the genome, how sites mutate, how mutation rate changes across species, changes in population during infection. 

<img src="../../images/09_bayes_beast.png" width = 900> 


## BEAST

**B**ayesian **E**volutionary **A**nalysis by **S**ampling **T**rees. BEAST is a popular software for estimating time-measured phylogenies that was originally developed by Alexei Drummond & Andrew Rambaut in 2007, with a host of [contributors](https://www.beast2.org/citation/) since. It uses Bayes' Theorem and MCMC to generate 1000s of trees, each which explore parameter, sequence, and evolutionary space to obtain an "average" phylogenetic tree. In Bayesian statistics, we do not have a 95% confidence interval in the frequentist sense but instead have the conceptually similar 95% Highest Posterior Density (HPD), which is the shortset interval that contains 95% of the posterior probability mass. 

### Mechanistic Overview

In standard genetic distance phylogenies, we estimate which sequences came from where, how close certain sequences are to each other through time or at any given point in time. BEAST allows you to do anything you can do with regular phylogenies but instead of basing observations off of a single tree, you are now drawing conclusions from an “average” tree of multiple samples from a posterior distribution. There are underlying models that go into creating a phylogenetic model (tree):

- clock models: the rate at which mutations occur across the branches 
- substitution models: the rate at which/ how nucleotides change across the genome 
- branch models: the way branches diverge and their lengths

Each of these is a prior (branch prior, clock prior, substitution prior), each with several choices of models (ex. the clock prior has a strict clock model, relaxed uncorrelated, relaxed correlated, local [clock model](https://beast.community/clocks)..) that together provide some *prior* information (P(A) in Bayes' Theorem) that we will incorporate into our final tree. 

Bayesian methods use Markov Chain Monte Carlo (MCMC) sampling which results in a large number of trees representing the distribution over all possible phylogenies. Imagine a 2D landscape with peaks and valleys where each point on the landscape represents a possible tree (its topology + branch lengths + parameters). The height of the landscape at any point represents the posterior probability of that tree (see [Bayes' Theorem](#bayes-theorem)), so a point (tree) from a peak on this surface is more plausible given the data and model than a tree from a valley. Imagine you send a robot, blindfolded, to explore this surface (MCMC algorithm) and ask it to periodically record the point (tree) it is standing on (sample from the posterior distribution). The robot tends to move to higher areas (better trees) but sometimes visits lower areas on the surface. The result of this expedition is a collection of trees, drawn more frequently from high-probability regions of the landscape which provides confidence about most commonly occurring clades, estimates of parameters like evolutionary rate, and variability in divergence times.

### Analysis Overview 

There are more software depending on the analysis you are running, but the key practical steps are briefly outlined:

<img src="../../images/09_beast_workflow.png" width=800>

`Tempest`: Tool to look at ‘clocklikeness’ of molecular phylogenies and can perform molecular clock rooting. This can be a useful place to see if there are outliers in the data that violate the "clock" assumption, as they may hint towards poor quality sequences or those with mislabelled dates!

`BEAUTi`: Bayesian Evolutionary Analysis Utility. This program is used to import data, design the analysis, and generate the BEAST control file (*.xml).

`BEAST`: Bayesian Evolutionary Analysis Sampling Trees. This is the main program that takes the control file generated by BEAUti and performs the analysis. It uses Markov Chain Monte Carlo (MCMC) to tweak parameters of underlying (nucleotide, branching, clock) models and generate a posterior distribution of trees.

`Tracer`: A tool to explore BEAST outputs, summarize results, and check for problems to adjust analysis if necessary. Likely, you will need to redo the BEAST step at least once after checking the *.log files in Tracer.

`TreeAnnotator`: Program that produces a summary tree from the posterior distribution of trees that BEAST generates. Since we are estimating the most credible tree from a distribution, there will be "jitter" around each underlying parameter or model that goes into making a tree. For example, the most credible estimate of when a speciation event occurs is drawn from a distribution of trees with that speciation event, so we expect to see some "jitter" or a range of estimates for this node placement. The tool DensiTree really assists in clariying what BEAST is doing.

`DensiTree`: A tool to qualitatively analyze sets of trees produced by BEAST.

`FigTree`: A GUI tree visualization tool.


### BEAST Workshop

Feel free to follow along in class or on your own afterwards. BEAST2 and BEAUti2 are Java programs, so should be platform agnostic. There are several tutorials and extensive documentation provided by the BEAST community which are recommended if you are interested in using BEAST for to answer your hypothesis! This tutorial is from the BEAST website and serves as a starting point, mainly aimed at digesting the concepts, tools, and general workflow of a basic BEAST analysis. Let's navigate over to a [BEAST tutorial](https://bioinformatics-tutorials.readthedocs.io/en/latest/beastintro/). The figures may appear slightly different as it is based on a different version, but the principles are the same. You can download the input MSA from the resources directory of our [class repo](https://github.com/uleth-advanced-bioinformatics/BCHM5420A-summer-2025/tree/main/resources). 


```python
# download MSA of flu sequences for BEAST workshop

curl -O https://raw.githubusercontent.com/uleth-advanced-bioinformatics/BCHM5420A-summer-2025/main/resources/Flu.nex
```

## Applied Phylodynamics

In November of 2024, a teen from BC (since recovered) was infected by influenza A(H5N1). This was the first infection by H5N1 recorded in Canada. The virus belonged to Subtype: A / H5N1, GISAID clade: 2.3.4.4b, Genoflu genotype: D1.1, which was of concern because the mortality rate is ~ 50%, H5N1 has a large host range (bears, cats, cows, dolphins, birds), and migratory aquatic birds are the natural reservoir of H5N1. Since 2020, highly pathogenic avian influenza (HPAI) A(H5N1) virus was circulating in nonhuman mammals so detecting it in a human was of concern, even if there was not yet evidence of human-to-human transmission.

The sequence was uploaded to GISAID under accession EPI_ISL_19548836 on Nov 15 (1 week after discussion among NML and BCCDC regarding sites with mixed VAF among sequencing methods/ sample replicates), and the [publication](https://www.nejm.org/doi/full/10.1056/NEJMc2415890) chronicling the BC teen case was released on Dec 31, 2024. 

<img src="../../images/09_adolescent_infection_article.png" width=300>

The time from detection to publication of the case was just over a month - the dates provide insight into how quickly the situation was unfolding, and the short turnaround times that such a fast-evolving situation necessitated! This included the phylodynamic analysis to estimate the origin of influenza A genotype D1.1 in BC, which I was enlisted to perform on Nov 27, 2024 and completed on Nov 29, 2024. Here was the bioinformatic analysis approach.

As we know, the first step was to define the research question! What is the origin of D1.1 into BC? When we say "origin" what does that mean? 

**Research Question:** From which host & country did D1.1 arrive into BC and when? Expect that it was from North America, maybe a duck? since migratory aquatic birds are the natural reservoir, and before last fall in alignment with respiratory season.

**Analysis Approach:** Use timing of transition of reassorted segments (PB2, PA, NP, NA) from non-D1.1 type to D1.1 type (ex. NA segment: ea1/2 --> am4N1). But given the timeline (2 days), this was not plausible. So the analysis was adapted to look at only the NA segment because this type (am4N1) was unique to D1.1 and had not been previously seen in North America. 

<img src="../../images/09_flu_analysis.png" width=600>
 
1. Made 2 databases to blast the NA segment from Genoflu against(1 from NCBI all viral nt seqs and 1 from fluviewer) then confirmed top hits from FluViewer are all present in top hits of NCBI, and since they were, use NCBI only moving forward. 
2. Retrieve metadata from NCBI `EDirect` --> there were several NA segments from H1N1 subtypes
3. Select if percent id >= 98.5% or is more recent than 2021
4. Collect ORFs sequences of theses top hits
5. Align in MAFFT 
6. Make a ML tree 1000 bootstraps with IQ-Tree

<img src="../../images/09_flu_preprocess.png" width=00>

7. Check temporal signal of dataset (n=84 NA segments) in `Tempest`

<img src="../../images/09_tempest.png" width=500>

8. Use `BEAUTi` to specify priors as uncorrelated relaxed log-normal clock, the HKY substitution model without gamma rate heterogeneity, and a coalescent Bayesian skyline tree prior. The posterior distribution was approximated using 100 million MCMC steps, sampled every 10,000 steps, with a 10% burn-in.

<img src="../../images/09_beauti.png" width=500>

9. Perform phylodynamic analysis with `BEAST` v2.7.7. This ran overnight.

<img src="../../images/09_beast.png" width=500>

10. Check results in `Tracer` to look for covergene of the MCMC chain, the Effective sample size is > 200, and that the estimates seem reasonable  

<img src="../../images/09_tracer.png" width=500>

11. Use `TreeAnnotator` to obtain a maximum clade credibility tree (“consensus” tree). `DensiTree` can be used to visualize the underlying sample of trees that our MCC tree is built from.

<img src="../../images/09_mcc.png" width=500>
<br>
<img src="../../images/09_densitree.png" width=500>

12. Visualize and annotate the tree in `FigTree` or `ggtree`.

<img src="../../images/09_flu_results.png" width=700>

Where it shifts from phylogenetics to phylodynamics is when you integrate epidemiological info with genomic. 

- It appears there were sustained speciation events into H1N1 and some other subtype. The first one in 2019 then 2021, 2023 and most recently end of August, 2024. 
- Oregon samples are D1.2 which also has the NA segment of type am4N1, so it checks out that they are grouping with BC samples.
- There is a NA segment from an H1N1 subtype isolated from a mallard in Alberta that is clustering close to the BC D1.1 samples. **The NA segment from H5N1 D1.1 found in BC share an ancestor with NA segment from mallards infected with H1N1** which could mean:
- Shared & recent ancestor
- NA segment of D1.1 came from H1N1 virus (reassortment)
- Convergent evolution of NA segment in H5N1 & H1N1 
- Biased sampling of H1N1 in mallards

13. Interpret results

<img src="../../images/09_interpretation_host.png" width=700 height=300>

Here is a map of migratory flyways - blue is the Mississippi flyway. If we looked at the map on the left overlayed with the data, one conclusion could be these ducks were breeding in the Mississippi flyway. Factoring in other metadata such as collection date (right map) and what we know about breeding patterns allows further interpretation - maybe we can infer these two samples in Ohio were during breeding because April = ducklings and that the BC & Alberta samples may have been collected during fall migration season when they were headed south. We can assume these viral isolates are not from same season based on how far apart collection dates are. So are they detected here because it is where most mallards infected with H1N1 are, or is there a sampling program in the Mississippi flyway? Could there be even more infection in a different type of bird harbouring H1N1 in the Pacific flyway that we are missing? 

**Consider Caveats:** 

As we think through the results, some caveats include:

- The origin of D1.1 in BC depends on what was sampled – theoretically, it is possible if we sample a bunch of Egyptian geese, they would have viruses with NA segments that cluster with our BC D1.1 NA segments

- Only have 4 H1N1 sample points – need to be careful about conclusions drawn - it is tempting to say mallards infected with H1N1 were the source of D1.1 or that it originated from the Mississippi flyway but more analyses need to be done to support this. This is a preliminary analysis of data to formulate a hypothesis from. 

- This is the NA segment only – introduction of NA segment into BC does not necessarily represent when D1.1 (all 8 segments) was introduced. It is possible that the reassortant segments happened all at once, but maybe in multiple steps. The ideal would be to perform this analysis for the other 3 segments and see if timing of introduction, host, location aligns among them to estimate a period over which D1.1 genotype was introduced into BC. 

- Collection date precision = year – calibrating the time tree with more specific dates would give us a better estimate into the timing of events

- Sequencing bias toward H1N1 samples - maybe we are finding H1N1 because we are looking for it more (swine flu)

**Conclusion:**

Based on the NA segment of the genotype D1.1 (which is unique to D1.1 and not previously seen in North America), the origin of D1.1 into BC was
from:

**Time:** Fall of 2023 <br>
**Host:** Mallard – wild migratory waterfowl <br>
**Location:** West Coast (BC/AB) – Mississippi flyway <br>
**Genomic:** Reassortment from H1N1 NA segment <br>

14. Share findings. There were several reviews, adjustments, and re-analyses but the first draft was submitted on Dec 4, 2024. 

Himsworth, C. G., Caleta, J. M., Jassem, A. N., Yang, K. C., Zlosnik, J., Tyson, J. R....Russell, S. L. (2025). Highly Pathogenic Avian Influenza A(H5N1) in Wild Birds and a Human, British Columbia, Canada, 2024. Emerging Infectious Diseases, 31(6), 1216-1221. https://doi.org/10.3201/eid3106.241862.

## Phylodynamic Visualization

There are GUI and CLI tools to visualize phylogenetic trees. You may want to quickly glance at your results, in which case iTOL (interactive Tree of Life) will allow you to manipulate and annotate in your web browser, whereas other times you need a publication-quality figure, where `ggtree` may be more appropriate to allow more fine-grained control. 

- FigTree
- iTOL
- ggtree 
- ETE3 
- Archaeopteryx

The figure for publication was produced using `ggtree` in R v4.1.1: 

<img src = "../../images/09_ggtree_fig.png" width = 700>

You can see that it affords a lot of control over labeling tips, coloring error bars, adding symbols to nodes. Here is the code that was generated it: 


```python
library(ggtree)
library(treeio)
library(ggplot2)
library(svglite)

# load in the mcc tree generated from BEAST2 then TreeAnnotator

tree <- treeio::read.beast("BEAST2/am4N1-like_NA/am4N1-like_NA_HKY_relaxed-HKY_relaxed_median-heights.mcc.tree")

# get.fields(tree)
# tree@phylo$tip.label

cids <- tree@phylo$tip.label[grepl("avian_unknown", tree@phylo$tip.label)]
deidentified_tips <- sapply(cids, 
                              function(x) gsub("\\|RXXXX[0-9]{6}-[0-9]{4}-[A-Z]{1}-[A-Z]{1}[0-9]{2}","", x))
tree@phylo$tip.label[grepl("avian_unknown", tree@phylo$tip.label)] <- deidentified_tips
#tree@phylo$tip.label <- toupper(tree@phylo$tip.label)

d1.2 <- tree@phylo$tip.label[grepl("OR\\|24", tree@phylo$tip.label)]
# label nodes to find relevant ones
ggtree(tree) + geom_text(aes(label = node),
hjust = 0.1, size = 2.5)

bc_tips <- tree@phylo$tip.label[grepl("BC", tree@phylo$tip.label)]
mrca_node <- ape::getMRCA(tree@phylo, bc_tips)

ggtree(tree, mrsd = "2024-11-30") + 
  geom_hilight(mapping=aes(subset = node %in% mrca_node),
               fill = "grey",
               alpha = .25)+
  geom_tree(size = 1, color="#3b3b3b")+
  theme_tree2(plot.margin=margin(6, 150, 1, 6)) + # time scale axis 
  geom_tiplab( aes(subset = !label %in% d1.2),
               size = 3, 
               offset = 0.2) +
  geom_tiplab(mapping = aes(subset = label %in% d1.2),
              fontface = 4,
              size = 3, 
              offset = 0.2)+
  geom_tippoint(mapping = aes(subset = node %in% c(54,48,52,53,84,83,78,82,81)),
                 color="#3b3b3b", 
                 shape=17,
                position = position_nudge(x = 0.16),
                 size=2)+
  geom_nodepoint(mapping = aes(subset = !isTip & as.numeric(posterior)> 0.9),
                 color="black",
                 shape=19,
                 alpha = 0.65,
                 size=2)+
                # show.legend = FALSE)+
  # geom_nodelab(aes(x=branch, 
  #                  label=round(posterior, 2),
  #                  subset=as.numeric(posterior)> 0.9), 
  #              vjust=-0.3, 
  #              hjust = 0.2,
  #              size=3)  +
  geom_text2(aes(label=round(2024.915-height, 1),
                 subset = !isTip ), 
               vjust=0.7, 
               hjust = -0.1,
               size=2.5,
             color="#222222")  +
  coord_cartesian(clip = 'off') + # prevent tip label truncation
  geom_range("height_0.95_HPD", 
             color = "darkblue", 
             size = 1.5, 
             vjust = -0.3,
             alpha=0.3)  +
  scale_x_continuous(breaks = seq(2015, 2025,1))+
  theme(axis.text.x = element_text(size=12))

ggsave("BEAST2/am4N1-like_NA/EID_fig.svg",
       width = 15, 
       height = 11, 
       dpi = 650, 
       units = "in")
```

## Recap

You have now been introduced to ***phylogenetics*** and better understand how ***microbial genomes*** are used to estimate the way a microbe changes over time. You have been introduced to tools required for the steps of phylogenetic analysis, including options for visualization, and have seen one in a disease ***outbreak application***. You have learned the basic steps to perform a ***phylodynamic analysis*** using the ***BEAST*** software suite and know the difference between a ***timetree*** and ***distance tree*** as well as a ***rooted*** and ***unrooted*** phylogeny. 
