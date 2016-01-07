# Copyright (C) 2010 Modestas Vainius <modax@debian.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>

package Debian::PkgKde;

use File::Spec;
use Cwd qw(realpath);

use base qw(Exporter);
our @EXPORT = qw(get_program_name
    printmsg info warning errormsg error syserr usageerr);
our @EXPORT_OK = qw(find_exe_in_path);

sub find_exe_in_path {
    my ($exe, @exclude) = @_;
    my @realexclude;

    # Canonicalize files to exclude
    foreach my $exc (@exclude) {
	if (my $realexc = realpath($exc)) {
	    push @realexclude, $realexc;
	}
    }
    if (File::Spec->file_name_is_absolute($exe)) {
	return $exe;
    } elsif ($ENV{PATH}) {
	foreach my $dir (split /:/, $ENV{PATH}) {
	    my $path = realpath(File::Spec->catfile($dir, $exe));
	    if (-x $path && ! grep({ $path eq $_ } @realexclude)) {
		return $path;
	    }
	}
    }
    return undef;
}

{
    my $progname;
    sub get_program_name {
	unless (defined $progname) {
	    $progname = ($0 =~ m,/([^/]+)$,) ? $1 : $0;
	}
	return $progname;
    }
}

sub format_message {
    my $type = shift;
    my $format = shift;

    my $msg = sprintf($format, @_);
    return ((defined $type) ?
	get_program_name() . ": $type: " : "") . "$msg\n";
}

sub printmsg {
    print STDERR format_message(undef, @_);
}

sub info {
    print STDERR format_message("info", @_);
}

sub warning {
    warn format_message("warning", @_);
}

sub syserr {
    my $msg = shift;
    die format_message("error", "$msg: $!", @_);
}

sub errormsg {
    print STDERR format_message("error", @_);
}

sub error {
    die format_message("error", @_);
}

sub usageerr {
    die format_message("usage", @_);
}

1;
