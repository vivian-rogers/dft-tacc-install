#!/bin/bash


awk 'BEGIN{
	FS=" ";
 	Gl = 0;
	Gh = 0;
	Xl = 0;
	Xh = 0;
	i = 0;
 }
 {
	{i++;}
	{if(i==323){Gl=$8; Gh=$9};}
	{if(i==483){Xl=$8; Xh=$9};}
 }
 END{
	print "G-G: " (Gh-Gl) "; G-X: " (Xh-Gl) "; X-X: " (Xh-Xl);
 }' bands.dat 

