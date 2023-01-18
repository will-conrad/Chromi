# Things to do

- [ ] Implement other luminant (D60) for RGB-XYZ Transformations
- [ ] Add CIELab from [Here](http://www.brucelindbloom.com/index.html) 
- [ ] Create test data for gel swatches
- [ ] Implement [Euclidean Distance](https://en.wikipedia.org/wiki/Euclidean_distance#Higher_dimensions)
  
  $d(p,q) = \sqrt{(p_{1}-q_{1})^2+(p_{2}-q_{2})^2+(p_{3}-q_{3})^2}$
  
`func getEuclideanDistance(p: [CGFloat], q: [CGFloat]) { }`

  - P and Q are three, 3-dimentional points
      - P = input color
      - Q = compared color in .csv
- [ ] 