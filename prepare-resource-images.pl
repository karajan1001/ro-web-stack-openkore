#!/usr/bin/env perl
# Restore only generated, local image paths from the selected resource version.
use strict;
use warnings;
use Digest::SHA;
use Fcntl qw(O_WRONLY O_CREAT O_EXCL);
use File::Basename qw(dirname);
use File::Copy qw(copy);
use File::Path qw(make_path);
use File::Spec;
use FindBin qw($RealBin);

my $data = shift(@ARGV) // $ENV{RO_CLIENT_DATA_ROOT}
    // die "Pass the paired resource data directory or set RO_CLIENT_DATA_ROOT.\n";
die "Unexpected argument.\n" if @ARGV;
my $source_root = File::Spec->catdir(File::Spec->rel2abs($data), 'assets', 'components', 'openkore');
my $checkout = File::Spec->rel2abs($RealBin);
my @files;
while (my $relative = <DATA>) {
    chomp $relative;
    next unless length $relative;
    my @parts = split m{/}, $relative;
    die "Invalid resource path: $relative\n" if grep { $_ eq '..' || $_ eq '' } @parts;
    my $source = File::Spec->catfile($source_root, @parts);
    my $destination = File::Spec->catfile($checkout, @parts);
    die "Missing selected resource: $source\n" unless -f $source;
    die "Refusing symbolic-link output: $destination\n" if -l $destination;
    if (-e $destination) {
        die "Not an image file: $destination\n" unless -f $destination;
        my $source_sha = Digest::SHA->new(256)->addfile($source)->hexdigest;
        my $destination_sha = Digest::SHA->new(256)->addfile($destination)->hexdigest;
        die "Existing output differs from selected resource: $destination\n" unless $source_sha eq $destination_sha;
    } else {
        push @files, [$source, $destination];
    }
}
for my $entry (@files) {
    my ($source, $destination) = @$entry;
    make_path(dirname($destination));
    sysopen(my $output, $destination, O_WRONLY | O_CREAT | O_EXCL, 0666)
        or die "Cannot create $destination: $!\n";
    binmode $output;
    if (!copy($source, $output) || !close($output)) {
        my $error = $!;
        close($output);
        unlink($destination);
        die "Cannot copy $source to $destination: $error\n";
    }
}
print "OpenKore image paths prepared from $source_root\n";
__DATA__
plugins/macro/Macro/Wx/break.png
plugins/macro/Macro/Wx/go.png
plugins/macro/Macro/Wx/reload.png
plugins/macro/Macro/Wx/step.png
plugins/macro/Macro/Wx/stop.png
plugins/macro/Macro/Wx/watch.png
plugins/needs-review/Obsolete/legacy/ropp/branches/gcc/splash.bmp
plugins/needs-review/Obsolete/legacy/ropp/trunk/splash.bmp
plugins/needs-review/dataminer/trunk/chardb/webfrontend/images/bg.default.gif
plugins/needs-review/dataminer/trunk/chardb/webfrontend/images/bg2.gif
plugins/needs-review/dataminer/trunk/chardb/webfrontend/images/bg3.gif
plugins/needs-review/dataminer/trunk/chardb/webfrontend/images/delete.gif
plugins/needs-review/dataminer/trunk/chardb/webfrontend/images/link.gif
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/images/bg.default.gif
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/images/bg2.gif
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/images/bg3.gif
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/images/delete.gif
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/images/link.gif
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/maps/aldebaran.jpg
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/maps/payon.jpg
plugins/needs-review/dataminer/trunk/mercdb2/webfrontend/maps/prontera.jpg
plugins/needs-review/dataminer/trunk/screenshots/screen01.png
plugins/needs-review/dataminer/trunk/screenshots/screen02.png
plugins/needs-review/dataminer/trunk/screenshots/screen03.png
plugins/needs-review/dataminer/trunk/screenshots/screen04.png
plugins/needs-review/dataminer/trunk/screenshots/screen05.png
plugins/needs-review/dataminer/trunk/screenshots/screen06.png
plugins/needs-review/dataminer/trunk/screenshots/screen07.png
plugins/needs-review/dataminer/trunk/screenshots/screen08.png
plugins/needs-review/dataminer/trunk/screenshots/screen09.png
plugins/needs-review/dataminer/trunk/screenshots/screen10.png
plugins/needs-review/mapViewer/mapView/openkore.ico
plugins/needs-review/playerDatabase/trunk/www/error404.ico
plugins/needs-review/playerDatabase/trunk/www/img/a.png
plugins/needs-review/playerDatabase/trunk/www/img/dist.png
plugins/needs-review/playerDatabase/trunk/www/img/e.png
plugins/needs-review/playerDatabase/trunk/www/img/favicon.ico
plugins/needs-review/playerDatabase/trunk/www/img/g.png
plugins/needs-review/playerDatabase/trunk/www/img/glyphicons-halflings-white.png
plugins/needs-review/playerDatabase/trunk/www/img/glyphicons-halflings.png
plugins/needs-review/playerDatabase/trunk/www/img/gm.png
plugins/needs-review/playerDatabase/trunk/www/img/o.png
plugins/needs-review/playerDatabase/trunk/www/img/p.png
plugins/needs-review/playerDatabase/trunk/www/img/sair.png
plugins/needs-review/reactOnMiniMap/trunk/doc/howToAdd3CodeNumber.bmp
plugins/needs-review/reactOnMiniMap/trunk/doc/number4.jpg
plugins/needs-review/reactOnMiniMap/trunk/doc/number9.jpg
plugins/needs-review/responseOnASCIInumber/tags/v2.2.1/doc/console.jpg
plugins/needs-review/responseOnASCIInumber/tags/v2.2.1/doc/ingame(openInBrowser).gif
plugins/needs-review/responseOnASCIInumber/trunk/doc/console.jpg
plugins/needs-review/responseOnASCIInumber/trunk/doc/ingame(openInBrowser).gif
plugins/needs-review/responseOnASCIInumber/trunk/doc/ingame01.jpg
plugins/needs-review/responseOnASCIInumber/trunk/doc/ingame02.jpg
plugins/needs-review/responseOnASCIInumber/trunk/doc/ingame03.jpg
plugins/needs-review/responseOnASCIInumber/trunk/doc/ingame04.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_01-234.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_02-786.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_03-568.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_04-311.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_05-682.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_06-166.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_07-PORING.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_08-RODA.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_09-ALICE.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_10-ACIDUS.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_11-HARPY.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_12-HEATER.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_13-KIEL.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_14-ORC.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_15-PRIEST.jpg
plugins/needs-review/responseOnNPCImage/trunk/doc/sample_images/!antibot_16-PALADIN.jpg
plugins/needs-review/webMonitor/trunk/WWW/img/favicon.png
plugins/needs-review/webMonitor/trunk/WWW/img/glyphicons-halflings-white.png
plugins/needs-review/webMonitor/trunk/WWW/img/glyphicons-halflings.png
script-launcher/applications-system.ico
src/Interface/Wx/close.png
src/Interface/Wx/window.png
src/Task/UseSkill.png
src/build/openkore.ico
src/doc/srcdoc/development.png
src/doc/srcdoc/ipc-network.png
src/doc/srcdoc/overview.png
