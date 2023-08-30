+!vote_done
  <- 
     ?preference(Pref) ; // consult the agent's preference
     ?options(Options) ; // consult the temperature options
     ?closest(Pref, Options, Vote) ;

     // vote
     .print("Vote ", Vote) ;
     vote(Vote) .


//----------------- Greeting management --------------   

+!greet : language(english)
    <- .print("hello world.").            

+!greet : language(french)
    <- .print("bonjour.").     

+!greet
    <- .print("I do not know how to greet.").    




     


// closest(Pref,Options,V): discovers the Option closser to Pref
closest(P,[H|_],H) :- P <= H. // assuming options are ordered, if the first option is equals of greater than my pref, it is my vote
closest(P,[H1,H2|_],H1) :- P > H1 & P < H2 & P-H1 <= H2-P. // if my preference is between two options, chose the closer
closest(P,[H1,H2|_],H2) :- P > H1 & P < H2 & P-H1 >  H2-P.
closest(P,[H],H). // no more options
closest(P,[_|T],V) :- closest(P,T,V). // keep looking for options in the list

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }


// plans to handle obligations
// obligation to commit to a mission
+obligation(Ag,Norm,committed(Ag,Mission,Scheme),Deadline)[artifact_id(ArtId),workspace(_,W)]
    : .my_name(Ag)
   <- .random(R);
      .wait(R*100);
      !commit(Mission,Scheme,W).

+!commit(Mission, Scheme, WorkspaceId) 
   : obligation(Ag,Norm,committed(Ag,Mission,Scheme),Deadline)[artifact_id(ArtId),workspace(_,W)]
     & .my_name(Ag)
   <- .print("I am obliged to commit to ",Mission," on ",Scheme,"... doing so");
      commitMission(Mission)[artifact_name(Scheme), wid(W)].
     
+!commit(Mission, Scheme, WorkspaceId).     

{ include("$moiseJar/asl/org-obedient.asl") }