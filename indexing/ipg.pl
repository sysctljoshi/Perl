#!/usr/bin/perl
use strict;
use warnings;
use Filesys::DiskSpace;
use Math::Round; 
use Net::SMTP;
use HTML::Table;
#use mysql;
use DBI;
my $new_hdd_id;
my $host = "localhost";
my $database = "orderindex";
my $port = 3306;
my $user = "root";
my $pw = "password";
my $hdd_name;
my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $pw,{ RaiseError => 1, AutoCommit => 0 }) or die "Cannot connect to MySQL server\n";


my $srcdir = "/srv/orders_buff";
my $dir1 ="/usb_hdd1";
my $dir2 ="/usb_hdd2";
my $dstdir1 = "/usb_hdd1";
my $dstdir2 = "/usb_hdd2";

my $freespace1 = `df -m $dir1 | grep '$dir1' | awk '{print \$4}'`;
my $freespace2 = `df -m $dir2 | grep '$dir2' | awk '{print \$4}'`;
my $dfree1 = round($freespace1); 
my $dfree2 = round($freespace2); 
print ("$dfree1\n");
print ("$dfree2\n");

if ( $dfree1 > 30000 && $dfree2 > 30000 )    
{
print ("Good To Go \n");
khul_dir();
$dbh->disconnect;
}
else 
{
print ("CRITICAL !!!!\n");
chitti_becho1();   
$dbh->disconnect;
}

sub khul_dir {
print ("test\n");
my $directory = "/srv/orders_buff";
#chomp $directory;
opendir( DIR, $directory) || die "error occured while Opening $directory\n";
my @files= readdir(DIR);
my $num = $#files;
my $i = 0;

#print $dfree;
for($i; $i<=$num ; $i++ )
        {
        if(($files[$i] eq '.') || ($files[$i] eq '..'))  #### this is to omit . and .. from directory listing
                {
                #print ("this is . and ..");
                }
        else
        {
	        my $dir1 = "/usb_hdd1";	
		my $freespace2 = `df -m $dir1 | grep '$dir1' | awk '{print \$4}'`;
		my $dfree1 = round($freespace2); 

	        my $dir1 = "/usb_hdd2";	
		my $freespace3 = `df -m $dir2 | grep '$dir2' | awk '{print \$4}'`;
		my $dfree1 = round($freespace3); 
		
		if ( $dfree1 > 30000 && $dfree2 > 30000 )
		{ 
        	my $xit_val=system ("cp -rvf $directory/$files[$i] $dstdir1");
			if($xit_val!=0)
			{
  			print "Command failed with an exit code of $xit_val.\n";
			chitti_becho3();
                	last;
			}
			else
			{

			my $sth = $dbh->prepare('INSERT INTO ic_orders (disc_id,order_no) VALUES (?,?);');
			$sth->execute("0000","$files[$i]");
			$dbh->commit;
			}
        	#system ("mv -vf $directory/$files[$i] $dstdir2");
        	system ("cp -rvf $directory/$files[$i] $dstdir2 && rm -rvf $directory/$files[$i] >> /srv/deleted_folders.txt");
		}
		else
		{
		my $sth = $dbh->prepare('select max(disc_id) from ic_orders;');
		$sth->execute();
		my @result = $sth->fetchrow_array();
		my $hdd_id = $result[0];
		$new_hdd_id = $hdd_id + 1;

		my $sth = $dbh->prepare('update ic_orders set disc_id = (?) where disc_id = (?);');
		$sth->execute("$new_hdd_id","0000");
		$dbh->commit;
		chitti_becho2();   
		last ; 
		}

        }
        }

#$dbh->disconnect;
}


sub chitti_becho1 {
my $smtp = Net::SMTP->new("x.y.z.z",
                    Hello => 'localhost',
                    Timeout => 60);
$smtp->mail("babc@xyz.com");
$smtp->recipient("abc@xyz.com");
$smtp->data;
$smtp->datasend("From: abc@xyz.com");
$smtp->datasend("\n");
$smtp->datasend("To: abc@xyz.com");
$smtp->datasend("\n");
$smtp->datasend("Subject: IPG Backup Failed !! - Check the space in Both the the USB HDDs");
$smtp->datasend("\n");
$smtp->datasend("Hi Team, Please check the space on the USB HDD ");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("If there is no space , Please label the HDDs and Connect two new HDDs to the server AAA.BBB.CCC.DDD and Mount them as /usb_hdd1 and /usb_hdd2 ");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("Once you replace the hdds , Please e-mail and update the team ");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("abc@xyz.com");
$smtp->dataend;
$smtp->quit;

}



sub chitti_becho2 {
my $smtp = Net::SMTP->new("a.b.c.d",
                    Hello => 'localhost',
                    Timeout => 60);

$smtp->mail("abc@xyz.com");
$smtp->recipient("abc@xyz.com");
$smtp->data;
$smtp->datasend("From: abc@xyz.com");
$smtp->datasend("\n");
$smtp->datasend("To: abc@xyz.com");
$smtp->datasend("\n");
$smtp->datasend("Subject: Backup HDD  IC-$new_hdd_id Full !! - Please verify orders are copied in both the USB HDDs");
$smtp->datasend("\n");
$smtp->datasend("Hi Team, Please remove the HDDs, connect two new HDDs  and Mount it as /usb_hdd1 and /usb_hdd2");
$smtp->datasend("\n");
$smtp->datasend("Label the removed HDDs as IC-$new_hdd_id , email and update the team once you replaced the hdds ");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("-abc@xyz.com");
$smtp->dataend;
$smtp->quit;
}


sub chitti_becho3 {
my $smtp = Net::SMTP->new("1.22.3.4",
                    Hello => 'localhost',
                    Timeout => 60);
$smtp->mail("abc@xyz.com");
$smtp->recipient("abc@xyz.com");
$smtp->data;
$smtp->datasend("From: abc@xyz.com");
$smtp->datasend("\n");
$smtp->datasend("To: abc@xyz.com");
$smtp->datasend("\n");
$smtp->datasend("Subject: Issues when copying IC-XXXX orders , Please check");
$smtp->datasend("\n");
$smtp->datasend("Hi Team, Copying data to HDDs has issues, please check ");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("\n");
$smtp->datasend("abc@xyz.com");
$smtp->dataend;
$smtp->quit;

}
