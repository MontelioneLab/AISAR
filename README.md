# Hidden Structural States of Proteins Revealed by Conformer Selection with AlphaFold-NMR

Yuanpeng J. Huang and Gaetano T. Montelione

Abstract

Recent advances in molecular modeling using deep learning can revolutionize our understanding of
dynamic protein structures. NMR is particularly well-suited for determining dynamic features of
biomolecular structures. The conventional process for determining biomolecular structures from
experimental NMR data involves its representation as conformation-dependent restraints, followed by
generation of structural models guided by these spatial restraints. Here we describe an alternative
approach: generating a distribution of realistic protein conformational models using artificial intelligence-
(AI-) based methods and then selecting the sets of conformers that best explain the experimental data. We
applied this conformational selection approach to redetermine the solution NMR structure of the enzyme
Gaussia luciferase. First, we generated a diverse set of conformer models using AlphaFold2 (AF2) with
an enhanced sampling protocol. The models that best-fit NOESY and chemical shift data were then
selected with a Bayesian scoring metric. The resulting models include features of both the published
NMR structure and the standard AF2 model generated without enhanced sampling. This “AlphaFold-
NMR” protocol also generated an alternative “open” conformational state that fits nearly as well to the
overall NMR data but accounts for some NOESY data that is not consistent with first “closed”
conformational state; while other NOESY data consistent with this second state are not consistent with the
first conformational state. The structure of this “open” structural state differs from that of the “closed”
state primarily by the position of a thumb-shaped loop between 𝛼-helices H5 and H6, revealing a cryptic
surface pocket. These alternative conformational states of Gluc are supported by “double recall” analysis
of NOESY data and AF2 models. Additional structural states are also indicated by backbone chemical
shift data indicating partially-disordered conformations for the C-terminal segment. Considered as a
multistate ensemble, these multiple states of Gluc together fit the NOESY and chemical shift data better
than the “restraint-based” NMR structure and provide novel insights into its structure-dynamic-function
relationships. This study demonstrates the potential of AI-based modeling with enhanced sampling to
generate conformational ensembles followed by conformer selection with experimental data as an
alternative to conventional restraint satisfaction protocols for protein NMR structure determination.

