/*---------------------------------------------------------------------------*\
Copyright (C) 2018 by the LUEUR authors

License
This project is licensed under The 3-Clause BSD License. For further information
look for license file include with distribution.


Application
    plasmaSimFoam

Description
    simple plasma solver tailored towards test of addition of features and 
    debugging said features

\*---------------------------------------------------------------------------*/

// set up supporting libraries for simulation to run succesfully
// all these libraries are linked in the Make folder 
#include "fvCFD.H"
#include "coupledFvMatrices.H"
#include "regionCouplePolyPatch.H"
#include "multivariateScheme.H"
#include "regionProperties.H"
#include "zeroGradientFvPatchFields.H"
#include "multiSpeciesPlasmaModel.H"
#include "plasmaEnergyModel.H"
#include "thermoPhysicsTypes.H"
#include "emcModels.H"

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //

int main(int argc, char *argv[])
{
	// create fields and meshes required to simulation to run
	#include "setRootCase.H"
	#include "createTime.H"

	#include "createPlasmaMesh.H"
	#include "createFields.H"

	// turn off debug switches so terminal printouts are not shown 
    lduMatrix::debug = 0;
	coupledLduMatrix::debug = 0;
	blockLduMatrix::debug = 0;

	// Forces problems to be run exclusively as 1D
	if (solutionDomain == "plasma" && mesh.nSolutionD() == 1)
	{
		while (runTime.run())
		{
			// solve plasma equations 
			#include "plasmaEqn.H"

			// postFix increment. Will update after loop is completed 
		    runTime++;

		    Info<< "Simulation Time = " << runTime.timeName() << "s" << tab << "CPU Time = "
		        << runTime.elapsedCpuTime() << "s" << endl;

			// solve poisson equation  
			#include "solvePoisson.H"

	        // set up new time step by matching electron flux of the system to a user specified courant number  
		    scalar Cofactor = mspm().divFe();
		    scalar deltaTNew = MaxCo/(Cofactor+1e-10);
		    deltaTNew = min(deltaTNew,deltaTMax);
		    deltaTNew = max(deltaTNew,deltaTMin);
		    runTime.setDeltaT(deltaTNew);

		    // print obtained time step and courant number into terminal 
		    Info << "New timestep = " << runTime.deltaTValue() << endl;
		    Info << "Courant = " << Cofactor*runTime.deltaTValue() << endl;

		    // output data in terms of scalars and vector files 
		    if (runTime.write() && restartCapabale)
		    {		    
				thermo.Te().write();

			    thermo.T().write();

			    thermo.Tion().write();

			    thermo.p().write();

			    Phi.write();

			    forAll(composition.Y(), i)
			    {
					volScalarField specN
					(
						IOobject
						(
							composition.species()[i],
							runTime.timeName(),
							mesh
						),
						mspm().N(i),
						Y[i].boundaryField().types()
					);
					specN.write();
				}
		    }
		}
	}
	else
	{
		Info << "plasmaSimFoam is tailored towards development and testing" << endl;
		Info << "of features, focusing itself on 1D. Please use other solvers" << endl;
		Info << "for study of plasma phenomena" << endl;
	}

    return(0);
}


// ************************************************************************* //
