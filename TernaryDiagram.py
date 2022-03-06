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
    self.diag.set_xticks([])
    self.diag.set_yticks([])

    
  def point(self, x1, x2):
      x3 = 1-x1-x2
      x = 1-0.5*x2-x3
      y = (3**.5)/2*x2
      return(x,y)
  
  def makeGrid(self, spacing=0.1):
    comps = np.linspace(0,1,int(1/spacing))
    for x in comps:
        xs = [1-0.5*x,0.5*x]
        ys = [(3**.5)/2*x,(3**.5)/2*x]
        self.diag.plot(xs,ys,':r',alpha=0.5)
        xs = [x,0.5*(1+x)]
        ys = [0,3**.5/2*(1-x)]
        self.diag.plot(xs,ys,':g',alpha=0.5)
        xs = [0.5*(1-x),1-x]
        ys = [3**.5/2*(1-x),0]
        self.diag.plot(xs,ys,':b',alpha=0.5)
        
  def labelSides(self,bottom="Species 1",right="Species 2",left="Species 3"):
    #self.diag.text(0.45,-0.1,bottom,c="g")
    #self.diag.text(0.2,0.45,left,c="r",rotation=50)
    #self.diag.text(0.68,0.45,right,c="b",rotation=-54)
    
    self.diag.annotate(bottom, xy=(1,-0.1), xytext=(0,-0.12),
            arrowprops=dict(arrowstyle="->"),color='g')
    
    self.diag.annotate(right, xy=( 0.6,0.866), xytext=(1,0),
            arrowprops=dict(arrowstyle="->"),color='r')
    
    self.diag.annotate(left, xy=( -0.1,0), xytext=(0.3,0.866),
            arrowprops=dict(arrowstyle="->"),color='b')
    
    self.diag.set_xlim(-0.11,1.2)
    self.diag.set_ylim(-.2,1)
