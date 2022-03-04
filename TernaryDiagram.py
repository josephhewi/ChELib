import matplotlib.pyplot as plt
import numpy as np

class ternaryDiagram:
  
  def __init__(self, spacing=0.1):
    self.figure, self.diag = plt.subplots()
    #(0,0) = 100% species 3
    #(1,0) = 100% species 1
    #(,1/2) = 100% species 2
    self.diag.plot([0,1],[0,0],'k')
    self.diag.plot([0,0.5],[0,(3**.5)/2],'k')
    self.diag.plot([0.5,1],[(3**.5)/2,0],'k')

  def point(self, x1, x2):
      x3 = 1-x1-x2
      x = 1-0.5*x2-x3
      y = (3**.5)/2*x2
      return(x,y
      
  def makeGrid(self, spacing=0.1):
    for x in compositions:
        xs = [1-0.5*x,0.5*x]
        ys = [(3**.5)/2*x,(3**.5)/2*x]
        plt.plot(xs,ys,':r',alpha=0.5)
        xs = [x,0.5*(1+x)]
        ys = [0,3**.5/2*(1-x)]
        plt.plot(xs,ys,':g',alpha=0.5)
        xs = [0.5*(1-x),1-x]
        ys = [3**.5/2*(1-x),0]
        plt.plot(xs,ys,':b',alpha=0.5)










