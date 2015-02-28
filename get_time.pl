#!/usr/bin/perl

use Net::Time qw(inet_time inet_daytime);
use Net::Ping;
use Fcntl;

our @report;

my $LIST="/usr/local/bin/host_list";
my $LOG="/usr/local/bin/time_check.log";
my $DAILY_REPORT="/usr/local/bin/time_check.dailyreport";
my $DATE=`/bin/date`;
my $MAIL='/usr/bin/mail -s "Domain Time Check" it-team@domain.com';
open(LIST, $LIST);
open(LOG, ">$LOG");
open(DAILY_REPORT, ">>$DAILY_REPORT");
my @MACHINES = <LIST>;


my $p = Net::Ping->new("udp");

foreach my $HOST (@MACHINES){
 chomp($HOST);
# next if $HOST m/\#/;
  if ( $p->ping($HOST,2) ) {	
	print "Host is alive\n";
	&GET_TIME($HOST);
	$p->close();
  } else {
	print "$HOST is dead\n";
	$HOST = undef;
	$p->close();
	next;
  }
}
&REPORT;
if ( $ARGV[0] eq "-d" ) {
	&MAIL($DAILY_REPORT);
	system("/bin/rm $DAILY_REPORT");

} else {
	&MAIL($LOG);
}

$p->close();

sub GET_TIME{
  chomp($_[0]);
  my $remotetime = inet_time("$_[0]", tcp, 5);
  my $localtime = inet_time('localhost', udp); 
	if($remotetime eq undef){
	  print "time on $_[0] is not listening\n";
	  sleep (.5);
	next;
	}
	if($localtime eq undef){
	  print "time on $_[0] is not listening\n";
	next;
	}
#	if($remotetime == ""){
#	  print "time on $_[0] is not listening\n";
#	  next;
#	  }
	if ($remotetime == $localtime) {
	  print "Local and $_[0] time match\n";
	  sleep (.5);
	next;
	}
	if ($remotetime != $localtime) {
	  my $a = $remotetime - $localtime;
	  if (/-?1/){
	  	next};
	  next if $a == "1|-1";
	  #push(@report, "$_[0] is $a seconds off local=$localtime remote=$remotetime\n"); 
	  push(@report, "$_[0] is $a seconds off\n"); 
	 #push(@report, "$_[0] is $a seconds off\n"); 
	  print "$_[0] is $a seconds off\n";
	next;
	}
}

sub REPORT{
	print LOG  "\n$DATE\n";
	print DAILY_REPORT  "\n$DATE\n";
	foreach my $line (@report){
	  chomp $line;
	  print LOG "$line\n";
	  print DAILY_REPORT "$line\n";
	}
	
}	

sub MAIL{
	my $log = shift;
	system("cat $log | $MAIL '$ARGV[1]'");
}	
