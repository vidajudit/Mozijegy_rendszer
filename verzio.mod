set Filmek;
set Napok;
set Kaja;

param jegyar{f in Filmek, n in Napok};
param haromdese{f in Filmek};
param kajaar{k in Kaja};
param diakkedvezmeny;
param sajat_penz;
param kajapenz;
param diak_vane;
param akar_e_haromdet{f in Filmek};
#param ertek;

var megnezi_e{n in Napok, f in Filmek} binary;
var eszik_e{n in Napok, k in Kaja} binary;
var valami;
var valami2;
var kaja;

#ne k�lts�n t�bb p�nzt, mint amennyi van neki, att�l f�gg�en, hogy van-e di�kigazolv�nya
s.t. ne_koltson_tobbet:
sum{n in Napok, f in Filmek} ((megnezi_e[n,f]*jegyar[f,n]*diakkedvezmeny*diak_vane)+(megnezi_e[n,f]*(diak_vane-1)*(-1)*jegyar[f,n])) <= sajat_penz;

s.t. segedfuggveny:
sum{n in Napok, f in Filmek} (((megnezi_e[n,f]*jegyar[f,n]*diakkedvezmeny*diak_vane)+(megnezi_e[n,f]*(diak_vane-1)*(-1)*jegyar[f,n]))) = valami;

s.t. ne_koltson_tobbet_haromdevel:
sum{n in Napok, f in Filmek} ((akar_e_haromdet[f]*haromdese[f])*(megnezi_e[n,f]*jegyar[f,n])) <= sajat_penz;

s.t. segedfuggveny_haromde:
sum{n in Napok, f in Filmek} ((akar_e_haromdet[f]*haromdese[f])*(megnezi_e[n,f]*jegyar[f,n])) = valami2;

s.t. ne_koltson_tobbet_naponta_etelre:
sum{k in Kaja, n in Napok} (eszik_e[n,k]*kajaar[k])<=kajapenz;

s.t. segedfuggveny_etel:
sum{k in Kaja, n in Napok} (eszik_e[n,k]*kajaar[k])=kaja;

s.t. osszes_kiadas:
(valami-((valami2*diakkedvezmeny*diak_vane)+(valami2*(diak_vane-1)*(-1)))+valami2 + kaja)<=sajat_penz;

#legal�bb egy 3D-s filmet l�sson
s.t. haromdes_megnezett_filmek:
sum{n in Napok, f in Filmek} (haromdese[f]*megnezi_e[n,f]*akar_e_haromdet[f])>=1;

#egyszer legal�bb v�s�roljon a b�f�ben
s.t. egy_etel_legalabb:
sum{k in Kaja, n in Napok} eszik_e[n,k] >=1;

s.t. egy_nap_egy_film{f in Filmek}:
sum{n in Napok} megnezi_e[n,f]<=1;

s.t. egy_film_egyszer{n in Napok}:
sum{f in Filmek} megnezi_e[n,f]<=1;

maximize hany_filmet_latott: sum{n in Napok, f in Filmek} megnezi_e[n,f];
minimize mennyiert_evett: sum{n in Napok, k in Kaja} (eszik_e[n,k]*kajaar[k]);

solve;
printf "\n\n\nAz optim�lisan megn�zhet� filmek sz�ma %d forintb�l: %d db,\ndi�kigazolv�ny k�d: %d\n", sajat_penz, hany_filmet_latott, diak_vane;
printf "-------------------------------------------\n";
for{f in Filmek}{
	printf "%-1d. filmet\t\t", f;
	for{{0}: sum{n in Napok} megnezi_e[n,f]==0}
		 printf "nem n�zi meg.";
		
	for{n in Napok: megnezi_e[n,f]==1}
		printf "%d. napon n�zi meg.", n;
	
	printf"\n";
}
printf"\n\n%d forint�rt eszik a filmek\nmell� az al�bbi nap(ok)on:\n",  kajapenz;
for{k in Kaja}{
	printf "%s ennival�:  \t",k;
	for{{0}: sum{n in Napok} eszik_e[n,k]==0}
		printf "nem eszik.";
	for{n in Napok: eszik_e[n,k]==1}
		printf "%d ",n;
	
	printf"\n";
}
printf"\n\n\n\n";


end;

