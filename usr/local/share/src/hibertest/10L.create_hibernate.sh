#!/usr/bin/perl
# $Id: create_hibernate
# Contributed by:
# Piotr Wasiewicz
# pwasiewi@elka.pw.edu.pl

# This script, given parameters concerning the database nodes,
# generates hibernate java classes and hbm files
# create_hibernate -node localhost:dbaza1:postgres

use DBI;
use Getopt::Long;
use Switch;
use strict;

my $dataBase;
my $host;
my $dataBaseUser;
my $dataBasePassword;
my $dataBasePort;
my @nodes;
my $schema = 'public';
my $usage = "$0 -node host:database:user[:password:port] [-node ...] [-schema myschema]
First node is assumed to be the master.
Default schema is \"public\"\n";

&usage if(!GetOptions('node=s@'=>\@nodes, 'schema=s' => \$schema));

die "One node is required" if ( scalar(@nodes) < 1 );



my $nodeNumber = 1;
my $parentString;
my($tmpHost,$tmpDataBase,$tmpDataBaseUser,$tmpDataBasePassword,$tmpPort) = split(/:/,$nodes[0]);
die "Host is required" if ( !$tmpHost );
die "database is required" if ( !$tmpDataBase );
die "user is required" if ( !$tmpDataBaseUser );
$tmpPort = 5432 if ( !$tmpPort );
$host = $tmpHost if ( !$host );
$dataBase = $tmpDataBase if ( !$dataBase );
if ( !$dataBaseUser ) {
  $dataBaseUser = $tmpDataBaseUser;
  $dataBasePassword = $tmpDataBasePassword if ( $tmpDataBasePassword );
  $dataBasePort = $tmpPort if ( $tmpPort );
}
print "Pobieram tabele z host => '$tmpHost', dbname => '$tmpDataBase', port =>$tmpPort,
      user=>'$tmpDataBaseUser', password=>'$tmpDataBasePassword', node=>$nodeNumber $parentString);\n";
$parentString = ', parent=>1';
$nodeNumber++;
my $connectString = "dbi:Pg:dbname=$dataBase;host=$host;port=$dataBasePort";
my $dbh = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
die "connect: $DBI::errstr" if ( !defined($dbh) || $DBI::err );
# Read in all the user 'normal' tables in $schema (public by default).
my $tableQuery = $dbh->prepare("
select * from tabele_z_kluczem_glownym_i_sekwencje('$schema') as tzkgis(nazwa text, relkind character,  relhaspkey bool, relnatts int2);
");
die "prepare(tableQuery): $DBI::errstr" if ( !defined($tableQuery) || $DBI::err );
die "execute(tableQuery): $DBI::errstr" if ( !$tableQuery->execute() );
die "No objects to replicate found in schema \"$schema\"\n" if ($tableQuery->rows <= 0);

my @tablesWithIndexes;
my @tablesWithoutIndexes;
my @attributes;
my @attributes1;
my @sequences;
my @tmpattributes;
my @tmprelname;
my $attr;
my $ile;
while ( my $row = $tableQuery->fetchrow_arrayref() ) {
  my $relname = @$row[0];
  my $relkind = @$row[1];
  my $relhaspkey = @$row[2];
  my $relattnum = @$row[3];
  push(@sequences,$relname) if ( $relkind eq 'S' );
  if ( $relkind eq 'r' && $relhaspkey == 1 )
  {
	push(@tablesWithIndexes,$relname);
  	@tmprelname = split(/\./,$relname);
	open FILE, "+>", ucfirst($tmprelname[1]).".java" or die $!; 
	poczatek_java(*FILE, $tmprelname[1]);
	open FILE1, "+>", ucfirst($tmprelname[1]).".hbm.xml" or die $!; 
	poczatek_hbm(*FILE1, $tmprelname[1]);
  }
  push(@tablesWithoutIndexes,$relname) if ( $relkind eq 'r' && $relhaspkey == 0 );

  
  if ( $relkind eq 'r' && $relhaspkey == 1 ){

###################################################################################################################
# Pliki *Key.java
# Klasy kluczy głównych złożonych
###################################################################################################################
  my $dbh2 = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
  die "connect: $DBI::errstr" if ( !defined($dbh2) || $DBI::err );
  @tmprelname = split(/\./,$relname);
  my $tmptableQuery1 = $dbh2->prepare("
  select * from klucze_glowne_zlozone('$tmprelname[1]') as kgz(relname name, attrelid oid, attname name, typname name, atthasdef bool, attnotnull bool, attnum int2, contype character, conkey int2[], adim integer, relname1 name);
  ");
  die "prepare(tmptableQuery): $DBI::errstr" if ( !defined($tmptableQuery1) || $DBI::err );
  die "execute(tmptableQuery): $DBI::errstr" if ( !$tmptableQuery1->execute() );
  if ($tmptableQuery1->rows > 0)
  {
  print FILE "private ".ucfirst($tmprelname[1])."Key id;\n";
  push(@attributes,$tmprelname[1]."\.id\.".ucfirst($tmprelname[1])."Key");
  print FILE1 "<composite-id name=\"id\" class=\"".ucfirst($tmprelname[1])."Key\">\n";

  open FILE2, "+>", ucfirst($tmprelname[1])."Key.java" or die $!; 
  poczatek_java(*FILE2, $tmprelname[1]."Key");
  while ( my $tmprow = $tmptableQuery1->fetchrow_arrayref() ) {
	push(@attributes1,$tmprow->[0]."\.".$tmprow->[2]."\.".ucfirst($tmprow->[10]));
	my $tmpnull="false";
	switch ($tmprow->[5]) {
	 	case 0 {$tmpnull="false"}
	 	case 1 {$tmpnull="true"}
	}
	print FILE2 "private ".ucfirst($tmprow->[10])." ".$tmprow->[2].";\n";
  	print FILE1 "\t <key-many-to-one name=\"".$tmprow->[2]."\" column=\"".$tmprow->[2]."\" class=\"".ucfirst($tmprow->[10])."\"/>\n";
  }
  print FILE1 "</composite-id>\n\n";
  }
  $tmptableQuery1->finish();
  $dbh2->disconnect();

###################################################################################################################
# get i set Camel nazwy atrybutów do pliku <Klasa>Key.java
###################################################################################################################
  foreach my $attr (@attributes1) {
  	my @tmpattr = split(/\./,$attr);
	if ($tmpattr[0] eq $tmprelname[1])
	{
	print FILE2 "public ".$tmpattr[2]." get".ucfirst($tmpattr[1])."(){\n\treturn ".$tmpattr[1].";}\n";
	print FILE2 "public void set".ucfirst($tmpattr[1])."(".$tmpattr[2]." ".$tmpattr[1]."){\n\tthis\.".$tmpattr[1]."=".$tmpattr[1].";}\n";
	}
  }

###################################################################################################################
# Equal and Hash -  Camel nazwy atrybutów do pliku <Klasa>Key.java
###################################################################################################################
  foreach my $attr (@attributes1) {
  	my @tmpattr = split(/\./,$attr);
	if ($tmpattr[0] eq $tmprelname[1])
	{
	my $tmptype="Integer";
	push(@tmpattributes,$tmpattr[1]);
	}
  }
  print FILE2 "public boolean equals(Object o) \{ \n";
  print FILE2 "\t if (o instanceof ".ucfirst($tmprelname[1])."Key) \{\n";
  print FILE2 "\t\t ".ucfirst($tmprelname[1])."Key mk = (".ucfirst($tmprelname[1])."Key) o;\n";
  print FILE2 "\t\t return ".$tmpattributes[0].".equals(mk.".$tmpattributes[0].") \&\& ".$tmpattributes[1].".equals(mk.".$tmpattributes[1].");\n";
  print FILE2 "\t \}\n\t return false;\n"; 
  print FILE2 "\}\n\n";
  print FILE2 "public int hashCode()\{ \n";
  print FILE2 "\t return ".$tmpattributes[0].".hashCode() + ",1000+int(rand(1000))," * ".$tmpattributes[1].".hashCode();\n";
  print FILE2 "\}\n";
  @tmpattributes=();
  #print $tmpattributes[0]."   ".$tmpattributes[1]."\n";

  print FILE2 "}\n"; 
  close FILE2;


###################################################################################################################
# Atrybuty będące kluczami głównymi i z warunkami notnull, unique bez kluczy głównych złożonych
###################################################################################################################
  my $dbh1 = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
  die "connect: $DBI::errstr" if ( !defined($dbh1) || $DBI::err );
  @tmprelname = split(/\./,$relname);
  my $tmptableQuery = $dbh1->prepare("
  select * from klucze_glowne_i_inne('$tmprelname[1]') as kgi(relname name, attrelid oid, attname name, typname name, atthasdef bool, attnotnull bool, attnum int2, contype character, conkey int2[], adim integer);
  ");
  die "prepare(tmptableQuery): $DBI::errstr" if ( !defined($tmptableQuery) || $DBI::err );
  die "execute(tmptableQuery): $DBI::errstr" if ( !$tmptableQuery->execute() );
  if ($tmptableQuery->rows > 0)
  {
  while ( my $tmprow = $tmptableQuery->fetchrow_arrayref() ) {
	push(@attributes,$tmprow->[0]."\.".$tmprow->[2]."\.".$tmprow->[3]);
	my $tmptype=zmiana_atrybutu($tmprow->[3]);
	my $tmpnull="false";
	switch ($tmprow->[5]) {
	 	case 0 {$tmpnull="false"}
	 	case 1 {$tmpnull="true"}
	}
	print FILE "private ".$tmptype." ".$tmprow->[2].";\n";
	#print "<<<<".@$tmprow[9].">>>>";
	if($tmprow->[4] eq 1 and $tmprow->[7] eq 'p'  and $tmprow->[9] <= 1)
	{
		print FILE1 "<id name=\"".$tmprow->[2]."\" type=\"".lc($tmptype)."\"\n";
		print FILE1 "column=\"".$tmprow->[2]."\" unsaved-value=\"0\">\n";
		print FILE1 "<generator class=\"sequence\">\n";
		print FILE1 "<param name=\"sequence\">\n";
		print FILE1 $tmprelname[1]."_".$tmprow->[2]."_seq</param>\n";
		print FILE1 "</generator>\n";
		print FILE1 "</id>\n\n";
	}
	if($tmprow->[4] eq 0 and $tmprow->[7] eq 'p'  and $tmprow->[9] <= 1)
	{
		print FILE1 "<id name=\"".$tmprow->[2]."\" type=\"".lc($tmptype)."\"\n";
		print FILE1 "column=\"".$tmprow->[2]."\" unsaved-value=\"0\">\n";
		print FILE1 "</id>\n\n";
	}
	if($tmprow->[4] eq 0 and $tmprow->[7] ne 'p')
	{
		print FILE1 "<property name=\"".$tmprow->[2]."\"\n";
		print FILE1 "type=\"".lc($tmptype)."\" column=\"".$tmprow->[2]."\"\n";
		print FILE1 "not-null=\"".$tmpnull."\" unique=\"".$tmpnull."\"/>\n\n";
	}
  }
  }
  $tmptableQuery->finish();
  $dbh1->disconnect();

###################################################################################################################
# Atrybuty będące kluczami obcymi prostymi
###################################################################################################################
  my $dbh1 = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
  die "connect: $DBI::errstr" if ( !defined($dbh1) || $DBI::err );
  @tmprelname = split(/\./,$relname);
  my $tmptableQuery = $dbh1->prepare("
  select * from klucze_obce_pojedyncze('$tmprelname[1]') as kop(relname name, attrelid oid, attname name, relname1 name, atthasdef bool, attnotnull bool, attnum int2, contype character, attname1 name);
  ");
  die "prepare(tmptableQuery): $DBI::errstr" if ( !defined($tmptableQuery) || $DBI::err );
  die "execute(tmptableQuery): $DBI::errstr" if ( !$tmptableQuery->execute() );
  if ($tmptableQuery->rows > 0)
  {
  while ( my $tmprow = $tmptableQuery->fetchrow_arrayref() ) {
	push(@attributes,$tmprow->[0]."\.".$tmprow->[2]."\.".ucfirst($tmprow->[3]));
	my $tmpnull="false";
	switch ($tmprow->[5]) {
	 	case 0 {$tmpnull="false"}
	 	case 1 {$tmpnull="true"}
	}
	print FILE "private ".ucfirst($tmprow->[3])." ".$tmprow->[2].";\n";
  }
  }
  $tmptableQuery->finish();
  $dbh1->disconnect();

###################################################################################################################
# Atrybuty nie będące kluczami i bez żadnych warunków
###################################################################################################################
  my $dbh1 = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
  die "connect: $DBI::errstr" if ( !defined($dbh1) || $DBI::err );
  @tmprelname = split(/\./,$relname);
  my $tmptableQuery = $dbh1->prepare("
  select * from atrybuty_nie_klucze_i_proste('$tmprelname[1]') as ankip(relname name, attrelid oid, attname name, typname name, atthasdef bool, attnotnull bool, attnum int2);
  ");
  die "prepare(tmptableQuery): $DBI::errstr" if ( !defined($tmptableQuery) || $DBI::err );
  die "execute(tmptableQuery): $DBI::errstr" if ( !$tmptableQuery->execute() );
  if ($tmptableQuery->rows > 0)
  {
  while ( my $tmprow = $tmptableQuery->fetchrow_arrayref() ) {
	push(@attributes,$tmprow->[0]."\.".$tmprow->[2]."\.".$tmprow->[3]);
	my $tmptype=zmiana_atrybutu($tmprow->[3]);
	my $tmpnull="false";
	switch ($tmprow->[5]) {
	 	case 0 {$tmpnull="false"}
	 	case 1 {$tmpnull="true"}
	}
	print FILE "private ".$tmptype." ".$tmprow->[2].";\n";
	#print "<<<<".@$tmprow[9].">>>>";
	print FILE1 "<property name=\"".$tmprow->[2]."\"\n";
	print FILE1 "type=\"".lc($tmptype)."\" column=\"".$tmprow->[2]."\"\n";
	print FILE1 "not-null=\"".$tmpnull."\" unique=\"".$tmpnull."\"/>\n\n";
  }
  }
  $tmptableQuery->finish();
  $dbh1->disconnect();



###################################################################################################################
# get i set Camel nazwy atrybutów do pliku <Klasa>.java
###################################################################################################################
  foreach my $attr (@attributes) {
  	my @tmpattr = split(/\./,$attr);
	if ($tmpattr[0] eq $tmprelname[1])
	{
	my $tmptype=zmiana_atrybutu($tmpattr[2]);
	#print $tmptype." - ";
	print FILE "public ".$tmptype." get".ucfirst($tmpattr[1])."(){\n\treturn ".$tmpattr[1].";}\n";
	print FILE "public void set".ucfirst($tmpattr[1])."(".$tmptype." ".$tmpattr[1]."){\n\tthis\.".$tmpattr[1]."=".$tmpattr[1].";}\n";
	}
  }
  #@attributes=();
  #print "\n< ",@attributes," >\n ";

###################################################################################################################
# Klucze obce do konfiguracyjnych plików
###################################################################################################################
  my $dbh2 = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
  die "connect: $DBI::errstr" if ( !defined($dbh2) || $DBI::err );
  @tmprelname = split(/\./,$relname);
  my $tmptableQuery1 = $dbh2->prepare("
  select * from klucze_obce_pojedyncze1('$tmprelname[1]') as kop1(conname name, relname name, attname1 name, relname1 name);
  ");
  die "prepare(tmptableQuery): $DBI::errstr" if ( !defined($tmptableQuery1) || $DBI::err );
  die "execute(tmptableQuery): $DBI::errstr" if ( !$tmptableQuery1->execute() );
  if ($tmptableQuery1->rows > 0)
  {
  while ( my $tmprow = $tmptableQuery1->fetchrow_arrayref() ) {
        #print $tmprow->[0].$tmprow->[1].$tmprow->[2].$tmprow->[3]."\n";
  	print FILE1 "<many-to-one name=\"".$tmprow->[2]."\" column=\"".$tmprow->[2]."\" class=\"".ucfirst($tmprow->[3])."\"\n";	
	print FILE1 "not-null=\"false\"/>\n\n";
  }
  }
  $tmptableQuery1->finish();
  $dbh2->disconnect();

###################################################################################################################
# Dodatkowe funkcje do Java
##################################################################################################################
  my $dbh2 = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
  my $dbh2 = DBI->connect($connectString,$dataBaseUser,$dataBasePassword, {RaiseError => 0, PrintError => 0, AutoCommit => 1});
  die "connect: $DBI::errstr" if ( !defined($dbh2) || $DBI::err );
  @tmprelname = split(/\./,$relname);
  my $tmptableQuery1 = $dbh2->prepare("
  select cast(relnatts as bigint) - (select count(*) from tablice_atrybuty_typy('$schema') as tat(relname name, relnatts int2, attname name, typname name) where typname IN ('int4','bytea','oid') and relname='$tmprelname[1]'),  attname, typname from tablice_atrybuty_typy('$schema') as tat(relname name, relnatts int2, attname name, typname name) where typname NOT IN ('int4','bytea','oid') and relname='$tmprelname[1]';
  ");
  die "prepare(tmptableQuery): $DBI::errstr" if ( !defined($tmptableQuery1) || $DBI::err );
  die "execute(tmptableQuery): $DBI::errstr" if ( !$tmptableQuery1->execute() );
  if ($tmptableQuery1->rows > 0)
  {
  	
	print FILE "public String toString() {\n\treturn ";
	my $i = 0;
  	while ( my $tmprow = $tmptableQuery1->fetchrow_arrayref() ) {
		$i = $i+1;
		print FILE "\ \"".ucfirst($tmprow->[1]).":\" + get".ucfirst($tmprow->[1])."()";
		if ($tmprow->[0] > $i) {print FILE "+";}
	}
	print FILE ";\n}\n"
  }
  $tmptableQuery1->finish();
  $dbh2->disconnect();

###################################################################################################################
# Koniec
###################################################################################################################
  print FILE "}\n"; 
  close FILE;
  print FILE1 "</class>\n";
  print FILE1 "</hibernate-mapping>\n"; 
  close FILE1;


  }
  }
$tableQuery->finish();
$dbh->disconnect();
print "\nKONIEC\n";
exit 0;

sub usage {
  print "$usage";
  exit 0;
}

sub zmiana_atrybutu
{
 my($tmpvar)=@_;
my $tmptype=$tmpvar;
switch ($tmpvar) {
 	case "int4" {$tmptype="Integer"}
 	case "int2" {$tmptype="Integer"}
 	case "varchar" {$tmptype="String"}
 	case "text" {$tmptype="String"}
 	case "numeric" {$tmptype="Double"}
 	case "date" {$tmptype="Calendar"}
 	case "bytea" {$tmptype="Byte[]"}
}
return $tmptype;
}

sub poczatek_java
{
 my($FILE, $mytable)=@_;
 print $FILE "package pl.wit.przyklad;\nimport java.io.Serializable;\n"; 
 print $FILE "import java.util.Calendar;\n"; 
 print $FILE "public class ".ucfirst($mytable)." implements Serializable {\n"; 
}

sub poczatek_hbm
{
 	my($FILE, $mytable)=@_;
	print $FILE "<?xml version=\"1.0\" encoding=\"ISO-8859-2\"?>\n<!DOCTYPE hibernate-mapping PUBLIC\n";
	print $FILE "\t\"-//Hibernate/Hibernate Mapping DTD 3.0//EN\"\n\t\"http://hibernate.sourceforge.net/hibernate-mapping-3.0.dtd\">\n";
	print $FILE "<hibernate-mapping  package=\"pl.wit.przyklad\">\n\n";
	print $FILE "<class name=\"".ucfirst($mytable)."\" table=\"".$mytable."\">\n\n";
}
