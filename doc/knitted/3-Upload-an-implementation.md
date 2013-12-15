Upload an implementation
========================

If you want to upload predictions of an algorithm for a certain task, you have to know the algorithm's OpenML implementation ID. If the implementation is not yet registered, you need to upload it. Here, we give you some advice to help you get started.

### Get a valid session hash
In order to upload anything to the server, you have to authenticate your identity first. Therefore, you need to be registered at openml.org. Use the following function to get an authentication hash that is valid for one hour:


```r
hash <- authenticateUser(username = "your@email.com", password = "your_password")
```

### Upload an mlr learner
There are some helper functions in case you are using the package [mlr](https://github.com/berndbischl/mlr) (Machine Learning in R). To upload an mlr learner you have to convert it into an OpenML implementation description object. This can be made by the function `createOpenMLImplementationForMLRLearner`:


```r
library(mlr)
learner <- makeLearner("classif.rpart")
openML.impl <- createOpenMLImplementationForMLRLearner(learner)
```

This description object can be uploaded by

```r
uploadOpenMLImplementation(openML.impl, session.hash = hash)
```


### Upload an implementation without using mlr
If you are not using mlr, you will have to invest quite a bit more time to get things done. So -- unless you have good reasons to do otherwise -- we strongly encourage you to use mlr. 

The following example shows how to create an OpenML implementation description object manually.

First, create an implementation parameter list. This is a list that contains an `OpenMLImplementationParameter` for every parameter of your implementation. Let's assume we have written an algorithm that has two parameters called "a" (numeric, default: 500) and "b" (logical, default: TRUE). 

```r
impl.par.a <- OpenMLImplementationParameter(
  name = "a", 
  data.type = "numeric", 
  default.value = "500",  # Yes, all defaults must be passed as strings.
  description = "An optional description of parameter a.")  

impl.par.b <- OpenMLImplementationParameter(
  name = "b", 
  data.type = "logical", 
  default.value = "TRUE",  
  description = "An optional description of parameter b.")  

impl.pars <- list(impl.par.a, impl.par.b)
```

Now we can create the whole description object. Try to find a good name for your algorithm that gives other users an idea of what is happening. 

```r
openML.impl <- OpenMLImplementation(name = "good_name", version = "1.0", description = "Please take some time and write a description of your algorithm/changes compared with the previous\n  version/etc. here.", 
    parameter = impl.pars)
```

Now we finally have the implementation description object, which can be uploaded as we have already seen in the section above:

```r
uploadOpenMLImplementation(openML.impl, session.hash = hash)
```


----------------------------------------------------------------------------------------------------------------------
Jump to:    
[1 Introduction](1-Introduction.md)    
[2 Download a task](2-Download-a-task.md)  
3 Upload an implementation  
[4 Upload predictions](4-Upload-predictions.md)  
[5 Download performance measures](5-Download-performance-measures.md)