* Encoding: UTF-8.


*GOAL 1: The behavioral task includes many trials. 
    *These are basically times when the floor pattern changes from grey to striped. 
    *For each trial, you have data on how many spikes the neuron fired in the 500ms before the change (PreFloorSpkCt) 
    *and how many spikes the neuron fired in the 500 ms after (PostFloorSpkCt) the change. 
    *The first thing you'll want to do is add up all the trials to get a total spike count for the pre and post 'epochs'
    *As you see below, this function is called "Summarize"
   
    

*Make sure your data isn't "split" meaning that you can't compare across variables

SPLIT FILE OFF.
SUMMARIZE
  /TABLES=PreFloorSpkCt PostFloorSpkCt PreFloorFR PostFloorFR BY Neuron#
  /FORMAT=NOLIST TOTAL
  /TITLE='Case Summaries'
  /MISSING=VARIABLE
  /CELLS=SUM.




* GOAL 2: For each cell, determine whether there is a significant difference in the number of spikes 
    *in the pre versus post change epochs. 
    *This is a simple ttest that is comparing all of the trials pre vs post
    *You do need to make sure that the data is split by cells
    *This will ensure it runs separate analyses for each neuron, rather than lumping all neurons together

SORT CASES  BY Neuron#.
SPLIT FILE SEPARATE BY Neuron#.

T-TEST PAIRS=PreFloorFR WITH PostFloorFR (PAIRED) 
  /CRITERIA=CI(.9500) 
  /MISSING=ANALYSIS.




*GOAL 3: Once you've mastered the simple pre vs post concept, you can move on to a more complex analysis
    *Here, we will compare pre vs post, but we will also take into consideration WHICH change has occurred
    *The floor can either change from grey to stripe OR from stripe to grey
    *This will be a multivariate analysis with two within-subject variables
    *Variable 1 = 'epoch' [pre, post]
    *Variable 2 = 'floor' [stripe to grey, grey to stripe]
    
GLM PreFloorFR PostFloorFR BY Floor
  /WSFACTOR=Epoch 2 Polynomial 
  /METHOD=SSTYPE(3)
  /PRINT=DESCRIPTIVE ETASQ OPOWER 
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Epoch 
  /DESIGN=Floor.



