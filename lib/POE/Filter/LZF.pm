package POE::Filter::LZF;

use strict;
use Carp;
use Compress::LZF qw(compress decompress);
use vars qw($VERSION);
use base qw(POE::Filter);

$VERSION = '1.62';

sub new {
  my $type = shift;
  croak "$type requires an even number of parameters" if @_ % 2;
  my $buffer = { @_ };
  $buffer->{ lc $_ } = delete $buffer->{ $_ } for keys %{ $buffer };
  $buffer->{BUFFER} = [];
  return bless $buffer, $type;
}

sub get {
  my ($self, $raw_lines) = @_;
  my $events = [];

  foreach my $raw_line (@$raw_lines) {
	if ( my $line = decompress( $raw_line ) ) {
		push @$events, $line;
	} 
	else {
		warn "Couldn\'t decompress input\n";
	}
  }
  return $events;
}

sub get_one_start {
  my ($self, $raw_lines) = @_;
  push @{ $self->{BUFFER} }, $_ for @{ $raw_lines };
}

sub get_one {
  my $self = shift;
  my $events = [];

  if ( my $raw_line = shift ( @{ $self->{BUFFER} } ) ) {
	if ( my $line = decompress( $raw_line ) ) {
		push @$events, $line;
	} 
	else {
		warn "Couldn\'t decompress input\n";
	}
  }
  return $events;
}

sub put {
  my ($self, $events) = @_;
  my $raw_lines = [];

  foreach my $event (@$events) {
	if ( my $line = compress( $event ) ) {
		push @$raw_lines, $line;
	} 
	else {
		warn "Couldn\'t compress output\n";
	}
  }
  return $raw_lines;
}

1;

__END__

=head1 NAME

POE::Filter::LZF - A POE filter wrapped around Compress::LZF

=head1 SYNOPSIS

    use POE::Filter::LZF;

    my $filter = POE::Filter::LZF->new();
    my $scalar = 'Blah Blah Blah';
    my $compressed_array   = $filter->put( [ $scalar ] );
    my $uncompressed_array = $filter->get( $compressed_array );

    use POE qw(Filter::Stackable Filter::Line Filter::LZF);

    my ($filter) = POE::Filter::Stackable->new();
    $filter->push( POE::Filter::LZF->new(),
		   POE::Filter::Line->new( InputRegexp => '\015?\012', OutputLiteral => "\015\012" ),

=head1 DESCRIPTION

POE::Filter::LZF provides a POE filter for performing compression/decompression using L<Compress::LZF>. It is
suitable for use with L<POE::Filter::Stackable>.

=head1 CONSTRUCTOR

=over

=item new

Creates a new POE::Filter::LZF object. 

=back

=head1 METHODS

=over

=item get_one_start
=item get_one
=item get

Takes an arrayref which is contains lines of compressed input. Returns an arrayref of decompressed lines.

=item put

Takes an arrayref containing lines of uncompressed output, returns an arrayref of compressed lines.

=back

=head1 AUTHOR

Chris Williams <chris@bingosnet.co.uk>

=head1 SEE ALSO

L<POE>

L<Compress::LZF>

L<POE::Filter::Stackable>

=cut

