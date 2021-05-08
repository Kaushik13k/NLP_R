####Abreviate Strings

#Store regions in variable <region>
region <- c('California','Washington','Alabama','New York')
region


#extract fisrt 4 characters from left
sregion <- substr(x=region,start=1,stop=4)


# Extract the first 4 character
abregion <- abbreviate(region)
abregion
abregion[1]
names(abregion)


# Remove vector names
names(abregion) = NULL
abregion
abregion[1]


# abbreviate state names with 5 letters
ab5re <- abbreviate(region, minlength = 5)
ab5re

region <- c('California','Washington','South Dakota')
# size (in characters) of each name
region_char <- nchar(region)
region_char
region_char[1]


# Find the longest region name
maxregion <- region[which(region_char == max(region_char))]
maxregion