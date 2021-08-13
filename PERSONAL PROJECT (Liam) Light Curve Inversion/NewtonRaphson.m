function [newcontrol, oldcontrol, oldvalue, fprime, newfunction] = NewtonRaphson(searchfor, newcontrol, oldcontrol, newvalue, oldvalue)

    newfunction = newvalue - searchfor;

    fprime = (newvalue - oldvalue) / (newcontrol - oldcontrol);
    
    oldcontrol = newcontrol;
    oldvalue = newvalue;

    newcontrol = oldcontrol - newfunction / fprime;
    
end