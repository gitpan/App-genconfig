package App::genconf;
BEGIN {
  $App::genconf::AUTHORITY = 'cpan:FFFINKEL';
}
{
  $App::genconf::VERSION = '0.004';
}

#ABSTRACT: The world's simplest config file generator

use strict;
use warnings;

use Getopt::Long qw(GetOptions :config bundling);
use Template;


sub new {
    my ( $class, $inc ) = @_;
    $inc = [@INC] unless ref $inc eq 'ARRAY';
    bless { verbose => 0, }, $class;
}


sub run {
    my ( $self, @args ) = @_;
    local @ARGV = @args;
    GetOptions(
        'v|verbose!' => sub { ++$self->{verbose} },
        'V|version!' => \$self->{version},
        'config-dir' => \$self->{config_dir},
    ) or $self->usage;

    if ( $self->{version} ) {
        $self->puts("genconf (App::genconf) version $App::genconf::VERSION");
        exit 1;
    }

    if ( -d $ARGV[0] ) {
        opendir( DH, $ARGV[0] );
        my @files = readdir(DH);
        closedir(DH);

        $self->_generate_config($_) for @files;
    }
    elsif ( -f $ARGV[0] ) {
        $self->_generate_config($ARGV[0]);
    }

}


sub usage {
    my $self = shift;
    $self->puts(<< 'USAGE');
Usage:
  genconf [options] template|dir

  options:
    -v,--verbose                  Turns on chatty output
    --config-dir                  Specify config file directory, default .
USAGE

    exit 1;
}


sub _generate_config {
    my $self     = shift;
    my $template = shift;

    die 'Must specify template name' unless $ARGV[0];

    my $tt = Template->new() || die "$Template::ERROR\n";
    $tt->process( $template, \%ENV ) || die $tt->error();

    return 1;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

App::genconf - The world's simplest config file generator

=head1 VERSION

version 0.004

=head1 SYNOPSIS

=head1 NAME

App::genconf

=head1 METHODS

=head2 new

=head2 run

=head2 usage

=head2 _generate_config

=head1 AUTHOR

Matt Finkel <fffinkel@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Matt Finkel.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
