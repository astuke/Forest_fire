# Forest_fire

This Matlab code models a growing forest fire on an infinite square lattice, with one tree at every lattice site. The fire propagates according to the following rules:

- The trees have three possible states: Not yet burned, burning and burned

- Initially, the tree at coordinates (0,0) is set on fire

- A tree burns for one time step. After that, the tree is burned and can not catch fire a second time.

- At every time step, every burning tree has a probability *p* to ignite a neighbouring tree that is not yet burning or already burned. The ignited tree is then burning for the next time step. 

The code calculates how many trees get burned in a forest fire as a function of *p*. 
