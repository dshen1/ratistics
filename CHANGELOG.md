# Ratistics Changelog

### 0.3.0 *(in progress)*

Release Date: TBD

* Dropped support for Ruby < 1.9.2
* Completely refactored data loading helper modules
  * Significantly increased performance when loading CSV files
* Removed classes Aggregates, Frequencies, and Percentiles
* Removed monkey patching code

### 0.2.3

Release Date: March 22, 2013

* Added functions
  * Probability.cumulative_distribution_function (alias: cdf, cumulative_distribution)
  * Probability.cumulative_distribution_function_value (alias: cdf_value, cumulative_distribution_value)
  * Probability.sample_with_replacement (alias: resample_with_replacement, bootstrap)
  * Probability.sample_without_replacement (alias: resample_without_replacement, jackknife)
  * Frequencies.cumulative_distribution_function (alias: cdf, cumulative_distribution)
  * Frequencies.cumulative_distribution_function_value (alias: cdf_value, cumulative_distribution_value)
  * Array.sample_with_replacement (alias: resample_with_replacement, bootstrap)
  * Array.sample_without_replacement (alias: resample_without_replacement, jackknife)
  * Collection.collect
  * Collection.catalog (alias: catalogue)
  * Collection.catalog_hash(alias: catalogue_hash)
  * Collection.hash_catalog(alias: hash_catalogue)
  * Collection bisection
    * bisect_left, bisect_right (alias: bisect)
    * insort_left, insort_right (alias: insort)
    * insort_left!, insort_right! (alias: insort!)
* Added Inflect module
* Added NilSampleError
* Added Catalog (alias: Catalogue) class
* Greater consistency of return values and processing options
* Added more input and output options:
  * :as => :hash/:map/:array/:catalog/:catalogue to probability functions
  * :as => :hash/:map/:array/:catalog/:catalogue to percentile functions
  * :from => :sample/frequency/probability to frequency and probabilty functions
  * :inc/:increment/:incremental => true/false to #probability function
* Changed return values for Rank.ranks
  * returns nil when the sample is nil or empty
  * returns :hash by default
  * only returns an array when :as => :array
* Added Infinity and NaN constants

### 0.2.2

Release Date: February 14, 2012

* Added classes
  * Aggregares
  * Frequencies
  * Probabilities
* Added percentile functions
  * percentile
  * first_quartile (alias: lower_quartile)
  * second_quartile
  * thirs_quartile (alias: upper_quartile)
* Added math functions
  * summation (alias: sum)
* Added sorts and searches
  * insertion_sort!
  * linear_search

### 0.2.1

Release Date: February 4, 2013

Removed runtime dependencies that were accidentally added in 2.0.0.
They were intended to be development dependencies only.

### 0.2.0

Release Date: February 4, 2013

This release greatly enhanced the tests by adding support for ActiveRecord.
It also greatly enhanced cross-Ruby compatibility by fixing code that
was broken under 1.8.7 and by verifying compatibility with Rubinius.
Finally, several arithmetic and statitical computations.

* Added *Rank* module with functions related to percentiles
  * ranks (alias: percentiles, centiles)
  * linear_rank (aias: percentile, centile)
  * nearest_rank (with :ordinal, :nist_primary, and :nist_alternate formulas)
  * percent_rank
* Added math functions with block support
  * min
  * max
  * minmax
  * relative_risk
* Added collections functions with block support
  * ascending?
  * descending?
  * binary_search (alias: bsearch, half_interval_search)
* Added *#midrange* function to the *Average* module
* Added tests to confirm ActiveRecord compatability
* Refactored CSV loading for better support across Ruby versions
* Updated all functions with a *sorted* parameter to use a *:sorted* option instead
* Added an options hash to all stats functions
* Added more monkey-patch methods
* Added a *#slice* function to support more collection classes
* Support Hamster classes as return types when loading data from files
* Began testing under the Rubinius interpreter
* Bagan documenting answers to exercises to *Think Stats* in the *examples* directory
* Added more sample data and sample code to the *examples* directory
* Updated documentation
