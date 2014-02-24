################################################################
## First steps with R
## Author: Pablo Barbera
## Social Media and Political Participation
## Lab 1, January 6th 2014
################################################################

## This is an example of an R script
## Every lines that starts with a # sign is a comment
## Use comments to document every step, specially those that
## are not necessarily obvious

#### USING R AS A CALCULATOR ####

## You probably don't need a comment here...
2 + 2

## The most basic functionality of R is using it as a calculator
10 / 2
sqrt(100) + sqrt(9)
exp(1)

#### CREATING AND PRINTING OBJECTS ####

## What makes R very powerful is that you can store results as "objects"
x = 5
y = 10
## look at the "Environment" panel on the right to see that these numbers
## are stored in memory

## then you can do operations with them the same way you'd do it with numbers
x * y

## you can also save combinations of objects as new objects
z = x * y

## to print one of these objects in the console, use the "print" function
print(z)
## a function is a command that takes an argument ("z") and returns a value ("50")

## alternatively, you can just type the name of the objects on the console
z

#### VECTORS AND BASIC VISUALIZATION ####

## if objects have more than one element, they are called "vectors"
height = c(181, 175, 179, 175, 176)
## Note the use of the "c" (concatenate) function to put all 5 numbers together
## for example, this vector contains the height in cm of five U.S. males
print(height)

## you can create as many vectors as you want
weight = c(80, 61, 74, 58, 67)

## to visualize the relationship between the two variables, you can use
## the "plot" function
plot(x=height, y=weight)
## "plot" is a function just like "print", but it takes multiple arguments.
## First, you specify the variable you want in the x-axis: "x=height";
## and then the one you want on the y-axis: "y=weight"

#### FINDING HELP ####

## Now imagine that you want to add a title to your plot, but don't know how
## You can use the help page for "plot":
?plot
## and find that "main" is the option you're looking for
plot(x=height, y=weight, main="Relationship between height and weight")

## This is just a basic plot -- we will cover more advanced examples in Lab 2

#### INSTALLING AND LOADING PACKAGES ####

## There are many packages that expand the basic functionalities of R
## For example, imagine that we want to make a map of the U.S.
## The package "maps" is exactly what we're looking for

## First, we install it (you only need to do this once)
## Either typing the following:
install.packages("maps")
## OR
## 1) Go to the "Packages" tab on the bottom right panel
## 2) Click on "Install Packages"
## 3) Type "maps" and click on "Install"

## Now, we load the package (you will need to do this every time you want to
## use a function from the package)
library(maps)

## And we can use the "map" function, that will draw a map of the US if we
## specify the option 'database="state"'
map(database="world")
?map

## Later in the course we will learn how to add colors and labels to the map

