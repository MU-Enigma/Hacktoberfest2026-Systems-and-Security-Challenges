#!/usr/bin/perl

use strict;
use warnings;

my $directory = $ARGV[0];

# If no directory is given, use current directory
if (!defined $directory) {
    $directory = ".";
}

opendir(my $dir, $directory) or die "Cannot open directory: $!";

while (my $file = readdir($dir)) {

    # Ignore . and ..
    next if $file eq "." || $file eq "..";

    my $filepath = "$directory/$file";

    # Ignore directories
    next if -d $filepath;

    my $folder = "misc";

    # Check file extension
    if ($file =~ /\.jpg$/i || $file =~ /\.jpeg$/i || $file =~ /\.png$/i) {
        $folder = "images";
    }
    elsif ($file =~ /\.gif$/i || $file =~ /\.bmp$/i || $file =~ /\.svg$/i) {
        $folder = "images";
    }
    elsif ($file =~ /\.mp4$/i || $file =~ /\.mkv$/i || $file =~ /\.avi$/i) {
        $folder = "videos";
    }
    elsif ($file =~ /\.mp3$/i || $file =~ /\.wav$/i || $file =~ /\.flac$/i) {
        $folder = "audio";
    }
    elsif ($file =~ /\.pdf$/i) {
        $folder = "pdfs";
    }
    elsif ($file =~ /\.doc$/i || $file =~ /\.docx$/i || $file =~ /\.txt$/i) {
        $folder = "documents";
    }
    elsif ($file =~ /\.xls$/i || $file =~ /\.xlsx$/i || $file =~ /\.csv$/i) {
        $folder = "spreadsheets";
    }
    elsif ($file =~ /\.zip$/i || $file =~ /\.rar$/i || $file =~ /\.7z$/i) {
        $folder = "archives";
    }

    # Create folder if it doesn't exist
    if (!-d "$directory/$folder") {
        mkdir "$directory/$folder" or die "Cannot create folder: $!";
    }

    # Move the file
    my $newpath = "$directory/$folder/$file";

    if (-e $newpath) {
        print "Skipping $file because it already exists\n";
    }
    else {
        rename($filepath, $newpath) or die "Cannot move $file: $!";
        print "Moved $file -> $folder/\n";
    }
}

closedir($dir);

print "Done!\n";
