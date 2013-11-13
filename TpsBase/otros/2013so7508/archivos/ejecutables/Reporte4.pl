#!/usr/bin/perl -w
use warnings;
use Time::Piece;
use Switch;

# Directorios necesarios para trabajar
$REPODIR=$ENV{'REPODIR'};
$MAEDIR=$ENV{'MAEDIR'};
$PROCDIR=$ENV{'PROCDIR'};


$pais = "pais";
$sistema = "sistema";
$anio = "anio";
$periodo = "periodo";
$rango = "rango";
$salida = "salida";

$escribir_salida = 1;

sub print_help{
	print (" Ayuda del comando Reporte4\n");
	print (" Sintaxis: Reporte4 [Opcion] [Filtros]\n");
	print ("	Opcion -w: Graba un reporte de salida en el directorio $REPODIR \n");
	print ("	Los filtros válidos son:\n");
	print ("	1. -c (codigo de pais) - OBLIGATORIO\n");
	print ("	2. -s (codigo del sistema)\n");
	print ("	3. -a (anio)\n");
	print ("	4. -p [periodo (AAAA/MM)]\n");
	print ("	5. -r [Rango de periodos (AAAA/MM-AAAA/MM)]\n");
}

sub leer_parametros{
	
	my %hash;
	my $cantParametros=$#ARGV + 1;
	
	# Lectura de Parametros
	if ($cantParametros < 2){
		$command = "-h"
	} else {
		$command = $ARGV[0];
	}
	
	$i = 0;
	$hash{$salida} = 0;
	if ($command eq "-w"){
		#Si pasamos la opcion de grabar reporte debe haber por lo menos 3 parametros
		if ($cantParametros < 3){
			$command = "-h";
		} else {
			$fecha = localtime->strftime('%Y-%m-%d_%H:%M:%S');
			$archivo_salida = join ("",">",$REPODIR,"/Reporte4.",$fecha);
			open(SALIDA,$archivo_salida) || die "ERROR: No se pudo crear el archivo de salida";
			$i = 1;
			$hash{$salida} = 1;
			$escribir_salida = 0;
		}
	}

	if ($command eq "-h"){
		print_help();
		exit(0);
	}

	while ($i < $#ARGV){
		if ($ARGV[$i] eq "-c"){ $hash{$pais} = $ARGV[$i+1] };
		if ($ARGV[$i] eq "-s"){ $hash{$sistema} = $ARGV[$i+1] };
		if ($ARGV[$i] eq "-a"){ $hash{$anio} = $ARGV[$i+1] };
		if ($ARGV[$i] eq "-p"){
			if (exists $hash{$rango}){ 
					print "ERROR: Se han ingresado un periodo y un rango a la vez\n";
					print_help();
					exit(1);
			}
			my $string=$ARGV[$i+1];
			#Matcheamos la regexp
			if (($string !~ /^[0-9][0-9][0-9][0-9]\/1[0-2]$/)&&($string !~ /^[0-9][0-9][0-9][0-9]\/0?[1-9]$/)){
				print "Período incorrecto ingresado, respete el formato AAAA/MM\ny verifique que el mes sea válido\n";
			 	exit(1);
			}
			else{
			 	$hash{$periodo} = $ARGV[$i+1]
			}
		};
		#TODO: rango y periodo no deberian poder ingresarse a la vez
		if ($ARGV[$i] eq "-r"){ 
			if (exists $hash{$periodo}){ 
				print "ERROR: Se han ingresado un periodo y un rango a la vez\n";
				print_help();
				exit(1);
			}
			my $string=$ARGV[$i+1];
			#Matcheamos la regexp
			if (($string !~ /^[0-9][0-9][0-9][0-9]\/[0-1][0-9]-[0-9][0-9][0-9][0-9]\/1[0-2]$/)&&
			($string !~ /^[0-9][0-9][0-9][0-9]\/[0-1][0-9]-[0-9][0-9][0-9][0-9]\/0?[1-9]$/)){
				print "Rango incorrecto ingresado, por favor,respete el\nformato AAAA/MM-AAAA/MM y verifique que los meses sea válido\n";
				exit(1);
			}
			else{
			 	$hash{$rango} = $ARGV[$i+1]
			}
		};
		$i = $i + 2;
	}

	if (not exists $hash{$pais}){ 
		print "Por favor, ingrese el pais\n";
		$hash{$pais} = <STDIN>;
	}
	if ($escribir_salida == 0){
		print SALIDA "FILTROS UTILIZADOS\n";
		print SALIDA "Pais: ",$hash{$pais},"\n";
		if (exists $hash{$sistema}){
			print SALIDA "Sistema: ",$hash{$sistema},"\n";
		}
		if (exists $hash{$anio}){
			print SALIDA "Anio: ",$hash{$anio},"\n";
		}
		if (exists $hash{$periodo}){
			print SALIDA "Periodo: ",$hash{$periodo},"\n";			
		}
		if (exists $hash{$rango}){
			print SALIDA "Rango: ",$hash{$rango},"\n";
		}
		print SALIDA "\n";
	}
	# Fin de lectura de parametros
	return %hash;
}

#recibe el hash, el registro y el array; si se cumple el filtro agrega el registro al array 
sub filtrar_registro_ppi{
	my $miHash = shift;
	my $refArr = shift;
	my $refReg = shift;
	my %hash = %{$miHash};
	my @array= @{$refArr};
	my @reg= @{$refReg};

	if (not $reg[0] eq $hash{$pais}){
		return 0;
	}
	
	if (exists $hash{$sistema}){
		if (not $reg[1] eq $hash{$sistema}){
			return 0;
		}
	}
	if (exists $hash{$anio}){
		if (not $reg[2] eq $hash{$anio}){
			return 0;
		}
	}
	if (exists $hash{$periodo}){
		#Extraemos el año y el mes
		my @aux = split("/",$hash{$periodo});
		my $year = $aux[0];
		my $mes = $aux[1];
		if (not (($reg[2] == $year) && ($reg[3] == $mes)) ){
			return 0;
		}
	}
	if (exists $hash{$rango}){
		#Extraemos los años y meses
		my @aux = split("-",$hash{$periodo});
		my $principio = $aux[0];
		my $final = $aux[1];
				
		my @vecInicial= split("/",$principio);
		my @vecFinal= split("/",$final);
				
		my $anioIni = $vecInicial[0];
		my $mesIni = $vecInicial[1];
		my $anioFin = $vecFinal[0];
		my $mesFin = $vecFinal[1];
		if (not (($reg[2] >= $anioIni) && ($reg[3] >= $mesIni) && ($reg[2] <= $anioFin) && ($reg[3] <= $mesFin)) ){
			return 0;
		}	
					
	}
	
	#si llego hasta acá es match, return 1 (true)
	return 1;
}


sub cargar_archivo_ppi{
	(%filtros) = @_;
	
	# Abro los archivos y obtengo los registros necesaarios para trabajar
	open (PPI,"<$MAEDIR/PPI.mae") || die "ERROR: Archivo $MAEDIR/PPI.mae no se ha podido abrir";
	my @registros_ppi = ();
	while (<PPI>){
		my $line=$_;
		#chomp remueve el \n del final
		chomp($line);
		my @reg = split(";",$line);
		#filtramos el pais
		if ($reg[0] eq $filtros{$pais}){
			push(@registros_ppi,\@reg);
		}
	}
	close (PPI);
	
	return @registros_ppi;
}



sub cargar_archivo_ps{
	(%filtros) = @_;
	
	open (PS,"<$MAEDIR/p-s.mae") || die "ERROR: Archivo $MAEDIR/p-s.mae no se ha podido abrir";
	my @registros_ps = ();
	while (<PS>){
		chomp($_);
		my @reg = split(";",$_);
		if ($reg[0] eq $filtros{$pais}){
			push(@registros_ps,\@reg);
		}
	}
	close (PS);
	
	return @registros_ps;
}

sub cargar_archivo_prestamos{
	(%filtros) = @_;	

	open (PRESTAMOS,"<$PROCDIR/PRESTAMOS.$filtros{$pais}") || die "ERROR: Archivo $PROCDIR/PRESTAMOS.$filtros{$pais} no se ha podido abrir";
	my @registros_prestamos = ();
	while (<PRESTAMOS>){
		chomp($_);
		my @reg = split(";",$_);
		push(@registros_prestamos,\@reg);
		
	}
	close (PRESTAMOS);
	
	return @registros_prestamos;
	
}

sub calcular_monto_restante{

	(@registros_ppi) = @_;
	$monto = 0;
	foreach $regRef(@registros_ppi){
		my @reg = @{$regRef};
		$monto = $monto + $reg[9] + $reg[10] + $reg[11] + $reg[12] - $reg[13];		
	}
	
	return $monto;
}



sub leer_si_no{
	my $leido = <STDIN>;
	$leido = lc($leido);
	chomp($leido);
	while (($leido ne "si") && ($leido ne "no")){
		print "Por favor, ingrese una opción correcta (si/no)\n";
		$leido = <STDIN>;
		$leido = lc($leido);
		chomp($leido);
		print $leido;
	}
	return $leido;
}

sub leer_filtros{
	my $miHash = shift;
	my %hash = %{$miHash};
	delete $hash{$sistema};
	delete $hash{$anio};
	delete $hash{$rango};
	delete $hash{$periodo};
	
	print "Desea filtrar por sistema? (si/no)\n";
	my $leido = &leer_si_no();
	if ($leido eq "si"){
		print "Ingrese el sistema\n";
		my $aux = <STDIN>;
		while ($aux !~ /^[0-9]+$/){
			print "Por favor, ingrese un sistema válido (###+)\n";
			$aux = <STDIN>;
		}
		$hash{$sistema} = $aux;
	
	}
	print "Desea filtrar por anio? (si/no)\n";
	$leido = &leer_si_no();
	if ($leido eq "si"){
		print "Ingrese el anio (AAAA)\n";
		my $aux = <STDIN>;
		while ($aux !~ /^[0-9][0-9][0-9][0-9]$/){
			print "Por favor, ingrese un anio válido (AAAA)\n";
			$aux = <STDIN>;
		}
		$hash{$anio}=$aux;
		
	}
	print "Desea filtrar por periodo? (si/no)\n";
	$leido = &leer_si_no();
	if ($leido eq "si"){
		print "Ingrese el periodo (AAAA/MM)\n";
		my $aux2 = <STDIN>;
		while (($aux2 !~ /^[0-9][0-9][0-9][0-9]\/1[0-2]$/) && ($aux2 !~ /^[0-9][0-9][0-9][0-9]\/0?[1-9]$/)){
			print "Por favor, ingrese un periodo válido (AAAA/MM)\n";
			$aux2 = <STDIN>;
		}
		$hash{$periodo}=$aux2;
	
	}
	print "Desea filtrar por rango? (si/no)\n";
	$leido = &leer_si_no();
	if ($leido eq "si"){
		print "Ingrese el periodo (AAAA/MM-AAAA/MM)\n";
		my $aux3 = <STDIN>;
		while (($aux3 !~ /^[0-9][0-9][0-9][0-9]\/[0-1][0-9]-[0-9][0-9][0-9][0-9]\/1[0-2]$/)&&
			($aux3 !~ /^[0-9][0-9][0-9][0-9]\/[0-1][0-9]-[0-9][0-9][0-9][0-9]\/0?[1-9]$/)){
			print "Por favor, ingrese un rango válido (AAAA/MM-AAAA/MM)\n";
			$aux3 = <STDIN>;
		}
		$hash{$rango}=$aux3;
	
	}
	
	if ($escribir_salida == 0){
		print SALIDA "FILTROS UTILIZADOS\n";
		print SALIDA "Pais: ",$hash{$pais},"\n";
		if (exists $hash{$sistema}){
			print SALIDA "Sistema: ",$hash{$sistema},"\n";
		}
		if (exists $hash{$anio}){
			print SALIDA "Anio: ",$hash{$anio},"\n";
		}
		if (exists $hash{$periodo}){
			print SALIDA "Periodo: ",$hash{$periodo},"\n";			
		}
		if (exists $hash{$rango}){
			print SALIDA "Rango: ",$hash{$rango},"\n";
		}
		print SALIDA "\n";
	}
	
}

sub compararFechas{

	my $fecha1=shift;
	my $fecha2=shift;

	#Separamos el string en dia, mes año
	@arr1=split("\/",$fecha1);
	@arr2=split("\/",$fecha2);
	#print  @arr1;
	#anio
	if ($arr1[2]<$arr2[2]){
		return -1;
	}
	elsif ($arr1[2]>$arr2[2]){
		return 1;
	}
	#mes
	elsif ($arr1[1]<$arr2[1]){
		return -1;
	}
	elsif ($arr1[1]>$arr2[1]){
		return 1;
	}
	#dia
	elsif ($arr1[0]<$arr2[0]){
		return -1;
	}
	elsif ($arr1[0]>$arr2[0]){
		return 1;
	}
	return 0;
		
		
}


sub realizar_consulta_filtrada{
	my $refPrestamos = shift;
	my @registros = @{$refPrestamos};
	my $registros_ppi_ref = shift;
	my @registros_maestro=@{$registros_ppi_ref};
	my @resultados =();
	my $sizeResult =0;
	my @recalculos=();
	my @vect_no_encontrados=();
	#Flag que nos dira si es deseable recalculo
	my $flag=0;
	my $no_se_encontro=1;
	foreach $reg(@registros_maestro){
		my @arr = @{$reg};
		if ($no_se_encontro==0){
			$no_se_encontro=1;
			next;
		}
		@resultados =();
		foreach $regPrest(@registros){
			my @regPrestamo = @{$regPrest};
			#comparamos codigo prestamo, año, mes
			if (($arr[7] eq $regPrestamo[5]) && ($arr[2]==$regPrestamo[1]) && ($arr[3]==$regPrestamo[2])){
				push(@resultados,\@regPrestamo);
				$sizeResult++;
			}
		}
		my @regResultado =();
		#Verificamos cuantos registros encontramos
		if ($sizeResult == 0){
			push(@vect_no_encontrados,\@arr);
			$no_se_encontro=0;
			$sizeResult=0;
			next;
		}
		elsif ($sizeResult==1){
			my $prest = $resultados[0];
			@regResultado = @{$prest};
		}
		else{
			#buscamos el de mayor dia contable y fecha de grabacion
			my $diaContable=@{$resultados[0]}[3];
			my $fechaGrab ="0/0/0000";
			
			foreach $prestam(@resultados){
				my @prest = @{$prestam};
				if ($prest[3]>$diaContable){
					$diaContable=$prest[3];
					@regResultado = @prest;
				}
				elsif ($prest[3]==$diaContable){
					if (&compararFechas($fechaGrab,$prest[14])<0){
						$fechaGrab=$prest[14];
						@regResultado = @prest;
					}
				}
			}
			
		}
		
		for ($number=9;$number<=13;$number++){
			$nro=$arr[$number];
			$arr[$number]=`echo $nro| sed 's/,/./' `;
		}
		my $monto_restante_maestro = $arr[9] + $arr[10] + $arr[11] + $arr[12] - $arr[13];
		my $recomendacion = &calcular_recomendacion(\@regResultado,$reg, $monto_restante_maestro,$regResultado[11]);
		if ($recomendacion eq "RECALCULO"){
			push(@recalculos,\@regResultado);
			#Si un reg necesita recálculo debemos regrabar todo el prestamos.pais
			$flag = 1
		}
	$sizeResult=0;
	
	&print_resultado_consulta(\@regResultado,$reg, $monto_restante_maestro,$recomendacion);
	
	
	}
	if ($escribir_salida==0){
		print SALIDA "Los siguientes registros no se encontraron en el archivo de préstamos\n";
	}
	print "Los siguientes registros no se encontraron en el archivo de préstamos\n";
	foreach $noEncontrado(@vect_no_encontrados){
		@arr=@{$noEncontrado};
		if ($escribir_salida==0){
				$string = join("",$arr[7]," ,");
				print SALIDA $string;
		}
		$string = join("",$arr[7]," ,");
		print $string;
	}
	if ($escribir_salida==0){
		print SALIDA "\n";
	}
	print "\n";
	return @recalculos;
}

sub calcular_recomendacion{
	my $refPrestamos = shift;
	my @reg_prestamo = @{$refPrestamos};
	my $registro_ppi_ref = shift;
	my @registro_ppi=@{$registro_ppi_ref};
	my $recomendacion = "BUENO";
	my $monto_maestro = shift;
	my $monto_prestamo = shift;
	
	$monto_maestro=`echo $monto_maestro| sed 's/,/\./' `;
	$monto_prestamo=`echo $monto_prestamo| sed 's/,/\./' `;

	if (($registro_ppi[5] eq "SMOR") && ($reg_prestamo[4] ne "SMOR")){
		$recomendacion = "RECALCULO";
	}
	if ($monto_maestro < $monto_prestamo){
		$recomendacion = "RECALCULO";
	}

	return $recomendacion;



}

sub print_resultado_consulta{
	print "\n";
	my $registros_prestamos_ref=shift;
	my @registros_prestamos=@{$registros_prestamos_ref};
	my $reg_ma_ref=shift;
	my @reg_ma=@{$reg_ma_ref};
	my $monto_restante_maestro = shift;
	my $monto_restante_prestamos = $registros_prestamos[11];
	my $recomendacion = shift;
	if ($escribir_salida == 0){
		print SALIDA "\n";
		print SALIDA "Código prestamo: ", $registros_prestamos[5],"\n";
		print SALIDA "Código del cliente: ",$registros_prestamos[12],"\n";
		print SALIDA "Fecha contable: ",$registros_prestamos[1],"-",$registros_prestamos[2],"-",$registros_prestamos[3],"\n";
		print SALIDA "Estado contable del maestro: ",$reg_ma[5],"\n";
		print SALIDA "Estado contable del “prestamos.pais”: ",$registros_prestamos[4],"\n";
		print SALIDA "Monto restante del maestro: ",$monto_restante_maestro,"\n";
		print SALIDA "Monto restante del “prestamos.pais”: ",$monto_restante_prestamos,"\n";
		print SALIDA "Recomendacion: ",$recomendacion,"\n";
		print SALIDA "\n";
	}
	print "Código prestamo: ", $registros_prestamos[5],"\n";
	print "Código del cliente: ",$registros_prestamos[12],"\n";
	print "Fecha contable: ",$registros_prestamos[1],"-",$registros_prestamos[2],"-",$registros_prestamos[3],"\n";
	print "Estado contable del maestro: ",$reg_ma[5],"\n";
	print "Estado contable del “prestamos.pais”: ",$registros_prestamos[4],"\n";
	print "Monto restante del maestro: ",$monto_restante_maestro,"\n";
	print "Monto restante del “prestamos.pais”: ",$monto_restante_prestamos,"\n";
	print "Recomendacion: ",$recomendacion,"\n";
	print "\n";
}

sub grabar_recalculo{
	my $registros_prestamos_ref=shift;
	my @registros_prestamos=@{$registros_prestamos_ref};
	my $reg_ma_ref=shift;
	my @reg_ma=@{$reg_ma_ref};
	my $monto_restante_maestro = shift;
	my $aux = shift;
	open (RECALCULO,">>$REPODIR/RECALCULO.$aux" );
	#Recalculando
	foreach $regPrestRef(@registros_prestamos){
		@regPrestamo = @{$regPrestRef};
		foreach $regMaRef(@reg_ma){
			@arr = @{$regMaRef};
			#comparamos codigo prestamo, año, mes
			if (($arr[7] eq $regPrestamo[5]) && ($arr[2]==$regPrestamo[1]) && ($arr[3]==$regPrestamo[2])){
				for ($number=9;$number<=13;$number++){
					$nro=$arr[$number];
					$arr[$number]=`echo -n $nro| sed 's/,/./' `;
					$arr[$number]=`echo -n $arr[$number]| sed 's/\r//' `
				}
				my $monto_restante_maestro = $arr[9] + $arr[10] + $arr[11] + $arr[12] - $arr[13];
				print RECALCULO $arr[1],";";
				print RECALCULO $arr[2],";";
				print RECALCULO $arr[3],";";
				print RECALCULO $regPrestamo[3],";";
				print RECALCULO $arr[5],";";
				print RECALCULO $arr[7],";";
				print RECALCULO $regPrestamo[12],";";
				print RECALCULO $regPrestamo[13],";";
				print RECALCULO $arr[9],";";
				print RECALCULO $arr[10],";";
				print RECALCULO $arr[11],";";
				print RECALCULO $arr[12],";";
				print RECALCULO $arr[13],";";
				print RECALCULO $monto_restante_maestro,";";
				print RECALCULO localtime->strftime('%Y-%m-%d'), ";";
				print RECALCULO `echo \"\$(whoami)\"`;
			}
		
		}
	}
			
		
	close(RECALCULO);
}



#Dado un porcentaje X, imprime todos los registros del archivo de prestamos cuyo
#diferencia con el monto restante del maestro sea mayor a X%
sub calcular_x_porcentuales{
	my $flag = 0;	
	my $x_porcentual = shift;
	my $registros_prestamos_ref=shift;
	my @registros_prestamos=@{$registros_prestamos_ref};
	my $reg_ma_ref=shift;
	my @registros_maestro=@{$reg_ma_ref};
	my @resultados = ();
	
	foreach $regPrestRef(@registros_prestamos){
		@regPrestamo = @{$regPrestRef};
		foreach $regMaRef(@registros_maestro){
			@arr = @{$regMaRef};
			#comparamos codigo prestamo, año, mes
			if (($arr[7] eq $regPrestamo[5]) && ($arr[2]==$regPrestamo[1]) && ($arr[3]==$regPrestamo[2])){
				#Reemplazamos , por .
				for ($number=9;$number<=13;$number++){
					$nro=$arr[$number];
					$arr[$number]=`echo $nro| sed 's/,/\./' `;
				}
				my $monto_maestro = $arr[9] + $arr[10] + $arr[11] + $arr[12] - $arr[13];
				#Comparamos montos
				$regPrestamo[11]=`echo $regPrestamo[11]| sed 's/,/\./' `;
				my $diferencia=0;
				if ($monto_maestro==0){
					if ($regPrestamo[11]==0){
					 $diferencia=0;
					}
					else{
					$diferencia = ($monto_maestro-$regPrestamo[11])/$regPrestamo[11]*100;}
				}
				else{
					$diferencia = ($monto_maestro-$regPrestamo[11])/$monto_maestro*100;
				}
				if ($diferencia>$x_porcentual){
					if ($escribir_salida == 0){
						print SALIDA "Codigo Prestamo: ",$regPrestamo[5],"\n";
						print SALIDA "Fecha contable: ",$regPrestamo[2],"\n";
						print SALIDA "Monto restante maestro: ",$monto_maestro,"\n";
						print SALIDA "Monto restante pais: ",$regPrestamo[11],"\n";
					
						printf SALIDA "Diferencia (%%): %.2f\n", $diferencia,"\n"; 
						print SALIDA "\n";
					}
					print "Codigo Prestamo: ",$regPrestamo[5],"\n";
					print "Fecha contable: ",$regPrestamo[2],"\n";
					print "Monto restante maestro: ",$monto_maestro,"\n";
					print "Monto restante pais: ",$regPrestamo[11],"\n";
					
					printf "Diferencia (%%): %.2f\n", $diferencia,"\n"; 
					print "\n";
					$flag = 1;	
					last;
				}
			
			}
		}
			
	}
	if ($flag == 0){
		print "No se ha encontrado ningún préstamo que cumpla lo pedido\n"; 
	}
}

#Dado un valor absoluto X, imprime todos los registros del archivo de prestamos cuya
# diferencia con el monto restante del maestro sea mayor a X
sub calcular_x_absolutos{
	print "\n";
	my $flag = 0;	
	my $x_absoluto = shift;
	my $registros_prestamos_ref=shift;
	my @registros_prestamos=@{$registros_prestamos_ref};
	my $reg_ma_ref=shift;
	my @registros_maestro=@{$reg_ma_ref};
	my @resultados = ();
	foreach $regPrestRef(@registros_prestamos){
		@regPrestamo = @{$regPrestRef};
		foreach $regMaRef(@registros_maestro){
			@arr = @{$regMaRef};
			#comparamos codigo prestamo, año, mes
			if (($arr[7] eq $regPrestamo[5]) && ($arr[2]==$regPrestamo[1]) && ($arr[3]==$regPrestamo[2])){
				#Reemplazamos , por .
				for ($number=9;$number<=13;$number++){
					$nro=$arr[$number];
					$arr[$number]=`echo $nro| sed 's/,/./' `;
				}
				my $monto_maestro = $arr[9] + $arr[10] + $arr[11] + $arr[12] - $arr[13];
				#Comparamos montos
				$regPrestamo[11]=`echo $regPrestamo[11]| sed 's/,/./' `;
				my $diferencia = ($monto_maestro-$regPrestamo[11]);
				
				if ($diferencia>$x_absoluto){
					if ($escribir_salida == 0){
						print SALIDA "Codigo Prestamo: ",$regPrestamo[5],"\n";
						print SALIDA "Fecha contable: ",$regPrestamo[2],"\n";
						print SALIDA "Monto restante maestro: ",$monto_maestro,"\n";
						print SALIDA "Monto restante pais: ",$regPrestamo[11],"\n";
					
						printf SALIDA "Diferencia (%%): %.2f\n", $diferencia,"\n"; 
						print SALIDA "\n";
					}
					print "Codigo Prestamo: ",$regPrestamo[5],"\n";
					print "Fecha contable: ",$regPrestamo[2],"\n";
					print "Monto restante maestro: ",$monto_maestro,"\n";
					print "Monto restante pais: ",$regPrestamo[11],"\n";
					
					printf "Diferencia (\$): %.2f\n", $diferencia,"\n"; 
					print "\n";
					$flag = 1;	
					last;
				}
			
			}
		}
			
	}
	if ($flag == 0){
		print "No se ha encontrado ningún préstamo que cumpla lo pedido\n"; 
	}
}

sub ejecutar_calcular_x_absolutos{
	my $registros_prestamos = shift;
	my $registros_filtrados_ppi = shift;
	print "Cuál es la diferencia absoluta (en \$) por la que desea listar?\n";
	my $eleccion = <STDIN>;
	while ($eleccion!~ /^[0-9]+$/){
		print "Por favor, ingrese una valor correcto\n";
		$eleccion = <STDIN>;
	
	}
	
	&calcular_x_absolutos($eleccion,$registros_prestamos,$registros_filtrados_ppi);
}

sub ejecutar_calcular_x_porcentuales{
	my $registros_prestamos = shift;
	my $registros_filtrados_ppi = shift;
	print "Cuál es la diferencia porcentual por la que desea listar\n";
	my $eleccion = <STDIN>;
	while ($eleccion!~ /^-?[0-9]+$/){
		print "Por favor, ingrese una valor correcto\n";
		$eleccion = <STDIN>;
	
	}
	
	&calcular_x_porcentuales($eleccion,$registros_prestamos,$registros_filtrados_ppi);
}



sub print_menu{
	my $miFiltroRef = shift;
	my %filtro = %{$miFiltroRef};
	my $registros_prestamos = shift;
	my $registros_filtrados_ppi = shift;
	print "Menu Principal\n";
	print "¿Qué consulta desea realizar?\n";
	print "1. Consulta filtrada sobre el maestro\n";
	print "2. Consulta de diferencia porcentual de montos restantes (lista los de prestamo que son >= al del maestro)\n";
	print "3. Consulta de diferencia absoluta de montos restantes (lista los de prestamo que son >= al del maestro)\n";
	print "4. Salir\n";
	my $eleccion = <STDIN>;
	chomp($eleccion);
	while ($eleccion!~ /^[1-4]$/){
		print "Por favor, elija una opcion correcta\n";
		$eleccion = <STDIN>;
		chomp($eleccion);
	
	}
	switch ($eleccion){
		case 1 {
			&ejecutar_consulta_filtrada($miFiltroRef);
		}
		case 2 {
			&ejecutar_calcular_x_porcentuales($registros_prestamos,$registros_filtrados_ppi);
		}
		case 3 {
			&ejecutar_calcular_x_absolutos($registros_prestamos,$registros_filtrados_ppi);
		}
		case 4 {
			exit(0);
		}
	}
}

sub ejecutar_consulta_filtrada{
	my $mifiltroRef = shift;
	my %filtro = %{$mifiltroRef};

	my $opcion = "si";
	while ($opcion eq "si"){
		print "¿Desea cambiar algun filtro respecto de los ingresados? (si/no)\n";
		$pregunta = &leer_si_no();
		if ($pregunta eq "si"){
			leer_filtros(\%filtros);
		}
		my @todos_los_registros_ppi = &cargar_archivo_ppi(%filtros);
		my @registros_ps = &cargar_archivo_ps(%filtros);
		my @registros_prestamos = &cargar_archivo_prestamos(%filtros);

		
		#Filtramos los registros
		my @registros_filtrados_ppi = ();
		foreach $reg(@todos_los_registros_ppi){
			if (filtrar_registro_ppi(\%filtros,\@registros_filtrados_ppi,\@$reg)){
				push (@registros_filtrados_ppi,\@$reg);
			}
		}
	
	
		
		print "CONSULTA FILTRADA\n";
		my @resultado = realizar_consulta_filtrada(\@registros_prestamos, \@registros_filtrados_ppi);
	
		#si el vector de recalculos no esta vacio, recalculamos
		if (@resultado){
			print "¿Desea guardar recalculo?\n";
			my $choice = &leer_si_no();
		
			if ($choice eq "si"){
				&grabar_recalculo(\@resultado,\@registros_filtrados_ppi,$monto_restante_maestro,$filtros{$pais});
			}
		}
	
		print "¿Desea cambiar algun filtro y/o realizar otra consulta? (si/no)\n";
		$opcion = &leer_si_no();
		
	}
	
	

}


sub main{
	my %filtros = &leer_parametros();
	$count = scalar keys %filtros;
	if ( $count < 2 ){
		 &leer_filtros(\%filtros);
	}
	
	my @todos_los_registros_ppi = &cargar_archivo_ppi(%filtros);
	my @registros_ps = &cargar_archivo_ps(%filtros);
	my @registros_prestamos = &cargar_archivo_prestamos(%filtros);

	#Filtramos los registros
	my @registros_filtrados_ppi = ();
	foreach $reg(@todos_los_registros_ppi){
		if (filtrar_registro_ppi(\%filtros,\@registros_filtrados_ppi,\@$reg)){
			push (@registros_filtrados_ppi,\@$reg);
		}
	}
	
		
	print "CONSULTA FILTRADA\n";
	my @resultado = realizar_consulta_filtrada(\@registros_prestamos, \@registros_filtrados_ppi);
	
	#si el vector de recalculos no esta vacio, recalculamos
	if (@resultado){
		print "¿Desea guardar recalculo?\n";
		my $choice = &leer_si_no();
	
		if ($choice eq "si"){
			&grabar_recalculo(\@resultado,\@registros_filtrados_ppi,$monto_restante_maestro,$filtros{$pais});
		}
	}
	my $opcion = "si";
	while ($opcion eq "si"){
		&print_menu(\%filtros,\@registros_prestamos,\@registros_filtrados_ppi);		
		print "¿Desea realizar otra consulta? (si/no)\n";
		$opcion = &leer_si_no();	
	}
	if (exists $filtros{$salida}){
		close (SALIDA);
	}
}

main();
1;
