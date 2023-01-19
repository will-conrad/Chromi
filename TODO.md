# Things to do

## ColorConversions
- [x] Implement other luminant (D50) for RGB-XYZ Transformations
    - [x] Add global illuminant
- [x] Add CIELab from [Here](http://www.brucelindbloom.com/index.html) 
- [ ] Create test data for gel swatches


## Swatches
- [ ] Read from csv file
- [ ] Implement [Euclidean Distance](https://en.wikipedia.org/wiki/Euclidean_distance#Higher_dimensions)
  
  $d(p,q) = \sqrt{(p_{1}-q_{1})^2+(p_{2}-q_{2})^2+(p_{3}-q_{3})^2}$
  
`func getEuclideanDistance(p: [CGFloat], q: [CGFloat]) { }`

  - P and Q are three, 3-dimentional points
      - P = input color
      - Q = compared color in .csv

## Settings
- [x] Create list layout for settings page     