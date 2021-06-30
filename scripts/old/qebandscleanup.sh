#!/bin/bash

printf "Simulation name: "
read inputname
mkdir $inputname
cp -avr input.* ./$inputname/
cp -avr *.UPF ./$inputname/
cp -avr *.svg ./$inputname/
cp -avr *.dat ./$inputname/
cp -avr *.err ./$inputname/
cp -avr *.out ./$inputname/
