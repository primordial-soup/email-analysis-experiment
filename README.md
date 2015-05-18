```shell
# Get software dependencies
cpanm --installdeps .
Rscript ./install.R
./tool/dep/mallet/get-mallet
./tool/dep/mallet/build-mallet

# Get data
./tool/data/enron-label-berkeley/get-enron-label-berkeley-data
./tool/data/enron-label-berkeley/extract-enron-label-berkeley-data

# Run analysis
make -f Makefile.data

# Generate plots
export ENRON_PLOT_PATH="/path/to/directory" # default: gfx/ (optional)
./bin/generate-plots
```
