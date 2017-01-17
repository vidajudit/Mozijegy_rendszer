set Filmek;
set Napok;
set Etel;
set Emberek;

param jegyar{f in Filmek, n in Napok};
param haromdese{f in Filmek};
param etelar{e in Etel};
param diakkedvezmeny;
param sajat_penz;
param etelpenz;
param romantikus{f in Filmek};
param akcio{f in Filmek};


var megnezi_e{n in Napok, f in Filmek, e in Emberek} binary;
var eszik_e{n in Napok, e in Etel} binary;
var seged;
var seged2;
var etel;

s.t. ne_koltson_tobbet:
sum{n in Napok, f in Filmek, e in Emberek} (megnezi_e[n,f,e]*jegyar[f,n])=seged;

s.t. ne_koltson_haromdere_tobbet:
sum{n in Napok, f in Filmek, e in Emberek} ((haromdese[f])*(megnezi_e[n,f,e]*jegyar[f,n]))= seged2;

s.t. segedfuggveny_etel:
sum{e in Etel, n in Napok} (eszik_e[n,e]*etelar[e])=etel;

s.t. osszes_kiadas:
((seged2+etel)+(((seged-seged2)*diakkedvezmeny)))<=sajat_penz;

s.t. ne_menjen_csak_enni{n in Napok, r in Emberek}:
sum{e in Etel} eszik_e[n,e]<= sum{f in Filmek}megnezi_e[n,f,r];

s.t. haromdes_megnezett_filmek_szama:
sum{n in Napok, f in Filmek, e in Emberek} (haromdese[f]*megnezi_e[n,f,e])>=1;

s.t. etel_legalabb:
sum{e in Etel, n in Napok} eszik_e[n,e] >= sum{f in Filmek, n in Napok, e in Emberek} (megnezi_e[n,f,e]/2);

s.t. egy_nap_egy_film{f in Filmek, e in Emberek}:
sum{n in Napok} megnezi_e[n,f,e]<=1;

s.t. egy_film_egyszer{n in Napok, e in Emberek}:
sum{f in Filmek} megnezi_e[n,f,e]<=1;

s.t. akciofilm{n in Napok, f in Filmek}:
sum{e in Emberek}(megnezi_e[n,f,1]*akcio[f])<=sum{e in Emberek}(megnezi_e[n,f,2]*akcio[f]);

s.t. romantikus_film{n in Napok, f in Filmek}:
sum{e in Emberek}(megnezi_e[n,f,1]*romantikus[f])<=sum{e in Emberek}(megnezi_e[n,f,2]*romantikus[f]);


maximize hany_filmet_latott: sum{n in Napok, f in Filmek, e in Emberek} megnezi_e[n,f,e];
minimize mennyiert_evett: sum{n in Napok, e in Etel} (eszik_e[n,e]*etelar[e]);



solve;
printf "\n\n\nAz optimálisan megnézhetõ filmek száma %d forintból: %d db,\ndiákigazolvány van\n", sajat_penz, hany_filmet_latott;
printf "-------------------------------------------\n";
for{f in Filmek}{
	printf "%-10s filmet\t", f;
	for{{0}: sum{n in Napok, e in Emberek} megnezi_e[n,f,e]==0}
		 printf "nem nézi meg.";
		
	for{n in Napok, e in Emberek: megnezi_e[n,f,e]==1}
		printf "%s %d. napon nézi meg, ",e, n;
	
	printf"\n";
}

printf"\n\n";

for{f in Filmek}{
	printf "%-10s filmet\t", f;
	for{{0}: sum{n in Napok, e in Emberek} (haromdese[f]*megnezi_e[n,f,e])==0}
		 printf "nem nézik meg 3D-ben.";
		
	for{n in Napok, e in Emberek: (haromdese[f]*megnezi_e[n,f,e])==1}
		printf "%s %d. napon nézi meg 3D-ben.",e,n;
	
	printf"\n";
}


printf"\n\n%d forintért esznek a filmek\nmellé az alábbi nap(ok)on:\n", etel;
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

