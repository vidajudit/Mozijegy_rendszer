set Filmek;
set Napok;
set Etel;

param jegyar{f in Filmek, n in Napok};
param haromdese{f in Filmek};
param etelar{e in Etel};
param diakkedvezmeny;
param sajat_penz;
param etelpenz;
param diak_vane;
param akar_e_haromdet{f in Filmek};

var megnezi_e{n in Napok, f in Filmek} binary;
var eszik_e{n in Napok, e in Etel} binary;
var seged;
var seged2;
var etel;

s.t. ne_koltson_tobbet:
sum{n in Napok, f in Filmek} (megnezi_e[n,f]*jegyar[f,n])=seged;

s.t. ne_koltson_haromdere_tobbet:
sum{n in Napok, f in Filmek} ((akar_e_haromdet[f]*haromdese[f])*(megnezi_e[n,f]*jegyar[f,n]))= seged2;

s.t. segedfuggveny_etel:
sum{e in Etel, n in Napok} (eszik_e[n,e]*etelar[e])=etel;

s.t. osszes_kiadas:
((seged2+etel)+(((seged-seged2)*diakkedvezmeny*diak_vane)+((seged-seged2)*(diak_vane-1)*(-1))))<=sajat_penz;

s.t. ne_menjen_csak_enni{n in Napok}:
sum{e in Etel} eszik_e[n,e]<= sum{f in Filmek}megnezi_e[n,f];

s.t. haromdes_megnezett_filmek_szama:
sum{n in Napok, f in Filmek} (haromdese[f]*megnezi_e[n,f]*akar_e_haromdet[f])>=1;

s.t. etel_legalabb:
sum{e in Etel, n in Napok} eszik_e[n,e] >= sum{f in Filmek, n in Napok} (megnezi_e[n,f]/2);

s.t. egy_nap_egy_film{f in Filmek}:
sum{n in Napok} megnezi_e[n,f]<=1;

s.t. egy_film_egyszer{n in Napok}:
sum{f in Filmek} megnezi_e[n,f]<=1;



maximize hany_filmet_latott: sum{n in Napok, f in Filmek} megnezi_e[n,f];
minimize mennyiert_evett: sum{n in Napok, e in Etel} (eszik_e[n,e]*etelar[e]);



solve;
printf "\n\n\nAz optimálisan megnézhetõ filmek száma %d forintból: %d db,\ndiákigazolvány kód: %d\n", sajat_penz, hany_filmet_latott, diak_vane;
printf "-------------------------------------------\n";
for{f in Filmek}{
	printf "%-10s filmet\t", f;
	for{{0}: sum{n in Napok} megnezi_e[n,f]==0}
		 printf "nem nézi meg.";
		
	for{n in Napok: megnezi_e[n,f]==1}
		printf "%d. napon nézi meg.", n;
	
	printf"\n";
}

printf"\n\n";

for{f in Filmek}{
	printf "%-10s filmet\t", f;
	for{{0}: sum{n in Napok} (haromdese[f]*megnezi_e[n,f]*akar_e_haromdet[f])==0}
		 printf "nem nézi meg 3D-ben.";
		
	for{n in Napok: (haromdese[f]*megnezi_e[n,f]*akar_e_haromdet[f])==1}
		printf "%d. napon nézi meg 3D-ben.", n;
	
	printf"\n";
}


printf"\n\n%d forintért eszik a filmek\nmellé az alábbi nap(ok)on:\n", etel;
for{e in Etel}{
	printf "%s ennivaló:  \t",e;
	for{{0}: sum{n in Napok} eszik_e[n,e]==0}
		printf "nem eszik.";
	for{n in Napok: eszik_e[n,e]==1}
		printf "%d ",n;
	
	printf"\n";
}
printf"\n\n\n\n";


end;

