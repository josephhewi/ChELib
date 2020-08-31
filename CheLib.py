# -*- coding: utf-8 -*-
"""
Created on Tuesday, June 12, 2017
Version 0.1.3 - 

@author: joseph hewitt

      _/_/_/  _/    _/  _/_/_/_/        _/        _/_/_/  _/_/_/
   _/        _/    _/  _/              _/          _/    _/    _/
  _/        _/_/_/_/  _/_/_/   _/_/   _/          _/    _/_/_/
 _/        _/    _/  _/              _/          _/    _/    _/
  _/_/_/  _/    _/  _/_/_/_/        _/_/_/_/  _/_/_/  _/_/_/
  
                                        Equation of state library
  
  
List of Functions:
    filler - fills rectangle outlined by two points
    convpress - converts pressure from one unit to another
    convtemp - converts temperature from one unit to another
    
List of Classes
    Compound
        __init__ - retrieve all relevant data
        info - displays information from antoine and critical info csv's
        antoine - uses antoine equation to calculate partial pressure_conversion
        shortcut - uses shortcut method to approximate pressure
        pengrobinson - calculates pressure using the peng-robinson method EOS
        VDW - calculate pressure using Van Der Waal's equation of state
"""

from __future__ import division
import numpy as np
import csv
import pandas as pd
import matplotlib.pyplot as plt
  
class compound(name):
    
    def __init__(self,IUPAC_name):
        self.iupac = IUPAC_name.lower()
		found = False
        data = csv.reader(open('./resources/antoine-coeff.csv'),delimiter=',')
        y,x = np.shape(data)
        for i in range(0,y):
            if (data[i,2]==self.iupac):
                self.antoine_data = data[i]
                found = True
        if found == False:
            ValueError('No Antoine data for {0}'.format(IUPAC_name))
		found = False
        data = pd.read_csv('./resources/crit_info.csv').as_matrix()
        y,x = np.shape(data)
        for i in range(0,y):
            if (data[i,1].lower()==self.iupac):
                self.critical_data = data[i]
                found = True
        if found == False:
            print('No critical data for {0}'.format(IUPAC_name))		
    
    '''
    print the antoine and critical data for the desired compound
    '''
	def info(self):
		pass
    
    '''
    key word arguments for this function
    are used to choose the output unit for 
    pressure.  Selections include bar, atm, MPa,
    Torr (default), psia.
    Default temperature needs to be in K.
    '''
    def antoine(self,temperature,unit='torr'):
        temperature = convtemp(temperature, 'K', 'C')
        p = 10**(self.antoine_data[3]-self.antoine_data[4]/(self.antoine_data[5]+temperature))
        p = convpress(p,'torr',unit)
        return(p)
        
    '''
    key word arguments for this function
    are used to choose the output unit for 
    pressure.  Selections include bar, atm, MPa,
    Torr (default), psia.
    Default temperature needs to be in K.
    '''   
    def shortcut(self, t, unit='torr'):
        tc = self.critical_data[2]
        pc = self.critical_data[3]
        tr = t/tc
        omega = self.critical_data[4]
        p = pc*(10**((7/3)*(1+omega)*(1-1/tr)))
        p = convpress(p,'MPa',unit)
        return(p)
        
    """
    Input Temperature, output pressure.  Temperature input must be in K
    """
    """
    Input Temperature, output pressure.  Temperature input must be in K.
    Keyword arguments adjust the pressure range that the recursive solver
    starts at, and changes the output pressure unit.  This solver is only 
    valid for a fluid where T < Tc, P < Pc.
    """
    def pengrobinson(self, T,P_high = 30, unit='torr'):
        P_low = 0
        max_error = 1e-6
        error = 1
        R = 8.314 # MPa
        Tc = self.critical_data[2] #K
        Pc = self.critical_data[3]  #MPa
        omega = self.critical_data[4]
        Tr = T/Tc
        kappa = 0.37464+1.54226*omega-0.26992*omega**2
        alpha = (1+kappa*(1-(Tr**0.5)))**2
        while abs(error)>max_error:
            '''
            begin using recursive function to determine the value of
            pressure which solves the cubic equation of state, and 
            satisfies the equilibrium requirement fl = fv
            '''
            P = (P_high + P_low)/2
            Pr = P/Pc
            a = 0.4572355289*((Tc*R)**2)*alpha/Pc
            b = 0.0777960739*R*Tc/Pc
            A = a*P/((R*T)**2)
            B = b*P/(R*T)
            # Set Up Cubic Equation Of State
            a_2 = -(1-B)
            a_1 = (A-3*(B**2)-2*B)
            a_0 = -(A*B-(B**2)-(B**3))
            p_z = (3*a_1-a_2**2)/3
            q_z = (2*a_2**3-9*a_2*a_1+27*a_0)/27
            R_z = ((q_z**2)/4)+((p_z**3)/27)
            if R_z >= 0:
                P_high = P
                '''
                for T<Tc and P<Pc, there will be 3 real roots for the cubic
                equation of state.  if R is negative, there will be 3 real
                roots.  If R is greater than 0, pressure it too high, but 
                this value does not monotonically increase or decrease
                with changes in pressure.
                '''
            else:
                '''
                This function calculates the real roots of the cubic
                equation using a triganometric solution taken from the 
                Peng-Robinson spreadsheet provided by Hasegawa.
                '''
                m = 2*((-p_z/3)**0.5)
                Q_z = 3*q_z/p_z/m
                theta = np.arccos(Q_z)/3
                r_1 = m*np.cos(theta)           # root 1
                r_2 = m*np.cos(theta+4*np.pi/3) # root 2
                r_3 = m*np.cos(theta+2*np.pi/3) # root 3
                z1 = r_1-a_2/3 # vapor compressibility factor
                z2 = r_2-a_2/3 # This value has no real meaning
                z3 = r_3-a_2/3 # liquid compressibility factor
                fv = P*np.exp(-np.log(z1-B)-A/(B*8**0.5)*np.log((z1+(1+2**0.5)*B)/(z1+(1-2**0.5)*B))+z1-1) #Peng-Robinson Equation
                fl = P*np.exp(-np.log(z3-B)-A/(B*8**0.5)*np.log((z3+(1+2**0.5)*B)/(z3+(1-2**0.5)*B))+z3-1) #Peng-Robinson Equation
                error = (fl/fv)-1
                phi = fl/P
                if error < 0: #pressure is too high
                    P_high = P
                elif error > 0: #pressure is too low
                    P_low = P
        '''
        table = (["Name",self.iupac],
                 ["Temperature",T],
                 ["Pressure",P],
                 ["Fugacity",fl],
                 ["compressibility",z1])
        print(tabulate(table)) # print table showing the important data calculated
        '''
        P = convpress(P,'MPa',unit) #convert pressure from MPa to whatever unit is desired
        return(P,phi,z1) #return the 3 most important peices of information

    
    """
    Input Temperature, output pressure.  Temperature input must be in K
    """
    def VDW(self, t, unit='torr'):
        R = 8.314 # MPa cm3 / mol K
        tc = self.critical_data[2] #K
        pc = convpress(self.critical_data[3],'mpa','atm')
        rho = self.critical_data[9] #mol/cm3
        b = (R*tc)/(8*pc)
        a = (27/64)*(R**2*tc**2)/pc
        p = (rho*R*t)/(1-b*rho)-a*(rho**2)
        p = convpress(p,'bar',unit)
        return(p)


