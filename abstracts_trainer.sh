#!/bin/bash

# Makes programs and trains a GloVe model.

make clean
make

# Modifiable variables (filenames):
CORPUS=lemmatized_abstracts.txt
VOCAB_FILE=abstracts_vocab.txt
COOCCURRENCE_FILE=abstracts_conc.bin
COOCCURRENCE_SHUF_FILE=abstracts_conc.shuf.bin
SAVE_FILE=abstracts_vec

# Training parameters, resources:
MEMORY=6.0
NUM_THREADS=7
TURNOFF=0

# Training parameters, model:
VOCAB_MIN_COUNT=5
MAX_ITER=100
WINDOW_SIZE=20
VECTOR_SIZE=300
X_MAX=10
ALPHA=0.75
ETA=0.005

# Other parameters:
BUILDDIR=build
VERBOSE=2
BINARY=2



#Execution:
$BUILDDIR/vocab_count -min-count $VOCAB_MIN_COUNT -verbose $VERBOSE < $CORPUS > $VOCAB_FILE
if [[ $? -eq 0 ]]
  then
  $BUILDDIR/cooccur -memory $MEMORY -vocab-file $VOCAB_FILE -verbose $VERBOSE -window-size $WINDOW_SIZE < $CORPUS > $COOCCURRENCE_FILE
  if [[ $? -eq 0 ]]
  then
    $BUILDDIR/shuffle -memory $MEMORY -verbose $VERBOSE < $COOCCURRENCE_FILE > $COOCCURRENCE_SHUF_FILE
    if [[ $? -eq 0 ]]
    then
       $BUILDDIR/glove -save-file $SAVE_FILE -threads $NUM_THREADS -input-file $COOCCURRENCE_SHUF_FILE -x-max $X_MAX -alpha $ALPHA -eta $ETA -iter $MAX_ITER -vector-size $VECTOR_SIZE -binary $BINARY -vocab-file $VOCAB_FILE -verbose $VERBOSE
    fi
  fi
fi

if [[ $TURNOFF -eq 1 ]]
	then
	shutdown /s /f /t 0
fi