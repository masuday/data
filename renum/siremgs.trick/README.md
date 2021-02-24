# A trick for a sire-MGS model

The `renumf90` program does not support any sire models, including a sire-MGS model.
Hence, you need a trick to generate the files for the sire models.
If you apply the simple sire model with the sire pedigree, please check the directory `sire.trick`.
This documentation is for users who apply the sire-MGS model or the sire model with sire-MGS pedigree.

## Sire-MGS model

### Flow

Please follow the procedure.

1. Run `renumf90` with the standard direct-maternal genetic model.
2. Run the awk script, `conv_mat_to_siremgs.awk`. It generates a new data file, `renf90sire.dat` and a pedigree file `renaddsire.ped`. The new data file has 2 additional columns: sire ID and MGS ID.
3. Modify `renf90.par` so that it replaces `add_animal` by `add_sire`, the position of animal ID with the sire ID (the first additional column in `renf90sire.dat`), and the position of maternal ID with the MGS ID (the second additional column in `renf90sire.dat`).

### Example

Let's use the files in this directory to see how it works.
First, you should run `renumf90` with `renum.mat.1.txt` for a maternal model.

```
renumf90 renum.mat.1.txt
```

Then, check `renf90.par` for the positions of animal ID and maternal ID in `renf90.dat`.
In this case, we need position 5 for animal ID and position 6 for maternal ID in the last two lines in the EFFECT block.

```
DATAFILE
 renf90.dat
NUMBER_OF_TRAITS
           1
NUMBER_OF_EFFECTS
           5
OBSERVATION(S)
    1
WEIGHT(S)

EFFECTS: POSITIONS_IN_DATAFILE NUMBER_OF_LEVELS TYPE_OF_EFFECT[EFFECT NESTED]
 2         2 cross
 3         4 cross
 4 1 cov
 5        15 cross
 6         15 cross
RANDOM_RESIDUAL VALUES
   1.0000
 RANDOM_GROUP
     4     5
 RANDOM_TYPE
 add_animal
 FILE
renadd04.ped
(CO)VARIANCES
  0.65000      0.16250
  0.16250      0.52000
```

Once you know the positions of IDs, run the awk script.
Please see the following example for usage.

```
# posa = position of animal ID; 5 in this example
# posm = position of maternal ID; 6 in this example
# renadd04.ped = renumbered pedigree file
# renf90.dat   = renumbered data file
awk -v posa=5 -v posm=6 -f conv_mat_to_siremgs.awk renadd04.ped renf90.dat
```

The script creates two files: `renf90sire.dat` for data and `renaddsire.ped` for pedigree.
The new data file has two additional columns corresponding to sire ID and MGS ID; the sire ID is in column 7, the MGS ID, column 8.
If sire or MSG is unknown, the script puts 0 to their ID, implying they are unknown and their breeding values are expected to be 0.

```
 9.2 1 2 0.98 6 12 2 0
 9.7 2 4 1.00 8 4 6 2
 10.9 2 2 1.02 4 15 2 0
 9.7 1 1 1.00 1 4 6 2
 10.7 2 3 1.04 2 10 11 0
 9.9 1 4 1.01 9 8 5 6
 10.6 1 2 0.99 7 3 6 13
 9.9 1 3 1.05 3 12 13 0
 9.5 2 1 1.01 5 14 11 0
```

Finally, you can rewrite `renf90.par` to reflect the changes.
Please check the following example.

```
TAFILE
 renf90sire.dat   # change the data file name
NUMBER_OF_TRAITS
           1
NUMBER_OF_EFFECTS
           5
OBSERVATION(S)
    1
WEIGHT(S)

EFFECTS: POSITIONS_IN_DATAFILE NUMBER_OF_LEVELS TYPE_OF_EFFECT[EFFECT NESTED]
 2         2 cross
 3         4 cross
 4 1 cov
 7        15 cross   # change 5 to 7
 8         15 cross  # change 6 to 8
RANDOM_RESIDUAL VALUES
   1.0000
 RANDOM_GROUP
     4     5
 RANDOM_TYPE
 add_sire        # change add_animal to add_sire
 FILE
renaddsire.ped   # change the pedigree-file name
(CO)VARIANCES
  0.65000      0.16250
  0.16250      0.52000
```

When using the above files in blupf90, you will see many 0 solutions; those values are for dams that are not in the pedigree.


## Sire model with MGS pedigree

The procedure is the same as the sire-MGS model.
The only difference is the awk script.
For the sire model with MGS pedigree, you don't need `posm`; without this option, the script still creates the pedigree with the sire and MGS ID.

