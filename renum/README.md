RENUMF90 sample parameter files
===============================

By Yutaka Masuda, University of Georgia.

Introduction
------------

This repository has *parameter files* for `RENUMF90`.
Each file simply shows how a user writes a parameter file for a particular model.
The files are artificial and I do not guarantee the quality of the data.

Files
-----

The files are saved in separate directories by model.

- `fixed`: Fixed effect model
- `animal`: Animal model; A-inverse without inbreeding (default)
- `inb`: ANimal model; A-inverse with inbreeding
- `upg`: Animal model including unknown parent groups
- `random`: Mixed model with more random effects
- `rep`: Repeatability model
- `maternal`: Direct-maternal model
- `rrm`: Random regression model
- `mltdm`: Multiple-lactation random-regression test-day model
- `ssGBLUP`: Single-step GBLUP
- `options`: SOme other options in `RENUMF90`
