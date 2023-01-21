	ionFlux = mspm().totalIonFlux();

	mspm().correct(Y, E, chemistry, fields);

	kappa_e = mspm().electronConductivity(chemistry);

	pem.ecorrect(chemistry, E);

	gradTe = mspm().gradTe();

	pem.icorrect(chemistry);

	pem.gcorrect(chemistry, E);

	thermo.correct();

	rho = thermo.rho();

	volVectorField F = mspm().netChargeFlux();

	if (emcModelRef == "power")
	{
		ddtE = fvc::ddt(E);
	}
