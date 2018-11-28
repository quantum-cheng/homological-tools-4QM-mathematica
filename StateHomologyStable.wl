(* ::Package:: *)

AppendTo[$Path,NotebookDirectory[]];


BeginPackage["StateHomologyStable`",{"StateFunctorStable`","CechOpsStable`","BasicStable`"}];


(* ::Title:: *)
(*Descriptions of Public (Unhidden) Functions*)


comCohomologyRk::usage="comHomologyRk[deg,rho,dimprim,cover] outputs the rank of the degree 'deg'
cohomology group associated to the state rho";


GNSCohomologyRk::usage="GNSHomologyRk[deg,rho,dimprim,cover] outputs the rank of the degree 'deg'
cohomology group associated to the state rho";


comCohomologyVect::usage="comHomologyVect[deg,rho,dimprim,cover] outputs a list of generators of 
the degree 'deg' cohomology group---identified with a vector space---associated to the state rho";


GNSCohomologyVect::usage="GNSHomologyVect[deg,rho,dimprim,cover] outputs a list of generators of 
the degree 'deg' hcohomology group---identified with a vector space---associated to the state rho";


comCohomologyObj::usage="comHomologyObj[deg,rho,dimprim,cover] outputs a lists of generators of the degree
'deg' cohomology group---given by chains valued in elements of endFunctorObj---associated to the state rho.";


GNSCohomologyObj::usage="GNSHomologyObj[deg,rho,dimprim,cover] outputs a lists of generators of the degree
'deg' cohomology group---given by chains valued in elements of GNSFunctorObj---associated to the state rho.";


comCohomologyRkList::usage="comHomologyRkList[rho_,dimprim_,cover_] outputs a list of the ranks
of the homology groups (associated to the state rho) from degree -1 to degree Length[cover]-1.  This 
function is faster than sequentially using comCohomologyRk as it temporarily stores values
from endFunctorObj and endFunctorMor.";


GNSCohomologyRkList::usage="GNSHomologyRkList[rho_,dimprim_,cover_] outputs a list of the ranks
of the homology groups (associated to the state rho) from degree -1 to degree Length[cover]-1.  This 
function is faster than sequentially using GNSCohomologyRk as it temporarily stores values
from GNSFunctorObj and GNSFunctorMor.";


comPoly::usage="comPoly[rho_,dimprim_,cover_][y] outputs the commutant Poincare polynomial, in variable y, of the multipartite density state
specified by the data of the density state 'rho', list of dimension vectors 'dimprim', and cover of tensor factors 'cover'.";


GNSPoly::usage="comPoly[rho_,dimprim_,cover_][y] outputs the GNS Poincare polynomial, in variable y, of the multipartite density state
specified by the data of the density state 'rho', list of dimension vectors 'dimprim', and cover of tensor factors 'cover'.";


(* ::Title:: *)
(*Function Definitions*)


(* ::Subsection:: *)
(*Homologically Graded*)


Begin["`Private`"];


comHomologyRk[rho_,dimprim_,cover_][deg_]:=homologyRank[deg, endFunctorObj[rho,dimprim], endFunctorMor[rho,dimprim], cover, localInProd];


GNSHomologyRk[rho_,dimprim_,cover_][deg_]:=homologyRank[deg, GNSFunctorObj[rho,dimprim], GNSFunctorMor[rho,dimprim], cover, localInProd];


comHomologyVect[rho_,dimprim_,cover_][deg_]:=homologyVect[deg, endFunctorObj[rho,dimprim], endFunctorMor[rho,dimprim], cover, localInProd];


GNSHomologyVect[rho_,dimprim_,cover_][deg_]:=homologyVect[deg, GNSFunctorObj[rho,dimprim], GNSFunctorMor[rho,dimprim], cover, localInProd];


comHomologyObj[rho_,dimprim_,cover_][deg_]:=homologyObj[deg, endFunctorObj[rho,dimprim], endFunctorMor[rho,dimprim], cover, localInProd];


GNSHomologyObj[rho_,dimprim_,cover_][deg_]:=homologyObj[deg, GNSFunctorObj[rho,dimprim], GNSFunctorMor[rho,dimprim], cover, localInProd];


comHomologyRkList[rho_,dimprim_,cover_]:=Module[{funMor,funObj},
funObj[srcobj_]:=funObj[srcobj]=endFunctorObj[rho,dimprim][srcobj];
funMor[src_,tgt_]:=funMor[src,tgt]=endFunctorMor[rho,dimprim][src,tgt];
Table[homologyRank[deg, funObj, funMor, cover, localInProd],{deg,-1,Length@cover-2}]
];


GNSHomologyRkList[rho_,dimprim_,cover_]:=Module[{funMor,funObj},
funObj[srcobj_]:=funObj[srcobj]=GNSFunctorObj[rho,dimprim][srcobj];
funMor[src_,tgt_]:=funMor[src,tgt]=GNSFunctorMor[rho,dimprim][src,tgt];
Table[homologyRank[deg, funObj, funMor, cover, localInProd],{deg,-1,Length@cover-2}]
];


(* ::Subsection:: *)
(*Cohomologically Graded*)


fixDegree[deg_,cover_]:=Length@cover-deg-2;


comCohomologyRk[rho_,dimprim_,cover_][deg_]:=comHomologyRk[rho,dimprim,cover][fixDegree[deg,cover]];


GNSCohomologyRk[rho_,dimprim_,cover_][deg_]:=GNSHomologyRk[rho,dimprim,cover][fixDegree[deg,cover]];


comCohomologyVect[rho_,dimprim_,cover_][deg_]:=comHomologyVect[rho,dimprim,cover][fixDegree[deg,cover]];


GNSCohomologyVect[rho_,dimprim_,cover_][deg_]:=comHomologyVect[rho,dimprim,cover][fixDegree[deg,cover]];


comCohomologyObj[rho_,dimprim_,cover_][deg_]:=comCohomologyObj[rho,dimprim,cover][fixDegree[deg,cover]];


GNSCohomologyObj[rho_,dimprim_,cover_][deg_]:=comCohomologyObj[rho,dimprim,cover][fixDegree[deg,cover]];


comCohomologyRkList:=Reverse@*comHomologyRkList;


GNSCohomologyRkList:=Reverse@*GNSHomologyRkList;


comPoly[rho_,dimprim_,cover_][y_]:=y^(Range[0,Length@cover-1]).comCohomologyRkList[rho,dimprim,cover];


GNSPoly[rho_,dimprim_,cover_][y_]:=y^(Range[0,Length@cover-1]).GNSCohomologyRkList[rho,dimprim,cover];


(* ::Title:: *)
(*End Matter*)


End[];


EndPackage[]



