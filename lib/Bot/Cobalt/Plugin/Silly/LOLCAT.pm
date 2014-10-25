package Bot::Cobalt::Plugin::Silly::LOLCAT;
our $VERSION;
BEGIN {
  require Bot::Cobalt::Plugin::Silly;
  $VERSION = $Bot::Cobalt::Plugin::Silly::VERSION;
}

use 5.12.1;

use POE::Filter::Stackable;
use POE::Filter::Line;
use POE::Filter::LOLCAT;

use Bot::Cobalt::Common;

sub new { bless {}, shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'SERVER',
    [ 'public_cmd_lolcat' ]  
  );

  $self->{Filter} = POE::Filter::Stackable->new(
    Filters => [
      POE::Filter::Line->new(),
      POE::Filter::LOLCAT->new(),
    ],
  );
  
  $core->log->info("$VERSION loaded");
  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;
  $core->log->info("Unloaded");
  return PLUGIN_EAT_NONE
}

sub Bot_public_cmd_lolcat {
  my ($self, $core) = splice @_, 0, 2;

  my $msg     = ${ $_[0] };
  my $context = $msg->context;

  my $str = decode_irc( join ' ', @{ $msg->message_array } );
  $str ||= "Can I have a line to parse?";

  my $filter = $self->{Filter};
  $filter->get_one_start([$str."\n"]);
  my $lol = $filter->get_one;
  my $cat = shift @$lol;
  chomp($cat);

  my $channel = $msg->channel;
  $core->send_event( 'send_message',
    $context,
    $channel,
    'LOLCAT: '.$cat
  ) if $cat;  
  
  return PLUGIN_EAT_ALL
}

1;
__END__
=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly::LOLCAT - Translate to LOLCAT

=head1 SYNOPSIS

  !plugin load LOLCAT Bot::Cobalt::Plugin::Silly::LOLCAT
  !lolcat some text here

=head1 DESCRIPTION

A L<Bot::Cobalt> plugin.

Simple bridge to L<POE::Filter::LOLCAT> (which in turn uses 
L<Acme::LOLCAT>).

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
