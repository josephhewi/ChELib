from __future__ import division
from Tkinter import *
from ttk import *
	
def infosearch():
	pass
	
root = Tk()

compound = StringVar()


book = Notebook(root)

page1 = Frame(book) #Info
page2 = Frame(book) #EOS
page3 = Frame(book) #Unit Converter



pg1_title = Label(page1, text="Information Retrieval", font="a 14 bold" ).grid(row=0,column=0,columnspan=5)

pg1_txt1 = Label(page1, text="Compound: ").grid(                 row=1,column=0)
pg1_ent1 = Entry(page1, textvariable=compound).grid(             row=1,column=1)
pg1_but1 = Button(page1, text="Search", command=infosearch).grid(row=1,column=2)

pg1_txt2 = Label(page1, text="Molar Density").grid(row=2, column=0)
pg1_txt3 = Label(page1, text="Molar Mass").grid(   row=2, column=1)
pg1_txt4 = Label(page1, text="Z").grid(            row=2, column=2)

pg1_txt5 = Label(page1, text="-")
pg1_txt6 = Label(page1, text="-")
pg1_txt7 = Label(page1, text="-")
pg1_txt5.grid(row=3, column=0)
pg1_txt6.grid(row=3, column=1)
pg1_txt7.grid(row=3, column=2)

pg1_txt8 = Label(page1, text="Antoine Data", font="a 10 bold").grid(row=4, column=0, columnspan=5)

pg1_txt9  = Label(page1, text="Tc").grid(row=5, column=0)
pg1_txt10 = Label(page1, text="Th").grid(row=5, column=1)
pg1_txt11 = Label(page1, text="A").grid( row=5, column=2)
pg1_txt12 = Label(page1, text="B").grid( row=5, column=3)
pg1_txt13 = Label(page1, text="C").grid( row=5, column=4)

pg1_txt14 = Label(page1, text="-")
pg1_txt15 = Label(page1, text="-")
pg1_txt16 = Label(page1, text="-")
pg1_txt17 = Label(page1, text="-")
pg1_txt18 = Label(page1, text="-")
pg1_txt14.grid(row=6, column=0)
pg1_txt15.grid(row=6, column=1)
pg1_txt16.grid(row=6, column=2)
pg1_txt17.grid(row=6, column=3)
pg1_txt18.grid(row=6, column=4)

pg1_txt19 = Label(page1, text="-")
pg1_txt20 = Label(page1, text="-")
pg1_txt21 = Label(page1, text="-")
pg1_txt22 = Label(page1, text="-")
pg1_txt23 = Label(page1, text="-")
pg1_txt19.grid(row=7, column=0)
pg1_txt20.grid(row=7, column=1)
pg1_txt21.grid(row=7, column=2)
pg1_txt22.grid(row=7, column=3)
pg1_txt23.grid(row=7, column=4)

pg1_txt24 = Label(page1, text="Critical Data", font="a 10 bold").grid(row=8, column=0, columnspan=5)

pg1_txt25 = Label(page1, text="Temp").grid(    row=9, column=0)
pg1_txt26 = Label(page1, text="Press").grid(   row=9, column=1)
pg1_txt27 = Label(page1, text="Density").grid( row=9, column=2)
pg1_txt28 = Label(page1, text="Cp/R").grid(    row=9, column=3)
pg1_txt29 = Label(page1, text="Omega").grid(   row=9, column=4)

pg1_txt30 = Label(page1, text="-")
pg1_txt31 = Label(page1, text="-")
pg1_txt32 = Label(page1, text="-")
pg1_txt33 = Label(page1, text="-")
pg1_txt34 = Label(page1, text="-")
pg1_txt30.grid(row=10, column=0)
pg1_txt31.grid(row=10, column=1)
pg1_txt32.grid(row=10, column=2)
pg1_txt33.grid(row=10, column=3)
pg1_txt34.grid(row=10, column=4)

book.add(page1,text="INFO")
book.add(page2,text="EOS")
book.add(page3,text="UNITS")
book.pack()
root.mainloop()