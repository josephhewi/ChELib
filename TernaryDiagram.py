
import matplotlib.pyplot as plt
import numpy as np

class ternaryDiagram:
  def __init__(self,makeGrid=True,spacing=0.1,species1="Species 1",species2="Species 2",species3="Species 3",
  airLine=False,explosiveGas="Experimental Gas",stoichRatio=1,stoichLine=False):
    
    self.grid=makeGrid
    self.spacing=spacing
    self.airLine=airLine
    self.points = []
    self.lines = []
    
    if airLine:
      self.species1="Oxygen"
      self.species2="Nitrogen"
      self.species3=explosiveGas
    else:
      self.species1=species1
      self.species2=species2
      self.species3=species3
    
  def add_point(self, x1, x2):
    x3 = 1-x1-x2
    x = 1-0.5*x2-x3
    y = (3**.5)/2*x2
    return(x,y)
  
  def generateGraph(self):
    # generate basic equilateral triangle
    plt.plot([0,1],[0,0],'k')
    plt.plot([0,0.5],[0,(3**.5)/2],'k')
    plt.plot([0.5,1],[(3**.5)/2,0],'k')
    
    # generate grid
    if self.grid:
      comps = np.linspace(0,1,int(1/self.spacing))
      for x in comps:
        xs = [1-0.5*x,0.5*x]
        ys = [(3**.5)/2*x,(3**.5)/2*x]
        plt.plot(xs,ys,':r',alpha=0.5)
        
        xs = [x,0.5*(1+x)]
        ys = [0,3**.5/2*(1-x)]
        plt.plot(xs,ys,':g',alpha=0.5)
        
        xs = [0.5*(1-x),1-x]
        ys = [3**.5/2*(1-x),0]
        plt.plot(xs,ys,':b',alpha=0.5)
        
    # generate 3 labels on axes
    plt.annotate(self.species1, xy=(1,-0.1), xytext=(0,-0.12),
            arrowprops=dict(arrowstyle="->"),color='g')
    
    plt.annotate(self.species2, xy=( 0.6,0.866), xytext=(1,0),
            arrowprops=dict(arrowstyle="->"),color='r')
    
    plt.annotate(self.species3, xy=( -0.1,0), xytext=(0.3,0.866),
            arrowprops=dict(arrowstyle="->"),color='b')
    
    plt.xlim(-0.11,1.2)
    plt.ylim(-.2,1)
    plt.xticks([])
    plt.yticks([])
    plt.show()

