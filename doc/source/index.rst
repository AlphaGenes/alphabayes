Welcome to AlphaBayes's documentation!
======================================

.. toctree::
   :maxdepth: 3
   :caption: Contents:

Introduction
=========================================================================================

|AB| is a simple program for genome-wide marker regression along with fixed and random effects. This is a stripped down no-frills version of previous AlpahBayes that only fits a ridge regression model for markers.

Please report bugs or suggestions on how the program / user interface / manual could be improved or made more user friendly to `alphagenes@roslin.ed.ac.uk <alphagenes@roslin.ed.ac.uk>`_.

Availability
------------

|AB| is available from the AlphaGenes website, `http://www.alphagenes.roslin.ed.ac.uk <http://www.alphagenes.roslin.ed.ac.uk/>`_.

Material available comprises the compiled programs for 64 bit Windows, Linux, and Mac OSX machines, together with this document.

Conditions of use
-----------------

|AB| is part of a suite of software that our group has developed. It is fully and freely available for all use under the MIT License.

Disclaimer
----------

While every effort has been made to ensure that |AB| does what it claims to do, there is absolutely no guarantee that the results provided are correct. Use of |AB| is entirely at your own risk.

Advertisement
-------------

|AB| is part of the AlphaSuite collection of programs that we have developed. The collection can perform many of the common tasks in animal breeding, plant breeding, and human genetics including phasing, imputation, estimation of genetic values, genome-wide association, optimal contributions, simulation, and various data recoding and handling tools.

The AlphaSuite is available from `AlphaGenes website (http://www.AlphaGenes.roslin.ed.ac.uk) <http://www.AlphaGenes.roslin.ed.ac.uk>`_.

Run command
=========================================================================================

|AB| is run from a terminal. By default it uses a `Specifications file`_ named ``AlphaBayesSpec.txt``.

On MS Windows use one of the following options:

* ``AlphaBayes.exe``

On Linux or Mac OSX use one of the following options:

* ``./AlphaBayes``

Specifications file
=========================================================================================

|AB| is controlled by a single specification file, which should be a simple text file. In this file, a user specifies:

The specifications are of the form:

::

  Specification , Value

The specifications can appear in any order. In the case of conflicting specifications (e.g., one turns a feature off, but another turns it on), the latest one is used.

Specifications are not case sensitive.

Unrecognised specifications are ignored, so beware of typos! User is notified which specifications are accepted and which are ignored.

An example:

::

  GenotypeTrainFile  , Genotypes.txt
  PhenotypeTrainFile , Phenotypes.txt
  NumberOfMarkers    , 1000
  Stop

PhenotypeTrainFile
------------------

::

  PhenotypeTrainFile , [String]
  PhenotypeTrainFile , PhenotypeTrain.txt

PhenotypeTrainFile specifies a file that contains phenotypes used in training. The file should have *1 + 1* columns, where the first column are individual identifications and the second column are phenotype values, and *nR* rows, where *nR* is number of records. See `NumberOfTrainRecords`_ to specify number of records. Columns can be separated by space, tab, or comma. Phenotype values should be numeric and no checking is done about them! An example for four individuals phenotyped is:

::

  id1 102.5
  id2 122.9
  id3  95.7
  id4  77.8

NumberOfTrainRecords
--------------------

::

  NumberOfTrainRecords , [Value]
  NumberOfTrainRecords , 100

NumberOfTrainRecords specifies the number of training records used in training files. When this specification is not given all training records are used.

CovariateTrainFile
------------------

::

  CovariateTrainFile , [String]
  CovariateTrainFile , CovariateTrain.txt

CovariateTrainFile specifies a file that contains covariates used in training. The file should have *1 + nC* columns, where the first column are individual identifications and *nC* is the number of covariate columns, and *nR* rows, where *nR* is number of records. See `NumberOfCovariates`_ `NumberOfTrainRecords`_ to specify these dimensions. Columns can be separated by space, tab, or comma. Covariates values should be numeric and no checking is done about them! An example for four individuals with two covariates is:

::

  id1 1 -0.5
  id2 2  1.5
  id3 1  2.2
  id4 0 -0.1

NumberOfCovariates
------------------

::

  NumberOfCovariates , [Value]
  NumberOfCovariates , 2

NumberOfCovariates specifies the number of covariates in `CovariateTrainFile`_. This specification must be given if `CovariateTrainFile`_ is specified!

FixedEffectTrainFile
--------------------

::

  FixedEffectTrainFile , [String]
  FixedEffectTrainFile , FixedEffectsTrain.txt

FixedEffectTrainFile specifies a file that contains a file with fixed effect factors used in training. The file should have *1 + nL* columns, where the first column are individual identifications and *nL* is number of levels of all factors, and *nR* rows, where *nR* is number of records. See `NumberOfTrainRecords`_ to specify number of rows. Columns can be separated by space, tab, or comma. Factor levels must be provided as dummy codes and no checking is done about them! An example for four individuals with three levels for the first factor and two levels for the second factor with dummy coding that provides estimates that sum to zero is shown below. The result is three columns with three estimable levels. If you are struggling to understand all this or prepare it yourself, use a tool like "model.matrix" in R. Note also that |AB| always fits intercept, so you need to take this into account. An R code to do all this would be like this:

::

  # Construct model matrix (here sum to zero dummy coding is chosen, but others are also valid)
  X = model.matrix(~ 1 + Effect1 + Effect2,
                   data = YourDataFrame,
                   contrasts = list(Effect1 = "contr.sum", Effect2 = "contr.sum"))
  # Prepare the file
  #   * first column must be individual identifications
  #   * note that intercept is removed from X
  library(package = "readr")
  write_csv(x = as.tibble(cbind(YourDataFrame$Id, X[, -1])),
            path = "FixedEffectsTrain.csv", col_names=FALSE)
  # Number of levels to provide in the spec file
  ncol(X[, -1])

::

  id1  1  0  1
  id2  0  1 -1
  id3 -1 -1  1
  id4  1  0 -1

NumberOfFixedEffectLevels
-------------------------

::

  NumberOfFixedEffectLevels , [Value]
  NumberOfFixedEffectLevels , 2

NumberOfFixedEffectLevels specifies the number of fixed effect levels in `FixedEffectTrainFile`_. This specification must be given if `FixedEffectTrainFile`_ is specified! Note that this is the number of estimable levels!!!

RandomEffectTrainFile
---------------------

::

  RandomEffectTrainFile , [String]
  RandomEffectTrainFile , RandomEffectsTrain.txt

RandomEffectTrainFile specifies a file that contains a file with random effect factor (just one for now!) used in training. The file should have *1 + nL* columns, where the first column are individual identifications and *nL* is number of levels of the factors, and *nR* rows, where *nR* is number of records. See `NumberOfTrainRecords`_ to specify number of rows. Columns can be separated by space, tab, or comma. Factor levels must be provided as dummy codes and no checking is done about them! An example for four individuals with three levels is shown below. The result is three columns with three estimable levels, because prior information enables estimation of all levels. If you are struggling to understand all this or prepare it yourself, use a tool like "model.matrix" in R. An R code to do all this would be like this:

::

  # Construct model matrix
  X = model.matrix(~ -1 + Effect1,
                   data = YourDataFrame)
  # Prepare the file
  #   * first column must be individual identifications
  library(package = "readr")
  write_csv(x = as.tibble(cbind(x[[1]], X)),
            path = "RandomEffectsTrain.csv", col_names=FALSE)
  # Number of levels to provide in the spec file
  ncol(X)

::

  id1  1  0  0
  id2  0  1  0
  id3  0  0  1
  id4  1  0  0

NumberOfRandomEffectLevels
--------------------------

::

  NumberOfRandomEffectLevels , [Value]
  NumberOfRandomEffectLevels , 3

NumberOfRandomEffectLevels specifies the number of random effect levels in `RandomEffectTrainFile`_. This specification must be given if `RandomEffectTrainFile`_ is specified!

GenotypeTrainFile
-----------------

::

  GenotypeTrainFile , [String]
  GenotypeTrainFile , GenotypeTrain.txt

GenotypeTrainFile specifies a file that contains marker genotypes used in training. The file should have *1 + nM* columns, where the first column are individual identifications and *nM* is number of marker genotype columns and *nR* rows, where *nR* is number of records. See `NumberOfMarkers`_ and `NumberOfTrainRecords`_ to specify these dimensions. Columns can be separated by space, tab, or comma. Valid genotype values (genotype dosages) are between 0 and 2 (usually 0, 1, or 2, but values in between are valid too). Any value outside this range is assumed as a missing genotype and is replaced by an average genotype (marker specific). An example for four individuals genotyped at 3 markers is:

::

  id1 2 1 0
  id2 0 1 9
  id3 2 2 2
  id4 0 1 1

NumberOfMarkers
---------------

::

  NumberOfMarkers , [Value]
  NumberOfMarkers , 1000

NumberOfMarkers specifies the number of marker genotypes in genotype files; `GenotypeTrainFile`_ and `GenotypePredictFile`_. This specification must be given if `GenotypeTrainFile`_ is specified!

NumberOfPredictSets
-------------------

::

  NumberOfPredictSets , [Value]
  NumberOfPredictSets , 2

NumberOfPredictSets specifies the number of prediction datasets. See `GenotypePredictFile`_ and `PhenotypePredictFile`_.

GenotypePredictFile
-------------------

::

  GenotypePredictFile , [String]
  GenotypePredictFile , GenotypePredict.txt

GenotypePredictFile specifies a file that contains marker genotypes used in prediction. See `GenotypeTrainFile`_ for file format details. See `NumberOfpredictRecords`_ to specify number of records. In case there are several prediction sets set `NumberOfPredictSets`_ and use several GenotypePredictFile specifications, e.g., for two prediction sets use:

::

  GenotypePredictFile , GenotypePredict1.txt
  GenotypePredictFile , GenotypePredict2.txt

PhenotypePredictFile
--------------------

::

  PhenotypePredictFile , [String]
  PhenotypePredictFile , PhenotypePredict.txt

PhenotypePredictFile specifies a file that contains phenotypes used in prediction. See `PhenotypeTrainFile`_ for file format details. See `NumberOfpredictRecords`_ to specify number of records. In case there are several prediction sets use several PhenotypePredictFile specifications, e.g., for two prediction sets use:

::

  PhenotypePredictFile , PhenotypePredict1.txt
  PhenotypePredictFile , PhenotypePredict2.txt

NumberOfPredictRecords
----------------------

::

  NumberOfPredictRecords , [Value]
  NumberOfPredictRecords , 100

NumberOfPredictRecords specifies the number of prediction records used in `GenotypePredictFile`_ and `PhenotypePredictFile`_. When this specification is not given all records in prediction files are used. In case there are several prediction sets use several NumberOfPredictRecords specifications, e.g., for two prediction sets use:

::

  NumberOfPredictRecords , 100
  NumberOfPredictRecords , 200

NumberOfIterations
------------------

::

  NumberOfIterations , [Value]
  NumberOfIterations , 10000

NumberOfIterations specifies the number of iterations used. Iteration stops either when either this value or `ConvergenceTolerance`_ is reached. Default is 10,000.

NumberOfBurnInIterations
------------------------

::

  NumberOfBurnInIterations , [Value]
  NumberOfBurnInIterations , 1000

NumberOfBurnInIterations specifies the number of burn-in iterations used when using MCMC methods. Default is 1,000.

RandomEffectVariance
--------------------

::

  RandomEffectVariance , [Value]
  RandomEffectVariance , 0.5

RandomEffectVariance specifies variance for the random effect. This is used as a given/known value in some methods - described elsewhere. Default is 0.5 (when genetic markers are not included in the model) or 0.33 (when genetic markers are included in the model).

GeneticVariance
---------------

::

  GeneticVariance , [Value]
  GeneticVariance , 0.5

GeneticVariance specifies genetic variance. This is used as a given/known value in some methods - described elsewhere. Default is 0.5 (when random effect is not given) or 0.33 (when random effect is given).

ResidualVariance
----------------

::

  ResidualVariance , [Value]
  ResidualVariance , 0.5

ResidualVariance specifies residual/environmental variance. This is used as a given/known value in some methods - described elsewhere. Default is 0.5 (when random effect is not given) or 0.33 (when random effect is given).

NumberOfProcessors
------------------

::

  NumberOfProcessors , [Value]
  NumberOfProcessors , 4

NumberOfProcessors specifies the number of processors used to speedup calculations. Default is 1.

GenotypeScalingMethod
---------------------

::

  GenotypeScalingMethod , [1, 2, 3, 4, 5]
  GenotypeScalingMethod , 4

GenotypeScalingMethod specifies how to scale marker genotypes:

  * Method 1 does not scaling
  * Method 2 scales by marker specific genotype standard deviation (expected)
  * Method 3 scales by marker specific genotype standard deviation (observed)
  * Method 4 scales by average genotype standard deviation (expected)
  * Method 5 scales by average genotype standard deviation (observed)

Default is 4.

EstimationMethod
----------------

::

  EstimationMethod , [String]
  EstimationMethod , RidgeSolve

EstimationMethod specifies which method is used to estimate marker effects and perform phenotype fitting and prediction. |AB| at the moment provides:

  * RidgeSolve estimates marker effects with provided variance components; `GeneticVariance`_ (*VarG*) is used to provide variance of allele substitution effects (*VarS*) computed as *VarS=VarG/nS*, where *nS* is `NumberOfMarkers`_.
  * RidgeSample estimates marker effects and variance components (see `EstimateVariances`_) using MCMC algorithm.

Default is RidgeSolve.

EstimateVariances
-----------------

::

  EstimateVariances , [Yes/No]
  EstimateVariances , No

EstimateVariances specifies wether variances are to be estimated when running MCMC algorithm. Default is No.

ConvergenceTolerance
--------------------

::

  ConvergenceTolerance , [String]
  ConvergenceTolerance , RidgeSolve

ConvergenceTolerance specifies convergence tolerance (sum of squared differences between the previous and current solutions) for the RidgeSolve `EstimationMethod`_. Iteration stops either when either this value or `NumberOfIterations`_ is reached. Default is 1.0E-8.

NumberOfGenomePartitions
------------------------

::

  NumberOfGenomePartitions , [Value]
  NumberOfGenomePartitions , 2

NumberOfGenomePartitions specifies how many genome partitions should |AB| evaluate. Genome partition is simply a fitted/predicted value for a group of markers. Default spceification is 0.

GenomePartitionFile
-------------------

::

  GenomePartitionFile , [String]
  GenomePartitionFile , GenomePartition.txt

GenomePartitionFile specifies a file that contains markers used for genome partitions. The file should simply contain a list of marker numbers with one marker number per line. The marker number refers to a column in genotype files, i.e., `GenotypeTrainFile`_. For example, marker number 2 refers to the second marker genotype, which is the third column in a genotype file. In case there are several genome partitions use several GenomePartitionFile specifications, e.g., for two genome partitions use specification shown below. Note that markers should not be repeated in different partitions - |AB| does not check for this!

::

  GenomePartitionFile , GenomePartition1.txt
  GenomePartitionFile , GenomePartition2.txt

Stop
^^^^

::

  Stop

Stop ends the specification file. Any specifications following Stop are ignored.

Output files
=========================================================================================

ParamEstimate.txt
------------------

Holds "Param" effect estimates.

ParamSamples.txt
----------------

Holds "Param" posterior samples. Produced when MCMC algorithm is used.

PredictionsForSetX.txt
----------------------

Holds predictions for individuals in the set "X".

PredictionsSummary.txt
----------------------

Holds descriptive statistics about predictions - correlation between true and predicted values as well as regression of one on another.

GenomePartitionN.txt
--------------------

Holds estimates/predictions or samples for genome partition "N". The "Remainder" partition covers all markers that have not been allocated to any other partition.

Use the utility script `util/GenomePartitions.R` to summarize variance components for genome partitions.

Examples
=========================================================================================

There is an example shipped with |AB| that demonstrates use.

.. |AB| replace:: **AlphaBayes**

.. |EXPERIMENTAL| replace:: **This is an experimental specification in development and no yet tested! Do not use!**
